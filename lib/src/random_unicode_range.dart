// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:lim/lim.dart';
import 'package:random_unicode/random_unicode.dart';

/// Class for the pair of lower and upper boundaries
///
class RandomUnicodeRange {
  /// Lowest character code
  ///
  late final int min;

  /// Highest character code
  ///
  late final int max;

  /// The constructor
  ///
  RandomUnicodeRange([int min = Lim.minCharCode, int? max]) {
    this.min = (min >= Lim.minCharCode ? min : Lim.minCharCode);
    max ??= min;
    this.max = (max <= Lim.maxCharCode ? max : Lim.maxCharCode);
  }

  /// Next char code generator
  ///
  int nextCharCode(RandomUnicodeNextIntProc nextIntProc) =>
      min >= max ? min : min + nextIntProc(max - min);
}
