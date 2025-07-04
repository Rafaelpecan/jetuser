import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetrideruser/domain/firebase_auth/creditcard.dart';

class EmailAndPassUser {
  EmailAndPassUser({
    this.username, 
    this.email, 
    this.password, 
    this.confirmedPassword, 
    this.id,
    this.cpf,
    this.creditCard
    });

  EmailAndPassUser.fromDocument(DocumentSnapshot document) {
    id = document.id;
    username = document["name"] as String?;
    email = document['email'] as String?;
    
    if (document["creditCards"] != null && (document["creditCards"] as List).isNotEmpty) {
      List creditCardsList = document["creditCards"] as List;
      creditCard = CreditCard.fromDocument(creditCardsList.last as Map<String, dynamic>);
    }
  }

  String? id;
  String? username;
  String? email;
  String? password;
  String? cpf;
  String? confirmedPassword;
  CreditCard? creditCard;

  void setCpf(String cpf){
    this.cpf = cpf;
  }
}