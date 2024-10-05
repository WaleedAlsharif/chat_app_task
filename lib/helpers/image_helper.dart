import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

mixin ImageHelper {
  Widget imageBox({
    required double size,
    BoxShape shape = BoxShape.circle,
    required Widget child,
  }) {
    return Container(
      height: size.h,
      width: size.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: shape,
      ),
      child: child,
    );
  }

  Widget appSvgImage(
    String path, {
    Color? color,
    double? width,
    double? height,
    bool fullPath = false,
    BoxFit fit = BoxFit.contain,
    Widget? placeholderBuilder,
    bool network = false,
    double opacity = 1,
  }) {
    /// Path => folder/name
    return Opacity(
      opacity: opacity,
      child: !network
          ? SvgPicture.asset(
              fullPath ? path : 'assets/$path.svg',
              width: width,
              height: height,
              color: color,
              // colorFilter: color != null
              //     ? ColorFilter.mode(
              //         color,
              //         BlendMode.srcIn,
              //       )
              //     : null,
              fit: fit,
              // placeholderBuilder: (context) => placeholderBuilder ?? errorImageBuilder,
            )
          : SvgPicture.network(
              path,
              width: width,
              height: height,
              color: color,
              fit: fit,
            ),
    );
  }

  Widget appCachedImage(
    String? image, {
    double? width = double.infinity,
    double? height,
    Color? color,
  }) {
    return CachedNetworkImage(
      imageUrl: image ?? '',
      width: width,
      fit: BoxFit.cover,
      height: height,
      color: color,
      errorWidget: (context, url, error) => errorImageBuilder,
    );
  }

  Widget get errorImageBuilder {
    return Padding(
      padding: EdgeInsets.all(6.h),
      child: appSvgImage(
        appLogo(),
        fit: BoxFit.cover,
        fullPath: true,
        color: Colors.black,
      ),
    );
  }

  String appLogo() => 'assets/images/app_logo.svg';
}
