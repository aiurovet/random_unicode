// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:random_unicode/random_unicode.dart';

/// Class for the pair of lower and upper boundaries
///
class RandomUnicodeRange {
  /// Minimum possible character code
  ///
  static const minLower = 0;

  /// Maximum possible character code
  ///
  static const maxUpper = 0x10FFFF;

  /// Lower boundary character code
  ///
  late final int lower;

  /// Upper boundary character code
  ///
  late final int upper;

  /// The constructor
  ///
  RandomUnicodeRange(int lower, [int? upper]) {
    this.lower = (lower < minLower ? minLower : lower);

    if (upper != null) {
      this.upper = (upper > maxUpper ? maxUpper : upper);
    } else {
      this.upper = this.lower;
    }
  }

  /// Range generator. Examples:
  ///
  /// ASCII any:
  /// RandomUnicodeRange.generateList([[0x00, 0xFF]]);
  /// ASCII alpha:
  /// RandomUnicodeRange.generateList([[0x41, 0x5A], [0x61, 0x7A]]);
  /// ASCII alpha-numeric:
  /// RandomUnicodeRange.generateList([[0x30, 0x39], [0x41, 0x5A], [0x61, 0x7A]]);
  /// ASCII numeric:
  /// RandomUnicodeRange.generateList([[0x30, 0x39]]);
  /// Bad filename characters for exclusion:
  /// RandomUnicodeRange.generateList(['#%&{}\\<>*?/\$!":@+`|='.codeUnits]);
  ///
  static List<RandomUnicodeRange> generateList(List<List<int>> ranges) {
    final result = <RandomUnicodeRange>[];

    for (var range in ranges) {
      final length = range.length;

      if (length > 0) {
        result.add(RandomUnicodeRange(range[0], range[length - 1]));
      }
    }

    return result;
  }

  /// Next char code generator
  ///
  int nextCharCode(RandomUnicodeNextIntProc nextIntProc) =>
      lower >= upper ? lower : lower + nextIntProc(upper - lower);
}
