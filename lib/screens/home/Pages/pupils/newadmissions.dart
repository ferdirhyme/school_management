import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:gap/gap.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/field.dart';
import '../../../../services/dbServices.dart';
import '../teachers/assignments.dart';

class NewAdmission extends StatefulWidget {
  final String school;
  final String emisCode;
  const NewAdmission({super.key, required this.emisCode, required this.school});

  @override
  State<NewAdmission> createState() => _NewAdmissionState();
}

class _NewAdmissionState extends State<NewAdmission> {
  final formKey = GlobalKey<FormState>();
  String dropdownValue = classess1.first;
  // final MultiSelectController selectedclasses = MultiSelectController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  late TextEditingController admissionDateController = TextEditingController();
  late TextEditingController dobController = TextEditingController();
  final TextEditingController nameOfGaurdianController = TextEditingController();
  final TextEditingController gaurdianPhoneController = TextEditingController();
  late DateTime _selectedDOB;
  late DateTime _selectedAD;
  late String school;
  late String emisCode;
  final dobFieldKey = GlobalKey();
  final admissionFieldKey = GlobalKey();
  final client = Supabase.instance.client;
  String admissionNumber = 'Generating...';
  String? userId;
  Uint8List? selectedImageBytes;
  Map pupilData = {};
  String imageUrl = '';
  final dbService = DBservices();
  bool loading = false;
  dynamic firstImage;

  Future<void> uploadImage(imageFile, path) async {
    final imageExtension = path.split('.').last.toLowerCase();
    // final imageBytes = File.fromRawPath(imageFile.filePath).readAsBytes();
    // final imageBytes = await imageFile.readAsBytes();
    final userId = client.auth.currentUser!.id;
    final imagePath = '/$userId/${gaurdianPhoneController.text}/pupil_profiles';
    final storage = client.storage.from('pupil_profiles');
    if (imageFile != null) {
      final response = await storage.uploadBinary(
        imagePath,
        imageFile,
        fileOptions: FileOptions(
          upsert: true,
          contentType: 'image/$imageExtension',
        ),
      );
      imageUrl = client.storage.from('pupil_profiles').getPublicUrl(imagePath);
      imageUrl = Uri.parse(imageUrl).replace(queryParameters: {'t': DateTime.now().millisecondsSinceEpoch.toString()}).toString();
      setState(() {
        imageUrl = client.storage.from('pupil_profiles').getPublicUrl(imagePath);
        imageUrl = Uri.parse(imageUrl).replace(queryParameters: {'t': DateTime.now().millisecondsSinceEpoch.toString()}).toString();
      });
    } else {
      return;
    }
  }

  fetchteacherApprovals() async {
    var userId = client.auth.currentUser;
    var user = userId?.id;
    final headschool = await client.from('headteacher').select('*').eq('id', user);
    var k = headschool[0]['emisCode'].toString()[8] + headschool[0]['emisCode'].toString()[9];
    final lastadmnumber = await client.from('pupil_init').select('admissionNumber').eq('school', headschool[0]['school']);
    // debugPrint((lastadmnumber.length + 1).toString());
    setState(() {
      admissionNumber = 'T00$k${(lastadmnumber.length + 1)}';
      school = headschool[0]['school'];
      emisCode = headschool[0]['emisCode'];
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
    _selectedDOB = DateTime.now();
    _selectedAD = DateTime.now();
    userId = client.auth.currentUser!.id;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(children: [
          const Gap(30),
          !loading
              ? Form(
                  key: formKey,
                  child: Column(
                    children: [
                      FormBuilderImagePicker(
                        onChanged: (List<dynamic>? selectedImages) async {
                          if (selectedImages != null && selectedImages.isNotEmpty) {
                            setState(() {
                              firstImage = selectedImages[0];
                            });

                            if (firstImage is XFile) {
                              // Convert XFile to Uint8List
                              selectedImageBytes = await File(firstImage.path).readAsBytes();
                              // debugPrint("Selected Image Bytes: $selectedImageBytes");
                            } else {
                              debugPrint("Invalid image type. Expected XFile, received: $firstImage");
                              toast(msg: "Invalid image type. Expected XFile, received: $firstImage", context: context);
                            }
                          }
                        },
                        name: 'singleAvatarPhoto',
                        decoration: const InputDecoration(
                          labelText: 'Pick Photos',
                        ),
                        transformImageWidget: (context, displayImage) => Card(
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: SizedBox.expand(
                            child: displayImage,
                          ),
                        ),
                        showDecoration: false,
                        maxImages: 1,
                        previewAutoSizeWidth: false,
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
                      myTextField(
                        ontap: () {},
                        obscure: false,
                        context: context,
                        enabled: true,
                        hintText: 'Name',
                        preFixIcon: const Icon(Icons.person),
                        textController: nameController,
                      ),
                      const Gap(10),
                      SizedBox(
                        width: MediaQuery.of(context).size.height / 2,
                        child: DropdownMenu<String>(
                          // initialSelection: classess1.first,
                          controller: classController,
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
                      datefield(
                        context: context,
                        dateController: dobController,
                        hintText: 'Date Of Birth',
                        preFixIcon: const Icon(Icons.date_range),
                        selectedDate: _selectedDOB,
                        key: dobFieldKey,
                      ),
                      const Gap(10),
                      myTextField(
                        ontap: () {},
                        obscure: false,
                        context: context,
                        enabled: true,
                        hintText: 'Name of Gaurdian',
                        preFixIcon: const Icon(Icons.person),
                        textController: nameOfGaurdianController,
                      ),
                      const Gap(10),
                      myTextField(
                        ontap: () {},
                        obscure: false,
                        context: context,
                        enabled: true,
                        hintText: 'Gaurdian Phone #',
                        preFixIcon: const Icon(Icons.phone),
                        textController: gaurdianPhoneController,
                        keyboardType: TextInputType.phone,
                        inputformat: [
                          LengthLimitingTextInputFormatter(10), // Limit to 10 characters
                          FilteringTextInputFormatter.digitsOnly, // Allow only numeric input
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            // Ensure the phone number starts with '0'
                            if (newValue.text.isEmpty || (newValue.text.startsWith('0') && newValue.text.length <= 10)) {
                              return newValue;
                            }
                            return oldValue;
                          }),
                        ],
                      ),
                      const Gap(10),
                      datefield(
                        context: context,
                        dateController: admissionDateController,
                        hintText: 'Admission Date',
                        preFixIcon: const Icon(Icons.date_range),
                        selectedDate: _selectedAD,
                        key: admissionFieldKey,
                      ),
                      
                      
                      const Gap(20),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (selectedImageBytes != null && classController.text.isNotEmpty) {
                                if (admissionNumber != 'Generating...') {
                                  uploadImage(selectedImageBytes, firstImage.path);
                                  if (imageUrl != '') {
                                    setState(() {
                                      loading = true;
                                    });
                                    pupilData = {
                                      'admissionNumber': admissionNumber,
                                      'name': nameController.text,
                                      'profilePicUrl': imageUrl,
                                      'school': widget.school,
                                      'class': classController.text,
                                      'admissionDate': admissionDateController.text,
                                      'dateOfBirth': dobController.text,
                                      'nameOfGaurdian': nameOfGaurdianController.text,
                                      'phoneNumberOfGuardian': gaurdianPhoneController.text,
                                      'schoolEmisCode': widget.emisCode,
                                    };
                                    var upload = await dbService.insertPupilData(data: pupilData);
                                    setState(() {
                                      loading = false;
                                    });
                                    print(upload);
                                  } else {
                                    toast(context: context, msg: 'An Error Occured while Uploading image.');
                                  }
                                } else {
                                  toast(context: context, msg: 'Admission Number Generation Faild');
                                }
                              } else {
                                toast(context: context, msg: 'You need to choose a profile image and an admitting class');
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: generalColor,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.greenAccent,
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                            // minimumSize: Size(100, 40), //////// HERE
                          ),
                          child: const Text(
                            'ADMIT',
                            // style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : loadingScreen(),
        ]),
      ),
    );
  }
}
