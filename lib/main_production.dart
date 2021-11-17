import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wallet/generated/assets.gen.dart';

import 'main_common.dart';

void main() async {
  await dotenv.load(fileName: Assets.env.envProduction);
  await mainCommon();
}
