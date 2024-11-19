import 'package:dart_frog/dart_frog.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as shelf;
import 'package:tasklist_backend/repositories/items/item_repository.dart';
import 'package:tasklist_backend/repositories/lists/list_repository.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(provider<TaskListRepository>((context) => TaskListRepository()))
      .use(provider<TaskItemRepository>((context) => TaskItemRepository()))
      .use(
        fromShelfMiddleware(
          shelf.corsHeaders(
            headers: {
              shelf.ACCESS_CONTROL_ALLOW_METHODS: 'GET POST DELETE PATCH',
            },
          ),
        ),
      );
}
