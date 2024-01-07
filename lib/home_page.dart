import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/home_appbar.dart';
import 'package:flutter_application_2/pages/home_conteudo.dart';
import 'package:flutter_application_2/pages/home_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHomeAppBar(),
      drawer: getHomeDrawer(context),
      body: const HomePageContent(),
    );
  }
}
