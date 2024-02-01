import 'package:easy_dashboard/easy_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:school_management/screens/home/Pages/teacherManagement.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/colors.dart';
import '../auth/signin.dart';
import 'Pages/inventory.dart';
import 'Pages/message.dart';
import 'Pages/pupilManagement.dart';
import 'Pages/home.dart';
import 'Pages/setting.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

class HeadTeacherHome extends StatefulWidget {
  const HeadTeacherHome({super.key});

  @override
  State<HeadTeacherHome> createState() => _HeadTeacherHomeState();
}

class _HeadTeacherHomeState extends State<HeadTeacherHome> {
  late final EasyAppController controller = EasyAppController(
    // intialBody: EasyBody(child: tile1.body, title: tile1.title),
    intialBody: EasyBody(
      child: const Home(),
      title: const Text(
        'Home',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
      ),
    ),
  );

  List<SideTile> tile = [
    SideBarTile(
      icon: const IconData(0xe318, fontFamily: 'MaterialIcons'),
      name: 'Home',
      title: const Text(
        'Home',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
      ),
      body: const Home(),
    ),
    SideBarTile(
      icon: const IconData(0xf89e, fontFamily: 'MaterialIcons'),
      name: 'Teacher Management',
      title: const Text(
        'Teacher Management',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
      ),
      body: const TeacherManagement(),
    ),
    SideBarTile(
      icon: const IconData(0xeabf, fontFamily: 'MaterialIcons'),
      name: 'Pupil Management',
      title: const Text(
        'Pupil Management',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
      ),
      body: const PupilManagement(),
    ),
    SideBarTile(
      icon: const IconData(0xe349, fontFamily: 'MaterialIcons'),
      name: 'Inventory Management',
      title: const Text(
        'Inventory Management',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
      ),
      body: const Inventory(),
    ),
    SideBarTile(
      icon: const IconData(0xe087, fontFamily: 'MaterialIcons'),
      name: 'Notice',
      title: const Text(
        'Notice',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
      ),
      body: const Message(),
    ),
    SideBarTile(
      icon: const IconData(0xe57f, fontFamily: 'MaterialIcons'),
      name: 'Settings',
      title: const Text(
        'Settings',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
      ),
      body: const Settings(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return EasyDashboard(
      controller: controller,
      navigationIcon: const Icon(Icons.menu, color: Colors.white),
      appBarActions: [
        TextButton.icon(
          onPressed: () {
            Supabase.instance.client.auth.signOut();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const SignIn(),
            ));
          },
          icon: const Icon(
            IconData(0xf199, fontFamily: 'MaterialIcons'),
            color: Colors.white,
          ),
          label: const Text(
            'SignOut',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        )
      ],
      centerTitle: true,
      appBarColor: generalColor!,
      sideBarColor: Colors.grey.shade100,
      navigationIconSplashRadius: 100,
      tabletView: const TabletView(
        fullAppBar: true,
        border: BorderSide(width: 0.5, color: Colors.grey),
      ),
      desktopView: const DesktopView(
        fullAppBar: true,
        border: BorderSide(width: 0.5, color: Colors.grey),
      ),
      drawer: (Size size, Widget? child) {
        return EasyDrawer(
          iconColor: Colors.black,
          hoverColor: Colors.grey.shade300,
          tileColor: Colors.grey.shade100,
          selectedColor: Colors.white,
          selectedIconColor: Colors.white,
          textColor: Colors.black,
          selectedTileColor: generalColor,
          tiles: tile,
          selectedTextColor: Colors.white,
          topWidget: const SideBox(
            scrollable: true, height: 150,
            child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/school-crest-template-design-3be8c4aaf4cfb68dc47300de0951723b_screen.jpg?ts=1618596601',
                ),
                child: ClipOval(
                  child: Image(
                    image: NetworkImage(
                      'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/school-crest-template-design-3be8c4aaf4cfb68dc47300de0951723b_screen.jpg?ts=1618596601',
                    ),
                  ),
                )),

            // topOpenWidget,
          ),
          bottomWidget: const SideBox(
            scrollable: false,
            height: 50,
            child: Text('bottomOpenWidget'),
            // bottomOpenWidget,
          ),
          bottomSmallWidget: const SideBox(
            height: 50,
            child: Text('bottomSmallWidget'),
            // bottomSmallWidget,
          ),
          topSmallWidget: const SideBox(
            height: 50,
            child: CircleAvatar(
              child: Image(
                image: NetworkImage('https://storage.googleapis.com/kaggle-avatars/images/6579202-gr.jpg'),
              ),
            ),
            // topSmallWidget,
          ),
          size: size,
          onTileTapped: (body) {
            controller.switchBody(body);
          },
        );
      },
    );
  }
}
