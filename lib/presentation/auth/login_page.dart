import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_app/bloc/login%20bloc/login_bloc.dart';
import 'package:transport_app/bloc/login%20bloc/login_event.dart';
import 'package:transport_app/bloc/login%20bloc/login_state.dart';
import 'package:transport_app/presentation/auth/registration.dart';
import 'package:transport_app/presentation/home.dart';
import 'package:transport_app/services/loginService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool _isLoading = false;

  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isPasswordVisible = false;
  bool result = false;

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget _submitButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          // onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          String phoneNumber =
              '+251${_phoneController.text.replaceFirst(RegExp('^0+'), '')}';
          print('phone number ====> $phoneNumber');
          context.read<UserBloc>().add(
                LoginUserEvent(
                  phone: phoneNumber,
                  password: _controllerPassword.text,
                ),
              );
          // final UserLogin userlogin = UserLogin();
          // try {
          //   result = await userlogin.login(
          //     '+251${_phoneController.text}',
          //     _controllerPassword.text,
          //   );
          //   if (result) {
          //     // Registration successful
          //     // ignore: use_build_context_synchronously
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(builder: (context) => Home()),
          //     );
          //   } else {
          //     // Registration failed
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       const SnackBar(
          //         content: Text("Error: Can't login"),
          //         backgroundColor: Colors.red,
          //         duration: Duration(seconds: 2),
          //       ),
          //     );
          //   }
          // } catch (e) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(
          //       content: Text("Error: Can't login"),
          //       backgroundColor: Colors.red,
          //       duration: Duration(seconds: 2),
          //     ),
          //   );
          // }
        },
        child: _isLoading ? const CircularProgressIndicator() : Text('Login'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  IconButton _buildPasswordVisibilityToggle() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isPasswordVisible = !_isPasswordVisible;
        });
      },
      icon: Icon(
        _isPasswordVisible
            ? Icons.visibility_off
            : Icons.remove_red_eye_rounded,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is LoadedUserState) {
          setState(() {
            _isLoading = false;
          });
          // Navigate to Home page on successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        } else if (state is UserLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is UserError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
          // setState(() {
          //   _isLoading = false;
          // });
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
              ),
              const Text(
                "Ticket Managment App",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.blue,
                  fontFamily: 'Poppins-Bold',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  validator: (Value) {
                    if (Value == null || Value.isEmpty) {
                      return "phone number cannot be empty";
                    }
                    return null;
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins-Light',
                  ),
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(6),
                    hintText: 'Phone Number eg 912345678',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'Poppins-Light',
                    ),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.grey,
                    ),
                    // prefix: Text(
                    //   '+251',
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     color: Colors.black,
                    //     fontFamily: 'Poppins-Light',
                    //   ),
                    // ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        )),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  validator: (Value) {
                    if (Value == null || Value.isEmpty) {
                      return "password cannot be empty";
                    }
                    return null;
                  },
                  obscureText: !_isPasswordVisible,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins-Light',
                  ),
                  controller: _controllerPassword,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(6),
                    hintText: 'Pin',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Poppins-Light',
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.key,
                      color: Colors.grey,
                    ),
                    suffixIcon: _buildPasswordVisibilityToggle(),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        )),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(child: _submitButton()),
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  "OR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Registration()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Register",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontFamily: 'Poppins-Light'),
                  ),
                ),
              ),
              Center(child: _errorMessage()),
            ],
          )),
        );
      },
    );
  }
}
