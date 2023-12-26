import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/schoolsModel.dart';

class supaDatabaseService {
  final client = Supabase.instance.client;

  Stream get schools {
    return client.from('schools').stream(primaryKey: ['school_code']);
  }
}
