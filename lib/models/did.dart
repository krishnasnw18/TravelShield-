class DigitalID {
  final String id;
  final String name;
  final String nationality;
  final String passportNumber;
  final DateTime tripStartDate;
  final DateTime tripEndDate;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String issueDate;
  final String qrCodeData;

  DigitalID({
    required this.id,
    required this.name,
    required this.nationality,
    required this.passportNumber,
    required this.tripStartDate,
    required this.tripEndDate,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.issueDate,
    required this.qrCodeData,
  });

  String get tripDuration {
    final days = tripEndDate.difference(tripStartDate).inDays;
    return '$days days';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'nationality': nationality,
    'passportNumber': passportNumber,
    'tripStartDate': tripStartDate.toIso8601String(),
    'tripEndDate': tripEndDate.toIso8601String(),
    'emergencyContactName': emergencyContactName,
    'emergencyContactPhone': emergencyContactPhone,
    'issueDate': issueDate,
    'qrCodeData': qrCodeData,
  };

  factory DigitalID.fromJson(Map<String, dynamic> json) => DigitalID(
    id: json['id'],
    name: json['name'],
    nationality: json['nationality'],
    passportNumber: json['passportNumber'],
    tripStartDate: DateTime.parse(json['tripStartDate']),
    tripEndDate: DateTime.parse(json['tripEndDate']),
    emergencyContactName: json['emergencyContactName'],
    emergencyContactPhone: json['emergencyContactPhone'],
    issueDate: json['issueDate'],
    qrCodeData: json['qrCodeData'],
  );
}

class TravelDocument {
  final String id;
  final String type;
  final String name;
  final String number;
  final DateTime expiryDate;
  final String status;
  final String country;

  TravelDocument({
    required this.id,
    required this.type,
    required this.name,
    required this.number,
    required this.expiryDate,
    required this.status,
    required this.country,
  });

  bool get isExpired => DateTime.now().isAfter(expiryDate);
  bool get isExpiringSoon => expiryDate.difference(DateTime.now()).inDays < 30;

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'name': name,
    'number': number,
    'expiryDate': expiryDate.toIso8601String(),
    'status': status,
    'country': country,
  };

  factory TravelDocument.fromJson(Map<String, dynamic> json) => TravelDocument(
    id: json['id'],
    type: json['type'],
    name: json['name'],
    number: json['number'],
    expiryDate: DateTime.parse(json['expiryDate']),
    status: json['status'],
    country: json['country'],
  );
}