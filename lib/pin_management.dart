import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PinManagementScreen extends StatefulWidget {
  @override
  _PinManagementScreenState createState() => _PinManagementScreenState();
}

class _PinManagementScreenState extends State<PinManagementScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  List<Map<String, String>> pins = [];

  @override
  void initState() {
    super.initState();
    _loadPins();
  }

  Future<void> _loadPins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPins = prefs.getString('pins');
    if (savedPins != null) {
      List<dynamic> decodedPins = jsonDecode(savedPins);
      setState(() {
        pins = decodedPins.map((pin) => Map<String, String>.from(pin)).toList();
      });
    }
  }

  Future<void> _savePins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedPins = jsonEncode(pins);
    await prefs.setString('pins', encodedPins);
  }

  void _addPin() {
    if (_pinController.text.length == 4) {
      setState(() {
        pins.add({
          'pin': _pinController.text,
          'tag': _tagController.text,
        });
        _pinController.clear();
        _tagController.clear();
        _savePins();
      });
    } else {
      _showErrorDialog("Please enter a 4-digit PIN.");
    }
  }

  void _deletePin(int index) {
    setState(() {
      pins.removeAt(index);
      _savePins();
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PIN Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(labelText: 'Enter 4-digit PIN'),
            ),
            TextField(
              controller: _tagController,
              decoration: InputDecoration(labelText: 'Tag (e.g., Bank, Email)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addPin,
              child: Text('Add PIN'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: pins.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('PIN: ${pins[index]['pin']}'),
                    subtitle: Text('Tag: ${pins[index]['tag']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deletePin(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
