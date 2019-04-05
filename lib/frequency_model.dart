class Frequency {
  String name;
  FrequencyType type;

  Frequency(this.name, this.type);
}

enum FrequencyType {
  daily,
  weekly,
  biweekly,
  monthly,
  quarterly,
  annually
}

final List<Frequency> frequencies = [
  Frequency('Daily', FrequencyType.daily),
  Frequency('Weekly', FrequencyType.weekly),
  Frequency('Every two weeks', FrequencyType.biweekly),
  Frequency('Monthly', FrequencyType.monthly),
  Frequency('Quarterly', FrequencyType.quarterly),
  Frequency('Annually', FrequencyType.annually),
];