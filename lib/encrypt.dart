import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class EncryptScreen extends StatefulWidget {
  @override
  _EncryptScreenState createState() => _EncryptScreenState();
}

class _EncryptScreenState extends State<EncryptScreen> {
  final TextEditingController _textController = TextEditingController();
  String? encryptedText;

  final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32 characters
  final _iv = encrypt.IV.fromLength(16); // 16 bytes for AES-128/CBC mode

  void _encryptText() {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encrypt(_textController.text, iv: _iv);
    setState(() {
      encryptedText = encrypted.base64;
      _saveEncryptedText(encryptedText!);
    });
  }

  Future<void> _saveEncryptedText(String encryptedText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('encryptedText', encryptedText);
    print("Encrypted text saved: $encryptedText"); // Debugging line
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Encrypt Text"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Enter text to encrypt'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _encryptText,
              child: Text("Encrypt"),
            ),
            if (encryptedText != null) ...[
              SizedBox(height: 20),
              Text(
                "Encrypted Text:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SelectableText(
                encryptedText!,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
