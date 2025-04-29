import 'package:flutter/material.dart';

class CategorySideBar extends StatelessWidget {
  const CategorySideBar({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            //Text
            Text(
              'CATEGORY',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
