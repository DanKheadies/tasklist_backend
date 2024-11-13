import 'package:dart_frog/dart_frog.dart';
import 'package:redis/redis.dart';

final conn = RedisConnection();

Handler middleware(Handler handler) {
  return (context) async {
    Response response;

    try {
      final command = await conn.connect('localhost', 6379);
      try {
        await command.send_object([
          'AUTH',
          'default',
          'password',
        ]);
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
