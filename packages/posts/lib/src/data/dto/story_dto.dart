import 'package:core/core.dart';
import '../../domain/entities/story.dart';

class StoryDto {
  final int id;
  final String? title;
  final String? by;
  final int? time;
  final int? score;
  final String? url;

  StoryDto({
    required this.id,
    this.title,
    this.by,
    this.time,
    this.score,
    this.url,
  });

  factory StoryDto.fromJson(JsonMap json) {
    return StoryDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      by: json['by'] as String?,
      time: (json['time'] as num?)?.toInt(),
      score: (json['score'] as num?)?.toInt(),
      url: json['url'] as String?,
    );
  }

  Story toEntity() => Story(
    id: id,
    title: title ?? '',
    by: by,
    time: time,
    score: score,
    url: url,
  );
}
