import 'package:flutter/material.dart';

import '../../data/enum_options.dart';

/// Renders a nationality selection as an inline grid of flags with a search bar.
class NationalityPickerField extends StatefulWidget {
  const NationalityPickerField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.enabled = true,
    this.suffixIcon,
  });

  final String label;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final Widget? suffixIcon;

  @override
  State<NationalityPickerField> createState() => _NationalityPickerFieldState();
}

class _NationalityPickerFieldState extends State<NationalityPickerField> {
  bool _expanded = false;
  String _searchQuery = '';
  late final TextEditingController _searchController = TextEditingController();
  late final List<String> _allOptions = EnumOptions.optionsFor('nationality');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Converts an ISO 3166-1 alpha-2 country code to its emoji flag.
  String _countryCodeToEmoji(String code) {
    if (code.length != 2) return '';
    final codePoints = code.toUpperCase().codeUnits.map((char) => 127397 + char).toList();
    return String.fromCharCodes(codePoints);
  }

  /// Hardcoded mapping to standard ISO country codes for the flag emojis.
  String _getFlagForCountry(String countryName) {
    if (countryName == 'Unknown') return '❓';
    
    // A simplified map of the countries in enum_options.dart
    const map = {
      'Afghanistan': 'AF', 'Albania': 'AL', 'Algeria': 'DZ', 'Andorra': 'AD', 'Angola': 'AO',
      'Antigua and Barbuda': 'AG', 'Argentina': 'AR', 'Armenia': 'AM', 'Australia': 'AU',
      'Austria': 'AT', 'Azerbaijan': 'AZ', 'Bahamas': 'BS', 'Bahrain': 'BH', 'Bangladesh': 'BD',
      'Barbados': 'BB', 'Belarus': 'BY', 'Belgium': 'BE', 'Belize': 'BZ', 'Benin': 'BJ',
      'Bhutan': 'BT', 'Bolivia': 'BO', 'Bosnia and Herzegovina': 'BA', 'Botswana': 'BW',
      'Brazil': 'BR', 'Brunei': 'BN', 'Bulgaria': 'BG', 'Burkina Faso': 'BF', 'Burundi': 'BI',
      'Cabo Verde': 'CV', 'Cambodia': 'KH', 'Cameroon': 'CM', 'Canada': 'CA', 'Central African Republic': 'CF',
      'Chad': 'TD', 'Chile': 'CL', 'China': 'CN', 'Colombia': 'CO', 'Comoros': 'KM', 'Congo': 'CG',
      'Costa Rica': 'CR', 'Croatia': 'HR', 'Cuba': 'CU', 'Cyprus': 'CY', 'Czechia': 'CZ',
      'Denmark': 'DK', 'Djibouti': 'DJ', 'Dominica': 'DM', 'Dominican Republic': 'DO',
      'Ecuador': 'EC', 'Egypt': 'EG', 'El Salvador': 'SV', 'Equatorial Guinea': 'GQ', 'Eritrea': 'ER',
      'Estonia': 'EE', 'Eswatini': 'SZ', 'Ethiopia': 'ET', 'Fiji': 'FJ', 'Finland': 'FI',
      'France': 'FR', 'Gabon': 'GA', 'Gambia': 'GM', 'Georgia': 'GE', 'Germany': 'DE',
      'Ghana': 'GH', 'Greece': 'GR', 'Grenada': 'GD', 'Guatemala': 'GT', 'Guinea': 'GN',
      'Guinea-Bissau': 'GW', 'Guyana': 'GY', 'Haiti': 'HT', 'Honduras': 'HN', 'Hungary': 'HU',
      'Iceland': 'IS', 'India': 'IN', 'Indonesia': 'ID', 'Iran': 'IR', 'Iraq': 'IQ',
      'Ireland': 'IE', 'Israel': 'IL', 'Italy': 'IT', 'Jamaica': 'JM', 'Japan': 'JP',
      'Jordan': 'JO', 'Kazakhstan': 'KZ', 'Kenya': 'KE', 'Kiribati': 'KI', 'Kuwait': 'KW',
      'Kyrgyzstan': 'KG', 'Laos': 'LA', 'Latvia': 'LV', 'Lebanon': 'LB', 'Lesotho': 'LS',
      'Liberia': 'LR', 'Libya': 'LY', 'Liechtenstein': 'LI', 'Lithuania': 'LT', 'Luxembourg': 'LU',
      'Madagascar': 'MG', 'Malawi': 'MW', 'Malaysia': 'MY', 'Maldives': 'MV', 'Mali': 'ML',
      'Malta': 'MT', 'Marshall Islands': 'MH', 'Mauritania': 'MR', 'Mauritius': 'MU', 'Mexico': 'MX',
      'Micronesia': 'FM', 'Moldova': 'MD', 'Monaco': 'MC', 'Mongolia': 'MN', 'Montenegro': 'ME',
      'Morocco': 'MA', 'Mozambique': 'MZ', 'Myanmar': 'MM', 'Namibia': 'NA', 'Nauru': 'NR',
      'Nepal': 'NP', 'Netherlands': 'NL', 'New Zealand': 'NZ', 'Nicaragua': 'NI', 'Niger': 'NE',
      'Nigeria': 'NG', 'North Korea': 'KP', 'North Macedonia': 'MK', 'Norway': 'NO', 'Oman': 'OM',
      'Pakistan': 'PK', 'Palau': 'PW', 'Panama': 'PA', 'Papua New Guinea': 'PG', 'Paraguay': 'PY',
      'Peru': 'PE', 'Philippines': 'PH', 'Poland': 'PL', 'Portugal': 'PT', 'Qatar': 'QA',
      'Romania': 'RO', 'Russia': 'RU', 'Rwanda': 'RW', 'Saint Kitts and Nevis': 'KN', 'Saint Lucia': 'LC',
      'Saint Vincent and the Grenadines': 'VC', 'Samoa': 'WS', 'San Marino': 'SM', 'Sao Tome and Principe': 'ST',
      'Saudi Arabia': 'SA', 'Senegal': 'SN', 'Serbia': 'RS', 'Seychelles': 'SC', 'Sierra Leone': 'SL',
      'Singapore': 'SG', 'Slovakia': 'SK', 'Slovenia': 'SI', 'Solomon Islands': 'SB', 'Somalia': 'SO',
      'South Africa': 'ZA', 'South Korea': 'KR', 'South Sudan': 'SS', 'Spain': 'ES', 'Sri Lanka': 'LK',
      'Sudan': 'SD', 'Suriname': 'SR', 'Sweden': 'SE', 'Switzerland': 'CH', 'Syria': 'SY',
      'Taiwan': 'TW', 'Tajikistan': 'TJ', 'Tanzania': 'TZ', 'Thailand': 'TH', 'Timor-Leste': 'TL',
      'Togo': 'TG', 'Tonga': 'TO', 'Trinidad and Tobago': 'TT', 'Tunisia': 'TN', 'Turkey': 'TR',
      'Turkmenistan': 'TM', 'Tuvalu': 'TV', 'Uganda': 'UG', 'Ukraine': 'UA', 'United Arab Emirates': 'AE',
      'United Kingdom': 'GB', 'United States': 'US', 'Uruguay': 'UY', 'Uzbekistan': 'UZ',
      'Vanuatu': 'VU', 'Vatican City': 'VA', 'Venezuela': 'VE', 'Vietnam': 'VN', 'Yemen': 'YE',
      'Zambia': 'ZM', 'Zimbabwe': 'ZW', 'The Island': '🏝️',
    };
    final code = map[countryName];
    if (code == null) return '🏳️';
    // If the value contains any non-ASCII character it's already an emoji, not an ISO code.
    if (code.runes.any((r) => r > 127)) return code;
    return _countryCodeToEmoji(code);
  }

  String _formatSelection(String? value) {
    if (value == null || value.isEmpty) return '—';
    final flag = _getFlagForCountry(value);
    return '$flag $value';
  }

  void _select(String? value) {
    if (value != null) {
      widget.onChanged(value);
    }
    setState(() {
      _expanded = false;
      _searchQuery = '';
      _searchController.clear();
    });
  }

  Widget _buildFlagButton(String country, bool isSelected) {
    final flag = _getFlagForCountry(country);
    final scheme = Theme.of(context).colorScheme;
    final color = scheme.primary;

    return Tooltip(
      message: country,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: widget.enabled ? () => _select(country) : null,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: isSelected
                ? color.withOpacity(0.18)
                : scheme.surfaceContainerHighest.withOpacity(0.35),
            border: Border.all(
              color: isSelected ? color : scheme.outlineVariant,
              width: isSelected ? 1.6 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.45),
                      blurRadius: 10,
                      spreadRadius: 0.5,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              flag,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredOptions = _allOptions.where((opt) =>
        opt.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: widget.enabled
              ? () => setState(() => _expanded = !_expanded)
              : null,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: widget.label,
              enabled: widget.enabled,
              suffixIcon: widget.suffixIcon != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                        widget.suffixIcon!,
                      ],
                    )
                  : Icon(_expanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            ),
            child: Text(_formatSelection(widget.initialValue)),
          ),
        ),
        if (_expanded && widget.enabled) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search nationality...',
              prefixIcon: Icon(Icons.search),
              isDense: true,
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildFlagButton('Unknown', widget.initialValue == 'Unknown'),
              for (final country in filteredOptions)
                _buildFlagButton(country, widget.initialValue == country),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}
