import 'package:isar/isar.dart';


part 'habit.g.dart';

@Collection()
class Habit{
  Id id = Isar.autoIncrement;

  late String name;

  List<DateTime> completedDays = [
    // DateTime (yil, oy, kun)
    // DateTime (2024, 01, 01)
    // DateTime (2024, 08, 21)

  ];


}