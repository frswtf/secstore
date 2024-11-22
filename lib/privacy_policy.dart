import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy & Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Privacy & Policy",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "1. Introduction\n\n"
                "SecStore respects your privacy and is committed to protecting your personal data. "
                "This policy outlines how we collect, use, and protect information within the app. "
                "By using SecStore, you agree to the terms outlined here.\n",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "2. Data Collection\n\n"
                "SecStore only collects minimal data necessary for its core functionalities, including:\n"
                "- PIN Management: Your PINs are stored locally on your device and are used solely to provide secure access to the app’s storage features. "
                "We do not access or store your PINs on any external servers.\n"
                "- Secure Storage: Any passwords or texts you choose to store are saved on your device only. "
                "SecStore does not share, upload, or transmit this information to external servers.\n",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "3. Data Security\n\n"
                "We prioritize your data security and employ the following practices:\n"
                "- Local Storage Only: All data, including PINs and stored passwords, is saved directly on your device. "
                "This ensures your data remains private and is not accessible externally.\n"
                "- Access Control: SecStore includes a lockout mechanism that restricts access to stored data after multiple incorrect PIN entries to enhance security.\n"
                "- Device-Specific Protection: Your data is protected on a per-device basis, meaning only this device has access to the stored information.\n",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "4. User Control and Access\n\n"
                "- PIN Change: Users can change their PIN at any time within the app. "
                "It’s recommended to use a unique PIN to enhance security.\n"
                "- Data Deletion: You can delete stored PINs, passwords, and QR code-generated data at any time. Once deleted, this data is removed permanently from the device.\n",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "5. No Third-Party Access\n\n"
                "SecStore does not use third-party services that could access your data. All functionalities operate solely within the app environment.\n",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "6. Policy Updates\n\n"
                "SecStore may update this Privacy & Policy as necessary to reflect changes in app functionality or legal requirements. "
                "We encourage you to review this policy periodically to stay informed about our data practices.\n",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "8. Contact Information\n\n"
                "If you have any questions, concerns, or feedback regarding this Privacy & Policy, please contact us through the app’s support feature.\n",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
