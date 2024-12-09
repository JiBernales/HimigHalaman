import 'package:flutter/material.dart';

class TermsAndServicesPage extends StatelessWidget {
  const TermsAndServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Services'),
        backgroundColor: Colors.green, // App theme color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms and Services',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '''
Welcome to Himig Halaman, your companion in plant care and crop management! By using this app, you agree to abide by the following terms and conditions:

1. **Purpose of the App**  
   Himig Halaman is designed to provide plant enthusiasts, plantitos, plantitas, and farmers with tools to manage and monitor plant health. This includes plant care guides, scheduling, and notifications.

2. **User Responsibility**  
   - You are responsible for the accuracy of the plant information you provide in the app.
   - Use of any plant-related advice provided in the app is at your discretion. While we strive to ensure accurate information, Himig Halaman is not liable for any unintended consequences.

3. **Data Collection and Privacy**  
   - Himig Halaman may collect and store plant-related data (e.g., plant type, watering schedules) to enhance user experience.
   - User data is not shared with third parties unless required by law. For more details, refer to our Privacy Policy.

4. **Content Ownership**  
   - All app content, including icons, graphics, and plant-care data, is proprietary to Himig Halaman. You may not copy or redistribute any content without explicit permission.

5. **Account Usage**  
   - Users are required to log in or create an account to save their data. Anonymous users may have limited access to features.
   - Ensure your account credentials are kept secure.

6. **Prohibited Activities**  
   Users may not:
   - Upload harmful, misleading, or malicious content.
   - Use the app for any illegal purposes.

7. **Limitation of Liability**  
   Himig Halaman is provided as-is, and we do not guarantee uninterrupted or error-free service. We are not responsible for any data loss or technical issues.

8. **Changes to Terms**  
   Himig Halaman reserves the right to update or modify these terms at any time. Continued use of the app indicates acceptance of updated terms.

By proceeding, you confirm that you have read and agree to the terms and services outlined above.
              ''',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the terms and return to the previous page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // App theme color
                ),
                child: const Text('Accept and Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
