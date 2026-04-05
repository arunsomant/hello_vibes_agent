import 'package:flutter/material.dart';

import '../../core/config/app_assets_mapper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacings.dart';
import 'app_text.dart';
import 'image_view.dart';

class AppDropDownButton<T> extends StatefulWidget {
  const AppDropDownButton({
    super.key,
    this.selectedItemBuilder,
    this.value,
    this.items,
    this.shadow = false,
    this.title,
    this.label,
    this.onChanged,
    this.enabled = true,
    this.isExpanded = true,
    this.enableIcon = true,
    this.underline = true,
    this.mandatory = false,
    this.filled = false,
  });

  final DropdownButtonBuilder? selectedItemBuilder;

  final T? value;

  final List<DropdownMenuItem<T>>? items;

  final bool shadow;

  final String? title;

  final String? label;

  final ValueChanged<T>? onChanged;

  final bool enabled;

  final bool isExpanded;

  final bool enableIcon;

  final bool underline;

  final bool mandatory;

  final bool filled;

  @override
  State<AppDropDownButton<T>> createState() => _AppDropDownButtonState<T>();
}

class _AppDropDownButtonState<T> extends State<AppDropDownButton<T>> {
  T? value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AppDropDownButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != null) {
      value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacings.s8,
      children: [
        if (widget.label != null) ...[
          AppText(widget.label!, type: AppTextType.t14r),
        ],
        InputDecorator(
          decoration: InputDecoration(
            fillColor: AppColors.backgroundInputField,
            filled: widget.filled,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacings.s16,
            ),
            alignLabelWithHint: true,
            focusedBorder: _getBorder(),
            enabledBorder: _getBorder(),
          ),
          child: DropdownButton<T>(
            value: value,
            elevation: 8,
            itemHeight: AppSizes.inputFieldHeight,
            selectedItemBuilder: widget.selectedItemBuilder,
            icon: widget.enableIcon
                ? AppSvgAsset(
                    AppAssetsMapper.icArrowDown,
                    color: AppColors.textPrimary,
                  )
                : const SizedBox(),
            iconSize: 24,
            borderRadius: BorderRadius.circular(AppRadii.r32),
            isExpanded: widget.isExpanded,
            hint: widget.title != null
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      style: AppText.t16sb.copyWith(color: AppColors.textHint),
                      TextSpan(
                        children: [
                          TextSpan(text: widget.title!),
                          if (widget.mandatory)
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: AppColors.textError),
                            ),
                        ],
                      ),
                    ),
                  )
                : null,
            dropdownColor: AppColors.backgroundRaised,
            style: AppText.t16r.copyWith(color: AppColors.textPrimary),
            underline: const SizedBox(),
            onChanged: widget.enabled
                ? (e) {
                    setState(() {
                      value = e;
                    });
                    if (widget.onChanged != null) {
                      widget.onChanged!.call(e as T);
                    }
                  }
                : null,
            items: widget.items,
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _getBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.r40),
      borderSide: BorderSide(color: AppColors.borderFocused, width: 1),
    );
  }
}
