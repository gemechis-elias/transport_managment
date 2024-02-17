import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_app/bloc/registration%20bloc/register_bloc.dart';
import 'package:transport_app/bloc/registration%20bloc/register_event.dart';
import 'package:transport_app/bloc/registration%20bloc/register_state.dart';
import 'package:transport_app/presentation/auth/login_page.dart';
import 'package:transport_app/models/user.dart';
import 'package:transport_app/presentation/home.dart';
import 'package:transport_app/services/registrationService.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

String? errorMessage = '';

class _RegistrationState extends State<Registration> {
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  bool _isPasswordVisible = false;
  bool result = false;
  bool _isLoading = false;

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
          DateTime now = DateTime.now();
          final UserRegistration userRegisteration = UserRegistration();
          context.read<UserRgistrationBloc>().add(
                RegisterUserEvent(
                  name: _fullNameController.text,
                  phone: _controllerPhone.text,
                  password: _controllerPassword.text,
                  confirmPassword: _confirmPasswordController.text,
                ),
              );
        },
        child:
            _isLoading ? const CircularProgressIndicator() : Text('Register'),
      ),
    );
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
    return BlocConsumer<UserRgistrationBloc, RegisterState>(
      listener: (context, state) {
        if (state is LoadedRegisterUserState) {
          setState(() {
            _isLoading = false;
          });
          // Navigate to Home page on successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        } else if (state is RegisterUserLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is RegisterUserError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                const Text(
                  "Registration",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.blue,
                    fontFamily: 'Poppins-Bold',
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                  child: TextFormField(
                    // ignore: non_constant_identifier_names
                    validator: (Value) {
                      if (Value == null || Value.isEmpty) {
                        return "First Name cannot be empty";
                      } else if (Value.length < 3) {
                        return 'First Name must be more than 2 character';
                      }
                      return null;
                    },
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins-Light',
                    ),
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(6),
                      hintText: 'FullName',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Poppins-Light',
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
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
                  padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
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
                    controller: _controllerPhone,
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
                      prefix: Text(
                        '+251',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontFamily: 'Poppins-Light',
                        ),
                      ),
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
                    padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (Value) {
                        if (Value == null || Value.isEmpty) {
                          return "password cannot be empty";
                        }
                        return null;
                      },
                      obscureText: true,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins-Light',
                      ),
                      controller: _controllerPassword,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(6),
                        hintText: 'Enter pin',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins-Light',
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(Icons.key, color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
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
                    )),
                Padding(
                    padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (Value) {
                        if (Value == null || Value.isEmpty) {
                          return "pin cannot be empty";
                        } else if (Value != _controllerPassword.text) {
                          return "pin doesn't Match";
                        }
                        return null;
                      },
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins-Light',
                      ),
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(6),
                        hintText: 'Confirm Pin',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins-Light',
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(Icons.key, color: Colors.grey),
                        suffix: _buildPasswordVisibilityToggle(),
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            )),
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
                    )),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: _submitButton(),
                ),
                const Center(
                  child: Text(
                    "OR",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Poppins-Light',
                    ),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text(
                      "Do you have an account? Login?",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontFamily: 'Poppins-Light'),
                    ),
                  ),
                ),
                Center(
                  child: _errorMessage(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
