class AddUserData {
  String? school;
  String? email;
  String? password;
  String? emisCode;
  String? staffID;
  String? name;
  String? admissionNumber;
  String? gaurdianPhone;
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
    gaurdianPhone = data['gaurdianPhone'];
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
      'gaurdianPhone': gaurdianPhone,
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
    this.gaurdianPhone,
  });
}
