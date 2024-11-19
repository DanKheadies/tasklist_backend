// import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../routes/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('GET /', () {
    // Note: this route has been updated to get a list of data
    // test('responds with a 200 and "Welcome to Dart Frog!".', () {
    //   final context = _MockRequestContext();
    //   final response = route.onRequest(context);
    //   expect(response.statusCode, equals(HttpStatus.ok));
    //   expect(
    //     response.body(),
    //     completion(equals('Welcome to Dart Frog!')),
    //   );
    // });
    test('', () {
      final context = _MockRequestContext();
      final response = route.onRequest(context);
      print(response);
    });
  });
}
