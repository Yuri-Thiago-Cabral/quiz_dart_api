import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import '../service/quiz_service.dart';
import 'dto/question_dto.dart';

class QuizController {
  static const baseRoute = '/quiz';

  final QuizService _quizService = QuizService();

  Response generateRandomQuestion(Request request) {
    Map<String, String> params = request.url.queryParameters;

    String? categoryPreference;
    if (params.containsKey('category')) {
      categoryPreference = params['category'];
    }

    QuestionDto question = _quizService.generateRandomQuestion(category: categoryPreference);

    return Response.ok(jsonEncode(question.toMap()), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
  }

  Future<Response> answerQuestionByEmail(Request request) async {
    final String requestBodyJson = await request.readAsString();

    Map<String, dynamic> requestBody = jsonDecode(requestBodyJson);

    _quizService.answerQuestion(
      requestBody['id'] ?? 0,
      requestBody['answerResp'] ?? '',
      requestBody['userEmail'] ?? '',
    );

    return Response.ok('Resposta correta!', headers: {
      HttpHeaders.contentTypeHeader: 'text/plain',
    });
  }
}
