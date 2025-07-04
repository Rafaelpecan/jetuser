import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class Creditcard {

  String? number;
  String? holder;
  String? expirationdate;
  String? securityCode;
  String? brand;

  void setHolder(String name) => holder = name;
  void setExpirationDate(String date) => expirationdate = date;
  void setCVV(String cvv) => securityCode = cvv;
  void setNumber(String number){
    this.number = number;
    brand = detectCCType(number.replaceAll(" ", "")).toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': number!.replaceAll(" ", ""),
      'holder': holder,
      'expirationDate': expirationdate,
      'securityCode': securityCode,
      'brand': brand
    };
  }
}