class SchoolsModel {
  String? institution;

  SchoolsModel.fromMap(
    Map<String, dynamic> data,
  ) {
    institution = data['institution'];
  }

  Map<String, dynamic> toMap() {
    return {
      'institution': institution,
    };
  }

  SchoolsModel({
    this.institution,
  });
}
