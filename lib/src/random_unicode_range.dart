// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:lim/lim.dart';
import 'package:random_unicode/random_unicode.dart';

/// Class for the pair of lower and upper boundaries
///
class RandomUnicodeRange {
  /// Lower boundary character code
  ///
  late final int lower;

  /// Upper boundary character code
  ///
  late final int upper;

  /// The constructor
  ///
  RandomUnicodeRange([lower = Lim.minCharCode, upper = Lim.maxCharCode]) {
    this.lower = (lower >= Lim.minCharCode ? lower : Lim.minCharCode);
    this.upper = (upper <= Lim.maxCharCode ? upper : Lim.maxCharCode);
  }

  /// Next char code generator
  ///
  int nextCharCode(RandomUnicodeNextIntProc nextIntProc) =>
      lower >= upper ? lower : lower + nextIntProc(upper - lower);
}
