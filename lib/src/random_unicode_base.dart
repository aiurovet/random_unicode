// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'dart:math';
import 'package:lim/lim.dart';
import 'package:random_unicode/random_unicode.dart';

/// Class for the random uncode string generation
///
class RandomUnicode {
  /// List of ranges to exclude
  ///
  final excluded = <RandomUnicodeRange>[];

  /// List of ranges to include
  ///
  final included = <RandomUnicodeRange>[];

  /// Random number generator
  ///
  late final Random random;

  /// Helper method to limit random strings to the ASCII set
  ///
  static RandomUnicode ascii([Random? random]) => RandomUnicode(random)
    ..addIncluded(min: Lim.minCharCode, max: Lim.maxCharCodeAscii);

  /// Helper method to limit random strings to A-Z and a-z
  ///
  static RandomUnicode asciiAlpha([Random? random]) => RandomUnicode(random)
    ..addIncluded(min: 0x41, max: 0x5A)
    ..addIncluded(min: 0x61, max: 0x7A);

  /// Helper method to limit random strings to 0-9, A-Z and a-z
  ///
  static RandomUnicode asciiAlphaNumeric([Random? random]) =>
      RandomUnicode(random)
        ..addFrom(asciiNumeric(random))
        ..addFrom(asciiAlpha(random));

  /// Helper method to limit random strings to 0-9, A-F and a-f
  ///
  static RandomUnicode asciiHexadecimal([Random? random]) =>
      RandomUnicode(random)
        ..addFrom(asciiNumeric(random))
        ..addIncluded(min: 0x41, max: 0x46)
        ..addIncluded(min: 0x61, max: 0x66);

  /// Helper method to limit random strings to 0-9
  ///
  static RandomUnicode asciiNumeric([Random? random]) =>
      RandomUnicode(random)..addIncluded(min: 0x30, max: 0x39);

  /// Helper method to limit random strings to the Basic Multilingual Plane
  ///
  static RandomUnicode bmp([Random? random]) => RandomUnicode(random)
    ..addIncluded(min: Lim.minCharCode, max: Lim.maxCharCodeBmp);

  /// Helper method to exclude characters not handled by Windows
  /// If [isStrict] is set, then some extra characters excluded
  /// to avoid general user problems (on POSIX-compliant systems,
  /// all of these characters are allowed)
  ///
  static RandomUnicode validFileName([Random? random, bool isStrict = false]) {
    var excluded = r'<>:"/\|?*';

    if (isStrict) {
      excluded += '\$[]{}()!,;';
    }

    return RandomUnicode(random)..addExcluded(list: excluded.codeUnits);
  }

  /// The constructor
  ///
  RandomUnicode([Random? random]) {
    this.random = random ?? Random();
  }

  /// Add a set of characters to included or excluded list
  /// either as a proper range or as char code(s) converted
  /// to the list of the trivial ranges
  ///
  void add(
      {bool isIncluded = false,
      int? min,
      int? max,
      List<int>? list,
      RandomUnicodeRange? range}) {
    final to = (isIncluded ? included : excluded);

    if ((min != null) || (max != null)) {
      min ??= Lim.minCharCode;
      to.add(RandomUnicodeRange(min: min, max: max, random: random));
    }
    if (list != null) {
      to.add(RandomUnicodeRange(list: list, random: random));
    }
    if (range != null) {
      range.random = random;
      to.add(range);
    }
  }

  /// Add all included and excluded ranges from [other] object
  ///
  void addFrom(RandomUnicode other) {
    for (var r in other.excluded) {
      r.random = random;
    }
    for (var r in other.included) {
      r.random = random;
    }
    excluded.addAll(other.excluded);
    included.addAll(other.included);
  }

  /// A wrapper for add(isIncluded: true, ...)
  ///
  void addIncluded(
          {int? min,
          int? max,
          List<int>? list,
          RandomUnicodeRange? range}) =>
      add(
          isIncluded: true,
          min: min,
          max: max,
          list: list,
          range: range);

  /// A wrapper for add(isIncluded: false, ...)
  ///
  void addExcluded(
          {int? min,
          int? max,
          List<int>? list,
          RandomUnicodeRange? range}) =>
      add(
          isIncluded: false,
          min: min,
          max: max,
          list: list,
          range: range);

  /// Generate random string of a given length or
  /// or of a random length within the length ramge
  ///
  String string(int minLen, [int? maxLen]) {
    var strLen = minLen;

    if ((maxLen != null) && (maxLen > minLen)) {
      strLen += random.nextInt(maxLen - minLen + 1);
    }

    final buffer = StringBuffer();
    int charCode;
    final defRangeOffset = Lim.minCharCode;
    final defRangeLength = Lim.maxCharCode - defRangeOffset + 1;
    final hasExcluded = excluded.isNotEmpty;
    final includedCount = included.length;

    for (var i = 0; i < strLen; i++) {
      do {
        if (includedCount > 0) {
          var range = included[random.nextInt(includedCount)];
          charCode = range.nextCharCode();
        } else {
          charCode = defRangeOffset + random.nextInt(defRangeLength);
        }
      } while (hasExcluded && _isInExcluded(charCode));

      buffer.writeCharCode(charCode);
    }

    return buffer.toString();
  }

  //* PRIVATE METHODS

  /// Check whether a given Unicode character is within the exclude
  /// ranges assuming [charCode] lies within the [included] range
  ///
  bool _isInExcluded(int charCode) {
    var count = excluded.length;

    for (var i = 0; i < count; i++) {
      final range = excluded[i];

      if ((charCode >= range.min) && (charCode <= range.max)) {
        return true;
      }
    }

    return false;
  }
}
