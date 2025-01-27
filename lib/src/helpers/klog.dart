import 'dart:developer';

klog(dynamic data) {
  log('$data');
}

void logInfo(dynamic msg) {
  log('\x1B[34m💡 $msg 💡\x1B[0m');
}

void logSuccess(dynamic msg) {
  log('\x1B[32m🤑 $msg 🤑\x1B[0m');
}

void logWarning(dynamic msg) {
  log('\x1B[33m⚠️ $msg ⚠️\x1B[0m');
}

void logError(dynamic msg) {
  log('\x1B[31m👾⛔ $msg ⛔👾\x1B[0m');
}
//  '🐛💡⚠️⛔👾',
