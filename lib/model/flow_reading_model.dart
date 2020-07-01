
class GaugeFlowReading {
  int flow;
  DateTime timestamp;
  GaugeFlowReading(this.flow, this.timestamp);
}

class GaugeReading<T> {
  T level;
  DateTime timeStamp;
  GaugeReading(this.level, this.timeStamp) {
    if (this is! GaugeReading<int> || this is! GaugeReading<double>) {
      throw ArgumentError('Unsupported type $T');
    }
  }
}
