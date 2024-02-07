import 'dart:io';
import 'package:date_picker_widget/date_picker_widget.dart';
import 'package:file_picker_pro/file_data.dart';
import 'package:file_picker_pro/file_picker.dart';
import 'package:file_picker_pro/files.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../constants/field.dart';
import '../teachers/assignments.dart';

class NewAdmission extends StatefulWidget {
  const NewAdmission({super.key});

  @override
  State<NewAdmission> createState() => _NewAdmissionState();
}

class _NewAdmissionState extends State<NewAdmission> {
  final formKey = GlobalKey<FormState>();
  String dropdownValue = classess1.first;
  final MultiSelectController selectedclasses = MultiSelectController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController admissionDateController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController nameOfGaurdianController = TextEditingController();
  final TextEditingController gaurdianPhone = TextEditingController();

  final client = Supabase.instance.client;
  String admissionNumber = 'Generating...';
  FileData _fileData = FileData();

  fetchteacherApprovals() async {
    var userId = client.auth.currentUser;
    var user = userId?.id;
    final headschool = await client.from('headteacher').select('*').eq('id', user);
    var k = headschool[0]['emisCode'].toString()[8] + headschool[0]['emisCode'].toString()[9];
    final lastadmnumber = await client.from('pupil').select('admissionNumber').eq('school', headschool[0]['school']);
    // debugPrint((lastadmnumber.length + 1).toString());
    setState(() {
      admissionNumber = 'T00$k${(lastadmnumber.length + 1)}';
    });

    if (admissionNumber.length == 6) {
      setState(() {
        admissionNumber = 'T00${k}0000${(lastadmnumber.length + 1)}';
      });
    } else if (admissionNumber.length == 7) {
      setState(() {
        admissionNumber = 'T00${k}000${(lastadmnumber.length + 1)}';
      });
    } else if (admissionNumber.length == 8) {
      setState(() {
        admissionNumber = 'T00${k}00${(lastadmnumber.length + 1)}';
      });
    } else if (admissionNumber.length == 9) {
      setState(() {
        admissionNumber = 'T00${k}0${(lastadmnumber.length + 1)}';
      });
    }

    debugPrint(admissionNumber);
    return headschool;
  }

  @override
  void initState() {
    if (mounted) {
      fetchteacherApprovals();
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        const Gap(20),
        FilePicker(
          context: context,
          height: 50,
          fileData: _fileData,
          crop: true,
          maxFileSizeInMb: 3,
          allowedExtensions: const [
            Files.png,
            Files.png,
            Files.jpg,
          ],
          onSelected: (fileData) {
            _fileData = fileData;
            debugPrint(fileData.filePath);
            setState(() {});
          },
          onCancel: (message, messageCode) {
            debugPrint("[$messageCode] $message");
          },
          child: _fileData.filePath != ''
              ? CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 20,
                  backgroundImage: FileImage(File(_fileData.filePath)),
                )
              : CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 20,
                  backgroundImage: const AssetImage('assets/imgs/noprofile.jpg'),
                  child: Stack(children: const [Positioned(top: 150, left: 50, child: Icon(Icons.camera_alt))]),
                ),
        ),
        const Gap(20),
        Text(
          'Admission Number: $admissionNumber ',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width / 90,
          ),
        ),
        const Gap(10),
        Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                myTextField(
                  obscure: false,
                  context: context,
                  enabled: true,
                  hintText: 'Name',
                  preFixIcon: const Icon(Icons.person),
                ),
                const Gap(10),
                SizedBox(
                  width: MediaQuery.of(context).size.height / 2,
                  child: DropdownMenu<String>(
                    // initialSelection: classess1.first,
                    hintText: 'Class',
                    leadingIcon: const Icon(Icons.school),
                    inputDecorationTheme: InputDecorationTheme(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                    onSelected: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    dropdownMenuEntries: classess1.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(value: value, label: value);
                    }).toList(),
                  ),
                ),
                const Gap(10),
                CustomTimePicker(
                  is24Hours: false,
                  height: 200,
                  width: 30,
                  initialDate: TimeOfDay.now(),
                  onTimeSelected: (time) {
                    print(time);
                  },
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
