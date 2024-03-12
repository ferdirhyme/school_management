import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../constants/colors.dart';
import 'pupils/newadmissions.dart';

class PupilManagement extends StatefulWidget {
  const PupilManagement({super.key});

  @override
  State<PupilManagement> createState() => _PupilManagementState();
}

class _PupilManagementState extends State<PupilManagement> {
  late final client;
  String school = '';
  String emisCode = '';

  @override
  void initState() {
    super.initState();
    client = Supabase.instance.client;
    fetchSchoolEmisCode();
  }

  Future<List> fetchSchoolEmisCode() async {
    var userId = client.auth.currentUser;
    var user = userId?.id;

    final headschool = await client.from('headteacher').select('school,emisCode').eq('id', user);

    setState(() {
      school = headschool[0]['school'].toString();
      emisCode = headschool[0]['emisCode'].toString();
      print(school + '+' + emisCode);
    });

    return headschool;
  }

  @override
  Widget build(BuildContext context) {
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
                  text: "Pupil ....",
                ),

//*******************************************************Pupil .....***********************************************
                Tab(
                  icon: TextButton.icon(
                    icon: const Icon(
                      IconData(0xe78d, fontFamily: 'MaterialIcons'),
                      color: Colors.red,
                    ),
                    onPressed: () {},
                    label: const Text(
                      '',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  text: "Pupil ....",
                ),

                // *********************Pupil ....*************************
                const Tab(
                  icon: Icon(Icons.person),
                  text: "New Admissions",
                ),
                // const Tab(icon: Icon(Icons.directions_car)),
                // const Tab(icon: Icon(Icons.directions_transit)),
                // const Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  const Center(
                    child: Icon(Icons.directions_car),
                  ),
                  const Center(
                    child: Icon(Icons.directions_transit),
                  ),
                  Center(
                    child: NewAdmission(school: school, emisCode: emisCode),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
