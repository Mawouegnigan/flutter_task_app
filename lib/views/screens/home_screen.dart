import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_task_app/models/task_api_model.dart';
import 'package:flutter_task_app/providers/app_settings_provider.dart';
import 'package:flutter_task_app/providers/category_provider.dart';
import 'package:flutter_task_app/services/task_service.dart';
import 'package:flutter_task_app/utils/translations.dart';
import 'package:flutter_task_app/utils/constants.dart';
import 'package:flutter_task_app/views/screens/add_editing_task_screen.dart';
import 'package:flutter_task_app/views/screens/profile_screen.dart';
import 'package:flutter_task_app/views/screens/calendar_screen.dart';
import 'package:flutter_task_app/services/notification_service.dart';
import 'package:flutter_task_app/views/screens/task_detail_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_task_app/services/cache_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Codes internes stables (ne dépendent pas de la langue) pour les 3 filtres
  // système. Les catégories personnalisées, elles, restent identifiées par
  // leur propre nom (données utilisateur, non traduites).
  static const String _filterAll = 'all';
  static const String _filterInProgress = 'in_progress';
  static const String _filterDone = 'done';

  List<TaskApiModel> _tasks = [];
  List<TaskApiModel> _filteredTasks = [];
  bool _isLoading = true;
  bool _isOffline = false;
  String _selectedFilter = _filterAll;
  String _searchQuery = '';
  String _sortBy = 'none';
  final TextEditingController _searchController = TextEditingController();
  final List<String> _filters = [_filterAll, _filterInProgress, _filterDone];

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
    // Vérifier d'abord le mode offline manuel
    final isManualOffline = context.read<AppSettingsProvider>().isManualOffline;

    final connectivityResult = await Connectivity().checkConnectivity();
    final hasNetwork = connectivityResult != ConnectivityResult.none;

    if (!hasNetwork || isManualOffline) {
      final cached = CacheService.getCachedTasks();
      if (mounted) {
        setState(() {
          _tasks = cached;
          _isLoading = false;
          _isOffline = true;
        });
        _applyFilters();
      }
      return;
    }

    try {
      final tasks = await TaskService.getTasks();
      await CacheService.cacheTasks(tasks);
      if (mounted) {
        setState(() {
          _tasks = tasks;
          _isLoading = false;
          _isOffline = false;
        });
        _applyFilters();
      }
    } catch (e) {
      final cached = CacheService.getCachedTasks();
      if (mounted) {
        setState(() {
          _tasks = cached;
          _isLoading = false;
          _isOffline = true;
        });
        _applyFilters();
        
      }
    }
  }

  void _applyFilters() {
    List<TaskApiModel> result = List.from(_tasks);

    if (_selectedFilter == _filterInProgress) {
      result = result.where((t) => t.color != '#9E9E9E').toList();
    } else if (_selectedFilter == _filterDone) {
      result = result.where((t) => t.color == '#9E9E9E').toList();
    } else if (_selectedFilter != _filterAll) {
      // Filtre par catégorie
      result = result
          .where((t) =>
              t.category != null &&
              t.category!.toLowerCase() ==
                  _selectedFilter.toLowerCase())
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      result = result
          .where((t) =>
              t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              t.content.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_sortBy == 'priority_asc') {
      result.sort((a, b) =>
          _priorityOrder(a.priority).compareTo(_priorityOrder(b.priority)));
    } else if (_sortBy == 'priority_desc') {
      result.sort((a, b) =>
          _priorityOrder(b.priority).compareTo(_priorityOrder(a.priority)));
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
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
        return 1;
      default:
        return 0;
    }
  }

  Future<void> _deleteTask(int id) async {
    try {
      await TaskService.deleteTask(id);
      await _loadTasks();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('home_delete_success'.tr(context))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('home_delete_error2'.tr(context))),
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
        category: task.category,
      );

      await TaskService.updateTask(task.id!, updatedTask);
      await _loadTasks();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('home_update_error2'.tr(context))),
        );
      }
    }
  }

  Future<void> _confirmDelete(TaskApiModel task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('home_delete_dialog_title'.tr(context)),
        content: Text('home_delete_dialog_body'.tr(context, title: task.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('cancel'.tr(context)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'delete'.tr(context),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirm == true) _deleteTask(task.id!);
  }

  void _showSortMenu() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
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
            Text('home_sort_title'.tr(context),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _sortOption('home_sort_priority_asc'.tr(context), 'priority_asc', Icons.arrow_upward),
            _sortOption('home_sort_priority_desc'.tr(context), 'priority_desc', Icons.arrow_downward),
            _sortOption('home_sort_date_asc'.tr(context), 'date_asc', Icons.calendar_today),
            _sortOption('home_sort_date_desc'.tr(context), 'date_desc',
                Icons.calendar_today_outlined),
            _sortOption('home_sort_none'.tr(context), 'none', Icons.clear),
            const SizedBox(height: 8),
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
      shape: const RoundedRectangleBorder(
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
                const Icon(Icons.notifications_outlined,
                    color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'home_notifications_title'.tr(context),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            upcomingTasks.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'home_no_upcoming_tasks'.tr(context),
                        style: const TextStyle(
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
                        leading: const Icon(
                          Icons.access_time_rounded,
                          color: AppColors.priorityHigh,
                        ),
                        title: Text(
                          task.title,
                          style:
                              const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          "${'home_due_prefix'.tr(context)} ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year} ${'task_detail_at'.tr(context)} ${task.dueDate!.hour.toString().padLeft(2, '0')}h${task.dueDate!.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                            color: AppColors.textDarkSecondary,
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _sortOption(String label, String value, IconData icon) {
    return ListTile(
      leading:
          Icon(icon, color: _sortBy == value ? AppColors.primary : null),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('home_add_category'.tr(context)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'home_select_category'.tr(context),
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            ...context.read<CategoryProvider>().categories.map((cat) => ListTile(
                  dense: true,
                  title: Text(cat),
                  leading: const Icon(Icons.label_outline),
                  onTap: () {
                    if (!_filters.contains(cat)) {
                      setState(() => _filters.add(cat));
                    }
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('cancel'.tr(context)),
          ),
        ],
      ),
    );
  }

  String _priorityLabel(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'task_priority_high'.tr(context);
      case 'medium':
        return 'task_priority_medium'.tr(context);
      case 'low':
        return 'task_priority_low'.tr(context);
      default:
        return priority;
    }
  }

  String _filterLabel(String value) {
    switch (value) {
      case _filterAll:
        return 'home_filter_all'.tr(context);
      case _filterInProgress:
        return 'home_filter_in_progress'.tr(context);
      case _filterDone:
        return 'home_filter_done'.tr(context);
      default:
        return categoryLabel(value, context); // Nom de catégorie
    }
  }

  bool _isSystemFilter(String value) =>
      value == _filterAll || value == _filterInProgress || value == _filterDone;

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.priorityHigh;
      case 'medium':
        return AppColors.priorityMedium;
      case 'low':
        return AppColors.priorityLow;
      default:
        return Colors.grey;
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
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ),
        title: Text('home_my_tasks'.tr(context)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarScreen()),
              );
            },
            icon: const Icon(Icons.calendar_today_rounded),
            padding: const EdgeInsets.all(12),
            iconSize: 22,
          ),
          IconButton(
            onPressed: () => _showNotificationsPanel(),
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                if (NotificationService.getUpcomingTasks(_tasks).isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
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
        ],
      ),
      body: Column(
        children: [
          if (_isOffline)
            Container(
              width: double.infinity,
              color: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'home_offline_banner'.tr(context),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                      _applyFilters();
                    },
                    decoration: InputDecoration(
                      hintText: 'home_search_hint2'.tr(context),
                      hintStyle: TextStyle(
                        color: AppColors.textDarkSecondary,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(Icons.search),
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
                IconButton(
                  onPressed: _showSortMenu,
                  icon: const Icon(Icons.sort_rounded),
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
          // Filtres
          SizedBox(
            height: 40,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              children: [
                ..._filters.map(
                  (filterValue) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedFilter == filterValue
                              ? AppColors.primary.withAlpha(20)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedFilter == filterValue
                                ? AppColors.primary
                                : colorScheme.outlineVariant.withAlpha(100),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() => _selectedFilter = filterValue);
                                _applyFilters();
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 12,
                                  right: _isSystemFilter(filterValue)
                                      ? 12
                                      : 4,
                                  top: 6,
                                  bottom: 6,
                                ),
                                child: Text(
                                  _filterLabel(filterValue),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: _selectedFilter == filterValue
                                        ? AppColors.primary
                                        : AppColors.textDarkSecondary,
                                  ),
                                ),
                              ),
                            ),
                            if (!_isSystemFilter(filterValue))
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _filters.remove(filterValue);
                                    if (_selectedFilter == filterValue) {
                                      _selectedFilter = _filterAll;
                                    }
                                    _applyFilters();
                                  });
                                },
                                child: const Padding(
                                  padding:
                                      EdgeInsets.only(right: 8, left: 2),
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
                    child: const Icon(Icons.add_rounded, size: 18),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Compteur
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredTasks.length} ${_filteredTasks.length > 1 ? 'home_task_count_plural'.tr(context) : 'home_task_count_singular'.tr(context)}',
                  style: const TextStyle(
                    color: AppColors.textDarkSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Liste
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredTasks.isEmpty
                    ? Center(
                        child: Text(
                          'home_no_tasks'.tr(context),
                          style: const TextStyle(
                            color: AppColors.textDarkSecondary,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadTasks,
                        child: ListView.builder(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: _filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = _filteredTasks[index];
                            final priorityColor =
                                _priorityColor(task.priority);
                            return Card(
                              elevation: 1,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TaskDetailScreen(task: task),
                                    ),
                                  ).then((_) => _loadTasks());
                                },
                                contentPadding: const EdgeInsets.all(16),
                                leading: GestureDetector(
                                  onTap: () =>
                                      _toggleTaskCompletion(task),
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
                                        ? const Icon(Icons.check,
                                            size: 14,
                                            color: Colors.white)
                                        : null,
                                  ),
                                ),
                                title: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
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
                                            overflow:
                                                TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: priorityColor
                                                .withAlpha(40),
                                            borderRadius:
                                                BorderRadius.circular(12),
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    if (task.category != null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4),
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.label_outline,
                                                size: 13,
                                                color: AppColors.primary),
                                            const SizedBox(width: 4),
                                            Text(
                                              task.category!,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (task.content.isNotEmpty)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4),
                                        child: Text(
                                          task.content,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color:
                                                AppColors.textDarkSecondary,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    if (task.dueDate != null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 6),
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.schedule_rounded,
                                                size: 14,
                                                color: AppColors
                                                    .textDarkSecondary),
                                            const SizedBox(width: 4),
                                            Text(
                                              "${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year} ${task.dueDate!.hour.toString().padLeft(2, '0')}:${task.dueDate!.minute.toString().padLeft(2, '0')}",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors
                                                    .textDarkSecondary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  tooltip: 'home_actions_tooltip'.tr(context),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          const Icon(Icons.edit_outlined,
                                              size: 18),
                                          const SizedBox(width: 8),
                                          Text('home_edit'.tr(context)),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          const Icon(Icons.delete_outline,
                                              size: 18, color: Colors.red),
                                          const SizedBox(width: 8),
                                          Text('home_delete'.tr(context),
                                              style: const TextStyle(
                                                  color: Colors.red)),
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
                                      _confirmDelete(task);
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
              builder: (context) =>
                  const AddEditingTaskScreen(mode: 'Add'),
            ),
          ).then((_) => _loadTasks());
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}