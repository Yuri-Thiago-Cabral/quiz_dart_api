import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../controller/quiz_controller.dart';
import '../exceptions/answered_question_exception.dart';
import '../exceptions/invalid_answer_exception.dart';
import '../exceptions/not_found_exceptions.dart';

class Routes {
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
      if (error is NotFoundExcpetion) {
        return Response.notFound(jsonEncode({'error': error.message}), headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        });
      }

      if (error is AnsweredQuestionException) {
        return Response.forbidden(jsonEncode({'error': error.message}), headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        });
      }

      if (error is InvalidAnswerException) {
        return Response.badRequest(body: jsonEncode({'error': error.message}), headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        });
      }
    }

    return Response.internalServerError(body: {'error': 'Erro interno no servidor'});
  }
}
