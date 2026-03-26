import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/config/app_assets_mapper.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_sizes.dart';
import 'index.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage(
    this.image, {
    super.key,
    this.onPressed,
    this.showShadow = true,
    this.size = 48,
    this.radius,
    this.enableBorder = false,
    this.borderWidth,
  });

  final Widget image;
  final bool showShadow;
  final VoidCallback? onPressed;
  final double size;
  final double? radius;
  final double? borderWidth;
  final bool enableBorder;

  double get _radius => radius ?? AppRadii.r20;

  @override
  Widget build(BuildContext context) {
    return AppInkWell(
      borderRadius: _radius,
      onTap: onPressed,
      child: Container(
        padding: enableBorder
            ? EdgeInsets.all(borderWidth ?? AppSizes.profileBorderWidth)
            : null,
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_radius),
          //color: AppColors.profileBorder,
          //boxShadow: showShadow ? [AppShadows.secondaryShadow] : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            (radius ?? size) - (borderWidth ?? 0),
          ),
          child: image,
        ),
      ),
    );
  }

  ProfileImage.local(
    String image, {
    super.key,
    this.onPressed,
    this.showShadow = true,
    this.enableBorder = false,
    this.borderWidth,
    this.size = 40,
    this.radius,
  }) : image = image.isNotEmpty
           ? Image.file(
               File(image),
               fit: BoxFit.cover,
               errorBuilder: (context, error, stackTrace) {
                 return AppAssetImage(
                   AppAssetsMapper.personPlaceholder,
                   height: size,
                   width: size,
                 );
               },
             )
           : AppAssetImage(
               AppAssetsMapper.personPlaceholder,
               height: size,
               width: size,
             );

  ProfileImage.asset(
    String image, {
    super.key,
    this.onPressed,
    this.showShadow = true,
    this.enableBorder = false,
    this.borderWidth,
    this.size = 40,
    this.radius,
  }) : image = image.isNotEmpty
           ? Image.asset(
               image,
               fit: BoxFit.cover,
               errorBuilder: (context, error, stackTrace) {
                 return AppAssetImage(
                   AppAssetsMapper.personPlaceholder,
                   height: size,
                   width: size,
                 );
               },
             )
           : AppAssetImage(
               AppAssetsMapper.personPlaceholder,
               height: size,
               width: size,
             );

  ProfileImage.network(
    String image, {
    super.key,
    this.onPressed,
    this.showShadow = true,
    this.enableBorder = false,
    this.size = 40,
    this.borderWidth,
    this.radius,
  }) : image = AppNetworkImage(
         image,
         fit: BoxFit.cover,
         height: size,
         width: size,
         placeholder: AppAssetImage(
           AppAssetsMapper.personPlaceholder,
           height: size,
           width: size,
         ),
       );
}
