import 'package:flutter/widgets.dart';

import 'app/app.dart';
export 'app/app.dart' show CpClothApp;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CpClothApp());
}
