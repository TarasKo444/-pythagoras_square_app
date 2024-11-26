import 'package:intl/intl.dart';

final class CompatibilityService {
  int calculateLifePathNumber(DateTime birthdate) {
    final formatter = DateFormat('yyyy-MM-dd');
    final date = formatter.format(birthdate);

    int total = date
        .split('')
        .where((char) => int.tryParse(char) != null)
        .map(int.parse)
        .reduce((sum, digit) => sum + digit);

    while (total > 9 && ![11, 22, 33].contains(total)) {
      total = total
          .toString()
          .split('')
          .map(int.parse)
          .reduce((sum, digit) => sum + digit);
    }
    return total;
  }

  String getCompatibility(int lp1, int lp2) {
    Map<List<int>, String> compatibilityChart = {
      [11, 7]: "Highly spiritual and visionary connection.",
      [11, 11]: "Deeply intuitive and emotionally connected.",
      [11, 22]: "A visionary pair with potential for greatness.",
      [11, 33]: "Inspirational and transformative partnership.",
      [22, 4]: "A powerful and practical team.",
      [22, 8]: "Ambitious partnership with great success potential.",
      [22, 22]: "Masterful combination for achieving long-term visions.",
      [33, 6]: "Deeply nurturing and compassionate relationship.",
      [33, 9]: "Highly empathetic and focused on the greater good.",
      [33, 33]: "A rare and spiritually advanced union.",
      [1, 2]: "Balanced relationship with strong leadership and support.",
      [1, 3]: "Highly compatible: creative synergy.",
      [1, 5]: "Exciting and dynamic but may need balance.",
      [1, 7]: "Mutual respect for independence and intellect.",
      [1, 8]: "Goal-driven and ambitious connection.",
      [1, 9]: "Leader meets humanitarian: a dynamic team.",
      [2, 2]: "Peaceful and cooperative but may lack excitement.",
      [2, 3]: "Gentle and creative partnership with mutual encouragement.",
      [2, 4]: "Stable and cooperative partnership, good for family goals.",
      [2, 6]: "Harmonious, nurturing relationship.",
      [2, 8]: "Supportive and balanced with financial focus.",
      [2, 9]: "Empathetic and emotionally fulfilling connection.",
      [3, 3]: "Energetic, fun, but may lack focus.",
      [3, 4]: "Challenging: creative versus structured tendencies.",
      [3, 5]: "Dynamic, fun, and full of energy.",
      [3, 6]: "Creative and emotionally fulfilling relationship.",
      [3, 8]: "Creative meets ambitious: a good business team.",
      [3, 9]: "Highly imaginative and inspiring duo.",
      [4, 4]: "Strong foundation but may feel overly rigid.",
      [4, 5]: "Practicality meets adventure: exciting but challenging.",
      [4, 6]: "Structured and nurturing, ideal for long-term goals.",
      [4, 7]: "Grounded but intellectually stimulating connection.",
      [4, 8]: "Practical and goal-oriented partnership.",
      [5, 5]: "Exciting and free-spirited, but may lack stability.",
      [5, 6]: "Balanced between fun and responsibility.",
      [5, 7]: "Balanced between adventure and introspection.",
      [5, 9]: "Adventurous and humanitarian-minded connection.",
      [6, 6]: "Caring and nurturing but may become overly dependent.",
      [6, 8]: "Supportive and ambitious, great for family and business.",
      [6, 9]: "Deeply compassionate with shared values.",
      [7, 7]: "Intellectual and spiritual connection.",
      [7, 8]: "Grounded ambition meets intellectual curiosity.",
      [7, 9]: "Spiritual and idealistic connection.",
      [8, 8]: "Powerful and goal-driven team.",
      [8, 9]: "Ambitious meets humanitarian: a dynamic pairing.",
      [9, 9]: "Deeply empathetic and focused on the greater good."
    };

    for (var pair in compatibilityChart.keys) {
      if ((pair[0] == lp1 && pair[1] == lp2) ||
          (pair[0] == lp2 && pair[1] == lp1)) {
        return compatibilityChart[pair]!;
      }
    }

    return "Average compatibility. Consider other aspects of the relationship.";
  }
}
