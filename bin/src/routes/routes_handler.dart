import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../controller/dto/response/error_dto.dart';
import '../controller/quiz_controller.dart';
import '../exceptions/custom_exception.dart';

class RoutesHandler {
  static final QuizController _quizController = QuizController();

  static Router buildRouters() {
    final router = Router()
      ..get(
        '${QuizController.baseRoute}/questions/generate',
        (req) => _buildHttpRequest(
          request: req,
          apiCallback: _quizController.generateRandomQuestion,
        ),
      )
      ..post(
        '${QuizController.baseRoute}/questions/answer',
        (req) => _buildHttpRequest(
          request: req,
          apiAsyncCallback: _quizController.answerQuestionByEmail,
        ),
      );

    return router;
  }

  static Future<Response> _buildHttpRequest({
    required Request request,
    Response Function(Request request)? apiCallback,
    Future<Response> Function(Request request)? apiAsyncCallback,
  }) async {
    try {
      if (apiCallback != null) {
        return apiCallback.call(request);
      }

      if (apiAsyncCallback != null) {
        return await apiAsyncCallback.call(request);
      }
    } catch (error) {
      /*
      Realiza aqui os tratamentos de erro para evitar implementação em cada endpoint (diminuição de complexidade).
      Evita também o retorno default (internal error) caso alguma tratativa não fosse implementada no endpoint (autenticidade).
      */
      if (error is CustomException) {
        String errorJson = ErrorDto.fromMap({'message': error.message}).toJson();
        return Response(
          error.status,
          body: errorJson,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        );
      }
    }

    return Response.internalServerError(body: {'error': 'Erro interno no servidor'});
  }
}
