// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'dart:math';
import 'package:lim/lim.dart';

/// Class for the pair of lower and upper boundaries
///
class RandomUnicodeRange {
  /// Default random number generator
  ///
  static final defaultRandom = Random();

  /// Lowest character code
  ///
  late final int min;

  /// Highest character code
  ///
  late final int max;

  /// List of separate character codes
  ///
  late final List<int> list;

  /// [max] - [min] + 1 or the last index in the list
  ///
  late final int randomMax;

  /// Random number generator
  /// (can be overwritten by the parent RandomUnicode object)
  ///
  Random random = defaultRandom;

  /// The constructor
  ///
  RandomUnicodeRange({int? min, int? max, List<int>? list, Random? random}) {
    if (list != null) {
      this.list = list;
      this.min = Lim.minCharCode - 1;
      this.max = this.min;
      randomMax = list.length - 1;
    } else {
      min ??= Lim.minCharCode;
      this.min = (min >= Lim.minCharCode ? min : Lim.minCharCode);
      max ??= min;
      this.max = (max <= Lim.maxCharCode ? max : Lim.maxCharCode);
      this.list = [];
      randomMax = this.max - this.min + 1;
    }

    if (random != null) {
      this.random = random;
    }
  }

  /// Next char code generator
  ///
  int nextCharCode() {
    if (min >= Lim.minCharCode) {
      return min >= max ? min : min + random.nextInt(randomMax);
    } else {
      return list[random.nextInt(randomMax)];
    }
  }
}
