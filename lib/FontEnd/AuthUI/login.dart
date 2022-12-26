import 'package:demo/FontEnd/AuthUI/textField_button.dart';
import 'package:demo/FontEnd/home_screen.dart';
import 'package:demo/Global_Users/enum_generation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../BackEnd/firebase/Auth/sign_up_auth.dart';
import '../../Global_Users/reg_exp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _logInKey = GlobalKey<FormState>();


  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final EmailAndPassAuth _emailAndPassAuth = EmailAndPassAuth();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(30, 48, 60, 1),
        body: LoadingOverlay(
          isLoading: this._isLoading,
          child: Container(
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: 60),
                Center(
                  child: Text("Đăng nhập", style: TextStyle(fontSize: 30, color: Colors.red)),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 80.0, bottom: 10.0),
                  child: Form(
                    key: this._logInKey,
                    child: ListView(
                      children: [
                        textFormFiled(hintText: 'Email', validator: (String? inputVal) {
                          if(!emailRegex.hasMatch(inputVal.toString()))
                            return 'Email format not matching';
                          return null;
                        }, textEditingController: this._email),
                        textFormFiled(hintText: 'Password', validator: (String? inputVal) {
                          if(inputVal!.length < 6)
                            return 'Password must be at least 6 characters';
                          return null;
                        }, textEditingController: this._password),
                        logInAuthButton(context, 'Đăng nhập'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Tiếp tục với',
                    style: TextStyle(fontSize: 20.0, color: Colors.white38),
                  ),
                ),
                socialMediaIntegrationButtons(),
                switchScreen(context,"Bạn chưa có tài khoản? "," Đăng ký"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget logInAuthButton(BuildContext context, String buttonName) {
    return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width - 60, 30.0),
                elevation: 5.0,
                primary: Color.fromRGBO(57, 60, 80, 1),
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 7.0,
                  bottom: 7.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                )),
            child: Text(
              buttonName,
              style: TextStyle(
                fontSize: 25.0,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            onPressed: () async {
              if(this._logInKey.currentState!.validate()){
                print('Validated');

                if(mounted){
                  setState(() {
                    this._isLoading = true;
                  });
                }

                final EmailSignInResults emailSignInResults = await _emailAndPassAuth.signInWithEmailAndPassword(email: this._email.text, pass: this._password.text);
                String msg = '';
                if(emailSignInResults == EmailSignInResults.SignInCompleted){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
                }
                else if(emailSignInResults == EmailSignInResults.EmailNotVerified){
                  msg = 'Email không sai cú pháp.\n Xin vui lòng nhập lai email';
                }else if(emailSignInResults == EmailSignInResults.EmailOrPasswordInvalid){
                  msg = 'Email hoặc mật khẩu không chính xác';

                }
                else {
                  msg = 'Đăng nhập không thành công';
                }
                if(msg != ''){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('')));
                }
                if(mounted){
                  setState(() {
                    this._isLoading = false;
                  });
                }
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              }else {
                print('Not Validated');
              }
            }),
    );
  }
}
