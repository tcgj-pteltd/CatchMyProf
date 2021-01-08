import "prof.dart";

class Player {
  static Set<Prof> professors = new Set<Prof>();

  static void addProf(Prof professor) {
    professors.add(professor);
  }

  static List<Prof> getProfessors() {
    return professors.toList();
  }
}