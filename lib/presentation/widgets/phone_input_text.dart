import 'package:deep_country_code_picker/deep_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacings.dart';
import 'index.dart';

class PhoneInputText extends StatefulWidget {
  const PhoneInputText({
    super.key,
    this.textEditingController,
    this.onCountryCodeSelected,
    this.mandatory = false,
    this.selectedCountryCode = '',
  });

  final TextEditingController? textEditingController;
  final Function(Country country)? onCountryCodeSelected;
  final bool mandatory;
  final String selectedCountryCode;

  @override
  State<PhoneInputText> createState() => _PhoneInputTextState();
}

class _PhoneInputTextState extends State<PhoneInputText> {
  late Country _selectedCountryCode =
      CountryCodePicker.getCountry(widget.selectedCountryCode) ??
      CountryCodePicker.countries.first;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      widget.onCountryCodeSelected?.call(_selectedCountryCode);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: AppSizes.inputFieldHeight + 2,
          decoration: BoxDecoration(
            color: AppColors.backgroundRaised,
            border: Border.all(color: AppColors.borderFocused, width: 1),
            borderRadius: BorderRadius.circular(AppRadii.r32),
          ),
          child: Row(
            children: [
              _buildCountryCode(),
              Expanded(
                child: AppInputText(
                  mandatory: widget.mandatory,
                  controller: widget.textEditingController,
                  hintText: 'Phone number',
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.phone,
                  maxLines: 1,
                  border: false,
                  inputFormatters: [
                    PhoneInputFormatter(
                      allowEndlessPhone: false,
                      shouldCorrectNumber: false,
                      defaultCountryCode: _selectedCountryCode.countryCode,
                    ),
                  ],
                  filled: false,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCountryCode() {
    return AppInkWell(
      onTap: _showSearchableDialog,
      child: Container(
        height: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacings.s8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(_selectedCountryCode.flag, type: AppTextType.t24b),
            const SizedBox(width: AppSpacings.s4),
            AppText(_selectedCountryCode.dialCode, type: AppTextType.t16sb),
          ],
        ),
      ),
    );
  }

  void _showSearchableDialog() async {
    final Country? selectedItem = await showDialog<Country>(
      context: context,
      builder: (BuildContext context) {
        return AppCountrySearchableDialog(
          allItems: CountryCodePicker.countries,
        );
      },
    );

    if (selectedItem != null) {
      setState(() {
        _selectedCountryCode = selectedItem;
      });
      widget.onCountryCodeSelected?.call(selectedItem);
    }
  }
}
