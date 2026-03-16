// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zedbee_bms/bloc_folder/bloc/login_bloc/auth_bloc.dart';
import 'package:zedbee_bms/bloc_folder/bloc/login_bloc/auth_event.dart';
import 'package:zedbee_bms/bloc_folder/bloc/login_bloc/auth_state.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';
import 'package:zedbee_bms/utils/app_colors.dart';
import 'package:zedbee_bms/utils/app_routes.dart';
import 'package:zedbee_bms/utils/internet_checker.dart';
import 'package:zedbee_bms/utils/local_storage.dart';
import 'package:zedbee_bms/utils/spacer_widget.dart';
import 'package:zedbee_bms/widgets_folder/widgets/auth_textfield.dart';
import 'package:zedbee_bms/widgets_folder/widgets/loading_indicator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final LocalStorage _localStorage = LocalStorage();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    final data = await _localStorage.getUserDetails();

    if (data['rememberMe']) {
      setState(() {
        emailController.text = data['email'] ?? '';
        passwordController.text = data['password'] ?? '';
        rememberMe = data['rememberMe'];
      });
    }
  }

  Future<void> handleRememberMe() async {
    if (rememberMe) {
      await _localStorage.saveUserDetails(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } else {
      await _localStorage.clearUserDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffF8FFF2),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthSuccess) {
            await handleRememberMe();
            final UserModel user = state.userModel;
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.locationList,
              arguments: {'user': user},
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Row(
              children: [
                // LEFT SIDE CONTAINER .......
                Container(
                  height: screenHeight,
                  width: screenWidth * 0.45,
                  decoration: BoxDecoration(
                    color: Color(0xffF8FFF2),
                    image: DecorationImage(
                      image: AssetImage("assets/login.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            
                // RIGHT SIDE (LOGIN PANEL)
                Container(
                  width: screenWidth * 0.55,
                  height: screenHeight,
                  color: const Color(0xffF3F7ED),
                  child: Stack(
                    children: [
                      /// TOP RIGHT CIRCLE
                      Positioned(
                        right: -120,
                        top: -120,
                        child: Container(
                          width: 300,
                          height: screenHeight / 2.5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.lightgreen.withOpacity(.25),
                          ),
                        ),
                      ),
            
                      /// FORM CENTER
                      Center(
                        child: SizedBox(
                          width: screenWidth * 0.45,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// ICON
                                Image.asset("assets/thunder.png", height: 60),
                                SpacerWidget.size16,
            
                                /// EMAIL LABEL
                                Text(
                                  "Email",
                                  style: TextStyle(
                                    color: AppColors.darkgreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
            
                                AuthTextfield(
                                  controller: emailController,
                                  label: "",
                                  validator: (v) =>
                                      v!.isEmpty ? "Email required" : null,
                                ),
            
                                SizedBox(height: 25),
            
                                /// PASSWORD LABEL
                                Text(
                                  "Password",
                                  style: TextStyle(
                                    color: AppColors.darkgreen,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
            
                                AuthTextfield(
                                  controller: passwordController,
                                  label: "",
                                  isPassword: true,
                                  validator: (v) =>
                                      v!.length < 6 ? "Min 6 chars" : null,
                                ),
            
                                SizedBox(height: 15),
            
                                /// REMEMBER + FORGOT
                                Row(
                                  children: [
                                    Checkbox(
                                      value: rememberMe,
                                      fillColor: WidgetStatePropertyAll(
                                        AppColors.green,
                                      ),
                                      onChanged: (v) =>
                                          setState(() => rememberMe = v!),
                                    ),
                                    const Text("Remember me"),
                                    const Spacer(),
                                    Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        color: AppColors.darkgreen,
                                      ),
                                    ),
                                  ],
                                ),
            
                                SizedBox(height: 30),
            
                                /// LOGIN BUTTON
                                SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: state is AuthLoading
                                        ? null
                                        : () async {
                                            if (!formKey.currentState!.validate()) {
                                              return;
                                            }
            
                                            bool ok =
                                                await InternetChecker.checkInternet(
                                                  context,
                                                );
                                            if (!ok) return;
            
                                            context.read<AuthBloc>().add(
                                              LoginRequested(
                                                emailController.text.trim(),
                                                passwordController.text.trim(),
                                              ),
                                            );
                                          },
                                    child: state is AuthLoading
                                        ? const AppLoader()
                                        : Text(
                                            "Login",
                                            style: TextStyle(
                                              fontSize: 5.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
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
          );
        },
      ),
    );
  }
}
