import 'package:flutter/material.dart';

class ScoreBoardPage extends StatefulWidget {
  const ScoreBoardPage({super.key});

  @override
  State<ScoreBoardPage> createState() => _ScoreBoardPageState();
}

class _ScoreBoardPageState extends State<ScoreBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Score Board Page"),);
  }
}
