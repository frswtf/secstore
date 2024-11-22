import 'package:flutter/material.dart';
import 'package:secstore/privacy_policy.dart';
import 'pin_management.dart';
import 'secure_storage.dart';

void main() {
  runApp(SecStoreApp());
}

class SecStoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecStore',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SecStore'),
        elevation: 0, // Removes shadow under AppBar
      ),
      body: Column(
        children: [
          Divider(
            color: Colors.grey, // Set the color of the divider
            thickness: 1, // Set the thickness of the divider
            height: 1, // Minimal height to keep it close to the AppBar
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FeatureButton(
                    label: 'PIN Management',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PinManagementScreen()),
                      );
                    },
                  ),
                  FeatureButton(
                    label: 'Secure Storage',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecureStorageScreen()),
                      );
                    },
                  ),
                  FeatureButton(
                    label: 'Privacy & Policy',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  FeatureButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: 150, // Fixed width for consistent shape
        height: 100, // Fixed height for consistent shape
        child: ElevatedButton(
          onPressed: onTap,
          child: Text(label, textAlign: TextAlign.center), // Center the text
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Slight curve on corners
            ),
            padding: EdgeInsets.all(16.0),
          ),
        ),
      ),
    );
  }
}
