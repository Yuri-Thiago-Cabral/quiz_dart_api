class AnsweredQuestionException implements Exception {
  final String message;

  const AnsweredQuestionException({
    this.message = 'Parabéns! Você já respondeu corretamente esta pergunta e não poderá responder novamente',
  });

  @override
  String toString() => message;
}
