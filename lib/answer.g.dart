// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Answer _$AnswerFromJson(Map<String, dynamic> json) => Answer(
      id: json['id'] as String,
      object: json['object'] as String,
      created: (json['created'] as num).toInt(),
      model: json['model'] as String,
      choices: (json['choices'] as List<dynamic>)
          .map((e) => Choice.fromJson(e as Map<String, dynamic>))
          .toList(),
      usage: Usage.fromJson(json['usage'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'id': instance.id,
      'object': instance.object,
      'created': instance.created,
      'model': instance.model,
      'choices': instance.choices,
      'usage': instance.usage,
    };

Usage _$UsageFromJson(Map<String, dynamic> json) => Usage(
      prompt_tokens: (json['prompt_tokens'] as num).toInt(),
      completion_tokens: (json['completion_tokens'] as num).toInt(),
      total_tokens: (json['total_tokens'] as num).toInt(),
    );

Map<String, dynamic> _$UsageToJson(Usage instance) => <String, dynamic>{
      'prompt_tokens': instance.prompt_tokens,
      'completion_tokens': instance.completion_tokens,
      'total_tokens': instance.total_tokens,
    };

Choice _$ChoiceFromJson(Map<String, dynamic> json) => Choice(
      index: (json['index'] as num).toInt(),
      message: Message.fromJson(json['message'] as Map<String, dynamic>),
      finish_reason: json['finish_reason'] as String,
    );

Map<String, dynamic> _$ChoiceToJson(Choice instance) => <String, dynamic>{
      'index': instance.index,
      'message': instance.message.toJson(),
      'finish_reason': instance.finish_reason,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      role: json['role'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'role': instance.role,
      'content': instance.content,
    };
