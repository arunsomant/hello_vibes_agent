import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/config/app_assets_mapper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/cache_manager.dart';
import 'index.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage(
    this.url, {
    super.key,
    this.placeholder,
    this.height,
    this.width,
    this.fit,
    this.isFullScreen = false,
    this.alignment = Alignment.center,
    this.refererKey,
  });

  final String url;
  final Widget? placeholder;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Alignment alignment;
  final String? refererKey;
  final bool isFullScreen;

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    Widget placeholderWidget = SizedBox(
      height: height,
      width: width,
      child: Center(
        child:
            placeholder ??
            AppSvgAsset(
              AppAssetsMapper.imagePlaceholder,
              color: AppColors.iconPrimary,
              fit: fit ?? BoxFit.cover,
            ),
      ),
    );
    if (url.isNotEmpty) {
      final path = AppImageCacheManager.getStableCacheKey(url);
      return CachedNetworkImage(
        cacheKey: path,
        httpHeaders: refererKey != null ? {'referer': refererKey!} : null,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        imageUrl: url,
        alignment: alignment,
        cacheManager: AppImageCacheManager(),
        useOldImageOnUrlChange: true,
        maxHeightDiskCache: height != null
            ? (height! * devicePixelRatio).round()
            : null,
        maxWidthDiskCache: width != null
            ? (width! * devicePixelRatio).round()
            : null,
        memCacheHeight: height != null
            ? (height! * devicePixelRatio).round()
            : null,
        memCacheWidth: width != null
            ? (width! * devicePixelRatio).round()
            : null,
        //placeholder: (context, url) => placeholderWidget,
        progressIndicatorBuilder: (context, url, progress) {
          return AppShimmer(child: placeholderWidget);
        },
        errorWidget: (context, url, error) => placeholderWidget,
      );
    }
    return placeholderWidget;
  }
}

class AppSvgAsset extends StatelessWidget {
  const AppSvgAsset(
    this.asset, {
    super.key,
    this.height,
    this.width,
    this.fit,
    this.color,
  });

  final String asset;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (asset.isEmpty) {
      return AppPlaceholderWidget.image(width: width, height: height);
    }
    return SvgPicture.asset(
      asset,
      fit: fit ?? BoxFit.contain,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}

class AppAssetImage extends StatelessWidget {
  const AppAssetImage(
    this.asset, {
    super.key,
    this.height,
    this.width,
    this.fit,
    this.color,
  });

  final String asset;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,
      color: color,
    );
  }
}

class AppFileImage extends StatelessWidget {
  const AppFileImage(
    this.path, {
    super.key,
    this.height,
    this.width,
    this.fit,
    this.color,
  });

  final String path;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return AppAssetImage(
          AppAssetsMapper.personPlaceholder,
          height: height,
          width: width,
        );
      },
    );
  }
}

class AppPlaceholderWidget {
  static AppSvgAsset image({double? width, double? height}) => AppSvgAsset(
    AppAssetsMapper.imagePlaceholder,
    fit: BoxFit.cover,
    width: width,
    height: height,
  );
}

class AppCircleImage extends StatelessWidget {
  const AppCircleImage(this.url, {super.key, this.size = 50.0, this.fit});

  final String url;

  final double size;

  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: AppNetworkImage(
        url,
        height: size,
        width: size,
        fit: fit ?? BoxFit.cover,
      ),
    );
  }
}
