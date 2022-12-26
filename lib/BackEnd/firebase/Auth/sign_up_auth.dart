import 'package:demo/Global_Users/enum_generation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailAndPassAuth{

  Future<EmailSignUpResults> signUpAuth({required String email, required String pass}) async{
    try{
    final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
    if(userCredential.user!.email != null) {
        await userCredential.user!.sendEmailVerification();
        return EmailSignUpResults.SignUpCompleted;
      }
    return EmailSignUpResults.SignUpNotCompleted;
    }catch(e){
      print('Lỗi email và mật khẩu !!!! : ${e.toString()}');
      return EmailSignUpResults.EmailAlreadyPresent;
    }
  }

  Future<EmailSignInResults> signInWithEmailAndPassword({required String email, required String pass})async{
    try{
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
      if(userCredential.user!.emailVerified) {
        return EmailSignInResults.SignInCompleted;
      } else{
        final bool logOutRespose = await logOut();
        if (logOutRespose)
          return EmailSignInResults.EmailNotVerified;
        return EmailSignInResults.UnexpectedError;
      }
    }catch(e){
      print('Lỗi email và mật khẩu !!!! : ${e.toString()}');
      return EmailSignInResults.EmailOrPasswordInvalid;
    }
  }


  Future<bool> logOut() async{
    try{
      await FirebaseAuth.instance.signOut();
      return true;
    }catch(e){
      return false;
    }
  }

}