/// Static registry of allowed values for `enum`-typed attributes, keyed
/// by AttributeDefinition.attrKey. Raw values are stable identifiers
/// stored in Facts; display labels are resolved separately (see
/// attribute_labels.dart) so they can be bilingual.
class EnumOptions {
  EnumOptions._();

  static const Map<String, List<String>> _options = {
    'status': ['alive', 'deceased', 'missing', 'unknown', 'transformed'],
    'production_status': ['concept', 'developing', 'active', 'final', 'cut'],
  };

  static List<String> optionsFor(String attrKey) => _options[attrKey] ?? const [];
}
