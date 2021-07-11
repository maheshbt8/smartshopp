double toDouble(String str){
  double ret = 0;
  try {
    ret = double.parse(str);
  }catch(_){}
  return ret;
}

int toInt(String str){
  int ret = 0;
  try {
    ret = int.parse(str);
  }catch(_){}
  return ret;
}

bool toBool(String str){
  return  (str == "true") ? true : false;
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return false;
  else
    return true;
}
