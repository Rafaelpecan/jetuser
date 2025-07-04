import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:credit_card_type_detector/models.dart';

bool isValidEmail(String? inputString, {bool isRequired = false}) {
  if (!isRequired && (inputString?.isEmpty ?? true)) {
    return true;
  }

  if (inputString != null && inputString.isNotEmpty) {
    final regExp = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'); // Optimized regex
    return regExp.hasMatch(inputString);
  }

  return false;
}

bool isValidCardNumber(String inputString) {
  if (inputString.isEmpty) return false;

  List<CreditCardType> cardTypes = detectCCType(inputString);

  // If no valid card type detected, return false
  if (cardTypes.isEmpty) return false;

  // Get the expected length of the detected card type
  int expectedLength = (cardTypes.first).toString().length ?? 16;

  // Validate card length and Luhn Algorithm
  return inputString.replaceAll(RegExp(r'\D'), '').length == expectedLength && 
  
  _luhnCheck(inputString);
}

bool isValidCpf(String inputString) {
  return CPFValidator.isValid(inputString);
}

/// **Luhn Algorithm Check (for Credit Cards)**
bool _luhnCheck(String cardNumber) {
  List<int> digits =
      cardNumber.replaceAll(RegExp(r'\D'), '').split('').map(int.parse).toList();
  int sum = 0;
  bool isEven = false;

  for (int i = digits.length - 1; i >= 0; i--) {
    int digit = digits[i];

    if (isEven) {
      digit *= 2;
      if (digit > 9) digit -= 9;
    }

    sum += digit;
    isEven = !isEven;
  }

  return sum % 10 == 0;
}
