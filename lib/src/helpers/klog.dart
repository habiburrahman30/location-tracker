import 'dart:developer';

klog(dynamic data) {
  log('$data');
}

void logInfo(String msg) {
  log('\x1B[34m💡 $msg 💡\x1B[0m');
}

void logSuccess(dynamic msg) {
  log('\x1B[32m🤑 $msg 🤑\x1B[0m');
}

void logWarning(String msg) {
  log('\x1B[33m⚠️ $msg ⚠️\x1B[0m');
}

void logError(String msg) {
  log('\x1B[31m👾⛔ $msg ⛔👾\x1B[0m');
}
//  '🐛💡⚠️⛔👾',
