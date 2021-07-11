import 'package:flutter/foundation.dart';

dprint(String str){
  if (!kReleaseMode) print(str);
}