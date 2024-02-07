// import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

// import '../../models/schoolsModel.dart';

class AuthService {
  final client = Supabase.instance.client;

  late List check;
  late List admissionExist;
  late List gaurdianPhoneExist;

  Future<List> fetchEmisCode(password, emisCode) async {
    final emisData = await client.from('schools').select('school_code, password').match({'school_code': emisCode, 'password': password});
    return emisData;
  }

  Future<List> fetchEmisCodeForPupil(school) async {
    final emisData = await client.from('schools').select('school_code').match({'institution': school});
    return emisData;
  }

  Future<List> fetchAdmissionNumber(admissionNumber) async {
    final emisData = await client.from('pupils').select('admission_number').eq('admission_number', admissionNumber);

    return emisData;
  }

  Future<List> fetchGaudianPhoneNumber(admissionNumber) async {
    final gaurdianPhone = await client.from('pupils').select('phoneNumberOfGuardian').eq('admission_number', admissionNumber);
    return gaurdianPhone;
  }

  insertProfileData({data, usertype}) async {
    var userId = client.auth.currentUser;
    var user = userId?.id;
    if (usertype == 'headteacher') {
      await client.from(usertype).insert({
        'emisCode': data.emisCode,
        'id': user,
        'email': data.email,
        'name': data.name,
        'profilePicUrl': 'pic',
        'school': data.school,
      });
    } else if (usertype == 'teacher') {
      final results = await client.from(usertype).insert({
        'staffid': data.staffID,
        'id': user,
        'email': data.email,
        'name': data.name,
        'profilePicUrl': 'pic',
        'school': data.school,
      });
      // print(results);
      if (results == null) {
        await client.from('teacher_approvals').insert({
          'staffid': data.staffID,
          'id': user,
          'name': data.name,
          'school': data.school,
        });
      }
    } else if (usertype == 'pupil') {
      await client
          .from(usertype)
          .update({
            // 'admissionNumber': data.admissionNumber,
            'id': user,
            'email': data.email,
            // 'name': data.name,
            // 'profilePicUrl': 'pic',
            // 'school': data.school,
          })
          .eq('admissionNumber', data.admissionNumber)
          .eq('phoneNumberOfGuardian', data.guardianPhone);
    } else if (usertype == 'admin') {
      await client.from(usertype).insert({
        'staffid': data.staffID,
        'id': user,
        'email': data.email,
        'name': data.name,
        'profilePicUrl': 'pic',
      });
    }
    await client.from('user_status').insert({
      'id': user,
      'status': usertype,
    });
  }

  Future<String?> signupUser(usertype, data) async {
    String myreturn = '';
    if (usertype == 'headteacher') {
      final validEmisCode = fetchEmisCode(data.password, data.emisCode);

      await validEmisCode.then((value) {
        check = value;
      });

      if (check.isNotEmpty) {
        try {
          await client.auth.signUp(password: data.password, email: data.email).then(
            (value) {
              insertProfileData(usertype: usertype, data: data);
            },
          );
          // return '';
        } catch (e) {
          if (e.toString() == 'AuthException(message: Email rate limit exceeded, statusCode: 429)') {
            myreturn = 'Server Busy. Please try again after 30min';
          }
          myreturn = e.toString();
        }
      } else {
        myreturn = 'Invalid Emis Code or Password';
      }
    } else if (usertype == 'teacher') {
      try {
        await client.auth.signUp(password: data.password, email: data.email).then(
          (value) {
            insertProfileData(usertype: usertype, data: data);
          },
        );
        // return '';
      } catch (e) {
        if (e.toString() == 'AuthException(message: Email rate limit exceeded, statusCode: 429)') {
          myreturn = 'Server Busy. Please try again after 30min';
        }
        myreturn = e.toString();
      }
    } else if (usertype == 'pupil') {
      final admissionUmberExist = fetchAdmissionNumber(data.admissionNumber);
      final gaurdianphone = fetchGaudianPhoneNumber(data.admissionNumber);

      await admissionUmberExist.then((value) {
        admissionExist = value;
      });
      await gaurdianphone.then((value) {
        gaurdianPhoneExist = value;
      });
      if (admissionExist.isNotEmpty && gaurdianPhoneExist[0] == data.gaurdianPhone) {
        try {
          await client.auth.signUp(password: data.password, email: data.email).then(
            (value) {
              insertProfileData(usertype: usertype, data: data);
            },
          );
          // return '';
        } catch (e) {
          if (e.toString() == 'AuthException(message: Email rate limit exceeded, statusCode: 429)') {
            myreturn = 'Server Busy. Please try again after 30min';
          }
          myreturn = e.toString();
        }
      } else {
        myreturn = 'Admission Number Does Not Exist Or Incorrect Gaurdian Phone Number';
      }
    } else if (usertype == 'admin') {
      try {
        await client.auth.signUp(password: data.password, email: data.email).then(
          (value) {
            insertProfileData(usertype: usertype, data: data);
          },
        );
      } catch (e) {
        if (e.toString() == 'AuthException(message: Email rate limit exceeded, statusCode: 429)') {
          myreturn = 'Server Busy. Please try again after 30min';
        }
        myreturn = e.toString();
      }
    }
    return myreturn;
  }
}
