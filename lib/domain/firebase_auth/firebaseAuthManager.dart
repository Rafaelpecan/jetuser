import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:jetrideruser/domain/firebase_auth/creditcard.dart';
import 'package:jetrideruser/domain/firebase_auth/firebaseAuthModel.dart';
import 'package:jetrideruser/domain/geolocator/geoLocationModel.dart';


class EmailAndPassAuth{

  EmailAndPassAuth(){
    _loadingCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseDatabase fireDatabase = FirebaseDatabase.instance;
  EmailAndPassUser? user;
  CreditCard? mainCreditCard;
  dynamic referenceRideRequest;


  Future<void> signIn(EmailAndPassUser user) async{
    final UserCredential result = await auth.signInWithEmailAndPassword(email: user.email!, password: user.password!);
    await _loadingCurrentUser(user: result.user);
  }

  Future<void> signUp(EmailAndPassUser user) async {
    final UserCredential result = await auth.createUserWithEmailAndPassword(email: user.email!, password: user.password!);
    user.id = result.user!.uid;
    this.user = user;
    await _savedata(user);
  }
  
  void signOut(){
    auth.signOut();
    user = null;
  }

  Future<void> _loadingCurrentUser({User? user}) async{
     User? currentUser = user ?? auth.currentUser;
     if (currentUser != null){
      final DocumentSnapshot docUser = await firestore.collection('users').doc(currentUser.uid).get();
      this.user = EmailAndPassUser.fromDocument(docUser);
     }
  }

  Future<void> _savedata(EmailAndPassUser? user) async{
    await firestore.collection("users").doc(user!.id).set(toMap(user));
  }

  Future<void> requestRide(Location userLocation) async{

    referenceRideRequest = fireDatabase.ref().child("All Ride Request").push();

    Map originLocationMap = {
      "latitude": userLocation.latitude,
      "longitude": userLocation.longitude,
    };

    Map userInformation = {
      "origin": originLocationMap,
      "time": DateTime.now().toString(),
      "userName": user!.username ?? "sem nome",
      "originAdress": userLocation.address,
      "userPhone": "",
      "driverId": "wating",
    };

    await referenceRideRequest.set(userInformation);

  }

  Future<void> sendNotificationRideRequest(String driverID) async{
    await fireDatabase.ref().child("drivers").child(driverID).child("newRideStatus").set(referenceRideRequest!.key);

    fireDatabase.ref().child("drivers").child(driverID).child("token").once().then((snap){

      if (snap.snapshot.value != null) {
        String deviceToken = snap.snapshot.value.toString();
      }else{
        return Future.error('Não há motoristas Disponíveis, tente mais tarde');
      }
    });
  }

  Future<void> addCpf(String cpf) async {
    if (user == null) return;

    user!.setCpf(cpf);  // Actualiza en memoria
    await firestore.collection("users").doc(user!.id).update({'cpf': cpf}); // Guarda sin sobrescribir
  }


  Map<String, dynamic> toMap(EmailAndPassUser user){
    return {
      'name': user.username ?? "sem nome",
      'email': user.email ?? "sem email",
      'cpf': user.cpf ?? "sem cpf",
    };
  }

Future<void> addCreditCard(CreditCard creditCard) async {
  final userRef = firestore.collection("users").doc(user!.id);
  final userDoc = await userRef.get();

  if (!userDoc.exists) return; // Ensure the user document exists

  final newCard = cardToMap(creditCard);
  List<dynamic> existingCards = userDoc.data()?['creditCards'] ?? [];

  // Check if the card already exists based on number & validity date
  bool cardExists = existingCards.any((card) =>
      card['number'] == newCard['number'] && card['valid'] == newCard['valid']);

  if (cardExists) {
    print("Este cartão já foi cadastrado!");
    return;
  }

  // Add the new card to the array
  await userRef.update({
    'creditCards': FieldValue.arrayUnion([newCard])
  });
}

Map<String, dynamic> cardToMap(CreditCard creditCard) {
  return {
    'number': creditCard.number ?? "sem numero",
    'valid': creditCard.valid ?? "sem validade",
    'titular': creditCard.titular ?? "sem titular",
    'cvv': creditCard.cvv ?? "sem cvv",
    };
  }
}