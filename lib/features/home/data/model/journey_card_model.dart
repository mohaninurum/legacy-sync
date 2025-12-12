import 'package:legacy_sync/core/images/lottie.dart';

class JourneyCardModel {
  final int id;
  final String title;
  final String description;
  final String imagePath;
  final String colorCode;
  final bool isEnabled;
  final bool isAnimating;

  const JourneyCardModel({
    required this.id,
    required this.title,
     this.description = "",
    required this.imagePath,
    required this.colorCode,
    this.isEnabled = false,
    this.isAnimating = false,
  });

  JourneyCardModel copyWith({
    int? id,
    String? title,
    String? description,
    String? imagePath,
    String? colorCode,
    bool? isEnabled,
    bool? isAnimating,
  }) {
    return JourneyCardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      colorCode: colorCode ?? this.colorCode,
      isEnabled: isEnabled ?? this.isEnabled,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }

  factory JourneyCardModel.empty() => const JourneyCardModel(
    id: 0,
    title: '',
    description: '',
    imagePath: '',
    colorCode: '',
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'colorCode': colorCode,
      'isEnabled': isEnabled,
      'isAnimating': isAnimating,
    };
  }
  factory JourneyCardModel.fromJson(Map<String, dynamic> json) {
    return JourneyCardModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imagePath: json['imagePath'] ?? '',
      colorCode: json['colorCode'] ?? '',
      isEnabled: json['isEnabled'] ?? false,
      isAnimating: json['isAnimating'] ?? false,
    );
  }


  static List<JourneyCardModel> getDefaultCards() {
    return [
       const JourneyCardModel(
        id: 1,
        title: 'Childhood & Early Foundations',
        imagePath: LottieFiles.module_header,
        colorCode: '0xFFFF95CA',
         isEnabled: true,
        // isAnimating: true
      ),
      const JourneyCardModel(
        id: 2,
        title: 'Young Adulthood & New Beginnings',
        imagePath: LottieFiles.module_header2,
        colorCode: '0xFFFFD301',
      ),
      const JourneyCardModel(
        id: 3,
        title: 'Family Life & Building a Home',
        imagePath: LottieFiles.module_header3,
        colorCode: '0xFFF5F2ED',
      ),
      const JourneyCardModel(
        id: 4,
        title: 'Career & Life\'s Work',
        imagePath: LottieFiles.module_header4,
        colorCode: '0xFFA97EC5',
      ),
      const JourneyCardModel(
        id: 5,
        title: 'Midlife & Personal Evolution',
        imagePath: LottieFiles.module_header5,
        colorCode: '0xFF006FAD',
      ),
      const JourneyCardModel(
        id: 6,
        title: 'Reflections & Enduring Wisdom',
        imagePath: LottieFiles.module_header6,
        colorCode: '0xFFF37253',
      ),
      const JourneyCardModel(
        id: 7,
        title: 'My Core Beliefs & Guiding Values',
        imagePath: LottieFiles.module_header7,
        colorCode: '0xFF02AF5D',
      ),
      const JourneyCardModel(
        id: 8,
        title: 'Messages for Future Generations',
        imagePath: LottieFiles.module_header8,
        colorCode: '0xFF006DEE',
      ),
    ];
  }
}
