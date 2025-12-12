class PipeAnimationModel {
  final int index;
  final bool isEnabled;
  final double animationProgress;
  final bool isAnimating;

  const PipeAnimationModel({
    required this.index,
    this.isEnabled = false,
    this.animationProgress = 0.0,
    this.isAnimating = false,
  });

  PipeAnimationModel copyWith({
    int? index,
    bool? isEnabled,
    double? animationProgress,
    bool? isAnimating,
  }) {
    return PipeAnimationModel(
      index: index ?? this.index,
      isEnabled: isEnabled ?? this.isEnabled,
      animationProgress: animationProgress ?? this.animationProgress,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }

  static List<PipeAnimationModel> getDefaultPipes() {
    return List.generate(7, (index) => PipeAnimationModel(index: index));
  }
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'isEnabled': isEnabled,
      'animationProgress': animationProgress,
      'isAnimating': isAnimating,
    };
  }

  factory PipeAnimationModel.fromJson(Map<String, dynamic> json) {
    return PipeAnimationModel(
      index: json['index'] ?? 0,
      isEnabled: json['isEnabled'] ?? false,
      animationProgress: (json['animationProgress'] ?? 0.0).toDouble(),
      isAnimating: json['isAnimating'] ?? false,
    );
  }


}
