import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en'; // 'en' or 'as'

  String get currentLanguage => _currentLanguage;

  bool get isEnglish => _currentLanguage == 'en';
  bool get isAssamese => _currentLanguage == 'as';

  void toggleLanguage() {
    _currentLanguage = _currentLanguage == 'en' ? 'as' : 'en';
    notifyListeners();
  }

  void setLanguage(String lang) {
    if (lang == 'en' || lang == 'as') {
      _currentLanguage = lang;
      notifyListeners();
    }
  }

  // Search Screen Translations
  String get searchJobCard => _currentLanguage == 'en' ? 'Search Job Card' : 'জব কাৰ্ড অনুসন্ধান কৰক';
  String get enterJobCardNumber => _currentLanguage == 'en' 
      ? 'Enter a Job Card number below to view details.' 
      : 'বিৱৰণ চাবলৈ তলত জব কাৰ্ড নম্বৰ দিয়ক।';
  String get enterJobCardPlaceholder => _currentLanguage == 'en' ? 'Enter Job Card Number' : 'জব কাৰ্ড নম্বৰ দিয়ক';
  String get search => _currentLanguage == 'en' ? 'Search' : 'অনুসন্ধান';
  String get noDetailsYet => _currentLanguage == 'en' ? 'No details to show yet.' : 'এতিয়াও কোনো বিৱৰণ নাই।';
  String get pleaseEnterJobCard => _currentLanguage == 'en' ? 'Please enter a Job Card number.' : 'অনুগ্ৰহ কৰি জব কাৰ্ড নম্বৰ দিয়ক।';
  String get noDetailsFound => _currentLanguage == 'en' ? 'No details found. Please check the Job Card number.' : 'কোনো বিৱৰণ পোৱা নগ\'ল। অনুগ্ৰহ কৰি জব কাৰ্ড নম্বৰ পৰীক্ষা কৰক।';
  String get errorFetching => _currentLanguage == 'en' ? 'Error: Unable to fetch details. Please try again.' : 'ত্ৰুটি: বিৱৰণ আনিব পৰা নগ\'ল। অনুগ্ৰহ কৰি পুনৰ চেষ্টা কৰক।';

  // Job Card Details Translations
  String get mgnregaJobCard => _currentLanguage == 'en' ? 'MGNREGA JOB CARD' : 'মনৰেগা জব কাৰ্ড';
  String get familyMembers => _currentLanguage == 'en' ? 'Family Members' : 'পৰিয়ালৰ সদস্য';
  String get totalWorkDays => _currentLanguage == 'en' ? 'Total Work Days' : 'মুঠ কামৰ দিন';
  String get totalWagesPaid => _currentLanguage == 'en' ? 'Total Wages Paid' : 'মুঠ মজুৰি পৰিশোধ';
  
  // Menu Items
  String get basicDetails => _currentLanguage == 'en' ? 'Basic Details' : 'মৌলিক বিৱৰণ';
  String get familyMembersMenu => _currentLanguage == 'en' ? 'Family Members' : 'পৰিয়ালৰ সদস্য';
  String get employment => _currentLanguage == 'en' ? 'Employment' : 'নিয়োজন';
  String get attendance => _currentLanguage == 'en' ? 'Attendance' : 'উপস্থিতি';
  String get bankDetails => _currentLanguage == 'en' ? 'Bank Details' : 'বেংক বিৱৰণ';

  // Basic Details Fields
  String get jobCardNo => _currentLanguage == 'en' ? 'Job Card No.' : 'জব কাৰ্ড নং';
  String get headOfFamily => _currentLanguage == 'en' ? 'Head of Family' : 'পৰিয়ালৰ মুৰব্বী';
  String get familyId => _currentLanguage == 'en' ? 'Family ID' : 'পৰিয়াল আইডি';
  String get issueDate => _currentLanguage == 'en' ? 'Issue Date' : 'জাৰি কৰাৰ তাৰিখ';
  String get pmayBeneficiary => _currentLanguage == 'en' ? 'PMAY-G/IAY Beneficiary' : 'PMAY-G/IAY হিতাধিকাৰী';
  String get fraBeneficiary => _currentLanguage == 'en' ? 'FRA Beneficiary' : 'FRA হিতাধিকাৰী';
  String get jobCardActive => _currentLanguage == 'en' ? 'Job Card Active' : 'জব কাৰ্ড সক্ৰিয়';
  String get category => _currentLanguage == 'en' ? 'Category' : 'শ্ৰেণী';
  String get address => _currentLanguage == 'en' ? 'Address' : 'ঠিকনা';
  String get district => _currentLanguage == 'en' ? 'District' : 'জিলা';
  String get state => _currentLanguage == 'en' ? 'State' : 'ৰাজ্য';
  String get yes => _currentLanguage == 'en' ? 'Yes' : 'হয়';
  String get no => _currentLanguage == 'en' ? 'No' : 'নহয়';

  // Work Record
  String get workRecord => _currentLanguage == 'en' ? 'Work Record' : 'কামৰ ৰেকৰ্ড';
  String get date => _currentLanguage == 'en' ? 'Date' : 'তাৰিখ';
  String get days => _currentLanguage == 'en' ? 'Days' : 'দিন';
  String get work => _currentLanguage == 'en' ? 'Work' : 'কাম';

  // Bank Details
  String get bankName => _currentLanguage == 'en' ? 'Bank Name' : 'বেংকৰ নাম';
  String get branchName => _currentLanguage == 'en' ? 'Branch Name' : 'শাখাৰ নাম';
  String get ifscCode => _currentLanguage == 'en' ? 'IFSC Code' : 'IFSC কোড';
  String get accountNo => _currentLanguage == 'en' ? 'Account No.' : 'একাউণ্ট নং';
  String get activeLinked => _currentLanguage == 'en' ? 'Active & Linked' : 'সক্ৰিয় আৰু সংযুক্ত';

  // Attendance
  String get presentWorkDone => _currentLanguage == 'en' ? 'Present / Work Done' : 'উপস্থিত / কাম সম্পন্ন';

  // Navigation
  String get home => _currentLanguage == 'en' ? 'Home' : 'হোম';
  String get searchNav => _currentLanguage == 'en' ? 'Search' : 'অনুসন্ধান';
}
