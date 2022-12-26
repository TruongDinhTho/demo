import 'package:demo/BackEnd/firebase/Auth/sign_up_auth.dart';
import 'package:demo/FontEnd/AuthUI/login.dart';
import 'package:demo/FontEnd/AuthUI/textField_button.dart';
import 'package:demo/Global_Users/enum_generation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:loading_overlay/loading_overlay.dart';

import '../../Global_Users/reg_exp.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final GlobalKey<FormState> _signUpKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confPassword = TextEditingController();

  final EmailAndPassAuth _emailAndPassAuth = EmailAndPassAuth();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(34, 48, 60, 1),
        body: LoadingOverlay(
          isLoading: this._isLoading,
          child: Container(
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: 70),
                Center(
                  child: Text("Đăng ký tài khoản",
                      style: TextStyle(fontSize: 30, color: Colors.red)),
                ),
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 2,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  padding: EdgeInsets.only(top: 40.0),
                  child: Form(
                    key: this._signUpKey,
                    child: ListView(
                      children: [
                        textFormFiled(hintText: 'Email', validator: (inputVal) {
                          if (!emailRegex.hasMatch(inputVal.toString()))
                            return 'Email không khớp';
                          return null;
                        }, textEditingController: this._email),
                        textFormFiled(
                            hintText: 'Password', validator: (String? inputVal) {
                          if (inputVal!.length < 6)
                            return 'Mật khẩu có hơn 6 ký tự';
                          return null;
                        }, textEditingController: this._password),
                        textFormFiled(hintText: 'Confirm Password',
                            validator: (String? inputVal) {
                              if (this._password.text != this._confPassword.text)
                                return 'Mật khẩu không khớp';
                              return null;
                            },
                            textEditingController: this._confPassword),
                        signUpAuthButton(context, 'Đăng ký'),
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
                switchScreen(context, "Bạn đã có tài khoản? ", "Đăng nhập"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget signUpAuthButton(BuildContext context, String buttonName) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            // minimumSize: Size(MediaQuery.of(context).size.width - 60, 30.0),
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
            if(this._signUpKey.currentState!.validate()){
              print('Validated');

              if(mounted){
                setState(() {
                  this._isLoading = true;
                });
              }

              SystemChannels.textInput.invokeMethod('TextInput.hide');

              final EmailSignUpResults respose =  await this._emailAndPassAuth.signUpAuth(email: this._email.text, pass: this._password.text);
              if(respose == EmailSignUpResults.SignUpCompleted){
                Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));

              }else{
                final String msg = respose == EmailSignUpResults.EmailAlreadyPresent?'Email đã tồn tại': 'Sign up not completed';
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
              }
            }else {
              print('Not Validated');
            }
            if(mounted){
              setState(() {
                this._isLoading = false;
              });
            }
          }
      ),
    );
  }
}
