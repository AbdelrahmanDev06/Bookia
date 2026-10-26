class SliderModel {
  final String image;

  SliderModel({required this.image});

  factory SliderModel.fromJson(Map<String, dynamic> json) =>
      SliderModel(image: json['image']?.toString() ?? '');

  static List<SliderModel> listFromResponse(Map<String, dynamic> json) {
    final data = json['data'];
    final sliders = data is Map ? data['sliders'] : null;
    if (sliders is! List) return [];
    return sliders
        .whereType<Map>()
        .map((e) => SliderModel.fromJson(Map<String, dynamic>.from(e)))
        .where((s) => s.image.isNotEmpty)
        .toList();
  }
}
