import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:jetrideruser/domain/firebase_auth/creditcard.dart';
import 'package:jetrideruser/domain/firebase_auth/firebaseAuthModel.dart';
import 'package:cloud_functions/cloud_functions.dart';

class CieloPayment {

  final FirebaseFunctions functions = FirebaseFunctions.instance;

  Future<String> authorize({required CreditCard creditcard, required num price, required String orderId, required EmailAndPassUser user}) async{

    try {
      final Map<String, dynamic> dataSale = {
        'merchantOrderid': orderId,
        'amount': (price * 100).toInt(),
        'softDescriptor': "Jet RJ",
        'installments': 1,
        'creditCard': creditcard.toJson(),
        'cpf': user.cpf,
        'paymentType': 'creditCard'
    };
  
    final HttpsCallable callable = functions.httpsCallable('authorizeCreditCard');
    final response = await callable.call(dataSale);
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
    if (data['sucess'] as bool) {
      return data['paymentId'] as String;
    } else {
      return Future.error(data["error"]["message"]);
    }
} on Exception catch (e) {
    return Future.error("Falha ao processar transacao, tente novamente");
  }
}

  Future<void> capture(String payId) async {
    final Map<String, dynamic> captureData = {
      'payId': payId
    };
    final HttpsCallable callable = functions.httpsCallable('captureCreditCard'); 
    final response = await callable.call(captureData);
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
    if (data['sucess'] as bool) {
      return;
    } else {
      return Future.error(data["error"]["message"]);
    }
  }

  Future<void> cancel(String payId) async {
    final Map<String, dynamic> cancelData = {
      'payId': payId
    };
    final HttpsCallable callable = functions.httpsCallable('cancelCreditCard'); 
    final response = await callable.call(cancelData);
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
    if (data['sucess'] as bool) {
      return;
    } else {
      return Future.error(data["error"]["message"]);
    }
  } 





}