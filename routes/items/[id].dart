import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:tasklist_backend/repositories/items/item_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  return switch (context.request.method) {
    HttpMethod.get => _getItemsByList(context, id),
    HttpMethod.patch => _updateItem(context, id),
    HttpMethod.delete => _deleteItem(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _getItemsByList(RequestContext context, String id) async {
  final items = context.read<TaskItemRepository>().getItemsByList(id);

  return Response.json(body: items);
}

Future<Response> _updateItem(RequestContext context, String id) async {
  final listRepository = context.read<TaskItemRepository>();

  final body = await context.request.json() as Map<String, dynamic>;
  final name = body['name'] as String?;
  final listId = body['listId'] as String?;
  final description = body['description'] as String?;
  final status = body['status'] as bool?;

  if (name != null && listId != null && description != null && status != null) {
    await listRepository.updateItem(
      id: id,
      name: name,
      listId: listId,
      description: description,
      status: status,
    );
    return Response(statusCode: HttpStatus.noContent);
  } else {
    return Response(statusCode: HttpStatus.badRequest);
  }
}

Future<Response> _deleteItem(RequestContext context, String id) async {
  context.read<TaskItemRepository>().deleteItem(id);
  return Response(statusCode: HttpStatus.noContent);
}
