enum CakeCardColor { corn, englishVermillion, terraCotta }

class CakeCardColorConvertor {
  static CakeCardColor fromJson(json) {
    if (json == "corn") {
      return CakeCardColor.corn;
    } else if (json == "englishVermillion") {
      return CakeCardColor.englishVermillion;
    } else if (json == "terraCotta") {
      return CakeCardColor.terraCotta;
    } else {
      return CakeCardColor.corn;
    }
  }

  static String toJson(CakeCardColor cakeCardColor) {
    if (cakeCardColor == CakeCardColor.corn) {
      return 'corn';
    } else if (CakeCardColor.englishVermillion == cakeCardColor) {
      return 'englishVermillion';
    } else if (CakeCardColor.terraCotta == cakeCardColor) {
      return 'terraCotta';
    } else {
      return 'corn';
    }
  }
}
