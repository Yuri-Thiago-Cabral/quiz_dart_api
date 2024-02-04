class NotFoundExcpetion implements Exception {
  final String message;

  const NotFoundExcpetion(this.message);

  @override
  String toString() => message;
}
