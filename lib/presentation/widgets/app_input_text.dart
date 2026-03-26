import 'package:flutter/material.dart';

import '../../core/config/app_assets_mapper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacings.dart';
import 'app_text.dart';
import 'image_view.dart';

class AppInputText extends StatefulWidget {
  const AppInputText({
    super.key,
    this.hintText,
    this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText,
    this.controller,
    this.cursorColor,
    this.borderColor,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.onTap,
    this.maxLines,
    this.prefixIcon,
    this.suffixIcon,
    this.animateHints = false,
    this.border = true,
    this.autofocus = false,
    this.mandatory = false,
    this.enabled = true,
    this.showHintAsLabel = false,
    this.textInputAction,
    this.error,
    this.onSubmitted,
    this.height,
    this.filled = true,
    this.hintTextColor,
    this.onChanged,
    this.showCursor,
    this.enableInteractiveSelection,
    this.textCapitalization,
  });

  final String? hintText;

  final String? label;
  final String? error;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final Color? cursorColor;
  final Color? borderColor;
  final Color? hintTextColor;
  final bool? obscureText;
  final bool animateHints;
  final bool border;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final Function()? onTap;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool mandatory;
  final bool enabled;
  final bool showHintAsLabel;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final double? height;
  final bool filled;
  final Function(String)? onChanged;
  final bool? showCursor;
  final bool? enableInteractiveSelection;
  final TextCapitalization? textCapitalization;

  @override
  State<AppInputText> createState() => _AppInputTextState();
}

class _AppInputTextState extends State<AppInputText> {
  bool _obscure = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText ?? false;
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
        SizedBox(
          height: widget.height ?? AppSizes.inputFieldHeight,
          child: TextField(
            expands: widget.maxLines == null,
            onSubmitted: widget.onSubmitted,
            textInputAction: widget.textInputAction,
            enabled: widget.enabled,
            autofocus: widget.autofocus,
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: widget.keyboardType,
            maxLines: !_obscure ? widget.maxLines : 1,
            onTap: widget.onTap,
            style: AppText.t16sb.copyWith(color: AppColors.textPrimary),
            textCapitalization:
                widget.textCapitalization ?? TextCapitalization.none,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              fillColor: AppColors.backgroundInputField,
              filled: widget.filled,
              label: widget.hintText != null && widget.showHintAsLabel
                  ? Text.rich(
                      style: AppText.t16sb.copyWith(color: AppColors.textHint),
                      TextSpan(
                        children: [
                          TextSpan(text: widget.hintText!),
                          if (widget.mandatory)
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: AppColors.textError),
                            ),
                        ],
                      ),
                    )
                  : null,
              focusedBorder: _getBorder(),
              enabledBorder: _getBorder(),
              errorBorder: _getBorder(),
              border: _getBorder(),
              disabledBorder: _getBorder(),
              focusedErrorBorder: _getBorder(),
              hintText: !widget.showHintAsLabel ? widget.hintText : '',
              hintStyle: AppText.t16sb.copyWith(
                color: widget.hintTextColor ?? AppColors.textHint,
              ),
              error: widget.error != null && widget.error!.isNotEmpty
                  ? Text(
                      widget.error!,
                      style: AppText.t12r.copyWith(color: AppColors.textError),
                    )
                  : null,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.obscureText != null
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                      child: AppSvgAsset(
                        _obscure
                            ? AppAssetsMapper.icEyeSlash
                            : AppAssetsMapper.icEye,
                        height: 16,
                        width: 16,
                        fit: BoxFit.scaleDown,
                        color: _obscure
                            ? AppColors.iconSecondary
                            : AppColors.iconPrimary,
                      ),
                    )
                  : widget.suffixIcon,
            ),
            obscureText: _obscure,
            textAlign: widget.textAlign,
            enableInteractiveSelection: widget.enableInteractiveSelection,
            showCursor: widget.showCursor,
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _getBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.r40),
      borderSide: BorderSide(
        color: widget.border
            ? (widget.borderColor ?? AppColors.borderFocused)
            : AppColors.transparent,
        width: 1,
      ),
    );
  }
}
