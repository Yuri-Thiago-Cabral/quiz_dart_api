import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'src/routes/routes_handler.dart';

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;

  final handler = Pipeline().addMiddleware(logRequests()).addHandler(Routes.buildRouters());

  final port = 5469;
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
