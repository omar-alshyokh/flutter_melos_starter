import 'package:equatable/equatable.dart';

class Story extends Equatable {
  final int id;
  final String title;
  final String? by;
  final int? score;
  final int? time;
  final String? url;

  const Story({
    required this.id,
    required this.title,
    this.by,
    this.score,
    this.time,
    this.url,
  });

  @override
  List<Object?> get props => [id, title, by, score, time, url];
}
