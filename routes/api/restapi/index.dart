import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:http/http.dart' as http;

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _getRecipes(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _getRecipes(RequestContext context) async {
  final response = await http.get(
    // 'https://low-carb-recipes.p.rapidapi.com/random',
    // Uri.parse('https://api.spoonacular.com/recipes/complexSearch'),
    Uri.parse(
      'https://datausa.io/api/data?drilldowns=Nation&measures=Population',
    ),
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return Response.json(body: response.body);
  } else {
    return Response(statusCode: HttpStatus.badRequest);
  }
}
