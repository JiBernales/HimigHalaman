import 'dart:convert';
import 'package:http/http.dart' as http;
import '../plant.dart';
import 'package:html/parser.dart' show parse;

class APIIntegration {
  final String apiKey = 'pzyDB6bAXMwaztE8TT6mTCYfulg1t3Rle1AHdBnjjOmURH6Jn2';
  final WikipediaImageFetcher imageFetcher = WikipediaImageFetcher();

  Future<Plant?> identifyPlant(String imageUrl) async {
    const apiUrl = 'https://api.plant.id/v2/identify';
    final headers = {
      'Api-Key': apiKey,
      'Content-Type': 'application/json',
    };

    try {
      // Sending the request with image URL
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode({
          'images': [imageUrl],  // Directly using the image URL
          'plant_details': [
            'common_names',
            'url',
            'description',
            'synonyms',
            'similar_images'
          ],
        }),
      );

      // Handle non-200 responses
      if (response.statusCode != 200) {
        print("API request failed with status: ${response.statusCode}");
        print("Response: ${response.body}");
        return null;
      }

      // Parse the JSON response
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;

      // Check if suggestions exist
      if (jsonResponse.containsKey('suggestions') && jsonResponse['suggestions'] is List) {
        final suggestions = jsonResponse['suggestions'] as List;
        print(suggestions);

        if (suggestions.isNotEmpty) {
          // Sort suggestions by probability (highest first)
          suggestions.sort((a, b) =>
              (b['probability'] as double).compareTo(a['probability'] as double));

          final bestSuggestion = suggestions.first;
          final plantDetails = bestSuggestion['plant_details'] ?? {};

          // Extract plant details
          final plantName = bestSuggestion['plant_name'] as String? ?? 'Unknown Plant';
          final probability = (bestSuggestion['probability'] ?? 0.0) * 100; // Convert to percentage
          final similarImages = plantDetails['similar_images'] != null
              ? List<String>.from(plantDetails['similar_images'].map((img) => img['url'] ?? ''))
              : <String>[];

          // Handling the image URL
          String finalImageUrl = imageUrl;  // Default to the provided image URL

          // Fetch the Wikipedia URL from the response and use it to get the image
          final wikipediaUrl = plantDetails['url'] ?? '';
          if (wikipediaUrl.isNotEmpty) {
            final wikipediaImageUrl = await imageFetcher.getImageFromWikipedia(wikipediaUrl);
            if (wikipediaImageUrl != null) {
              finalImageUrl = wikipediaImageUrl;
            }
          }

          final description = plantDetails['description']?['value'] ?? 'No description available.';
          final commonNames = plantDetails['common_names'] != null
              ? List<String>.from(plantDetails['common_names'])
              : <String>[];
          final synonyms = plantDetails['synonyms'] != null
              ? List<String>.from(plantDetails['synonyms'])
              : <String>[];

          // Create and return a Plant object with imagePath
          return Plant(
            plantName: plantName,
            probability: probability,
            imagePath: finalImageUrl,  // Using fetched image URL here
            waterNeeded: true, // Default values
            sunlightNeeded: true,
            isFavorite: false,
            tasks: ["Water daily", "Place in indirect sunlight"],
            taskStatus: [false, false],
            description: description,
            commonNames: commonNames,
            synonyms: synonyms,
          );
        } else {
          print("No suggestions found in the response.");
        }
      } else {
        print("No suggestions key or it's empty.");
      }
    } catch (e) {
      print("Error identifying plant: $e");
      throw Exception("Error identifying plant: $e");
    }
    return null;
  }
}

class WikipediaImageFetcher {
  final String wikipediaApiUrl = 'https://en.wikipedia.org/w/api.php';

  Future<String?> getImageFromWikipedia(String wikipediaUrl) async {
    final url = Uri.parse(
      '$wikipediaApiUrl?action=parse&format=json&page=$wikipediaUrl&prop=text',
    );

    try {
      // Send request to the Wikipedia API
      final response = await http.get(url);

      // Handle errors in response
      if (response.statusCode != 200) {
        print("Error fetching Wikipedia page: ${response.statusCode}");
        return null;
      }

      final data = json.decode(response.body);
      final pageHtml = data['parse']['text']['*'] as String;

      // Parse the HTML content
      final document = parse(pageHtml);

      // Extract image URLs from img tags
      final images = document.getElementsByTagName('img');

      if (images.isNotEmpty) {
        // Get the first image URL
        final imageUrl = images[0].attributes['src'];
        return imageUrl != null ? 'https:$imageUrl' : null;
      } else {
        print("No images found on the Wikipedia page.");
        return null;
      }
    } catch (e) {
      print("Error fetching image from Wikipedia: $e");
      return null;
    }
  }
}
