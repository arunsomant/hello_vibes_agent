import 'package:flutter/material.dart';

import '../../core/config/app_assets_mapper.dart';
import '../../core/theme/app_colors.dart';
import 'index.dart';

class Accordion extends StatefulWidget {
  final List<Widget> children;
  final Widget header;
  final bool opened;
  final bool enableRightIcon;
  final String? primaryRightIcon;
  final String? secondaryRightIcon;

  const Accordion({
    super.key,
    required this.header,
    required this.children,
    this.opened = false,
    this.enableRightIcon = false,
    this.primaryRightIcon,
    this.secondaryRightIcon,
  });

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool showContent = false;

  final duration = const Duration(milliseconds: 400);

  @override
  void initState() {
    showContent = widget.opened;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget header = widget.header;
    if (widget.enableRightIcon) {
      header = Material(
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(child: header),
            if (widget.primaryRightIcon != null && !showContent)
              AppSvgAsset(widget.primaryRightIcon!),
            if (widget.secondaryRightIcon != null && showContent)
              AppSvgAsset(widget.secondaryRightIcon!),
            if (widget.primaryRightIcon == null &&
                widget.secondaryRightIcon == null)
              AnimatedRotation(
                duration: const Duration(milliseconds: 200),
                turns: showContent ? 0 : 0.5,
                child: const RotatedBox(
                  quarterTurns: 2,
                  child: AppSvgAsset(
                    AppAssetsMapper.icArrowDown,
                    color: AppColors.iconPrimary,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              showContent = !showContent;
            });
          },
          child: header,
        ),
        AnimatedSwitcher(
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (child, animation) {
            return SizeTransition(
              sizeFactor: animation,
              axisAlignment: 1,
              child: child,
            );
          },
          duration: duration,
          child: showContent
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(children: widget.children),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
