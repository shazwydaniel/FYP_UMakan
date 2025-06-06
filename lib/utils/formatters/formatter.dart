import 'package:intl/intl.dart';

class TFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(date); // Customize the date format as needed
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'MY', symbol: '\RM').format(amount); // Customize the currency locale and symbol as needed
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Check if the phone number starts with '+60'
    if (phoneNumber.startsWith('+60')) {
      if (phoneNumber.length == 12) {
        return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 5)}-${phoneNumber.substring(5, 9)}-${phoneNumber.substring(9)}';
      } else if (phoneNumber.length == 13) {
        return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 5)}-${phoneNumber.substring(5, 10)}-${phoneNumber.substring(10)}';
      }
    } else if (phoneNumber.length == 10 && phoneNumber.startsWith('0')) {
      // Assuming the phone number format is like 0172764901
      return '+60${phoneNumber.substring(1, 2)}-${phoneNumber.substring(2, 5)}-${phoneNumber.substring(5)}';
    } else if (phoneNumber.length == 11 && phoneNumber.startsWith('0')) {
      // Assuming the phone number format is like 01234567890
      return '+60${phoneNumber.substring(1, 2)}-${phoneNumber.substring(2, 6)}-${phoneNumber.substring(6)}';
    }
    // Return the original phone number if it does not match any format
    return phoneNumber;
  }



  // Not fully tested.
  static String internationalFormatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters from the phone number
    var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Extract the country code from the digitsOnly
    String countryCode = '+${digitsOnly.substring(0, 2)}';
    digitsOnly = digitsOnly.substring(2);

    // Add the remaining digits with proper formatting
    final formattedNumber = StringBuffer();
    formattedNumber.write('($countryCode) ');

    int i = 0;
    while (i < digitsOnly.length) {
      int groupLength = 2;
      if (i == 0 && countryCode == '+1') {
        groupLength = 3;
      }

      int end = i + groupLength;
      formattedNumber.write(digitsOnly.substring(i, end));

      if (end < digitsOnly.length) {
        formattedNumber.write(' ');
      }
      i = end;
    }

    return formattedNumber.toString();
  }




}


/*
*
*
* */
