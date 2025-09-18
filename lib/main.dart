import 'package:flutter/material.dart';

void main() {
  runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('Emoji App'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [EmojiHeader(), SizedBox(height: 16), EmojiDropdown()],
          ),
        ),
      ),
    );
  }
}

class EmojiHeader extends StatelessWidget {
  const EmojiHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.yellow[200],
      child: const Text('Create your own emoji!'),
    );
  }
}

class EmojiDropdown extends StatefulWidget {
  const EmojiDropdown({super.key});

  @override
  State<EmojiDropdown> createState() => _EmojiDropdownState();
}

class _EmojiDropdownState extends State<EmojiDropdown> {
  final List<String> items = ['Smile', 'Sad', 'In Love'];
  String selected = 'Smile';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButton<String>(
          value: selected,
          items: items
              .map((v) => DropdownMenuItem(value: v, child: Text(v)))
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => selected = value);
          },
        ),
        Text('Selected: $selected'),
      ],
    );
  }
}
