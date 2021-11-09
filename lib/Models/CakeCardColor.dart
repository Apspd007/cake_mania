enum CakeCardColor { corn, terraCotta, brinkPink }

class CakeCardColorConvertor {
  static CakeCardColor fromJson(json) {
    if (json == "corn") {
      return CakeCardColor.corn;
    } else if (json == "brinkPink") {
      return CakeCardColor.brinkPink;
    } else if (json == "terraCotta") {
      return CakeCardColor.terraCotta;
    } else {
      return CakeCardColor.corn;
    }
  }

  static String toJson(CakeCardColor cakeCardColor) {
    if (cakeCardColor == CakeCardColor.corn) {
      return 'corn';
    } else if (CakeCardColor.brinkPink == cakeCardColor) {
      return 'brinkPink';
    } else if (CakeCardColor.terraCotta == cakeCardColor) {
      return 'terraCotta';
    } else {
      return 'corn';
    }
  }
}
