import 'dart:async';

class StopWatchData {
  Duration _duration = const Duration();
  final StreamController<Duration> _durationStreamControler =
      StreamController();
  Stream<Duration> get durationStream => _durationStreamControler.stream;

  void startTimer() {
    _addTime();
  }

  void _addTime() {
    const addSeconds = 1;
    final seconds = _duration.inSeconds + addSeconds;
    _duration = Duration(seconds: seconds);
    _durationStreamControler.add(_duration);
  }

  void dispose() {
    _durationStreamControler.close();
  }

  String getTime({required Duration duration}) {
    final hrs = duration.inHours.toString().padLeft(2, '0');
    final min = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hrs:$min:$sec";
  }
}
