class VPDElement {
  double minHum;
  double maxHum;
  double temp;

  VPDElement.fromJson(Map<dynamic, dynamic> json) {
    this.minHum = (json["humidity_min"] as num).toDouble();
    this.maxHum = (json["humidity_max"] as num).toDouble();
    this.temp = (json["temperature"] as num).toDouble();
  }
}
