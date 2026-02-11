class ListItemModel {
  final String name;
  final String? location;
  final String? startDate;
  final String? endDate;

  const ListItemModel({
    required this.name,
    this.location,
    this.startDate,
    this.endDate,
  });

  factory ListItemModel.fromJson(Map<String, dynamic> map) {
    return ListItemModel(
      name: map['name'] ?? '',
      location: map['location'],
      startDate: map['startDate'],
      endDate: map['endDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (location != null) 'location': location,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
    };
  }

  bool get isEmpty => name.isEmpty;

  String get dateRange {
    if (startDate == null && endDate == null) return '';
    if (startDate != null && endDate != null) {
      return '$startDate - $endDate';
    }
    return startDate ?? endDate ?? '';
  }
}
