import 'package:flutter/material.dart';
import 'package:aws_restart_tracker/models/module.dart';
import 'package:aws_restart_tracker/services/progress_service.dart';

class ModulesScreen extends StatefulWidget {
  final String category;
  final List<Module> modules;
  final Map<int, bool> progress;

  const ModulesScreen({
    super.key,
    required this.category,
    required this.modules,
    required this.progress,
  });

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  late Map<int, bool> progress;

  @override
  void initState() {
    super.initState();
    progress = Map.from(widget.progress);
  }

  Future<void> _toggleModule(int moduleId, bool completed) async {
    setState(() {
      progress[moduleId] = completed;
    });
    await ProgressService.toggleModuleProgress(moduleId, completed);
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = progress.values.where((c) => c).length;
    final totalCount = widget.modules.length;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.category),
            Text(
              '$completedCount/$totalCount',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: widget.modules.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final module = widget.modules[index];
          final isCompleted = progress[module.id] ?? false;

          return _buildModuleTile(module, isCompleted);
        },
      ),
    );
  }

  Widget _buildModuleTile(Module module, bool isCompleted) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green.withOpacity(0.1)
                : Colors.grey.shade100,
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted ? Colors.green : Colors.transparent,
              width: 2,
            ),
          ),
          child: Icon(
            isCompleted ? Icons.check_rounded : Icons.radio_button_on_rounded,
            color: isCompleted ? Colors.green : Colors.grey.shade400,
            size: 20,
          ),
        ),
        title: Text(
          module.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? Colors.grey.shade600 : null,
          ),
        ),
        subtitle: module.subtitle != null ? Text(module.subtitle!) : null,
        trailing: _buildModuleTypeBadge(module),
        onTap: () => _toggleModule(module.id, !isCompleted),
      ),
    );
  }

  Widget _buildModuleTypeBadge(Module module) {
    if (module.isLab) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'LAB',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else if (module.isKC) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'KC',
          style: TextStyle(
            color: Colors.green,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
