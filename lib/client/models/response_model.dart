class ResponseModel {
  List<String>? files;
  String? summary;
  String? ppt;

  ResponseModel({
    this.files,
    this.summary,
    this.ppt,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['files'] = files;
    map['summary'] = summary;
    map['ppt'] = ppt;
    return map;
  }

  factory ResponseModel.fromJson(dynamic json) {
    return ResponseModel(
      files: json['files'] != null ? List<String>.from(json['files']) : null,
      summary: json['summary'],
      ppt: json['ppt'],
    );
  }
}
