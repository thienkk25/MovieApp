import 'package:flutter/material.dart';

class InforMovieScreen extends StatefulWidget {
  const InforMovieScreen({super.key});

  @override
  State<InforMovieScreen> createState() => _InforMovieScreenState();
}

class _InforMovieScreenState extends State<InforMovieScreen> {
  CarouselController carouselController = CarouselController();
  @override
  void initState() {
    if (carouselController.hasClients) {
      carouselController.animateTo(150,
          duration: const Duration(milliseconds: 500), curve: Curves.bounceIn);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tên phim"),
        centerTitle: true,
      ),
      body: SizedBox(
        height: 160,
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
