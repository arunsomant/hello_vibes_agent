import 'package:deep_country_code_picker/deep_country_code_picker.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/theme/app_spacings.dart';
import 'index.dart';

class AppCountrySearchableDialog extends StatefulWidget {
  final List<Country> allItems;

  const AppCountrySearchableDialog({super.key, required this.allItems});

  @override
  AppCountrySearchableDialogState createState() =>
      AppCountrySearchableDialogState();
}

class AppCountrySearchableDialogState
    extends State<AppCountrySearchableDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Country> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.allItems;
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = widget.allItems
          .where(
            (item) =>
                item.countryCode.toLowerCase().contains(query) ||
                item.name.toLowerCase().contains(query) ||
                item.dialCode.toLowerCase().contains(query),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      clipBehavior: Clip.hardEdge,
      backgroundColor: AppColors.backgroundRaised,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.r8),
      ),
      titlePadding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.s16,
        vertical: AppSpacings.s16,
      ),
      title: AppInputText(controller: _searchController, hintText: 'Search..'),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacings.s8),
          itemCount: _filteredItems.length,
          itemBuilder: (context, index) {
            final item = _filteredItems[index];
            return AppInkWell(
              borderRadius: AppRadii.r4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacings.s8,
                  vertical: AppSpacings.s4,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText(item.flag, type: AppTextType.t24b),
                    const SizedBox(width: AppSpacings.s8),
                    Flexible(child: AppText(item.name, maxLine: 1)),
                    Text(
                      '(${item.dialCode})',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                // Return the selected item and close the dialog.
                Navigator.of(context).pop(item);
              },
            );
          },
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacings.s16,
        vertical: AppSpacings.s4,
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
