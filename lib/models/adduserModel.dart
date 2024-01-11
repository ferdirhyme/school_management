class AddUserData {
  String? school;
  String? email;
  String? password;
  String? emisCode;
  String? staffID;
  String? name;
  String? admissionNumber;
  AddUserData.fromMap(
    Map<String, dynamic> data,
  ) {
    school = data['school'];
    email = data['email'];
    password = data['password'];
    emisCode = data['emisCode'];
    staffID = data['staffID'];
    name = data['name'];
    admissionNumber = data['admissionNumber'];
  }

  Map<String, dynamic> toMap() {
    return {
      'school': school,
      'email': email,
      'password': password,
      'emisCode': emisCode,
      'staffID': staffID,
      'name': name,
      'admissionNumber': admissionNumber,
    };
  }

  AddUserData({
    this.email,
    this.emisCode,
    this.name,
    this.password,
    this.school,
    this.staffID,
    this.admissionNumber,
  });
}
