import 'package:equatable/equatable.dart';

class EmployeeSummaryEntity extends Equatable {
  final String name;
  final String position;
  final String inLocation;
  final String totalWorkedText;
  final String imageUrl;

  const EmployeeSummaryEntity({
    required this.name,
    required this.position,
    required this.inLocation,
    required this.totalWorkedText,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [name, position, inLocation, totalWorkedText, imageUrl];
}
