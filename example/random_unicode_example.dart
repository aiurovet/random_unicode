// Copyright (c) 2022, Alexander Iurovetski
// All rights reserved under MIT license (see LICENSE file)

import 'package:random_unicode/random_unicode.dart';

/// Entry point
///
void main(List<String> args) {
  // Getting minimum and maximum string length
  // from the command-line arguments
  //
  final argCount = args.length;
  final minStrLen = (argCount <= 0 ? 100 : int.parse(args[0]));
  final maxStrLen = (argCount <= 1 ? minStrLen : int.parse(args[1]));

  // Creating the string generator
  //
  final u = RandomUnicode()
    ..addIncluded(min: 0x20, max: 0x7F)
    ..addIncluded(min: 0x100, max: 0x200)
    ..addIncluded(min: 0x1000, max: 0x2000)
    ..addExcluded(charCodes: r'BEZbez'.codeUnits);

  // Generating the string
  //
  final str = u.string(minStrLen, maxStrLen);

  // Showing the result
  //
  print('Len: $minStrLen <= ${str.length} <= $maxStrLen\n$str');
}
