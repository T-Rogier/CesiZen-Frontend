import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:cesizen_frontend/app/theme/app_theme.dart';

class NavIcon extends StatelessWidget {
  final String route;
  final int index;
  final int currentIndex;
  final IconData? iconData;
  final String? assetPath;
  final bool isSvg;
  final String label;

  const NavIcon({
    super.key,
    required this.route,
    required this.index,
    required this.currentIndex,
    required this.label,
    this.iconData,
    this.assetPath,
    this.isSvg = true,
  }) : assert(iconData != null || assetPath != null, 'Provide iconData or assetPath');

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    final color = isActive ? AppColors.black : AppColors.greenFont;

    return GestureDetector(
      onTap: () => context.go(route),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? AppColors.greenFill : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget _buildIcon(Color color) {
    if (assetPath != null) {
      if (isSvg) {
        return SvgPicture.asset(assetPath!, color: color, width: 28, height: 28);
      } else {
        return Image.asset(assetPath!, color: color, width: 28, height: 28);
      }
    } else {
      return Icon(iconData, color: color, size: 28);
    }
  }
}
