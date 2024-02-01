import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:gap/gap.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../constants/colors.dart';

class TeacherList extends StatelessWidget {
  List teachers;
  TeacherList({super.key, required this.teachers});
  final client = Supabase.instance.client;
  dialog(context, {id}) async {
    final teacherProfile = await client.from('teacher').select('*').eq('staffid', id);
    Widget buildDataRow(String label, String value, IconData icon) {
      return Row(
        children: [
          Icon(
            icon,
            color: generalColor,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                value.toString().replaceAll("[", "").replaceAll("]", "").toUpperCase(),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Teacher Profile'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(IconData(0xe3a4, fontFamily: 'MaterialIcons')),
                      onPressed: () {},
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: MediaQuery.of(context).size.width / 20,
                      backgroundImage: teacherProfile[0]['profilePicUrl'] != 'pic'
                          ? NetworkImage(teacherProfile[0]['profilePicUrl'])
                          : const NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1H81w4SmKH5DZmIbxU7EB0aMSkNQDoPQA1mRQxf2Y0wMF1NSa7vghbwwKASi1q4NPmNw&usqp=CAU'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  teacherProfile[0]['name'] ?? 'Not updated',
                  style: const TextStyle(fontSize: 20),
                ),
                Text(
                  '(${teacherProfile[0]['gender']})'.toUpperCase(),
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 10),
                buildDataRow('EMAIL', teacherProfile[0]['email'] ?? 'NULL', Icons.email),
                const SizedBox(height: 10),
                buildDataRow('PHONE', teacherProfile[0]['phone'] ?? 'NULL', Icons.phone),
                const SizedBox(height: 10),
                buildDataRow('STAFF ID', teacherProfile[0]['staffid'] ?? 'NULL', Icons.perm_identity),
                const SizedBox(height: 10),
                buildDataRow('REGISTERED NUMBER', teacherProfile[0]['registere_number'] ?? '', Icons.check_circle),
                const SizedBox(height: 10),
                buildDataRow('CURRENT SCHOOL', teacherProfile[0]['school'].toString().toUpperCase(), Icons.school),
                const SizedBox(height: 10),
                buildDataRow('SUBJECT(S) TAUGHT', teacherProfile[0]['subjects'].toString().toUpperCase(), Icons.book),
                const SizedBox(height: 10),
                buildDataRow('DATE OF BIRTH', teacherProfile[0]['dateOfBirth'].toString().toUpperCase(), Icons.calendar_today),
                const SizedBox(height: 10),
                buildDataRow('DATE OF FIRST APPOINTMENT', teacherProfile[0]['dateOfFirstApp'].toString().toUpperCase(), Icons.event),
                const SizedBox(height: 10),
                buildDataRow('CURRENT RANK', teacherProfile[0]['rank'].toString().toUpperCase(), Icons.star),
                const SizedBox(height: 10),
                buildDataRow('SSNIT NUMBER', teacherProfile[0]['ssnit'].toString().toUpperCase(), Icons.confirmation_number),
                const SizedBox(height: 10),
                buildDataRow('BANK', teacherProfile[0]['bank'].toString().toUpperCase(), Icons.account_balance),
                const SizedBox(height: 10),
                buildDataRow('BRANCH', teacherProfile[0]['branch'].toString().toUpperCase(), Icons.location_city),
                const SizedBox(height: 10),
                buildDataRow('ACCOUNT NUMBER', teacherProfile[0]['accNumber'].toString().toUpperCase(), Icons.account_circle),
                const SizedBox(height: 10),
                buildDataRow('NATIONALITY', teacherProfile[0]['nationality'].toString().toUpperCase(), Icons.flag),
                const SizedBox(height: 10),
                buildDataRow('HOMETOWN', teacherProfile[0]['hometown'].toString().toUpperCase(), Icons.home),
                const SizedBox(height: 10),
                buildDataRow('MARITAL STATUS', teacherProfile[0]['maritalStatus'].toString().toUpperCase(), Icons.favorite),
                const SizedBox(height: 10),
                buildDataRow('ACADEMIC QUALIFICATION', teacherProfile[0]['academicQualification'].toString().toUpperCase(), Icons.school),
                const SizedBox(height: 10),
                buildDataRow('PROFESSIONAL QUALIFICATION', teacherProfile[0]['profQualification'].toString().toUpperCase(), Icons.work),
                const SizedBox(height: 10),
                buildDataRow('LANGUAGES SPOKEN', teacherProfile[0]['languages'].toString().toUpperCase(), Icons.language),

                // Print Button
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text("Print"),
                  onPressed: () {
                    // your code
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SearchableList<dynamic>(
      seperatorBuilder: (context, index) {
        return Divider(
          color: generalColor,
        );
      },
      style: const TextStyle(fontSize: 25),
      builder: (list, index, item) {
        return TeacherItem(teacher: item);
      },
      errorWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.error,
            color: Colors.red,
          ),
          SizedBox(
            height: 20,
          ),
          Text('Error while fetching teachers')
        ],
      ),
      initialList: teachers,
      filter: (p0) {
        return teachers.where((element) => element['name'].toString().toUpperCase().contains(p0.toString().toUpperCase())).toList();
      },
      reverse: false,
      emptyWidget: const EmptyView(),
      onRefresh: () async {
        // setState(() {
        teachers = teachers;
        // });
      },
      onItemSelected: (dynamic item) {
        dialog(context, id: item['staffid'].toString());
      },
      inputDecoration: InputDecoration(
        labelText: "Search Teacher",
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      closeKeyboardWhenScrolling: true,
      displayClearIcon: true,
      textInputType: TextInputType.name,
    );

  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        Text('No teacher found'),
      ],
    );
  }
}

class TeacherItem extends StatelessWidget {
  final dynamic teacher;

  const TeacherItem({
    Key? key,
    required this.teacher,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 10,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Staff ID: ${teacher['staffid']}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Name: ${teacher['name'].toString().toUpperCase()}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
