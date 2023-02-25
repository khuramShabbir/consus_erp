import 'package:consus_erp/Providers/UserAuth/login_provider.dart';
import 'package:consus_erp/Widgets/extended_button.dart';
import 'package:consus_erp/Widgets/form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:provider/provider.dart';

import 'forgot_password_screen.dart';
import 'full_app.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginProvider loginProvider;

  @override
  void initState() {
    super.initState();
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: FxSpacing.nBottom(20),
        child: Form(
          key: loginProvider.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              title(),
              FxSpacing.height(20),
              AppFormField(
                controller: loginProvider.userNameCtrl,
                labelText: "User",
                validator: (value) {
                  if (value!.isEmpty) return "Required";
                  return null;
                },
              ),
              FxSpacing.height(10),
              AppFormField(
                controller: loginProvider.passwordCtrl,
                labelText: "Password",
                validator: (value) {
                  if (value!.isEmpty) return "Required";
                  return null;
                },
                isPasswordField: true,
              ),
              Consumer<LoginProvider>(
                builder: (BuildContext context, obj, Widget? child) {
                  return CheckboxListTile(
                    title: Text("Remember me"),
                    value: obj.rememberMe,
                    onChanged: (newValue) {
                      obj.remember();
                    },
                    controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                  );
                },
              ),
              FxSpacing.height(10),
              ExtendedButton(
                text: 'Login',
                onTap: () async {
                  bool result = await loginProvider.login();
                  if (result)
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ShoppingManagerFullApp();
                    }));
                },
              ),
              FxSpacing.height(10),
            ],
          ),
        ),
      ),
    );
  }

  Widget title() {
    return Align(
      alignment: Alignment.centerLeft,
      child: FxText.headlineMedium(
        "Consus ERP Sign In",
        fontWeight: 700,
      ),
    );
  }

  Widget forgetPassword() {
    return TextButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return ForgotPasswordScreen();
        }));
      },
      child: Text(
        "Forget Password",
        style: TextStyle(fontSize: 13),
      ),
    );
  }
}
