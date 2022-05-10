import 'package:random_unicode/random_unicode.dart';
import 'package:test/test.dart';

void main() {
  group('RandomUnicode -', () {
    test('add', () {
      final u = RandomUnicode()
        ..add(included: RandomUnicodeRange(0x20, 0x7F))
        ..add(included: RandomUnicodeRange(0x80, 0x81))
        ..add(charCode: 0x30)
        ..add(excluded: RandomUnicodeRange(0x22, 0x24));
      expect(u.included.length, 3);
      expect(u.excluded.length, 1);

      print(u.string(10));
    });
    test('string: empty', () {
      final u = RandomUnicode(included: [RandomUnicodeRange(0x20, 0x7F)]);
      expect(u.string(0).length, 0);
    });
    test('string: length between 10 and 20', () {
      final u = RandomUnicode(included: [RandomUnicodeRange(0x20, 0x7F)]);
      final s = u.string(10, 20);
      expect((s.length >= 10) && (s.length <= 20), true);
    });
    test('string: huge', () {
      final u = RandomUnicode();
      final length = 1000000;
      final s = u.string(length);
      expect((s.length >= length) && (s.length <= 2 * length), true);
    });
  });
}
