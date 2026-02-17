import 'package:equatable/equatable.dart';

class MoreState extends Equatable {
  final bool isDarkMode;
  final String languageCode;

  const MoreState({
    required this.isDarkMode,
    required this.languageCode,
  });

  factory MoreState.initial() => const MoreState(
    isDarkMode: false,
    languageCode: 'en',
  );

  MoreState copyWith({
    bool? isDarkMode,
    String? languageCode,
  }) {
    return MoreState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      languageCode: languageCode ?? this.languageCode,
    );
  }

  @override
  List<Object?> get props => [isDarkMode, languageCode];
}
