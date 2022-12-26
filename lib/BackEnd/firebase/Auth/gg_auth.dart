import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleAuth{
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle( )async{
    try{
      if(await this._googleSignIn.isSignedIn()){
        print('Already google signed in');
      }
      else{
        final GoogleSignInAccount? _ggSignInAccount = await this._googleSignIn.signIn();
        if(_ggSignInAccount == null){
          print('Google sign in not completed');
        }else {
          final GoogleSignInAuthentication _ggSignInAuth = await _ggSignInAccount.authentication;
          final OAuthCredential _oAuthCredential = await GoogleAuthProvider.credential(
            accessToken: _ggSignInAuth.accessToken,
            idToken: _ggSignInAuth.idToken,
          );
          final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(_oAuthCredential);
          if(userCredential.user!.email != null){
            print('Đăng nhập với Google thành công');
          }else{
            print('Đăng nhập với Google không thành công');
          }
        }
      }
    }catch(e){
      print('Lỗi tài khoản google !!!! : ${e.toString()}');
    }
  }

  Future<bool> logOut() async{
    try{
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      return true;
    }catch(e){
      print('Lỗi. Đăng xuất google không thành công !!!! : ${e.toString()}');
      return false;
    }
  }
}

