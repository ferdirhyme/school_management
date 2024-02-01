import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewAdmission extends StatefulWidget {
  const NewAdmission({super.key});

  @override
  State<NewAdmission> createState() => _NewAdmissionState();
}

class _NewAdmissionState extends State<NewAdmission> {
  final client = Supabase.instance.client;
  late String admissionNumber;
  fetchteacherApprovals() async {
    var userId = client.auth.currentUser;
    var user = userId?.id;
    final headschool = await client.from('headteacher').select('*').eq('id', user);
    var k = headschool[0]['emisCode'].toString()[8] + headschool[0]['emisCode'].toString()[9];
    final lastadmnumber = await client.from('pupil').select('admissionNumber').eq('school', headschool[0]['school']);
    // debugPrint((lastadmnumber.length + 1).toString());
    admissionNumber = 'T00${k}${(lastadmnumber.length + 1)}';

    if (admissionNumber.length == 6) {
      admissionNumber = 'T00${k}0000${(lastadmnumber.length + 1)}';
    } else if (admissionNumber.length == 7) {
      admissionNumber = 'T00${k}000${(lastadmnumber.length + 1)}';
    } else if (admissionNumber.length == 8) {
      admissionNumber = 'T00${k}00${(lastadmnumber.length + 1)}';
    } else if (admissionNumber.length == 9) {
      admissionNumber = 'T00${k}0${(lastadmnumber.length + 1)}';
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
    return const Placeholder();
  }
}
