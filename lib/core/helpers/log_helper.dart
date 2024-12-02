import 'dart:developer';

const kLogTag = "MV-Store";
const kLogEnable = true;

printLog(dynamic data) {
  if (kLogEnable) {
    log(data.toString(), name: kLogTag);
  }
}
