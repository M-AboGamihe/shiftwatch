import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/service_locator.dart';
import '../features/employees/domain/entities/employee_summary_entity.dart';
import '../features/employees/presentation/bloc/employees_bloc.dart';
import '../features/employees/presentation/bloc/employees_event.dart';
import '../features/employees/presentation/bloc/employees_state.dart';
import '../models/app_notification.dart';
import '../user_panel/user_panel_screen.dart';
import 'choose_location_screen.dart';
import 'dashboard_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

class EmployeeScreen extends StatefulWidget {
  static const String screenRoute = 'employee_screen';
  final List<AppNotification> allNotes;

  const EmployeeScreen({super.key, required this.allNotes});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  late final EmployeesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ServiceLocator.createEmployeesBloc()..add(LoadEmployeesEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _onMenuSelected(String choice, String empName, String? username) {
    switch (choice) {
      case 'Delete':
        _confirmDelete(empName);
        break;
      case 'Dashboard':
        Navigator.pushNamed(
          context,
          DashboardScreen.screenRoute,
          arguments: {'empName': empName, 'username': username},
        );
        break;
      case 'Profile':
        Navigator.pushNamed(
          context,
          ProfileScreen.screenRoute,
          arguments: {'empName': empName, 'username': username},
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$choice clicked for $empName')),
        );
    }
  }

  void _confirmDelete(String empName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete $empName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _bloc.add(DeleteEmployeeEvent(empName));
            },
            child: const Text('OK', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<EmployeesBloc, EmployeesState>(
        listener: (context, state) {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
          if (state.infoMessage != null && state.infoMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.infoMessage!)),
            );
          }
        },
        builder: (context, state) {
          final username = state.username;
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 2,
              titleSpacing: 0,
              title: Row(
                children: [
                  const SizedBox(width: 20),
                  const Icon(Icons.home, color: Colors.black87, size: 32),
                  const SizedBox(width: 12),
                  const Text(
                    'Home',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.restart_alt, size: 28, color: Colors.black87),
                    onPressed: () => context.read<EmployeesBloc>().add(RestartCounterEvent()),
                    tooltip: 'Restart',
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications, size: 28, color: Colors.black87),
                    onPressed: () =>
                        Navigator.pushNamed(context, NotificationScreen.screenRoute),
                    tooltip: 'Show all notes',
                  ),
                  IconButton(
                    icon: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue.shade400,
                      child: Text(
                        username != null && username.isNotEmpty
                            ? username[0].toUpperCase()
                            : '?',
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              UserPanelScreen(
                            userName: username,
                            userEmail: FirebaseAuth.instance.currentUser?.email,
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;
                            final tween =
                                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            final offsetAnimation = animation.drive(tween);
                            return SlideTransition(position: offsetAnimation, child: child);
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.employees.isEmpty
                    ? Center(
                        child: Text(
                          'There are no employees…',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 80),
                            child: ListView.builder(
                              itemCount: state.employees.length,
                              itemBuilder: (context, idx) {
                                final employee = state.employees[idx];
                                return _buildEmployeeCard(employee, username);
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: FloatingActionButton(
                                backgroundColor: Colors.blue[700],
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    ChooseLocationScreen.screenRoute,
                                    arguments: {'userName': username},
                                  );
                                  if (context.mounted) {
                                    context.read<EmployeesBloc>().add(LoadEmployeesEvent());
                                  }
                                },
                                child: const Icon(Icons.add, size: 30),
                              ),
                            ),
                          ),
                        ],
                      ),
          );
        },
      ),
    );
  }

  Widget _buildEmployeeCard(EmployeeSummaryEntity employee, String? username) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      employee.imageUrl,
                      width: 76,
                      height: 76,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(Icons.person, size: 40, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          employee.position,
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          employee.inLocation,
                          style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onSelected: (choice) => _onMenuSelected(choice, employee.name, username),
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'Dashboard',
                        child: ListTile(
                          leading: Icon(Icons.dashboard, color: Colors.blue[700]),
                          title: const Text('Dashboard'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'Profile',
                        child: ListTile(
                          leading: Icon(Icons.person, color: Colors.green[700]),
                          title: const Text('Profile'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'Delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      employee.totalWorkedText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Text('Hours Worked', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
