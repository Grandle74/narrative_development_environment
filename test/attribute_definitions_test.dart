import 'package:flutter_test/flutter_test.dart';
import 'package:narrative_development_environment/data/database.dart';

void main() {
  test('core identity fields are seeded as mutable for correction after save', () {
    final definitions = buildDefaultAttributeDefinitions();
    final mutableByKey = <String, bool>{
      for (final definition in definitions)
        definition.attrKey.value: definition.mutable.value,
    };

    expect(mutableByKey['name'], isTrue);
    expect(mutableByKey['alias'], isTrue);
    expect(mutableByKey['species'], isTrue);
    expect(mutableByKey['birth'], isTrue);
  });
}
