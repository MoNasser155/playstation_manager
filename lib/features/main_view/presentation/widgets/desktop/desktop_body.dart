
import 'package:flutter/material.dart';

class DesktopBody extends StatelessWidget {
  const DesktopBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 100,
            child: Card(child: Center(child: Text('Item $index'))),
          );
        },
      ),
    );
  }
}
