import 'package:flutter/material.dart';
import 'package:nmc_wrapper/repository/language/LanguageProvider.dart';
import 'package:provider/provider.dart';

class AppStrings {
  static Map<String, Map<String, String>> localizedValues = {
    'en': {
      'login': 'Citizen Login',
      'username': 'User Name',
      'password': 'Password',
      'continue': 'Continue',
      'enter_username': 'Please enter username',
      'enter_password': 'Enter 6 digit password',
      'forgot_password': 'Forgot Password?',
      'dont_have_account': 'Don’t have an account? ',
      'register_here': 'Register here',
      'version': 'Version v1.1',
      'copyright':
          '© 2026 Copyright | Nashik Municipal Corporation | Government of Maharashtra | All rights Reserved',
      'back': 'Back',
      'ok': 'OK',
      'cancel': 'Cancel',
      'logout': 'Logout',
      'logout_confirmation':
      'Are you sure you want to logout?',
      'pick_gender': 'Pick Gender',
      'male': 'Male',
      'female': 'Female',
      'other': 'Other',

      'citizen_registration': 'Citizen Registration',
      'full_name': 'Full Name',
      'please_enter_full_name': 'Please enter full name',

      'dob': 'DOB',
      'select_dob': 'Select DOB',

      'mobile': 'Mobile',
      'enter_mobile': 'Please enter 10 digit mobile',
      'mobile_registered': 'Mobile number already registered',


      'password_8': 'Password must be at least 8 characters',

      'confirm_password': 'Confirm Password',
      'confirm_password_enter': 'Please confirm password',
      'password_not_match': 'Passwords do not match',
      'email': 'Email Id',
      'enter_email': 'Please enter email',
      'invalid_email': 'Enter valid email',
      'email_registered': 'Email already registered',
      'gender': 'Gender',
      'select_gender': 'Select Gender',
      'register': 'Register',
      'already_account': 'Already have an account? ',
      'log_in': 'Log In',
      'failed_otp': 'Failed to send OTP',
      'forgot_password_msg':'Forgot Password? Enter registered mobile number',

      'send_otp': 'Send OTP',
      'please_check_mobile': 'Please check your mobile',
      'sent_code_to': "We've sent a code to ",
      'didnt_get_code': "Didn't get a code?",
      'resend_in': 'Resend in',
      'resend_otp': 'Resend OTP',
      'otp_sent_success': 'OTP sent successfully',
       'verify': 'Verify',
      'registration_success': 'Registration Successful',
      'registration_failed': 'Registration failed',
      'invalid_otp': 'Invalid OTP',

      'new_password': 'New Password',
      'enter_new_password': 'Enter new password',

       'confirm_new_password': 'Confirm new password',

       'confirm': 'Confirm',


      'password_reset_success':
      'Password reset successful',

      'hello':'Hello',
      'role':'Role',
      'citizen':'Citizen',

      'all_services':'All Services',
      'civic_services':'Civic Services',
      'connect_now':'Connect Now',

      'profile':'Profile',

      'emergency_use_only':'EMERGENCY USE ONLY',

      'police':'Police',
      'ambulance':'Ambulance',
      'fire_brigade':'Fire Brigade',
      'nmc_call_center':'NMC Call Center',

      'grievance_redressal':'Grievance\nRedressal',
      'marriage_registration':'Marriage\nRegistration',
      'challan_payment':'Challan\nPayment',
      'trade_license':'Trade\nLicense',
      'hoarding_permission':'Hoarding\nPermission',
      'tree_cutting_permission':'Tree Cutting\nPermission',
      'noc_issuance':'NOC\nIssuance',
      'water_connection':'Water &\nSewerage\nConnection',
      'birth_death':'Birth & Death Registration',
      'health_facility':'Health Facility Registration',
      'property_tax':'Property\nTax',

      'coming_soon':'Coming Soon',

      'nmc_help_center':'NMC Help Centre',
      'faq':'FAQ',
      'news':'NMC\nNEWS',
      'know_our_works':'Know our\nWorks',
      'elected_members':'Elected\nMembers',
      'administration':'Administration',
      'important_contacts':'Important Contacts',

      'help_center_timing':
      'NMC help center(Available from 7AM to 11PM)',
      "divisionalOffices": "Divisional Offices",
      "amardham": "Amardham",
      "fireBrigade": "Fire Brigade",
      "waterSupply": "Water Supply",
      "maternityHome": "Maternity Home",
      "policeStation": "Police Station",
      "hospital": "Hospital",
      "bloodBank": "Blood Bank",
      "pathologyLab": "Pathology Lab",
      "medicalCollege": "Medical College"
     },

    'mr': {
      'login': 'नागरिक लॉगिन',
      'username': 'वापरकर्ता नाव',
      'password': 'पासवर्ड',
      'continue': 'सुरू ठेवा',
      'enter_username': 'कृपया वापरकर्ता नाव प्रविष्ट करा',
      'enter_password': 'कृपया ६ अंकी पासवर्ड प्रविष्ट करा',
      'forgot_password': 'पासवर्ड विसरलात?',
      'dont_have_account': 'खाते नाही का? ',
      'register_here': 'येथे नोंदणी करा',
      'version': 'आवृत्ती v1.1',
      'copyright':
          '© २०२६ कॉपीराइट | नाशिक महानगरपालिका | महाराष्ट्र शासन | सर्व हक्क राखीव',
      'back': 'मागे',
      'ok': 'ठीक आहे',
      'cancel': 'रद्द करा',
      'logout': 'बाहेर पडा',
      'logout_confirmation':
      'तुम्हाला खात्री आहे की तुम्ही लॉगआउट करू इच्छिता?',
      'pick_gender': 'लिंग निवडा',
      'male': 'पुरुष',
      'female': 'महिला',
      'other': 'इतर',
      'citizen_registration': 'नागरिक नोंदणी',
      'full_name': 'पूर्ण नाव',
      'please_enter_full_name': 'कृपया पूर्ण नाव प्रविष्ट करा',
      'dob': 'जन्मतारीख',
      'select_dob': 'जन्मतारीख निवडा',
      'mobile': 'मोबाईल',
      'enter_mobile': 'कृपया १० अंकी मोबाईल क्रमांक प्रविष्ट करा',
      'mobile_registered': 'मोबाईल क्रमांक आधीच नोंदणीकृत आहे',
      'password_8': 'पासवर्ड किमान ८ अक्षरांचा असावा',
      'confirm_password': 'पासवर्डची पुष्टी करा',
      'confirm_password_enter': 'कृपया पासवर्डची पुष्टी करा',
      'password_not_match': 'पासवर्ड जुळत नाहीत',
      'email': 'ईमेल आयडी',
      'enter_email': 'कृपया ईमेल प्रविष्ट करा',
      'invalid_email': 'वैध ईमेल प्रविष्ट करा',
      'email_registered': 'ईमेल आधीच नोंदणीकृत आहे',
      'gender': 'लिंग',
      'select_gender': 'लिंग निवडा',
      'register': 'नोंदणी करा',
      'already_account': 'आधीच खाते आहे का? ',
      'log_in': 'लॉगिन करा',
      'failed_otp': 'OTP पाठवण्यात अयशस्वी',
      'forgot_password_msg':
      'पासवर्ड विसरलात? नोंदणीकृत मोबाईल क्रमांक प्रविष्ट करा',
      'send_otp': 'OTP पाठवा',
      'please_check_mobile': 'कृपया तुमचा मोबाईल तपासा',
      'sent_code_to': 'आम्ही कोड पाठवला आहे ',
      'didnt_get_code': 'कोड मिळाला नाही?',
      'resend_in': 'पुन्हा पाठवा',
      'resend_otp': 'OTP पुन्हा पाठवा',
      'otp_sent_success': 'OTP यशस्वीरित्या पाठवला',
      'verify': 'पडताळा',
      'registration_success': 'नोंदणी यशस्वी झाली',
      'registration_failed': 'नोंदणी अयशस्वी',
      'invalid_otp': 'अवैध OTP',
      'new_password': 'नवीन पासवर्ड',
      'enter_new_password':
      'नवीन पासवर्ड प्रविष्ट करा',
      'confirm_new_password':
      'नवीन पासवर्डची पुष्टी करा',
      'confirm': 'पुष्टी करा',
      'password_reset_success':
      'पासवर्ड यशस्वीरित्या रीसेट करण्यात आला',
      'hello':'नमस्कार',
      'role':'भूमिका',
      'citizen':'नागरिक',

      'all_services':'सर्व सेवा',
      'civic_services':'नागरी सेवा',
      'connect_now':'आमच्याशी जोडा',

      'profile':'प्रोफाइल',

      'emergency_use_only':'फक्त आपत्कालीन वापरासाठी',

      'police':'पोलीस',
      'ambulance':'रुग्णवाहिका',
      'fire_brigade':'अग्निशमन दल',
      'nmc_call_center':'एनएमसी कॉल सेंटर',

      'grievance_redressal':'तक्रार\nनिवारण',
      'marriage_registration':'विवाह\nनोंदणी',
      'challan_payment':'चलन\nभरणा',
      'trade_license':'व्यापार\nपरवाना',
      'hoarding_permission':'जाहिरात\nपरवानगी',
      'tree_cutting_permission':'वृक्षतोड\nपरवानगी',
      'noc_issuance':'एनओसी\nप्रदान',
      'water_connection':'पाणी व\nजलनिस्सारण\nजोडणी',
      'birth_death':'जन्म व मृत्यू नोंदणी',
      'health_facility':'आरोग्य सुविधा नोंदणी',
      'property_tax':'मालमत्ता\nकर',

      'coming_soon':'लवकरच येत आहे',

      'nmc_help_center':'एनएमसी मदत केंद्र',
      'faq':'वारंवार विचारले जाणारे प्रश्न',
      'news':'एनएमसी\nबातम्या',
      'know_our_works':'आमची\nकामे',
      'elected_members':'निवडून आलेले\nसदस्य',
      'administration':'प्रशासन',
      'important_contacts':'महत्त्वाचे संपर्क',

      'help_center_timing':
      'एनएमसी मदत केंद्र (सकाळी ७ ते रात्री ११)',
      "divisionalOffices": "विभागीय कार्यालये",
      "amardham": "अमरधाम",
      "fireBrigade": "अग्निशमन दल",
      "waterSupply": "पाणीपुरवठा",
      "maternityHome": "प्रसूतीगृह",
      "policeStation": "पोलीस स्टेशन",
      "hospital": "रुग्णालय",
      "bloodBank": "रक्तपेढी",
      "pathologyLab": "पॅथॉलॉजी लॅब",
      "medicalCollege": "वैद्यकीय महाविद्यालय"

    },
  };

  static String translate(BuildContext context, String key) {
    var locale = Provider.of<LanguageProvider>(
      context,
      listen: false,
    ).locale.languageCode;

    return localizedValues[locale]![key]!;
  }
}
