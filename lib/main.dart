import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primaryColor: Colors.indigo,
        hintColor: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TaskListScreen(),
    );
  }
}

class Task {
  String title;
  bool isCompleted;
  DateTime creationDate;
  Priority priority;

  Task({
    required this.title,
    this.isCompleted = false,
    required this.creationDate,
    required this.priority,
  });
}

enum Priority { Baixa, Media, Alta }

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Tarefas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddTaskDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Adicionar',
                style: TextStyle(
                  color: Colors.indigo,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade800, Colors.indigo.shade300],
          ),
        ),
        child: TaskList(
          tasks: tasks,
          onTaskToggle: _toggleTask,
          onTaskDelete: _deleteTask,
          onTaskEdit: _editTask,
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    String newTaskTitle = '';
    Priority selectedPriority = Priority.Baixa;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Adicionar Tarefa',
            style: TextStyle(color: Colors.indigo),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newTaskTitle = value;
                },
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Nome da Tarefa',
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 10.0),
              DropdownButtonFormField<Priority>(
                value: selectedPriority,
                onChanged: (Priority? value) {
                  if (value != null) {
                    setState(() {
                      selectedPriority = value;
                    });
                  }
                },
                items: Priority.values.map((Priority priority) {
                  return DropdownMenuItem<Priority>(
                    value: priority,
                    child: Text(
                      priority.toString().split('.').last,
                      style: const TextStyle(color: Colors.indigo),
                    ),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Prioridade',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newTaskTitle.isNotEmpty) {
                  setState(() {
                    tasks.add(Task(
                      title: newTaskTitle,
                      creationDate: DateTime.now(),
                      priority: selectedPriority,
                    ));
                  });
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _toggleTask(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _editTask(int index) {
    _showEditTaskDialog(context, index);
  }

  void _showEditTaskDialog(BuildContext context, int index) {
    String editedTaskTitle = tasks[index].title;
    Priority editedPriority = tasks[index].priority;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Editar Tarefa',
            style: TextStyle(color: Colors.indigo),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  editedTaskTitle = value;
                },
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Nome da Tarefa',
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 10.0),
              DropdownButtonFormField<Priority>(
                value: editedPriority,
                onChanged: (Priority? value) {
                  if (value != null) {
                    setState(() {
                      editedPriority = value;
                    });
                  }
                },
                items: Priority.values.map((Priority priority) {
                  return DropdownMenuItem<Priority>(
                    value: priority,
                    child: Text(
                      priority.toString().split('.').last,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Prioridade',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (editedTaskTitle.isNotEmpty) {
                  setState(() {
                    tasks[index].title = editedTaskTitle;
                    tasks[index].priority = editedPriority;
                  });
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
              ),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }
}

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(int) onTaskToggle;
  final Function(int) onTaskDelete;
  final Function(int) onTaskEdit;

  const TaskList({super.key, 
    required this.tasks,
    required this.onTaskToggle,
    required this.onTaskDelete,
    required this.onTaskEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          color: Colors.white,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tasks[index].title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    decoration: tasks[index].isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  'Criado em: ${_formatDate(tasks[index].creationDate)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  'Prioridade: ${tasks[index].priority.toString().split('.').last}',
                  style: TextStyle(
                    color: _getPriorityColor(tasks[index].priority),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    onTaskEdit(index);
                  },
                  color: Colors.indigo,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    onTaskDelete(index);
                  },
                  color: Colors.indigo,
                ),
              ],
            ),
            leading: Checkbox(
              value: tasks[index].isCompleted,
              onChanged: (value) {
                onTaskToggle(index);
              },
              activeColor: Colors.indigo,
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.Baixa:
        return Colors.green;
      case Priority.Media:
        return Colors.orange;
      case Priority.Alta:
        return Colors.red;
    }
  }
}
