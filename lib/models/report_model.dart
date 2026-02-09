class ReportModel {
  final String description;
  final String imageUrl;
  final double lat;
  final double lng;
  final String userId;

  ReportModel({
    required this.description,
    required this.imageUrl,
    required this.lat,
    required this.lng,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "imageUrl": imageUrl,
      "lat": lat,
      "lng": lng,
      "userId": userId,
      "likes": [],
      "createdAt": DateTime.now(),
    };
  }
}
