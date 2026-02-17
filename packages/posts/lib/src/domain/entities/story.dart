class Story {
  final int id;
  final String title;
  final String? by;
  final int? score;
  final int? time; // unix seconds
  final String? url;

  const Story({
    required this.id,
    required this.title,
    this.by,
    this.score,
    this.time,
    this.url,
  });
}
