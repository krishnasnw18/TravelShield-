import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wayfinder_bloom/models/did.dart';

class DIDService {
  static const _storage = FlutterSecureStorage();
  static const String _didKey = 'digital_id';
  static const String _documentsKey = 'travel_documents';

  Future<DigitalID> getDigitalID() async {
    try {
      final didData = await _storage.read(key: _didKey);
      if (didData != null) {
        return DigitalID.fromJson(jsonDecode(didData));
      }
    } catch (e) {
      // Handle error
    }
    
    // Return demo digital ID if none exists
    return _createDemoDigitalID();
  }

  Future<void> storeDigitalID(DigitalID digitalID) async {
    await _storage.write(key: _didKey, value: jsonEncode(digitalID.toJson()));
  }

  Future<List<TravelDocument>> getTravelDocuments() async {
    try {
      final documentsData = await _storage.read(key: _documentsKey);
      if (documentsData != null) {
        final List<dynamic> jsonList = jsonDecode(documentsData);
        return jsonList.map((json) => TravelDocument.fromJson(json)).toList();
      }
    } catch (e) {
      // Handle error
    }
    
    // Return demo documents if none exist
    return _createDemoDocuments();
  }

  Future<void> storeTravelDocuments(List<TravelDocument> documents) async {
    final jsonList = documents.map((doc) => doc.toJson()).toList();
    await _storage.write(key: _documentsKey, value: jsonEncode(jsonList));
  }

  DigitalID _createDemoDigitalID() {
    return DigitalID(
      id: 'DID-001-2024',
      name: 'John Smith',
      nationality: 'United States',
      passportNumber: 'US123456789',
      tripStartDate: DateTime.now().subtract(const Duration(days: 5)),
      tripEndDate: DateTime.now().add(const Duration(days: 10)),
      emergencyContactName: 'Jane Smith',
      emergencyContactPhone: '+1-555-0123',
      issueDate: DateTime.now().subtract(const Duration(days: 7)).toString().split(' ')[0],
      qrCodeData: 'WAYFINDER-BLOOM-DID-001-2024',
    );
  }

  List<TravelDocument> _createDemoDocuments() {
    return [
      TravelDocument(
        id: 'doc-1',
        type: 'Passport',
        name: 'US Passport',
        number: 'US123456789',
        expiryDate: DateTime.now().add(const Duration(days: 365 * 2)),
        status: 'Verified',
        country: 'United States',
      ),
      TravelDocument(
        id: 'doc-2',
        type: 'Visa',
        name: 'India Tourist Visa',
        number: 'IN987654321',
        expiryDate: DateTime.now().add(const Duration(days: 180)),
        status: 'Verified',
        country: 'India',
      ),
      TravelDocument(
        id: 'doc-3',
        type: 'Insurance',
        name: 'Travel Insurance',
        number: 'TI555123789',
        expiryDate: DateTime.now().add(const Duration(days: 30)),
        status: 'Active',
        country: 'Global',
      ),
      TravelDocument(
        id: 'doc-4',
        type: 'Vaccination',
        name: 'Vaccination Certificate',
        number: 'VC444666888',
        expiryDate: DateTime.now().add(const Duration(days: 90)),
        status: 'Pending',
        country: 'WHO',
      ),
    ];
  }
}