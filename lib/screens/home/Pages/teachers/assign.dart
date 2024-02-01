import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:gap/gap.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/field.dart';
import 'assignments.dart';

class Assign extends StatefulWidget {
  List teachers;
  Assign({super.key, required this.teachers});

  @override
  State<Assign> createState() => _AssignState();
}

class _AssignState extends State<Assign> {
  final client = Supabase.instance.client;
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  dialog(context, {id}) async {
    final MultiSelectController selectedclasses = MultiSelectController();
    final MultiSelectController selectedSubjectsController = MultiSelectController();
    List classesss = [];
    List subjectss = [];
    final teacherProfile = await client.from('teacher').select('*').eq('staffid', id);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return loading != true
            ? AlertDialog(
                scrollable: true,
                title: const Text('Assignment'),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          teacherProfile[0]['name'],
                          style: const TextStyle(fontSize: 30),
                        ),
                        const Gap(20),
                        MultiSelectDropDown(
                          hint: 'CLASSES',
                          showClearIcon: true,
                          controller: selectedclasses,
                          onOptionSelected: (options) {
                            // debugPrint(options.toString());
                          },
                          options: classess,
                          selectionType: SelectionType.multi,
                          chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                          selectedOptionBackgroundColor: generalColor,
                          optionTextStyle: const TextStyle(fontSize: 16),
                          selectedOptionIcon: const Icon(Icons.check_circle),
                        ),
                        const Gap(20),
                        MultiSelectDropDown(
                          alwaysShowOptionIcon: true,
                          showClearIcon: true,
                          controller: selectedSubjectsController,
                          hint: 'SUBJECTS',
                          onOptionSelected: (options) {
                            // debugPrint(options.toString());
                          },
                          options: subjects,
                          selectionType: SelectionType.multi,
                          chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                          selectedOptionBackgroundColor: generalColor,
                          optionTextStyle: const TextStyle(fontSize: 16),
                          selectedOptionIcon: const Icon(Icons.check_circle),
                        ),
                        const Gap(20),
                        ElevatedButton(
                          child: const Text("Assign"),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                                // print('kofi');
                              });
                              for (var element in selectedSubjectsController.selectedOptions) {
                                subjectss.add(element.value);
                              }
                              for (var element in selectedclasses.selectedOptions) {
                                classesss.add(element.value);
                              }
                              try {
                                await client
                                    .from('teacher')
                                    .update({'assignedClass': classesss, 'subjects': subjectss}).eq('staffid', teacherProfile[0]['staffid']);
                                setState(() {
                                  loading = false;
                                });
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                                // ignore: use_build_context_synchronously
                                toast(context: context, msg: 'Successfully Assigned');
                              } catch (e) {
                                toast(context: context, msg: e.toString());
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : loadingScreen();
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
      initialList: widget.teachers,
      filter: (p0) {
        return widget.teachers.where((element) => element['name'].toString().toUpperCase().contains(p0.toString().toUpperCase())).toList();
      },
      reverse: false,
      emptyWidget: const EmptyView(),
      onRefresh: () async {
        // setState(() {
        // teachers = widget.teachers;
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
        height: MediaQuery.of(context).size.height / 7,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 30,
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
                Text(
                  'Assigned Class: ${teacher['assignedClass'].toString().replaceAll("[", "").replaceAll("]", "").toUpperCase()}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Assigned Subjects: ${teacher['subjects'].toString().replaceAll("[", "").replaceAll("]", "").toUpperCase()}',
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
