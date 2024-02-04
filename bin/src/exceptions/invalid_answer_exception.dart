class InvalidAnswerException implements Exception {
  final String message;

  const InvalidAnswerException({this.message = 'A resposta informa está incorreta'});

  @override
  String toString() => message;
}
