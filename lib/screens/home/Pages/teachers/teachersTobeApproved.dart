import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:gap/gap.dart';
// import 'package:getwidget/getwidget.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/global.dart';

// ignore: must_be_immutable
class TeacherApproval extends StatefulWidget {
  List teachers;
  Function refresh;
  TeacherApproval({super.key, required this.teachers, required this.refresh});

  @override
  State<TeacherApproval> createState() => _TeacherApprovalState();
}

class _TeacherApprovalState extends State<TeacherApproval> {
  final client = Supabase.instance.client;

  conirmTeacher(staffid) async {
    await client.from('teacher').update({'confirmed': 'True'}).eq('staffid', staffid);
    setState(() {
      widget.teachers.removeWhere((teacher) => teacher['staffid'] == staffid);
      // appr = widget.teachers.length;
    });
  }

  showAlertDialog(BuildContext context, {id, name}) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Confirm"),
      onPressed: () {
        conirmTeacher(id);

        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm"),
      content: Text("Are you sure you want to comfirm $name ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    widget.refresh();
    super.initState();
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
      initialList: widget.teachers,
      filter: (p0) {
        return widget.teachers.where((element) => element['name'].toString().toUpperCase().contains(p0.toString().toUpperCase())).toList();
      },
      reverse: false,
      emptyWidget: const EmptyView(),
      onRefresh: () async {},
      onItemSelected: (dynamic item) {
        showAlertDialog(context, id: item['staffid'], name: item['name']);
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
