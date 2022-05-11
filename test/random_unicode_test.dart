import 'package:random_unicode/random_unicode.dart';
import 'package:test/test.dart';

void main() {
  group('RandomUnicode -', () {
    test('add', () {
      final u = RandomUnicode()
        ..addIncluded(lower: 0x20, upper: 0x7F)
        ..addIncluded(lower: 0x80, upper: 0x81)
        ..addExcluded(charCodes: [0x22, 0x24, 0x30]);
      expect(u.included.length, 2);
      expect(u.excluded.length, 3);
    });
    test('string: empty', () {
      final u = RandomUnicode()
        .. addIncluded(lower: 0x20, upper: 0x7F);
      expect(u.string(0).length, 0);
    });
    test('string: length between 10 and 20', () {
      final u = RandomUnicode()
        .. addIncluded(lower: 0x20, upper: 0x7F);
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
