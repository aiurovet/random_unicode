A library to generate random Unicode strings within the given range(s)

## Features

- Generates an arbitrary Unicode string
- Allows to limit destination to a certain list of character ranges
- Contains helper constriuctors for ASCII characters, ASCII alpha, ASCII alphanumeric,
  numeric (decimal), hexadecimal, BMP (basic multilingual plane) and valid filename (when
  several characters are excluded to avoid issues under Windows)

## Usage

The working example which can also be found in the repository in `example/perf_test_example.dart`

```dart
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
```
