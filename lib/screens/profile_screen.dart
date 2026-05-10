import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/service_locator.dart';
import '../features/employee_details/presentation/profile/profile_details_bloc.dart';
import '../features/employee_details/presentation/profile/profile_details_event.dart';
import '../features/employee_details/presentation/profile/profile_details_state.dart';
import '../user_panel/user_panel_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String screenRoute = 'profile_screen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileDetailsBloc _bloc;
  late String username;
  late String empName;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _bloc = ServiceLocator.createProfileDetailsBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    username = args['username'] as String;
    empName = args['empName'] as String;
    _bloc.add(LoadProfileDetailsEvent(username: username, employeeName: empName));
    _initialized = true;
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<ProfileDetailsBloc, ProfileDetailsState>(
        listener: (context, state) {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          final empData = state.employeeData;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Employee Profile'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: empData == null
                      ? null
                      : () async {
                          final result = await Navigator.pushNamed(
                            context,
                            EditProfileScreen.screenRoute,
                            arguments: {
                              'username': username,
                              'empName': empName,
                              'info': empData['info'] ?? {},
                            },
                          );
                          if (result != null && result is Map<String, dynamic>) {
                            empName = result['newName']?.toString() ?? empName;
                            _bloc.add(
                              LoadProfileDetailsEvent(username: username, employeeName: empName),
                            );
                          }
                        },
                ),
                IconButton(
                  icon: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue.shade400,
                    child: Text(
                      username.isNotEmpty ? username[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (context, animation, secondaryAnimation) => UserPanelScreen(
                          userName: username,
                          userEmail: FirebaseAuth.instance.currentUser?.email,
                        ),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          final tween =
                              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          return SlideTransition(position: animation.drive(tween), child: child);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : empData == null
                    ? const Center(child: Text('No data found for this employee.'))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildProfileDetails(empData),
                      ),
          );
        },
      ),
    );
  }

  Widget _buildProfileDetails(Map<String, dynamic> data) {
    final infoRaw = data['info'];
    final info = (infoRaw as Map?)?.cast<String, dynamic>() ?? {};

    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: info['photo_url'] != null && info['photo_url'].toString().isNotEmpty
              ? NetworkImage(info['photo_url'])
              : null,
          child: (info['photo_url'] == null || info['photo_url'].toString().isEmpty)
              ? const Icon(Icons.person, size: 60)
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          empName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        _buildInfoCard(Icons.phone, 'Phone', info['phone']?.toString() ?? 'N/A'),
        _buildInfoCard(Icons.home, 'Address', info['address']?.toString() ?? 'N/A'),
        _buildInfoCard(Icons.monetization_on, 'Salary', info['salary']?.toString() ?? 'N/A'),
        _buildInfoCard(
          Icons.access_time,
          'Working Hours',
          info['working_hours']?.toString() ?? 'N/A',
        ),
        _buildInfoCard(Icons.badge, 'Position', info['position']?.toString() ?? 'N/A'),
        _buildInfoCard(Icons.location_on, 'In Location', info['loccam']?.toString() ?? 'N/A'),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }
}
