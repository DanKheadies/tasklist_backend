import 'package:dart_frog/dart_frog.dart';
import 'package:redis/redis.dart';

final conn = RedisConnection();

Handler middleware(Handler handler) {
  return (context) async {
    Response response;

    try {
      final command = await conn.connect('localhost', 6379);
      // final command = await conn.connect('192.168.1.127', 6379);
      // final command = await conn.connect('127.0.0.1', 6379);
      try {
        // Note: freezes here, i.e. never succeeds or fails, after initial
        // login and/or account deletion.
        await command.send_object([
          'AUTH',
          'default',
          'password',
        ]);
        // Update: between the release of this tutorial and now, redis had a
        // change where a successful response does not return a payload
        // containing "success" and "message" but just the data passed
        // (I think). Would like to bundle the response into a "success"
        // message, but instead, I'll modify in the frontend.
        response =
            await handler.use(provider<Command>((_) => command)).call(context);
      } catch (err) {
        response = Response.json(
          body: {
            'success': false,
            'message': err.toString(),
          },
        );
      }
    } catch (err) {
      response = Response.json(
        body: {
          'success': false,
          'message': err.toString(),
        },
      );
    }
    return response;
  };
}
