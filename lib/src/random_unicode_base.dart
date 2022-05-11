// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'dart:math';
import 'package:lim/lim.dart';
import 'package:random_unicode/random_unicode.dart';

/// Type for a callback procedure providing with
/// random numbers between 0 and max inclusive
///
typedef RandomUnicodeNextIntProc = int Function(int max);

/// Class for the random uncode string generation
///
class RandomUnicode {
  /// Default next random number generator
  ///
  static final defaultRandom = Random();

  /// List of ranges to exclude
  ///
  final excluded = <RandomUnicodeRange>[];

  /// List of ranges to include
  ///
  final included = <RandomUnicodeRange>[];

  /// Callback procedure providing with random/ numbers between
  /// 0 and max inclusive, default: Random().nextInt
  ///
  late final RandomUnicodeNextIntProc nextIntProc;

  /// Helper method to limit random strings to the ASCII set
  ///
  static RandomUnicode ascii() => RandomUnicode()
    ..addIncluded(min: Lim.minCharCode, max: Lim.maxCharCodeAscii);

  /// Helper method to limit random strings to A-Z and a-z
  ///
  static RandomUnicode asciiAlpha() => RandomUnicode()
    ..addIncluded(min: 0x41, max: 0x5A)
    ..addIncluded(min: 0x61, max: 0x7A);

  /// Helper method to limit random strings to 0-9, A-Z and a-z
  ///
  static RandomUnicode asciiAlphaNumeric() => RandomUnicode()
    ..addFrom(asciiNumeric())
    ..addFrom(asciiAlpha());

  /// Helper method to limit random strings to 0-9, A-F and a-f
  ///
  static RandomUnicode asciiHexadecimal() => RandomUnicode()
    ..addFrom(asciiNumeric())
    ..addIncluded(min: 0x41, max: 0x46)
    ..addIncluded(min: 0x61, max: 0x66);

  /// Helper method to limit random strings to 0-9
  ///
  static RandomUnicode asciiNumeric() =>
      RandomUnicode()..addIncluded(min: 0x30, max: 0x39);

  /// Helper method to limit random strings to the Basic Multilingual Plane
  ///
  static RandomUnicode bmp() => RandomUnicode()
    ..addIncluded(min: Lim.minCharCode, max: Lim.maxCharCodeBmp);

  /// Helper method to exclude characters not handled by Windows
  /// If [isStrict] is set, then some extra characters excluded
  /// to avoid general user problems (on POSIX-compliant systems,
  /// all of these characters are allowed)
  ///
  static RandomUnicode validFileName([bool isStrict = false]) {
    var excluded = r'<>:"/\|?*';

    if (isStrict) {
      excluded += '\$[]{}()!,;';
    }

    return RandomUnicode()..addExcluded(charCodes: excluded.codeUnits);
  }

  /// The constructor
  ///
  RandomUnicode({RandomUnicodeNextIntProc? nextIntProc, int? seed}) {
    if (nextIntProc != null) {
      this.nextIntProc = nextIntProc;
    } else if (seed != null) {
      this.nextIntProc = Random(seed).nextInt;
    } else {
      this.nextIntProc = defaultRandom.nextInt;
    }
  }

  /// Add a set of characters to included or excluded list
  /// either as a proper range or as char code(s) converted
  /// to the list of the trivial ranges
  ///
  void add(
      {bool isIncluded = false,
      int? min,
      int? max,
      RandomUnicodeRange? range,
      List<int>? charCodes}) {
    final to = (isIncluded ? included : excluded);

    if ((min != null) || (max != null)) {
      to.add(RandomUnicodeRange(min ?? Lim.minCharCode, max));
    }
    if (range != null) {
      to.add(range);
    }
    if (charCodes != null) {
      for (var charCode in charCodes) {
        to.add(RandomUnicodeRange(charCode, charCode));
      }
    }
  }

  /// Add all included and excluded ranges from [other] object
  ///
  void addFrom(RandomUnicode other) {
    excluded.addAll(other.excluded);
    included.addAll(other.included);
  }

  /// A wrapper for add(isIncluded: true, ...)
  ///
  void addIncluded(
          {int? min,
          int? max,
          RandomUnicodeRange? range,
          List<int>? charCodes}) =>
      add(
          isIncluded: true,
          min: min,
          max: max,
          range: range,
          charCodes: charCodes);

  /// A wrapper for add(isIncluded: false, ...)
  ///
  void addExcluded(
          {int? min,
          int? max,
          RandomUnicodeRange? range,
          List<int>? charCodes}) =>
      add(
          isIncluded: false,
          min: min,
          max: max,
          range: range,
          charCodes: charCodes);

  /// Generate random string of a given length or
  /// or of a random length within the length ramge
  ///
  String string(int minLen, [int? maxLen]) {
    var strLen = minLen;

    if ((maxLen != null) && (maxLen > minLen)) {
      strLen += nextIntProc(maxLen - minLen);
    }

    final buffer = StringBuffer();
    int charCode;
    final defRangeOffset = Lim.minCharCode;
    final defRangeLength = Lim.maxCharCode - defRangeOffset;
    final hasExcluded = excluded.isNotEmpty;
    final includedCount = included.length;

    for (var i = 0; i < strLen; i++) {
      do {
        if (includedCount > 0) {
          var range = included[nextIntProc(includedCount)];
          charCode = range.nextCharCode(nextIntProc);
        } else {
          charCode = defRangeOffset + nextIntProc(defRangeLength);
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
