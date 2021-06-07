
class Logger {
  static var mute = true;
  static void log(String msg) {
    if (!mute) {
      print(msg);
    }
  }
}