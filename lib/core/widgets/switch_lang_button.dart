import 'package:flutter/material.dart';
import 'package:playstation_manager/core/extentions/theme_extensions.dart';

import '../languages/languages.dart';

class SwitchLangButton extends StatefulWidget {
  const SwitchLangButton({super.key});

  @override
  State<SwitchLangButton> createState() => _SwitchLangButtonState();
}

class _SwitchLangButtonState extends State<SwitchLangButton> {
  late Languages _currentLanguage = Languages.currentLanguage;

  @override
  Widget build(BuildContext context) {
    _currentLanguage = Languages.currentLanguage;
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<Languages>(
          isExpanded: true,
          value: _currentLanguage,
          dropdownColor: context.mapCard,
          padding: EdgeInsets.zero,
          borderRadius: BorderRadius.circular(4),
          items:
              Languages.values
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: FittedBox(
                        child: Text(
                          e.languageCode == 'en' ? 'English' : 'العربية',
                          style: context.textTheme.headlineLarge!.copyWith(
                            color: context.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            setState(() {
              if (value != null) {
                _currentLanguage = value;
                Languages.setLocaleWithContext(context, value);
              }
              // remove focus
              FocusScope.of(context).unfocus();
            });
          },
        ),
      ),
    );
  }
}
