import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recase/recase.dart';
import 'package:trash_troopers/services/auth_api.dart';
import 'package:trash_troopers/widgets/authButton.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthApi _auth = AuthApi();

  double width = 250;
  double height = 80;

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String passwordReenter = '';

  String profilePhoto =
      'https://firebasestorage.googleapis.com/v0/b/trash-troopers.appspot.com/o/photos%2FdefaultProfilePicture.png?alt=media&token=2f6d0167-9330-446e-8200-310f4fa25c2d';

  bool _autoValidate = false;
  bool _passwordVisible = false;
  // Widget Toggles
  bool register = false;
  bool forgotPassword = false;
  // Animation Toggles
  bool _isGoogleLoading = false;
  bool _isSignInLoading = false;

  // Focus Nodes
  final namefocus = FocusNode();
  final emailfocus = FocusNode();
  final passwordfocus = FocusNode();
  final passwordReenterfocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final scaffold = _globalKey.currentState;

    Widget emailInput = Container(
      width: width,
      height: height,
      child: TextFormField(
        textInputAction: TextInputAction.next,
        focusNode: emailfocus,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(passwordfocus);
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          filled: true,
          fillColor: Colors.white70,
          labelText: 'Email',
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColorDark, width: 2),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: validateEmail,
        initialValue: email.isEmpty ? null : email,
        onChanged: (val) {
          setState(() => email = val);
        },
      ),
    );

    Widget passwordInput = Container(
      width: width,
      height: height,
      child: TextFormField(
        textInputAction: TextInputAction.next,
        focusNode: passwordfocus,
        onFieldSubmitted: (v) {
          register
              ? FocusScope.of(context).requestFocus(passwordReenterfocus)
              : passwordfocus.unfocus();
        },
        decoration: InputDecoration(
          suffixIcon: SizedBox(
            child: IconButton(
              alignment: Alignment.centerRight,
              tooltip: 'View Password',
              focusColor: Theme.of(context).primaryColor,
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[600],
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
          ),
          prefixIcon: Icon(Icons.vpn_key),
          filled: true,
          fillColor: Colors.white70,
          labelText: 'Password',
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColorDark, width: 2),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty || value.length < 8) {
            return "Minimum 8 Characters";
          }
          return null;
        },
        obscureText: !_passwordVisible,
        initialValue: password.isEmpty ? null : password,
        onChanged: (val) {
          setState(() => password = val);
        },
      ),
    );

    Widget passwordReenterInput = Container(
      width: width,
      height: height,
      child: TextFormField(
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (v) {
          passwordReenterfocus.unfocus();
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          filled: true,
          fillColor: Colors.white70,
          labelText: 'Re-enter Password',
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColorDark, width: 2),
          ),
        ),
        validator: (String value) {
          if (this.password != this.passwordReenter) {
            return "Passwords Dont Match";
          } else {
            return null;
          }
        },
        obscureText: true,
        initialValue: null,
        onChanged: (val) {
          setState(() => passwordReenter = val);
        },
      ),
    );

    Widget nameInput = Container(
      width: width,
      height: height,
      child: TextFormField(
        textInputAction: TextInputAction.next,
        focusNode: namefocus,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(emailfocus);
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          filled: true,
          fillColor: Colors.white70,
          labelText: 'Name',
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColorDark, width: 2),
          ),
        ),
        keyboardType: TextInputType.text,
        validator: (String value) {
          if (value.trim().isEmpty) {
            return "Please Enter Name";
          }
          return null;
        },
        initialValue: email.isEmpty ? null : name,
        onChanged: (val) {
          setState(() => name = val);
        },
      ),
    );

    Widget googleLoaderButton = Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 50,
        width: width,
        child: OutlineButton(
          highlightElevation: 10,
          onPressed: () {},
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
          padding: EdgeInsets.all(0.0),
          child: Container(
            constraints: BoxConstraints(maxWidth: width, minHeight: 50),
            alignment: Alignment.center,
            child: SizedBox(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
              height: 30.0,
              width: 30.0,
            ),
          ),
        ),
      ),
    );

    Widget googlgSignInButton = Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 50,
        width: width,
        child: OutlineButton(
          highlightElevation: 10,
          onPressed: () async {
            setState(() {
              _isGoogleLoading = true;
            });
            await _auth.signInGoogle().catchError((error) {
              // if (mounted) {
              //   setState(() {
              //     _isGoogleLoading = false;
              //   });
              // }
              // String errorString = error.toString();
              // String errorText = errorString.split(',')[1];
              // scaffold.showSnackBar(
              //   SnackBar(
              //     content: Text("Error: $errorText"),
              //     action: SnackBarAction(
              //       label: 'HIDE',
              //       onPressed: scaffold.hideCurrentSnackBar,
              //     ),
              //   ),
              // );
              // print("Error: $error");
            }
            );
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
          padding: EdgeInsets.all(0.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage("assets/images/google_logo.png"),
                  height: 25.0),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'SIGN IN WITH GOOGLE',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

    Widget googleAnimator = AnimatedCrossFade(
      duration: const Duration(milliseconds: 800),
      firstChild: googleLoaderButton,
      secondChild: googlgSignInButton,
      crossFadeState: _isGoogleLoading
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );

    Widget buttonMain = AuthButton(
      label: register
          ? 'CREATE ACCOUNT'
          : forgotPassword ? 'RESET PASSWORD' : 'LOG IN',
      width: width,
      onPressed: () async {
        setState(() {
          _autoValidate = true;
        });
        FocusScope.of(context).unfocus();
        // Register
        if (register) {
          if (_formKey.currentState.validate()) {
            setState(() {
              _isSignInLoading = true;
            });

            await _auth
                .registerEmail(email, password, name.titleCase, profilePhoto)
                .catchError((error) {
              setState(() {
                _isSignInLoading = false;
              });
              String errorString = error.toString();
              String errorText = errorString.split(',')[1];
              scaffold.showSnackBar(
                SnackBar(
                  content: Text("Error: $errorText"),
                  action: SnackBarAction(
                    label: 'HIDE',
                    onPressed: scaffold.hideCurrentSnackBar,
                  ),
                ),
              );
              print("Error: $error");
            });
          }
          // Forgot Password
        } else if (forgotPassword) {
          if (_formKey.currentState.validate()) {
            setState(() {
              _isSignInLoading = true;
            });
            await _auth.resetPassword(email).then((val) {
              setState(() {
                _isSignInLoading = false;
              });

              scaffold.showSnackBar(
                SnackBar(
                  content: Text("EMAIL SENT"),
                  action: SnackBarAction(
                    label: 'SIGN IN',
                    onPressed: () {
                      scaffold.hideCurrentSnackBar();
                      setState(() {
                        forgotPassword = false;
                      });
                    },
                  ),
                ),
              );
            }).catchError((error) {
              setState(() {
                _isSignInLoading = false;
              });
              String errorString = error.toString();
              String errorText = errorString.split(',')[1];
              scaffold.showSnackBar(
                SnackBar(
                  content: Text("Error: $errorText"),
                  action: SnackBarAction(
                    label: 'HIDE',
                    onPressed: scaffold.hideCurrentSnackBar,
                  ),
                ),
              );
              print("Error: $error");
            });
          }
          // Sign In
        } else {
          if (_formKey.currentState.validate()) {
            setState(() {
              _isSignInLoading = true;
            });
            await _auth.signInEmail(email, password).catchError((error) {
              setState(() {
                _isSignInLoading = false;
              });
              String errorString = error.toString();
              String errorText = errorString.split(',')[1];
              scaffold.showSnackBar(
                SnackBar(
                  content: Text("Error: $errorText"),
                  action: SnackBarAction(
                    label: 'HIDE',
                    onPressed: scaffold.hideCurrentSnackBar,
                  ),
                ),
              );
              print("Error: $error");
            });
          }
        }
      },
    );

    Widget loaderButtonMain = Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: 50,
        child: Ink(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(40.0)),
          child: Container(
            constraints: BoxConstraints(maxWidth: width, minHeight: 50),
            alignment: Alignment.center,
            child: SizedBox(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              height: 30.0,
              width: 30.0,
            ),
          ),
        ),
      ),
    );

    Widget signInAnimator = AnimatedCrossFade(
      duration: const Duration(milliseconds: 800),
      firstChild: loaderButtonMain,
      secondChild: buttonMain,
      crossFadeState: _isSignInLoading
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
    );

    Widget buttonGoogleOrRegister = Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Container(
              width: width / 1.1,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      width: width / 3,
                      child: Divider(
                        height: 2,
                        color: Colors.grey,
                      ),
                    ),
                    Text("OR",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey)),
                    SizedBox(
                      width: width / 3,
                      child: Divider(
                        height: 2,
                        color: Colors.grey,
                      ),
                    ),
                  ]),
            )),
        googleAnimator,
        AuthButton(
            width: width,
            label: 'REGISTER',
            onPressed: () {
              setState(() {
                register = true;
              });
            }),
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: FlatButton(
            splashColor: Colors.white,
            child: Text("FORGOT PASSWORD?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey)),
            onPressed: () {
              setState(() {
                forgotPassword = true;
              });
            },
          ),
        ),
      ],
    );

    Widget buttonGoBack = Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: OutlineButton.icon(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.grey[100],
          splashColor: Colors.white,
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
          label: Text("GO BACK",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey)),
          onPressed: () {
            setState(() {
              forgotPassword = false;
              register = false;
            });
          },
        ));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: AbsorbPointer(
        absorbing: _isGoogleLoading || _isSignInLoading,
        child: Scaffold(
          key: _globalKey,
          resizeToAvoidBottomPadding: true,
          backgroundColor: Colors.white,
          body: Container(
              child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    !register
                        ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: Image(
                              image: AssetImage("assets/images/logo.png"),
                              width: MediaQuery.of(context).size.width * 0.4,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Create New Account',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 22,
                                fontFamily: 'Bebas Neue',
                              ),
                            ),
                          ),
                    register ? nameInput : SizedBox(),
                    register ? SizedBox(height: 10) : SizedBox(),
                    emailInput,
                    !forgotPassword ? SizedBox(height: 10) : SizedBox(),
                    !forgotPassword ? passwordInput : SizedBox(),
                    // Re-enter password field
                    register ? SizedBox(height: 10) : SizedBox(),
                    register ? passwordReenterInput : SizedBox(),

                    // Animate buttonMain
                    signInAnimator,
                    // Show back button
                    forgotPassword ? buttonGoBack : SizedBox(),
                    register ? buttonGoBack : SizedBox(),
                    !register && !forgotPassword
                        ? buttonGoogleOrRegister
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Invalid Email';
    } else
      return null;
  }
}
