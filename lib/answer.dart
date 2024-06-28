import 'package:json_annotation/json_annotation.dart';

part 'answer.g.dart';

// jsonをモデル化する
@JsonSerializable()
class Answer {
  String id;
  String object;
  int created;
  String model;
  List<Choice> choices;
  Usage usage;

  Answer(
      {required this.id,
      required this.object,
      required this.created,
      required this.model,
      required this.choices,
      required this.usage});

  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Usage {
  // @JsonKey(name: 'prompt_tokens')
  int prompt_tokens;
  int completion_tokens;
  int total_tokens;

  Usage(
      {required this.prompt_tokens,
      required this.completion_tokens,
      required this.total_tokens});

  factory Usage.fromJson(Map<String, dynamic> json) => _$UsageFromJson(json);

  Map<String, dynamic> toJson() => _$UsageToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Choice {
  // @JsonKey(name: 'prompt_tokens')
  int index;
  Message message;
  String finish_reason;

  Choice(
      {required this.index,
      required this.message,
      required this.finish_reason});

  factory Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);

  Map<String, dynamic> toJson() => _$ChoiceToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Message {
  String role;
  String content;

  Message(
      {required this.role,
      required this.content});

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
