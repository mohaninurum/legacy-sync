class LegacyWrappedPageModel {
  final String title;
  final String description;
  final String richText;
  final String imagePath;
  final bool childListing;
  final List<WData> data;

 const  LegacyWrappedPageModel({
    required this.title,
    required this.description,
    required this.richText,
    required this.imagePath,
     this.childListing = false,
     this.data =const [],
  });
}


class WData {
  final String title;
  final String description;
  final String imagePath;
  final int progress;

  WData({required this.title, required this.description, required this.imagePath, required this.progress});
  factory WData.empty() {
    return WData(
      title: '',
      description: '',
      imagePath: '',
      progress: 0,
    );
  }

}