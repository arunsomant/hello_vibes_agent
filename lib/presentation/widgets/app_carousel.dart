import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AppCarousel extends StatelessWidget {
  final Function(int index)? onPageChanged;

  final bool autoPlay;

  final double aspectRatio;

  final double? height;

  final ExtendedIndexedWidgetBuilder itemBuilder;

  final int itemCount;

  final int initialPage;

  final bool enlargeCenterPage;

  final bool enableInfiniteScroll;

  final double viewportFraction;

  const AppCarousel({
    super.key,
    this.onPageChanged,
    this.autoPlay = true,
    this.aspectRatio = 16 / 9,
    this.height,
    required this.itemBuilder,
    required this.itemCount,
    this.viewportFraction = 1,
    this.initialPage = 0,
    this.enlargeCenterPage = false,
    this.enableInfiniteScroll = true,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        initialPage: initialPage,
        viewportFraction: viewportFraction,
        aspectRatio: aspectRatio,
        disableCenter: true,
        padEnds: true,
        enlargeCenterPage: enlargeCenterPage,
        enlargeFactor: 0.4,
        enlargeStrategy: CenterPageEnlargeStrategy.zoom,
        clipBehavior: Clip.hardEdge,
        enableInfiniteScroll: enableInfiniteScroll,
        autoPlay: itemCount > 1 ? autoPlay : false,
        autoPlayInterval: const Duration(seconds: 5),
        onPageChanged: onPageChanged != null
            ? (index, reason) {
                onPageChanged!.call(index);
              }
            : null,
      ),
      itemBuilder: itemBuilder,
      itemCount: itemCount,
    );
  }
}
