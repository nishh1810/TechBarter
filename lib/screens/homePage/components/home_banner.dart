import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {

  final List<String> bannerImages = [
    'https://picsum.photos/id/1/3000/2000',
    'https://picsum.photos/id/200/3000/2000',
    'https://picsum.photos/id/500/3000/2000',
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: bannerImages.length,
      itemBuilder: (context, index, realIdx) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              bannerImages[index],
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.apple, color: Colors.white, size: 20),
                      SizedBox(width: 5),
                      Text(
                        "iPhone 14 Series",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Up to 10% off Voucher",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    child: Row(
                      children: [
                        Text("Shop Now", style: TextStyle(color: Colors.black)),
                        Icon(Icons.arrow_forward, color: Colors.black),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 1,
      ),
    );
  }
}
