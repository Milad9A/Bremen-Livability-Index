import 'package:bli/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CountryCodePicker extends StatelessWidget {
  static const List<(String, String, String)> countries = [
    ('🇩🇪', '+49', 'DE'),
    ('🇺🇸', '+1', 'US'),
    ('🇬🇧', '+44', 'GB'),
    ('🇫🇷', '+33', 'FR'),
    ('🇮🇹', '+39', 'IT'),
    ('🇪🇸', '+34', 'ES'),
    ('🇦🇹', '+43', 'AT'),
    ('🇨🇭', '+41', 'CH'),
    ('🇳🇱', '+31', 'NL'),
    ('🇧🇪', '+32', 'BE'),
    ('🇵🇱', '+48', 'PL'),
    ('🇵🇹', '+351', 'PT'),
    ('🇸🇪', '+46', 'SE'),
    ('🇳🇴', '+47', 'NO'),
    ('🇩🇰', '+45', 'DK'),
    ('🇫🇮', '+358', 'FI'),
    ('🇮🇪', '+353', 'IE'),
    ('🇬🇷', '+30', 'GR'),
    ('🇨🇿', '+420', 'CZ'),
    ('🇹🇷', '+90', 'TR'),
  ];

  final (String, String, String) selectedCountry;
  final Function((String, String, String)) onChanged;

  const CountryCodePicker({
    super.key,
    required this.selectedCountry,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<(String, String, String)>(
          value: selectedCountry,
          icon: const Icon(Icons.arrow_drop_down),
          dropdownColor: AppColors.white,
          menuMaxHeight: 400,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
          selectedItemBuilder: (context) => countries.map((country) {
            return Center(
              child: Text(
                '${country.$1} ${country.$2}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            );
          }).toList(),
          items: countries.map((country) {
            return DropdownMenuItem<(String, String, String)>(
              value: country,
              child: SizedBox(
                width: 200,
                child: Row(
                  children: [
                    Text(country.$1, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${country.$2} ${country.$3}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}
