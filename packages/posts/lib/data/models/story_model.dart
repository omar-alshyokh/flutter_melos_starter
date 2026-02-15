import 'package:posts/domain/entities/story.dart';

class StoryModel {
  final int id;
  final String title;
  final String? by;
  final int? score;
  final int? time;
  final String? url;

  StoryModel({
    required this.id,
    required this.title,
    this.by,
    this.score,
    this.time,
    this.url,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: (json['id'] as num).toInt(),
      title: (json['title'] as String?) ?? '(no title)',
      by: json['by'] as String?,
      score: (json['score'] as num?)?.toInt(),
      time: (json['time'] as num?)?.toInt(),
      url: json['url'] as String?,
    );
  }

  Story toEntity() => Story(
    id: id,
    title: title,
    by: by,
    score: score,
    time: time,
    url: url,
  );
}
