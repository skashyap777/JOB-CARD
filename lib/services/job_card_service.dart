
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class JobCardService {
  static const String _searchUrl = 'https://smartjobcard.assam.gov.in/api/household/search';
  static const String _detailsUrl = 'https://smartjobcard.assam.gov.in/api/household/qr/job-details';

  /// Searches for a job card by registration number.
  /// Returns a Map containing the API response if successful,
  /// or throws an exception if the request fails.
  static Future<Map<String, dynamic>> searchJobCard(String registrationNumber) async {
    try {
      debugPrint('--- API CALL: searchJobCard ---');
      debugPrint('URL: $_searchUrl');
      debugPrint('BODY: registration_number=$registrationNumber');

      final response = await http.post(
        Uri.parse(_searchUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'registration_number': registrationNumber,
        },
      );

      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data; // Raw JSON response
      } else {
        debugPrint('ERROR: Server error ${response.statusCode}');
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ERROR: Network error $e');
      throw Exception('Network error: $e');
    }
  }

  /// Fetches detailed job card information using encrypted registration number.
  static Future<Map<String, dynamic>> getJobCardDetails(String encryptedRegNo) async {
    try {
      debugPrint('--- API CALL: getJobCardDetails ---');
      debugPrint('URL: $_detailsUrl');
      debugPrint('BODY: encrypted_registration_number=$encryptedRegNo');

      final response = await http.post(
        Uri.parse(_detailsUrl),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'encrypted_registration_number': encryptedRegNo,
        },
      );

      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('RESPONSE: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        debugPrint('ERROR: Server error ${response.statusCode}');
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ERROR: Network error $e');
      throw Exception('Network error: $e');
    }
  }
}
