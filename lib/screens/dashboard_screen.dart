import 'package:flutter/material.dart';
import '../main.dart';
import '../models/habit.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Habit> habits = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchHabits();
  }

  Future<void> fetchHabits() async {
    setState(() => loading = true);
    final userId = supabase.auth.currentUser!.id;
    final data = await supabase
        .from('habits')
        .select()
        .eq('user_id', userId)
        .order('created_at');
    setState(() {
      habits = (data as List).map((e) => Habit.fromMap(e)).toList();
      loading = false;
    });
  }

  Future<void> addHabit(String name) async {
    final userId = supabase.auth.currentUser!.id;
    await supabase.from('habits').insert({'user_id': userId, 'name': name});
    fetchHabits();
  }

  Future<void> markDone(Habit habit) async {
    await supabase
        .from('habits')
        .update({'streak': habit.streak + 1}).eq('id', habit.id);
    fetchHabits();
  }

  void showAddDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Habit'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(hintText: 'e.g. Drink Water'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (ctrl.text.trim().isNotEmpty) {
                addHabit(ctrl.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalStreak = habits.fold<int>(0, (sum, h) => sum + h.streak);
    final bestStreak =
        habits.isEmpty ? 0 : habits.map((h) => h.streak).reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => supabase.auth.signOut(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4F46E5),
        onPressed: showAddDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchHabits,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      _statCard('Habits', habits.length.toString()),
                      const SizedBox(width: 10),
                      _statCard('Total Streak', totalStreak.toString()),
                      const SizedBox(width: 10),
                      _statCard('Best Streak', bestStreak.toString()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (habits.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Center(
                        child: Text('No habits yet — tap + to add your first one.',
                            style: TextStyle(color: Color(0xFF64748B))),
                      ),
                    ),
                  ...habits.map((h) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFFFEDD5),
                            child: Icon(Icons.local_fire_department,
                                color: Color(0xFFF97316)),
                          ),
                          title: Text(h.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('Streak: ${h.streak} days'),
                          trailing: FilledButton(
                            style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF4F46E5)),
                            onPressed: () => markDone(h),
                            child: const Text('Done Today'),
                          ),
                        ),
                      )),
                ],
              ),
            ),
    );
  }

  Widget _statCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)
          ],
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4F46E5))),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }
}
