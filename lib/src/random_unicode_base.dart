// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'dart:math';
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
  RandomUnicode(
      {List<int>? charCodes,
      List<RandomUnicodeRange>? excluded,
      List<RandomUnicodeRange>? included,
      RandomUnicodeNextIntProc? nextIntProc,
      int? seed}) {
    if (excluded != null) {
      this.excluded.addAll(excluded);
    }
    if (included != null) {
      this.included.addAll(included);
    }
    if (charCodes != null) {
      for (var i = 0, n = charCodes.length; i < n; i++) {
        this.included.add(RandomUnicodeRange(charCodes[i]));
      }
    }
    if (nextIntProc != null) {
      this.nextIntProc = nextIntProc;
    } else if (seed != null) {
      this.nextIntProc = Random(seed).nextInt;
    } else {
      this.nextIntProc = defaultNextIntProc;
    }
  }

  /// Check whether a given Unicode character is within
  /// the include range, but not within the exclude range
  ///
  void add(
      {int? charCode,
      RandomUnicodeRange? excluded,
      RandomUnicodeRange? included}) {
    if (excluded != null) {
      this.excluded.add(excluded);
    }
    if (included != null) {
      this.included.add(included);
    }
    if (charCode != null) {
      this.included.add(RandomUnicodeRange(charCode));
    }
  }

  /// Generate random string
  ///
  String string(int minLen, [int maxLen = -1]) {
    int strLen = minLen;

    if (maxLen > minLen) {
      strLen += nextIntProc(maxLen - minLen);
    }

    final incLen = included.length;
    var buffer = StringBuffer();
    int charCode;
    final defRangeOffset = RandomUnicodeRange.minLower;
    final defRangeLength = RandomUnicodeRange.maxUpper - defRangeOffset;
    var hasExcluded = excluded.isNotEmpty;

    for (var i = 0; i < strLen; i++) {
      do {
        if (incLen > 0) {
          var range = included[nextIntProc(incLen)];
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
