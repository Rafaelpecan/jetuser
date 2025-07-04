import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class CreditCard {
  CreditCard({
    this.id,
    this.number, 
    this.valid, 
    this.titular, 
    this.cvv,
    this.brand,
    });

CreditCard.fromDocument(Map<String, dynamic> data) {
  id = data["id"] as String?;
  number = data["number"] as String?;
  valid = data["valid"] as String?;
  titular = data["titular"] as String?;
  cvv = data["cvv"] as String?;
  brand = data["brand"] as String?;
}

  String? id;
  String? number;
  String? valid;
  String? titular;
  String? cvv;
  String? brand;

  void setNumber(String number) => this.number = number;
  void setValid(String date) => valid = date;
  void setTitular(String name) => titular = name;
  void setCvv(String cvv) => this.cvv = cvv;
  void setBrand(String number){
    brand = detectCCType(number.replaceAll(" ", "")).toString().toString().split(".").last;
  }

    Map<String, dynamic> toJson() {
    return {
      'cardNumber': number!.replaceAll(" ", ""),
      'holder': titular,
      'expirationDate': valid,
      'securityCode': cvv,
      'brand': brand
    };
  }
}
