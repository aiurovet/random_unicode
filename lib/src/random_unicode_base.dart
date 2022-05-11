// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'dart:math';
import 'package:lim/lim.dart';
import 'package:random_unicode/random_unicode.dart';

/// Type for a callback procedure providing with
/// random numbers between 0 and max inclusive
///
typedef RandomUnicodeNextIntProc = int Function(int max);

/// Class for the pair of lower and upper boundaries
///
class RandomUnicode {
  /// Default random number generator
  ///
  static final defaultNextIntProc = Random().nextInt;

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

  /// The constructor
  ///
  RandomUnicode({RandomUnicodeNextIntProc? nextIntProc, int? seed}) {
    if (nextIntProc != null) {
      this.nextIntProc = nextIntProc;
    } else if (seed != null) {
      this.nextIntProc = Random(seed).nextInt;
    } else {
      this.nextIntProc = defaultNextIntProc;
    }
  }

  /// Add a set of characters to included or excluded list:
  /// either as a proper range or as char code(s) converted
  /// to the list of the trivial ranges
  ///
  void add(
      {bool isIncluded = false,
      int? lower,
      int? upper,
      RandomUnicodeRange? range,
      List<int>? charCodes}) {
    final to = (isIncluded ? included : excluded);

    if ((lower != null) || (upper != null)) {
      to.add(RandomUnicodeRange(lower, upper));
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

  /// A wrapper for add(isIncluded: true, ...)
  ///
  void addIncluded(
          {int? lower,
          int? upper,
          RandomUnicodeRange? range,
          List<int>? charCodes}) =>
      add(
          isIncluded: true,
          lower: lower,
          upper: upper,
          range: range,
          charCodes: charCodes);

  /// A wrapper for add(isIncluded: false, ...)
  ///
  void addExcluded(
          {int? lower,
          int? upper,
          RandomUnicodeRange? range,
          List<int>? charCodes}) =>
      add(
          isIncluded: false,
          lower: lower,
          upper: upper,
          range: range,
          charCodes: charCodes);

  /// Generate random string
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

      if ((charCode >= range.lower) && (charCode <= range.upper)) {
        return true;
      }
    }

    return false;
  }
}
