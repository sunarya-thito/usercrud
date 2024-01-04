import 'package:flutter/material.dart';
import 'package:usercrud/components/standard_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return StandardPage(
      builder: (context) {
        return SizedBox();
      },
    );
  }
}
