// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:random_unicode/random_unicode.dart';
import 'package:test/test.dart';

/// RandomUnicodeRange tests
///
void main() {
  group('RandomUnicodeRange -', () {
    test('constructor - excessive', () {
      final r = RandomUnicodeRange(min: -3, max: 0x77777777);
      expect(r.min == 0 && r.max == 0x10FFFF, true);
    });
    test('constructor - trivial', () {
      final r = RandomUnicodeRange(min: 0x21);
      expect(r.min, 0x21);
      expect(r.max, 0x21);
    });
    test('nextCharCode - list', () {
      final r = RandomUnicodeRange(list: [0x10, 0x20, 0x30]);
      final c = r.nextCharCode();
      expect(c == 0x10 || c == 0x20 || c == 0x30, true);
    });
    test('nextCharCode - min/max', () {
      final r = RandomUnicodeRange(min: 0x10, max: 0x20);
      final c = r.nextCharCode();
      expect(c >= r.min && c <= r.max, true);
    });
  });
}
