class ConfigModel {
  final String searchUrl;

  ConfigModel({this.searchUrl});

  // map 转obj的工厂方法
  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(searchUrl: json['searchUrl']);
  }

  Map<String, dynamic> toJson() {
    return {searchUrl: searchUrl};
  }
}
