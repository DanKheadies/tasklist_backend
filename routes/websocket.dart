import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

// TODO: figure out why websocket won't echo messages on tasklist app
Future<Response> onRequest(RequestContext context) async {
  print('ws onRequest');
  final handler = webSocketHandler((channel, protocol) {
    print('websocket');
    channel.stream.listen(
      (message) {
        print(message);
        channel.sink.add('echo => $message!');
      },
      onDone: () => print('done'),
    );
  });

  return handler(context);
}

// Handler get onRequest {
//   return webSocketHandler(
//     (channel, protocol) {
//       print('websocket');
//       channel.stream.listen(
//         (message) {
//           print(message);
//           channel.sink.add('echo => $message!');
//         },
//         onDone: () => print('done'),
//       );
//     },
//   );
// }
