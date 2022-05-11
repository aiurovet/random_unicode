// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:random_unicode/random_unicode.dart';
import 'package:test/test.dart';

/// RandomUnicodeRange tests
///
void main() {
  group('RandomUnicodeRange -', () {
    test('constructor - excessive', () {
      final r = RandomUnicodeRange(-3, 0x77777777);
      expect(r.min == 0 && r.max == 0x10FFFF, true);
    });
    test('constructor - trivial', () {
      final r = RandomUnicodeRange(0x21);
      expect(r.min, 0x21);
      expect(r.max, 0x21);
    });
    test('nextCharCode', () {
      final r = RandomUnicodeRange(0x10, 0x20);
      final c = r.nextCharCode(RandomUnicode.defaultRandom.nextInt);
      expect(c >= r.min && c <= r.max, true);
    });
  });
}
