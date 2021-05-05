// #docregion imports
import 'dart:async';
// #enddocregion imports

// #docregion main, main-stub
Future<void> main() async {
  // #enddocregion main-stub
  print('Compute π using the Monte Carlo method.');
  await for (var estimate in computePi().take(500)) {
    print('π ≅ $estimate');
  }
  // #docregion main-stub
}
// #enddocregion main, main-stub

/// Generates a stream of increasingly accurate estimates of π.
Stream<double> computePi({int batch = 100000}) async* {
  // ...
}
