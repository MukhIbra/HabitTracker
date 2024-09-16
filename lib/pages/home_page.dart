import 'package:flutter/material.dart';
import 'package:habit_tracker/components/my_drawer.dart';
import 'package:habit_tracker/components/my_heat_map.dart';
import 'package:habit_tracker/database/habit_database.dart';
import 'package:provider/provider.dart';

import '../components/habit_tile.dart';
import '../model/habit.dart';
import '../utils/habit_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  final TextEditingController textController = TextEditingController();

  Future<void> createNewHabit() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextFormField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Create a new habit',
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                  border: const OutlineInputBorder(),
                ),
              ),
              actions: [
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      textController.clear();
                    },
                    child: const Text('Cancel')),
                MaterialButton(
                    onPressed: () {
                      final newHabitName = textController.text;
                      context.read<HabitDatabase>().addHabit(newHabitName);
                      textController.clear();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Create'))
              ],
            ));
  }

  Future<void> editHabit(Habit habit) async {
    textController.text = habit.name;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextFormField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Update a habit',
                ),
              ),
              actions: [
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      textController.clear();
                    },
                    child: const Text('Cancel')),
                MaterialButton(
                    onPressed: () {
                      context
                          .read<HabitDatabase>()
                          .updateHabitName(habit.id, textController.text);
                      textController.clear();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Update'))
              ],
            ));
  }

  Future<void> deleteHabit(int id) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Are you sure you want to delete a habit'),
              actions: [
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
                MaterialButton(
                    onPressed: () {
                      context.read<HabitDatabase>().deleteHabit(id);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Delete'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 5,
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(Icons.add,
            color: Theme.of(context).colorScheme.inversePrimary),
      ),
      body: ListView(
        children: [_buildHeatMap(), _buildHabitList()],
      ),
    );
  }

  Widget _buildHeatMap() {
    final habitDatabase = context.watch<HabitDatabase>();

    final currentHabits = habitDatabase.currentHabits;

    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHeatMap(
              startDate: snapshot.data!,
              datasets: prepHeatMapDataset(currentHabits));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();
    final currentHabits = habitDatabase.currentHabits;
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final habit = currentHabits[index];

        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        return HabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (p0) =>
              habitDatabase.updateHabitCompletion(habit.id, !isCompletedToday),
          editHabit: (p0) => editHabit(habit),
          deleteHabit: (p0) => deleteHabit(habit.id),
        );
      },
    );
  }
}
