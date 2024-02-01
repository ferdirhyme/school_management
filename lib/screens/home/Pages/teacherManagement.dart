import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../constants/colors.dart';
import '../../../constants/global.dart';
import 'teachers/assign.dart';
import 'teachers/teacherList.dart';
import 'teachers/teachersTobeApproved.dart';

class TeacherManagement extends StatefulWidget {
  const TeacherManagement({super.key});

  @override
  State<TeacherManagement> createState() => _TeacherManagementState();
}

class _TeacherManagementState extends State<TeacherManagement> {
  final client = Supabase.instance.client;
  List teachersToBeApproved = [];
  List teacherList = [];
  List teacherAssignment = [];
  fetchteacherApprovals() async {
    var userId = client.auth.currentUser;
    var user = userId?.id;
    final headschool = await client.from('headteacher').select('school').eq('id', user);
    final teachersTobeapproved = await client.from('teacher').select('staffid,name').eq('school', headschool[0]['school']).eq('confirmed', 'FALSE');
    // print(headschool[0]['school']);
    // print(teachersTobeapproved.length);
    setState(() {
      teachersToBeApproved = teachersTobeapproved;
    });
    return teachersTobeapproved;
  }

  fetchteacherList() async {
    var userId = client.auth.currentUser;
    var user = userId?.id;
    final headschool = await client.from('headteacher').select('school').eq('id', user);
    final teacherassignment =
        await client.from('teacher').select('staffid,name,subjects,assignedClass').eq('school', headschool[0]['school']).eq('confirmed', 'TRUE');

    final teacherlist = await client.from('teacher').select('staffid,name').eq('school', headschool[0]['school']).eq('confirmed', 'TRUE');
    setState(() {
      teacherList = teacherlist;
      teacherAssignment = teacherassignment;
    });
    return teacherList;
  }

  void refresh() {
    fetchteacherList();
    fetchteacherApprovals();
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchteacherList();
    fetchteacherApprovals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // fetchteacherApprovals();
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            ButtonsTabBar(
              backgroundColor: generalColor,
              unselectedBackgroundColor: Colors.grey[300],
              unselectedLabelStyle: const TextStyle(color: Colors.black),
              labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              tabs: [
                const Tab(
                  icon: Icon(Icons.assignment_add),
                  text: "Class Assignment",
                ),

//*******************************************************Teacher Approvals***********************************************
                Tab(
                  icon: TextButton.icon(
                    icon: const Icon(
                      IconData(0xe78d, fontFamily: 'MaterialIcons'),
                      color: Colors.red,
                    ),
                    onPressed: () {},
                    label: Text(
                      '${teachersToBeApproved.length}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  text: "Teacher Approval",
                ),

                // *********************Teacher Profile view*************************
                const Tab(
                  icon: Icon(Icons.person),
                  text: "Teacher Profile",
                ),
                // const Tab(icon: Icon(Icons.directions_car)),
                // const Tab(icon: Icon(Icons.directions_transit)),
                // const Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  Center(
                    child: Assign(teachers: teacherAssignment),
                  ),
//*******************************************************Teacher Approvals***********************************************
                  Center(
                    child: TeacherApproval(teachers: teachersToBeApproved, refresh: refresh),
                  ),

                  // *********************Teacher Profile view*************************
                  Center(
                    child: TeacherList(teachers: teacherList),
                  ),
                  // Center(
                  //   child: Icon(Icons.directions_car),
                  // ),
                  // Center(
                  //   child: Icon(Icons.directions_transit),
                  // ),
                  // Center(
                  //   child: Icon(Icons.directions_bike),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
