import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../../env/secrets.dart';

Handler middleware(Handler handler) {
  return (context) async {
    final db = await Db.create(
      'mongodb+srv://tutorial_user:$mongoPassword@cloudclustergg.bpsb1.mongodb.net/TasklistDartFrog?retryWrites=true&w=majority&appName=CloudClusterGG',
    );

    if (!db.isConnected) {
      await db.open();
    }

    final response = await handler.use(provider<Db>((_) => db)).call(context);

    await db.close();

    return response;
  };
}
