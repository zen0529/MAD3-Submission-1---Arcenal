import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile3_midterm/controller/authcontroller.dart';
import 'package:mobile3_midterm/services.dart/waiting_dialog.dart';

final _formKey = GlobalKey<FormState>();

class LogIn extends StatefulWidget {
  static const String route = '/login';
  static const String name = 'login';
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  late TextEditingController usernameController, passwordController;
  late FocusNode usernameFn, passwordFn;

  bool obfuscate = true;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    usernameFn = FocusNode();
    passwordFn = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    usernameFn = FocusNode();
    passwordFn = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/logIn/container.png',
              width: screenWidth,
              height: screenHeight,
              fit: BoxFit.fill,
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    height: screenHeight * 0.4,
                    width: screenWidth * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      image: const DecorationImage(
                        image: AssetImage(
                            'assets/images/logIn/smallContainer.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Login',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: const Color(0xFF262626),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Container(
                            //   padding: const EdgeInsets.all(0),
                            //   height: 50,
                            //   width: double.infinity,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(10),
                            //     color: const Color(0xFFF6F6F6),
                            //   ),
                            //   child:
                            TextFormField(
                              onEditingComplete: () {
                                passwordFn.requestFocus();
                              },
                              focusNode: usernameFn,
                              controller: usernameController,
                              decoration: decoration.copyWith(
                                  labelText: "Username",
                                  prefixIcon: const Icon(Icons.person)),
                              // InputDecoration(
                              //   border: InputBorder.none,
                              //   hintText: 'Username',
                              //   prefixIcon: Icon(Icons.perm_identity_sharp),
                              //   hintStyle: GoogleFonts.heebo(
                              //     color: const Color(0xFF252525),
                              //     fontWeight: FontWeight.normal,
                              //     fontSize: 15,
                              //   ),
                              // ),
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "A username is required"),
                                MinLengthValidator(4,
                                    errorText:
                                        "username needs to be atleast 4 characters"),
                                MaxLengthValidator(128,
                                    errorText:
                                        "password cannot exceed 72 characters"),
                                PatternValidator(r'^[a-zA-Z0-9 ]+$',
                                    errorText:
                                        "Username cannot contain special characters")
                              ]).call,
                            ),

                            const SizedBox(height: 15),

                            Flexible(
                              child: TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                focusNode: passwordFn,
                                controller: passwordController,
                                onEditingComplete: () {
                                  passwordFn.unfocus();
                                },
                                obscureText: obfuscate,
                                decoration: decoration.copyWith(
                                    labelText: "Password",
                                    prefixIcon: const Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            obfuscate = !obfuscate;
                                          });
                                        },
                                        icon: Icon(obfuscate
                                            ? Icons.remove_red_eye_rounded
                                            : CupertinoIcons.eye_slash))),
                                // InputDecoration(
                                //   border: InputBorder.none,
                                //   hintText: 'Password',
                                //   prefixIcon: Icon(Icons.lock),
                                //   suffixIcon: IconButton(
                                //     onPressed: () {
                                //       setState(() {
                                //         obfuscate = !obfuscate;
                                //       });
                                //     },
                                //     icon: Icon(obfuscate
                                //         ? Icons.remove_red_eye_rounded
                                //         : CupertinoIcons.eye_slash),
                                //   ),
                                //   hintStyle: GoogleFonts.heebo(
                                //     color: Color.fromARGB(255, 74, 74, 74),
                                //     fontWeight: FontWeight.normal,
                                //     fontSize: 15,
                                //   ),
                                // ),
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "A password is required"),
                                  MinLengthValidator(8,
                                      errorText:
                                          "Password needs to be atleast 8 characters"),
                                  PatternValidator(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$',
                                    errorText:
                                        "password must contain atleast one number, one uppercase letter, 1 lowercase letter,and one special character",
                                  )
                                ]).call,
                              ),
                            ),
                            // ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Material(
                                elevation: 10,
                                shadowColor: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: const Color(0xFF176BCE),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    onSubmit();
                                  },
                                  child: Text(
                                    "Login",
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFFFFFFF),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      WaitingDialog.show(context,
          future: AuthController.I.login(
              usernameController.text.trim(), passwordController.text.trim()));
    }

    // AuthController.I.printCredentials();
  }

  final OutlineInputBorder _baseBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  InputDecoration get decoration => InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      filled: true,
      fillColor: Colors.white,
      errorMaxLines: 3,
      disabledBorder: _baseBorder,
      enabledBorder: _baseBorder.copyWith(
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
      focusedBorder: _baseBorder.copyWith(
        borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
      ),
      errorBorder: _baseBorder.copyWith(
        borderSide: const BorderSide(color: Colors.deepOrangeAccent, width: 1),
      ));
}
