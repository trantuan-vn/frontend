import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartconsultor/core/localization/app_localizations.dart';
import 'package:smartconsultor/features/login/presentation/bloc/auth_bloc.dart';


class LoginControls extends StatefulWidget {
  const LoginControls({
    super.key,
  });

  @override
  State<LoginControls> createState() => _LoginControlsState();
}

class _LoginControlsState extends State<LoginControls> {
  
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isEmailValid = true;
  bool isStrongPassword = true;
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();  
  
  
  @override
  void initState() {
    super.initState();

    // Listen to focus changes
    emailFocusNode.addListener(_onFocusChange);
    passwordFocusNode.addListener(_onFocusChange);
  }
  
  // Callback function to handle focus change
  void _onFocusChange() {
    if (!emailFocusNode.hasFocus) {
      // Validate data when focus moves to TextField 1
      setState(() {
        isEmailValid = validateEmailPhone(usernameController.text);
      });
    } 
    
    if (!passwordFocusNode.hasFocus) {
      // Validate data when focus moves to TextField 2
      setState(() {
        isStrongPassword = validatePassword(passwordController.text);
      });
    }
  }  
  
  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    
    String? emailPhoneErrorText = isEmailValid == true ? null : strings.emailPhoneInvalid;
    String? passwordErrorText =
        isStrongPassword == true ? null : strings.strongPasswordInvalid;

    // Get the screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Set the maximum width and height of the container
    double containerWidth = screenWidth > 450 ? 450 : screenWidth;
    double containerHeight = screenHeight > 470 ? 470 : screenHeight;

    return Container(
          constraints: BoxConstraints(
            maxWidth: containerWidth,
            maxHeight: containerHeight,
          ),          
          child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                          controller: usernameController,
                          focusNode: emailFocusNode,
                          decoration: InputDecoration(
                            labelText: strings.emailPhone,
                            errorText: emailPhoneErrorText,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0), // Điều chỉnh giá trị để thay đổi độ cong của góc
                            ), 
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onEditingComplete: () {
                            // Add email validation logic here if needed
                            setState(() {
                              isEmailValid = validateEmailPhone(usernameController.text);
                            });
                          },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                          controller: passwordController,
                          focusNode: passwordFocusNode,
                          decoration: InputDecoration(
                            labelText: strings.password,
                            errorText: passwordErrorText,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0), // Điều chỉnh giá trị để thay đổi độ cong của góc
                            ),                            
                          ),
                          obscureText: true,
                          onEditingComplete: () {
                            // Add password validation logic here if needed
                            setState(() {
                              isStrongPassword = validatePassword(passwordController.text);
                            });
                          },
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {
                          // Add login logic here
                          if (isEmailValid && isStrongPassword) {
                            // Email and password are valid, proceed with login
                            context.read<AuthBloc>().add(SignInEvent(username: usernameController.text, password: passwordController.text));                        
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0), // Adjust the value to change the corner radius
                          ),
                          side: BorderSide(color: Theme.of(context).primaryColor), // Customize border color
                        ),                        
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(16.0),
                          child: Text(strings.loginButtonTitle),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }     

  bool validateEmailPhone(String email) {
    // Use regular expression to check email address
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    final phoneRegex = RegExp(r'^(0|\+84)\d{9,10}$');
    
    return emailRegex.hasMatch(email) || phoneRegex.hasMatch(email);
  }

  bool validatePassword(String password) {
    // Check if the value is strong enough
    // Requires at least 8 characters, at least one uppercase letter, one lowercase letter, and one digit
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')) &&
        true;
  }
}