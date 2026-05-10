import 'package:firebase_database/firebase_database.dart';

abstract class EmployeeDetailsRemoteDataSource {
  Future<Map<String, dynamic>> getEmployeeData({
    required String username,
    required String employeeName,
  });
}

class EmployeeDetailsRemoteDataSourceImpl implements EmployeeDetailsRemoteDataSource {
  final FirebaseDatabase _database;

  EmployeeDetailsRemoteDataSourceImpl(this._database);

  @override
  Future<Map<String, dynamic>> getEmployeeData({
    required String username,
    required String employeeName,
  }) async {
    final snapshot = await _database.ref('$username/employees/$employeeName').get();
    if (!snapshot.exists || snapshot.value == null) {
      throw Exception('Employee data not found.');
    }
    return Map<String, dynamic>.from(snapshot.value as Map);
  }
}
