formatDuration(Duration d) {
  String twoDigits(int n) {
    return n >= 10 ? "$n" : "0$n";
  }

  String min = twoDigits(d.inMinutes.remainder(60));
  String sec = twoDigits(d.inSeconds.remainder(60));
  return "$min:$sec";
}
