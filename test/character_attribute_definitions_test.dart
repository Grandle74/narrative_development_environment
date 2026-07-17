import 'package:flutter_test/flutter_test.dart';
import 'package:narrative_development_environment/data/database.dart';

void main() {
  test('buildDefaultAttributeDefinitions uses the new identity and narrative field types', () {
    final definitions = buildDefaultAttributeDefinitions();
    final defsByKey = <String, AttributeDefinitionsCompanion>{};
    for (final definition in definitions) {
      if (definition.attrKey.present) {
        defsByKey[definition.attrKey.value] = definition;
      }
    }

    expect(defsByKey['alias']?.valueType.value, 'tag_list');
    expect(defsByKey['affiliation']?.valueType.value, 'tag_list');
    expect(defsByKey['nationality']?.valueType.value, 'enum');
    expect(defsByKey['first_appearance_volume']?.valueType.value, 'number');
    expect(defsByKey['first_appearance_chapter']?.valueType.value, 'number');
    expect(defsByKey['first_appearance_page'], isNull);
    expect(defsByKey['current_location'], isNull);
  });
}
