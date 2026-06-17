import 'package:flutter/material.dart';
import 'package:flutter_task_app/models/task_api_model.dart';
import 'package:flutter_task_app/services/task_service.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/screens/add_editing_task_screen.dart';
import 'package:flutter_task_app/views/screens/profile_screen.dart';
import 'package:flutter_task_app/views/screens/calendar_screen.dart';
import 'package:flutter_task_app/services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TaskApiModel> _tasks = [];
  List<TaskApiModel> _filteredTasks = [];
  bool _isLoading = true;
  String _selectedFilter = 'Toutes les tâches';
  String _searchQuery = '';
  String _sortBy = 'none';
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = ['Toutes les tâches', 'En cours', 'Terminées'];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await TaskService.getTasks();
      if (mounted) {
        setState(() {
          _tasks = tasks;
          _isLoading = false;
        });
        _applyFilters();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de chargement des tâches')),
        );
      }
    }
  }

  void _applyFilters() {
    List<TaskApiModel> result = List.from(_tasks);

    if (_selectedFilter == 'En cours') {
      result = result.where((t) => t.color != '#9E9E9E').toList();
    } else if (_selectedFilter == 'Terminées') {
      result = result.where((t) => t.color == '#9E9E9E').toList();
    }

    if (_searchQuery.isNotEmpty) {
      result = result.where((t) =>
        t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        t.content.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    if (_sortBy == 'priority_asc') {
      result.sort((a, b) => _priorityOrder(a.priority).compareTo(_priorityOrder(b.priority)));
    } else if (_sortBy == 'priority_desc') {
      result.sort((a, b) => _priorityOrder(b.priority).compareTo(_priorityOrder(a.priority)));
    } else if (_sortBy == 'date_asc') {
      result.sort((a, b) {
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });
    } else if (_sortBy == 'date_desc') {
      result.sort((a, b) {
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return b.dueDate!.compareTo(a.dueDate!);
      });
    }

    setState(() => _filteredTasks = result);
  }

  int _priorityOrder(String priority) {
    switch (priority.toLowerCase()) {
      case 'high': return 3;
      case 'medium': return 2;
      case 'low': return 1;
      default: return 0;
    }
  }

  Future<void> _deleteTask(int id) async {
    try {
      await TaskService.deleteTask(id);
      await _loadTasks();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tâche supprimée avec succès')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la suppression')),
        );
      }
    }
  }
  Future<void> _toggleTaskCompletion(TaskApiModel task) async {
  try {
    final isCompleted = task.color == '#9E9E9E';
    final newColor = isCompleted
        ? (task.priority.toLowerCase() == 'high'
            ? '#F44336'
            : task.priority.toLowerCase() == 'medium'
                ? '#FF9800'
                : '#4CAF50')
        : '#9E9E9E';

    final updatedTask = TaskApiModel(
      title: task.title,
      content: task.content,
      priority: task.priority,
      color: newColor,
      dueDate: task.dueDate,
    );

    await TaskService.updateTask(task.id!, updatedTask);
    await _loadTasks();
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la mise à jour')),
      );
    }
  }
}
  void _showSortMenu() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trier par',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          _sortOption('Priorité croissante', 'priority_asc', Icons.arrow_upward),
          _sortOption('Priorité décroissante', 'priority_desc', Icons.arrow_downward),
          _sortOption('Date croissante', 'date_asc', Icons.calendar_today),
          _sortOption('Date décroissante', 'date_desc', Icons.calendar_today_outlined),
          _sortOption('Aucun tri', 'none', Icons.clear),
          SizedBox(height: 8),
        ],
      ),
    ),
  );
}
void _showNotificationsPanel() {
  final upcomingTasks = NotificationService.getUpcomingTasks(_tasks);
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_outlined, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          upcomingTasks.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Aucune tâche dans les prochaines 24h',
                      style: TextStyle(
                        color: AppColors.textDarkSecondary,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: upcomingTasks.length,
                  itemBuilder: (context, index) {
                    final task = upcomingTasks[index];
                    return ListTile(
                      leading: Icon(
                        Icons.access_time_rounded,
                        color: AppColors.priorityHigh,
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        "Échéance : ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year} à ${task.dueDate!.hour.toString().padLeft(2, '0')}h${task.dueDate!.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          color: AppColors.textDarkSecondary,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
          SizedBox(height: 8),
        ],
      ),
    ),
  );
}
  Widget _sortOption(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: _sortBy == value ? AppColors.primary : null),
      title: Text(label),
      selected: _sortBy == value,
      selectedColor: AppColors.primary,
      onTap: () {
        setState(() => _sortBy = value);
        _applyFilters();
        Navigator.pop(context);
      },
    );
  }

  void _showAddFilterDialog() {
    final TextEditingController filterController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter un filtre'),
        content: TextField(
          controller: filterController,
          decoration: InputDecoration(
            hintText: 'Nom du filtre',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              final label = filterController.text.trim();
              if (label.isNotEmpty && !_filters.contains(label)) {
                setState(() => _filters.add(label));
              }
              Navigator.pop(context);
            },
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  String _priorityLabel(String priority) {
  switch (priority.toLowerCase()) {
    case 'high': return 'Haute';
    case 'medium': return 'Moyenne';
    case 'low': return 'Basse';
    default: return priority;
  }
}

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high': return AppColors.priorityHigh;
      case 'medium': return AppColors.priorityMedium;
      case 'low': return AppColors.priorityLow;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ),
        title: const Text("Mes tâches"),
        centerTitle: true,
        actions: [
          // Calendrier
          // Calendrier
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalendarScreen(),
                  ),
                );
              },
              icon: Icon(Icons.calendar_today_rounded),
              padding: const EdgeInsets.all(12),
              iconSize: 22,
            ),
         // Notifications
          IconButton(
            onPressed: () => _showNotificationsPanel(),
            icon: Stack(
              children: [
                Icon(Icons.notifications_outlined),
                if (NotificationService.getUpcomingTasks(_tasks).isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            iconSize: 28,
          ),
       ]
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                // Champ de recherche
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                      _applyFilters();
                    },
                    decoration: InputDecoration(
                      hintText: "Rechercher une tâche, un projet...",
                      hintStyle: TextStyle(
                        color: AppColors.textDarkSecondary,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                                _applyFilters();
                              },
                            )
                          : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: colorScheme.outlineVariant.withAlpha(50),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: colorScheme.outlineVariant.withAlpha(50),
                          width: 1.5,
                        ),
                      ),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Bouton tri
                IconButton(
                  onPressed: _showSortMenu,
                  icon: Icon(Icons.sort_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.outlineVariant.withAlpha(30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Section filtres
          SizedBox(
            height: 40,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              children: [
                ..._filters.map(
                      (label) => Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _selectedFilter == label
                                  ? AppColors.primary.withAlpha(20)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _selectedFilter == label
                                    ? AppColors.primary
                                    : colorScheme.outlineVariant.withAlpha(100),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() => _selectedFilter = label);
                                    _applyFilters();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 12,
                                      right: label != 'Toutes les tâches' &&
                                              label != 'En cours' &&
                                              label != 'Terminées'
                                          ? 4
                                          : 12,
                                      top: 6,
                                      bottom: 6,
                                    ),
                                    child: Text(
                                      label,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: _selectedFilter == label
                                            ? AppColors.primary
                                            : AppColors.textDarkSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                                if (label != 'Toutes les tâches' &&
                                    label != 'En cours' &&
                                    label != 'Terminées')
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _filters.remove(label);
                                        if (_selectedFilter == label) {
                                          _selectedFilter = 'Toutes les tâches';
                                        }
                                        _applyFilters();
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8, left: 2),
                                      child: Icon(
                                        Icons.close_rounded,
                                        size: 14,
                                        color: AppColors.textDarkSecondary,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                // Bouton + pour ajouter un filtre
                GestureDetector(
                  onTap: _showAddFilterDialog,
                  child: Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.outlineVariant.withAlpha(50),
                        width: 1,
                      ),
                    ),
                    child: Icon(Icons.add_rounded, size: 18),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6),

          // Compteur de tâches
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredTasks.length} tâche${_filteredTasks.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    color: AppColors.textDarkSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6),

          // Liste des tâches
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredTasks.isEmpty
                    ? Center(
                        child: Text(
                          'Aucune tâche pour le moment',
                          style: TextStyle(
                            color: AppColors.textDarkSecondary,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadTasks,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: _filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = _filteredTasks[index];
                            final priorityColor = _priorityColor(task.priority);
                            return Card(
                              elevation: 1,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: GestureDetector(
                                    onTap: () => _toggleTaskCompletion(task),
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: task.color == '#9E9E9E'
                                            ? AppColors.primary
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: task.color == '#9E9E9E'
                                              ? AppColors.primary
                                              : Colors.grey.shade400,
                                          width: 2,
                                        ),
                                      ),
                                      child: task.color == '#9E9E9E'
                                          ? Icon(Icons.check, size: 14, color: Colors.white)
                                          : null,
                                    ),
                                  ),
                                  title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            task.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: priorityColor.withAlpha(40),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                             _priorityLabel(task.priority),
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: priorityColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (task.content.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          task.content,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.textDarkSecondary,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    if (task.dueDate != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Row(
                                          children: [
                                            Icon(Icons.schedule_rounded,
                                                size: 14,
                                                color: AppColors.textDarkSecondary),
                                            SizedBox(width: 4),
                                            Text(
                                              "${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year} ${task.dueDate!.hour.toString().padLeft(2, '0')}:${task.dueDate!.minute.toString().padLeft(2, '0')}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textDarkSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit_outlined, size: 18),
                                          SizedBox(width: 8),
                                          Text('Modifier'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete_outline,
                                              size: 18, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('Supprimer',
                                              style: TextStyle(color: Colors.red)),
                                        ],
                                      ),
                                    ),
                                  ],
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddEditingTaskScreen(
                                            mode: 'Edit',
                                            task: task,
                                          ),
                                        ),
                                      ).then((_) => _loadTasks());
                                    } else if (value == 'delete') {
                                      _deleteTask(task.id!);
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                          
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditingTaskScreen(mode: 'Add'),
            ),
          ).then((_) => _loadTasks());
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
