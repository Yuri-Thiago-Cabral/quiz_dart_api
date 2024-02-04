import 'dart:convert';

class QuestionAnswerDto {
  final int id;
  final String? userEmail;
  final String? answerResp;

  const QuestionAnswerDto({
    required this.id,
    required this.userEmail,
    required this.answerResp,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userEmail': userEmail,
      'answerResp': answerResp,
    };
  }

  factory QuestionAnswerDto.fromMap(Map<String, dynamic> map) {
    return QuestionAnswerDto(
      id: map['id'] ?? 0,
      userEmail: map['userEmail'] as String?,
      answerResp: map['answerResp'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionAnswerDto.fromJson(String source) =>
      QuestionAnswerDto.fromMap(json.decode(source) as Map<String, dynamic>);
}
