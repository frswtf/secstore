import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class DecryptScreen extends StatefulWidget {
  @override
  _DecryptScreenState createState() => _DecryptScreenState();
}

class _DecryptScreenState extends State<DecryptScreen> {
  final TextEditingController _encryptedTextController = TextEditingController();
  String? decryptedText;

  final _key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32 characters
  final _iv = encrypt.IV.fromLength(16);

  void _decryptText() {
    try {
      final encrypter = encrypt.Encrypter(encrypt.AES(_key));
      final decrypted = encrypter.decrypt64(_encryptedTextController.text, iv: _iv);
      setState(() {
        decryptedText = decrypted;
      });
    } catch (e) {
      print("Decryption error: $e"); // Debugging line
      setState(() {
        decryptedText = "Error: Invalid encrypted text!";
      });
    }
  }

  Future<void> _loadEncryptedText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEncryptedText = prefs.getString('encryptedText');
    setState(() {
      _encryptedTextController.text = savedEncryptedText ?? '';
      print("Loaded encrypted text: ${_encryptedTextController.text}"); // Debugging line
    });
  }

  @override
  void initState() {
    super.initState();
    _loadEncryptedText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Decrypt Text"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _encryptedTextController,
              decoration: InputDecoration(
                labelText: 'Encrypted Text',
                hintText: 'Enter or paste encrypted text here',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _decryptText,
              child: Text("Decrypt"),
            ),
            SizedBox(height: 10),
            if (decryptedText != null)
              Text(
                "Decrypted Text: $decryptedText",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
