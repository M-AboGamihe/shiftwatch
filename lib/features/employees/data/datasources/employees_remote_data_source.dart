import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/employee_summary_entity.dart';
import '../../domain/repositories/employees_repository.dart';

abstract class EmployeesRemoteDataSource {
  Future<EmployeesHomeEntity> loadHome();
  Future<void> deleteEmployee(String employeeName);
  Future<void> restartCounter();
}

class EmployeesRemoteDataSourceImpl implements EmployeesRemoteDataSource {
  static const String azureBaseUrl = 'https://gp1storage2.blob.core.windows.net';
  static const String sasToken =
      'sv=2024-11-04&ss=bfqt&srt=co&sp=rwdlacupiytfx&se=2025-09-24T05:14:52Z&st=2025-05-15T21:14:52Z&spr=https&sig=MlWw3VH44GSpIHQ45Bw5htIOuaJEaJSw%2Fc%2FgQF9bVJA%3D';

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseDatabase _database;

  EmployeesRemoteDataSourceImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required FirebaseDatabase database,
  })  : _auth = auth,
        _firestore = firestore,
        _database = database;

  @override
  Future<EmployeesHomeEntity> loadHome() async {
    final user = _auth.currentUser;
    final email = user?.email;
    if (email == null || email.isEmpty) {
      throw Exception('User is not authenticated.');
    }

    final qs = await _firestore
        .collection('usersInfo')
        .where('userEmail', isEqualTo: email)
        .limit(1)
        .get();
    if (qs.docs.isEmpty) {
      throw Exception('Username not found.');
    }
    final username = qs.docs.first.get('userName').toString();

    final snapshot = await _database.ref('$username/employees').get();
    final employeesMap = snapshot.exists && snapshot.value is Map
        ? Map<String, dynamic>.from(snapshot.value as Map)
        : <String, dynamic>{};

    final today = DateTime.now();
    final todayKey =
        '${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final employees = employeesMap.entries.map((entry) {
      final empName = entry.key;
      final empMap = Map<String, dynamic>.from(entry.value as Map);
      final info = Map<String, dynamic>.from(empMap['info'] ?? {});
      final todayData =
          (empMap['month'] ?? {})[todayKey] as Map<dynamic, dynamic>?;
      final totalTime = _formatTime(todayData?['total_time'] as List<dynamic>?);
      final imageUrl = '$azureBaseUrl/$username-images/$empName.jpg';

      return EmployeeSummaryEntity(
        name: empName,
        position: (info['position'] ?? '').toString(),
        inLocation: (info['In Location'] ?? '').toString(),
        totalWorkedText: totalTime,
        imageUrl: imageUrl,
      );
    }).toList();

    return EmployeesHomeEntity(username: username, employees: employees);
  }

  @override
  Future<void> deleteEmployee(String employeeName) async {
    final home = await loadHome();
    final username = home.username;

    await _database.ref('$username/employees/$employeeName').remove();
    await _database.ref('$username/last_updated').set(DateTime.now().toIso8601String());

    final encodedEmpName = Uri.encodeComponent(employeeName);
    final deleteUrl = '$azureBaseUrl/$username-images/$encodedEmpName.jpg?$sasToken';
    await http.delete(Uri.parse(deleteUrl));
  }

  @override
  Future<void> restartCounter() async {
    final home = await loadHome();
    final startRef = _database.ref('${home.username}/start');
    final snapshot = await startRef.get();
    var current = 0;
    if (snapshot.exists && snapshot.value != null) {
      current = int.tryParse(snapshot.value.toString()) ?? 0;
    }
    await startRef.set(current + 1);
  }

  String _formatTime(List<dynamic>? t) =>
      (t == null || t.length < 3) ? '0h 0m 0s' : '${t[0]}h ${t[1]}m ${t[2]}s';
}
