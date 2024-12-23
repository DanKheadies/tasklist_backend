import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:tasklist_backend/repositories/lists/list_repository.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  return switch (context.request.method) {
    HttpMethod.get => _getList(context, id),
    HttpMethod.patch => _updateList(context, id),
    HttpMethod.delete => _deleteList(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed))
  };
}

Future<Response> _getList(RequestContext context, String id) async {
  final list = await context.read<TaskListRepository>().listById(id);

  if (list?.id != id) {
    return Response(statusCode: HttpStatus.forbidden);
  }

  return Response.json(
    body: {
      'id': list!.id,
      'name': list.name,
    },
  );
}

Future<Response> _updateList(RequestContext context, String id) async {
  final listRepository = context.read<TaskListRepository>();

  final body = await context.request.json() as Map<String, dynamic>;
  final name = body['name'] as String?;

  if (name != null) {
    await listRepository.updateList(
      id: id,
      name: name,
    );
    return Response.json(body: {'id': id});
  } else {
    return Response(statusCode: HttpStatus.badRequest);
  }
}

Future<Response> _deleteList(RequestContext context, String id) async {
  context.read<TaskListRepository>().deleteList(id);
  return Response(statusCode: HttpStatus.noContent);
}
