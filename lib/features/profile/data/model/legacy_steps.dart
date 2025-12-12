

class LegacySteps {
  final String title;
  final String description;
  final String imagePath;
  final int progress;

  LegacySteps({required this.title, required this.description, required this.imagePath, required this.progress});
  factory LegacySteps.empty() {
    return LegacySteps(
      title: '',
      description: '',
      imagePath: '',
      progress: 0,
    );
  }

}