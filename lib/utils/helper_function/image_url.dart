class ImageUrl {
    // Base API details
  static const String basePath = "https://zedbee.io/api/micro/service/call/post/BZHEZISEWY/mobile";
  static const String apiToken = "dabf7de1-7ab9-4f00-90a8-298c45839015";
  static const String apiPath = "https://zedbee.io/api";

  /// Returns full download URL for any file
  static String getFileUrl(String fileName) {
    if (fileName.isEmpty) return "";
    return "$apiPath/files/download/$apiToken/$fileName";
  }

  /// Specifically for building images (optional helper)
  static String getBuildingImage(String img) {
    return getFileUrl(img);
  }
}