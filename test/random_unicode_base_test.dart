// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:random_unicode/random_unicode.dart';
import 'package:test/test.dart';

/// RandomUnicode tests
///
void main() {
  group('RandomUnicode -', () {
    test('add', () {
      final u = RandomUnicode()
        ..addIncluded(min: 0x20, max: 0x7F)
        ..addIncluded(min: 0x80, max: 0x81)
        ..addExcluded(charCodes: [0x22, 0x24, 0x30]);
      expect(u.included.length, 2);
      expect(u.excluded.length, 3);
    });
    test('string - empty', () {
      final u = RandomUnicode()..addIncluded(min: 0x20, max: 0x7F);
      expect(u.string(0).length, 0);
    });
    test('string - length between 10 and 20', () {
      final u = RandomUnicode()..addIncluded(min: 0x20, max: 0x7F);
      final s = u.string(10, 20);
      expect((s.length >= 10) && (s.length <= 20), true);
    });
    test('string - huge', () {
      final u = RandomUnicode();
      final length = 1000000;
      final s = u.string(length);
      expect((s.length >= length) && (s.length <= 2 * length), true);
    });
    test('string - ASCII', () {
      final s = RandomUnicode.asciiAlpha().string(300);
      expect(s.replaceAll(RegExp(r'[\x00-\x7F]*'), '').length, 0);
    });
    test('string - ASCII alpha', () {
      final s = RandomUnicode.asciiAlpha().string(100);
      expect(s.replaceAll(RegExp(r'[A-Za-z]*'), '').length, 0);
    });
    test('string - ASCII alphanumeric', () {
      final s = RandomUnicode.asciiAlphaNumeric().string(100);
      expect(s.replaceAll(RegExp(r'[0-9A-Za-z]*'), '').length, 0);
    });
    test('string - ASCII numeric', () {
      final s = RandomUnicode.asciiNumeric().string(100);
      expect(s.replaceAll(RegExp(r'[0-9]*'), '').length, 0);
    });
    test('string - ASCII hexadecimal', () {
      final s = RandomUnicode.asciiHexadecimal().string(100);
      expect(s.replaceAll(RegExp(r'[0-9A-Fa-f]*'), '').length, 0);
    });
    test('string - BMP', () {
      final s = RandomUnicode.bmp().string(300);
      expect(s.replaceAll(RegExp(r'[\u0000-\uFFFF]*', unicode: true), '').length, 0);
    });
    test('string - valid file name - lax', () {
      final s = RandomUnicode.validFileName().string(100);
      expect(RegExp(r'[<>:"/\|?*]').hasMatch(s), false);
    });
    test('string - valid file name - strict', () {
      final s = RandomUnicode.validFileName().string(100);
      expect(RegExp('[<>:"/\\|?*]\$[]{}()!,;').hasMatch(s), false);
    });
  });
}
