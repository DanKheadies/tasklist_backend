import 'package:dart_frog/dart_frog.dart';
import 'package:firedart/firedart.dart';

Handler middleware(Handler handler) {
  return (context) async {
    if (!Firestore.initialized) {
      Firestore.initialize('tasklist-dartfrog-a5816');
    }

    final response = await handler(context);

    return response;
  };
}
