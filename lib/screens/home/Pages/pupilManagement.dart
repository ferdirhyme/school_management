import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../constants/colors.dart';
import 'pupils/newadmissions.dart';

class PupilManagement extends StatefulWidget {
  const PupilManagement({super.key});

  @override
  State<PupilManagement> createState() => _PupilManagementState();
}

class _PupilManagementState extends State<PupilManagement> {
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
            const Expanded(
              child: TabBarView(
                children: <Widget>[
                  Center(
                    child: Icon(Icons.directions_car),
                  ),
                  Center(
                    child: Icon(Icons.directions_transit),
                  ),
                  Center(
                    child: NewAdmission(),
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
