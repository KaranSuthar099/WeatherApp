class WindDirectionConvertor {
  static String convert(num degree) {
    List<String> degreeMap = [
      "North",
      "North-Northeast",
      "Northeast",
      "East-Northeast",
      "East",
      "East-Southeast",
      "Southeast",
      "South-Southeast",
      "South",
      "South-Southwest",
      "Southwest",
      "West-Southwest",
      "West",
      "West-Northwest",
      "Northwest",
      "North-Northwest"
    ];

    if (degree == 360) return degreeMap[0];

    int index = ((degree.toInt()) / 22.5).round();
    return degreeMap[index];
  }
}
