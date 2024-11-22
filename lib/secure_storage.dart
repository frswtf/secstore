import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageScreen extends StatefulWidget {
  @override
  _SecureStorageScreenState createState() => _SecureStorageScreenState();
}

class _SecureStorageScreenState extends State<SecureStorageScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _currentPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmNewPinController = TextEditingController();

  bool isLockedOut = false;
  bool accessGranted = false;
  int failedAttempts = 0;
  Timer? lockoutTimer;

  String? savedPin;
  List<String> storedTexts = [];

  @override
  void initState() {
    super.initState();
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedPin = prefs.getString('pin') ?? "1234"; // Default PIN for first-time use
    storedTexts = prefs.getStringList('storedTexts') ?? [];
    setState(() {});
  }

  Future<void> _saveStoredData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', savedPin!);
    await prefs.setStringList('storedTexts', storedTexts);
  }

  void _attemptAccess() {
    if (isLockedOut) {
      _showErrorDialog("You are locked out. Please wait for the lockout period to end.");
      return;
    }

    if (_pinController.text == savedPin) {
      setState(() {
        failedAttempts = 0;
        accessGranted = true; // Grant access on correct PIN
      });
      _pinController.clear();
    } else {
      failedAttempts++;
      if (failedAttempts >= 5) {
        _triggerLockout();
      } else {
        _showErrorDialog("Incorrect PIN. You have ${5 - failedAttempts} attempts remaining.");
      }
    }
  }

  void _triggerLockout() {
    setState(() {
      isLockedOut = true;
      accessGranted = false;
    });
    lockoutTimer = Timer(Duration(seconds: 30), () {
      setState(() {
        isLockedOut = false;
        failedAttempts = 0;
      });
    });
    _showErrorDialog("Too many failed attempts. You are locked out for 30 seconds.");
  }

  void _addText() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        storedTexts.add(_textController.text);
        _textController.clear();
        _saveStoredData();
      });
    }
  }

  void _deleteText(int index) {
    setState(() {
      storedTexts.removeAt(index);
      _saveStoredData();
    });
  }

  void _showChangePinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Change PIN"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _currentPinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              decoration: InputDecoration(labelText: 'Current PIN'),
            ),
            TextField(
              controller: _newPinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              decoration: InputDecoration(labelText: 'New PIN'),
            ),
            TextField(
              controller: _confirmNewPinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              decoration: InputDecoration(labelText: 'Confirm New PIN'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _changePin();
            },
            child: Text("Change"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _changePin() {
    if (_currentPinController.text == savedPin) {
      if (_newPinController.text == _confirmNewPinController.text && _newPinController.text.length == 4) {
        setState(() {
          savedPin = _newPinController.text;
          _saveStoredData();
        });
        _showSuccessDialog("PIN changed successfully!");
      } else {
        _showErrorDialog("New PINs do not match or are not 4 digits.");
      }
    } else {
      _showErrorDialog("Current PIN is incorrect.");
    }

    // Clear the text fields
    _currentPinController.clear();
    _newPinController.clear();
    _confirmNewPinController.clear();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _textController.dispose();
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmNewPinController.dispose();
    lockoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Secure Storage"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!accessGranted) ...[
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(labelText: 'Enter 4-digit PIN to access'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _attemptAccess,
                child: Text("Access Stored Texts"),
              ),
            ] else ...[
              TextField(
                controller: _textController,
                decoration: InputDecoration(labelText: 'Enter text to save'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addText,
                child: Text("Save Text"),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: storedTexts.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(storedTexts[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteText(index),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _showChangePinDialog,
                child: Text("Change PIN"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
