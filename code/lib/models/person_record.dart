class PersonRecord {
  final String? id;
  final String name;
  final String rollOrEmpId;
  final String department;

  const PersonRecord({
    this.id,
    required this.name,
    required this.rollOrEmpId,
    required this.department,
  });

  Map<String, Object?> toMap() => {
        'name': name,
        'rollOrEmpId': rollOrEmpId,
        'department': department,
      };

  factory PersonRecord.fromMap(String id, Map<String, Object?> map) => PersonRecord(
        id: id,
        name: map['name'] as String? ?? '',
        rollOrEmpId: map['rollOrEmpId'] as String? ?? '',
        department: map['department'] as String? ?? '',
      );
}
