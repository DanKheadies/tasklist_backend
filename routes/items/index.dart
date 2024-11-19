import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:tasklist_backend/repositories/items/item_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _createItem(context),
    HttpMethod.get => _getAllItems(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _getAllItems(RequestContext context) async {
  final items = context.read<TaskItemRepository>().getAllItems();
  // print(items);

  return Response.json(body: items);
}

Future<Response> _createItem(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final listId = body['listId'] as String?;
  final name = body['name'] as String?;
  final description = body['description'] as String?;
  final status = body['status'] as bool?;

  final itemRepository = context.read<TaskItemRepository>();

  if (name != null && listId != null && description != null && status != null) {
    final id = itemRepository.createItem(
      name: name,
      listId: listId,
      description: description,
      status: status,
    );

    return Response.json(body: {'id': id});
  } else {
    return Response(statusCode: HttpStatus.badRequest);
  }
}
