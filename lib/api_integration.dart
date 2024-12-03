import 'dart:convert';
import 'package:http/http.dart' as http;
import 'web-scraping.dart';
import 'plant.dart';

class APIIntegration {
  final String apiKey = 'YOUR_API_KEY_HERE';

  Future<List<Plant>?> identifyPlant(String base64Image) async {
    const apiUrl = 'https://api.plant.id/v2/identify';
    final headers = {
      'Api-Key': apiKey,
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode({
          'images': [base64Image],
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body) as Map<String, dynamic>;

        if (jsonResponse['is_plant'] == true) {
          final webScraping = WebScraping();
          final suggestions = jsonResponse['suggestions'] as List;

          // Map the suggestions to a list of Plant objects
          return Future.wait(
            suggestions.map((suggestion) async {
              final plantName = suggestion['plant_name'];
              final imageUrl = await webScraping.getImageFromWeb(plantName);

              // If no image was fetched, use a default placeholder image
              final validImageUrl = imageUrl.isNotEmpty
                  ? imageUrl
                  : 'https://example.com/placeholder-image.jpg'; // Placeholder

              // Define tasks and taskStatus based on your logic or hardcoded for now
              List<String> tasks = [
                "Water daily",
                "Place in indirect sunlight",
                "Prune leaves weekly"
              ];
              List<bool> taskStatus = [false, false, false]; // Example status

              return Plant(
                id: suggestion['id'], // Use the plant ID from the API response
                plantName: plantName,
                probability: suggestion['probability'] * 100, // Convert probability to percentage
                imagePath: validImageUrl, // Use fetched or fallback image
                waterNeeded: suggestion['water_needed'] ?? true, // Default to true if not provided
                sunlightNeeded: suggestion['sunlight_needed'] ?? true, // Default to true if not provided
                isFavorite: false, // Assuming it starts as not a favorite
                tasks: tasks, // Pass the tasks
                taskStatus: taskStatus, // Pass the task status
              );
            }).toList(),
          );
        } else {
          print("No plant found in the response.");
        }
      } else {
        print("API request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error identifying plant: $e");
    }
    return null;
  }
}
