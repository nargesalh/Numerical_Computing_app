import 'package:flutter/material.dart';

class ChaptersPage extends StatelessWidget {
  const ChaptersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chapters')),
      body: const Center(
        child: Text('Chapters will be added after receiving the notes.'),
      ),
    );
  }
}
