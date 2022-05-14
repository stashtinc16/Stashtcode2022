import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationService{
  FirebaseAuth _auth=FirebaseAuth.instance;
  Future createuser(String email, String password,String  name) async{
    UserCredential credential;
    try {
      credential = await _auth.createUserWithEmailAndPassword(email: email, password: password,);
      User user = credential.user!;
      return user;
    } catch(e){
      return print(e.toString());
    }
  }
  Future login(String email, String password,String name) async{
    UserCredential credential;
    try {
      credential = await _auth.signInWithEmailAndPassword(email: email, password: password, );
      User user = credential.user!;
      return user;
    } catch(e){
      return print(e.toString());
    }
  }
  Future<void> signout() async{
    try{
      return _auth.signOut();
    } catch(e){
      return print(e.toString());
    }
    return null;
  }
}
