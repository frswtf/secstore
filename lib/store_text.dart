import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoredTextScreen extends StatefulWidget {
  final List<String> storedTexts;
  final Function(List<String>) onTextsUpdated;

  StoredTextScreen({required this.storedTexts, required this.onTextsUpdated});

  @override
  _StoredTextScreenState createState() => _StoredTextScreenState();
}

class _StoredTextScreenState extends State<StoredTextScreen> {
  List<String> texts = [];

  @override
  void initState() {
    super.initState();
    texts = widget.storedTexts;
  }

  void _deleteText(int index) async {
    setState(() {
      texts.removeAt(index);
    });
    await _saveTexts();
    widget.onTextsUpdated(texts);
  }

  Future<void> _saveTexts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('storedTexts', texts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stored Texts"),
      ),
      body: ListView.builder(
        itemCount: texts.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(texts[index]),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteText(index),
          ),
        ),
      ),
    );
  }
}
