import '../model/habit.dart';

bool isHabitCompletedToday(List<DateTime> completedDay) {
  final today = DateTime.now();
  return completedDay
      .any((date) => date == DateTime(today.year, today.month, today.day));
}

Map<DateTime, int> prepHeatMapDataset (List<Habit> habits){
  Map<DateTime, int> dataset = {};

  for (var habit in habits){
    for (var date in habit.completedDays){
      final normalizedDate = date;

      if (dataset.containsKey(normalizedDate)){
        dataset[normalizedDate] = dataset[normalizedDate]! + 1;
      }else{
        dataset[normalizedDate] = 1;
      }
    }
  }
  return dataset;
}
