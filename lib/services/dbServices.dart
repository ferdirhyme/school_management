import 'package:supabase_flutter/supabase_flutter.dart';

class DBservices {
  final client = Supabase.instance.client;

  insertPupilData({required Map data}) async {
    await client.from('pupil_init').insert(data);
  }
}
