import '../styles.dart';

class GrowPhase {
  double vegation_temp;
  double vegation_hum;
  String vegation_suntime;
  double flower_temp;
  double flower_hum;
  String flower_suntime;
  double lateflower_temp;
  double lateflower_hum;
  String lateflower_suntime;
  String phase;

  GrowPhase({
    this.flower_hum,
    this.flower_suntime,
    this.flower_temp,
    this.lateflower_hum,
    this.lateflower_suntime,
    this.lateflower_temp,
    this.vegation_hum,
    this.vegation_suntime,
    this.vegation_temp,
  });

  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      "vegation_temp": vegation_temp,
      "vegation_hum": vegation_hum,
      "vegation_suntime": vegation_suntime,
      "flower_temp": flower_temp,
      "flower_hum": flower_hum,
      "flower_suntime": flower_suntime,
      "lateflower_temp": lateflower_temp,
      "lateflower_hum": lateflower_hum,
      "lateflower_suntime": lateflower_suntime,
    };
  }

  GrowPhase.fromJson(Map<dynamic, dynamic> json) {
    this.vegation_temp = (json["vegation_temp"] as num).toDouble();
    this.vegation_hum = (json["vegation_hum"] as num).toDouble();
    this.vegation_suntime = json["vegation_suntime"];
    this.flower_temp = (json["flower_temp"] as num).toDouble();
    this.flower_hum = (json["flower_hum"] as num).toDouble();
    this.flower_suntime = json["flower_suntime"];
    this.lateflower_temp = (json["lateflower_temp"] as num).toDouble();
    this.lateflower_hum = (json["lateflower_hum"] as num).toDouble();
    this.lateflower_suntime = json["lateflower_suntime"];
  }
}
