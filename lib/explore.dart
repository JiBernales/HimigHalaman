import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'navbar.dart';
import 'plant_identification/scanner.dart';
import 'profile.dart';
import 'settings/settings.dart';
import 'myplants.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Map<String, String>> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    scrapeArticles(); // Start scraping when the page loads
  }

  Future<void> scrapeArticles() async {
    const url = 'https://www.thesill.com/pages/plant-care-articles';

    // Placeholder images to use when an article is missing an image
    final List<String> placeholderImages = [
      'https://www.thesill.com/cdn/shop/articles/MG_7036_1.jpg?v=1527089526&width=1500',
      'https://www.thesill.com/cdn/shop/articles/pdp-plant-bio-image_coffee-plant.jpg?v=1601386794',
      'https://www.thesill.com/cdn/shop/articles/the-sill_propegation_pothos.jpg?v=1594056248',
      'https://www.thesill.com/cdn/shop/articles/core-plants-watering.jpg?v=1623094844&width=1500',
    ];

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final document = parse(response.body);
        final articleCards = document.querySelectorAll('.card__content');

        // Set to track unique article links
        final Set<String> uniqueLinks = {};
        List<Map<String, String>> fetchedArticles = [];

        for (var card in articleCards) {
          final title = card
              .querySelector('.card__heading a')
              ?.text
              .trim() ?? "No Title";
          final link = card
              .querySelector('.card__heading a')
              ?.attributes['href'] ?? "";
          final imageElement = card.parent?.querySelector('img');
          String imageUrl = imageElement?.attributes['src'] ?? "";

          // Convert relative URL to full URL
          imageUrl = imageUrl.startsWith("//") ? "https:$imageUrl" : imageUrl;

          // Assign a random placeholder image if no image URL is found
          if (imageUrl.isEmpty) {
            final randomIndex = Random().nextInt(placeholderImages.length);
            imageUrl = placeholderImages[randomIndex];
          }

          // Avoid duplicate articles using unique links
          if (link.isNotEmpty && !uniqueLinks.contains(link)) {
            uniqueLinks.add(link);
            fetchedArticles.add({
              'title': title,
              'link': "https://www.thesill.com$link",
              'image': imageUrl,
            });
          }
        }

        setState(() {
          articles = fetchedArticles;
          isLoading = false; // Stop showing the loading indicator
        });
      } else {
        throw Exception('Failed to load website: ${response.statusCode}');
      }
    } catch (e) {
      print('Error scraping website: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header and Search Bar
              ..._buildHeader(),

              // Articles Section
              if (isLoading)
                const Column(
                  children: [
                    SizedBox(height: 20),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Searching articles for you, please wait...",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                )
              else
                if (articles.isEmpty)
                  const Center(
                    child: Text("No articles found."),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return buildArticleCard(
                        context,
                        article['title'] ?? "No Title",
                        article['image'] ?? "",
                        article['link'] ?? "", // Pass the link here
                      );
                    },
                  )
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyPlantsPage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PlantScannerPage()),
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildHeader() {
    return [
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.person, size: 40),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, size: 40),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Text(
          "Explore",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    ];
  }

// Article Card Widget
  Widget buildArticleCard(BuildContext context,
      String title,
      String imageUrl,
      String url, // Pass the article URL here
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
        color: Theme
            .of(context)
            .cardColor,
        child: Column(
          children: [
            // Article Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15)),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : Container(
                height: 150,
                color: Colors.grey,
                child: const Center(child: Icon(Icons.image_not_supported)),
              ),
            ),
            // Article Details
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: const Text("Read More"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}