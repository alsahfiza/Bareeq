import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bareeq/admin/core/view_models/auth_provider.dart';
import 'package:bareeq/admin/core/models/user_model.dart';
import '../routes/route_name.dart';
import '../utils/ui_tools/my_alert_dialog.dart';
import '../widgets/reusable_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late FocusNode _passwordNode;
  late FocusNode _emailNode;
  late UserModel _userModel;

  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;

  bool _isEmailValid = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordNode = FocusNode();
    _emailNode = FocusNode();
    _userModel = UserModel();
  }

  @override
  void dispose() {
    _passwordNode.dispose();
    _emailNode.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (!isValid) return;

    _formKey.currentState!.save();

    final authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    setState(() => _isLoading = true);

    try {
      await authProvider.signUp(
        email: _userModel.email.toLowerCase().trim(),
        password: _password.trim(),
        userModel: _userModel,
      );

      if (!mounted) return;

      Navigator.of(context).pushNamedAndRemoveUntil(
        RouteName.bottomBarScreen,
        (_) => false,
      );
    } catch (e) {
      final msg = e.toString().toLowerCase();
      if (msg.contains('email')) {
        _isEmailValid = false;
        _formKey.currentState!.validate();
      } else if (msg.contains('network')) {
        MyAlertDialog.connectionError(context);
      } else {
        MyAlertDialog.error(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            MediaQuery.of(context).size.height * 0.06,
            20,
            16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sign Up',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.07),

              if (!_isEmailValid)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'This email already exists. Please login or reset password.',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ReusableTextField(
                      valueKey: 'email',
                      focusNode: _emailNode,
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          value == null ||
                                  !EmailValidator.validateEmail(value)
                              ? 'Enter a valid email'
                              : null,
                      onEditingComplete: () =>
                          FocusScope.of(context)
                              .requestFocus(_passwordNode),
                      onSaved: (value) => _email = value!,
                    ),

                    PasswordTextField(
                      focusNode: _passwordNode,
                      label: 'Password',
                      validator: (value) =>
                          value != null && value.length < 6
                              ? 'Password must be at least 6 characters'
                              : null,
                      onSaved: (value) => _password = value!,
                      onEditingComplete: _submitForm,
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Sign Up'),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(
                              context,
                              RouteName.logInScreen,
                            );
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailValidator {
  static bool validateEmail(String email) {
    final emailReg = RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@'
      r'((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|'
      r'(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    return emailReg.hasMatch(email);
  }
}
