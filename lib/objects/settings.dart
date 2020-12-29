class Settings {
  int theme;
  bool automaticTimeLapse;
  bool notifications;

  Settings({
    this.theme,
    this.automaticTimeLapse,
    this.notifications,
  });

  Settings.fromJson(Map<dynamic, dynamic> json) {
    this.theme = json["theme"];
    this.automaticTimeLapse = json["automaticTimelapse"];
    this.notifications = json["notifications"];
  }
}
