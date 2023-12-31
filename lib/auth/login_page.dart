import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:saman/auth/register_page.dart';
import 'package:saman/widgets/progress_indicators.dart';

import '../components/pass_form_builder.dart';
import '../components/text_form_builder.dart';
import '../utilities/regex.dart';
import '../view_models/auth/login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoginViewModel viewModel = Provider.of<LoginViewModel>(context);

    buildForm(BuildContext context, LoginViewModel viewModel) {

      return Form(
        key: viewModel.loginFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(children: [
          TextFormBuilder(
            capitalization: false,
            enabled: !viewModel.loading,
            prefix: CupertinoIcons.mail_solid,
            hintText: 'E-Mail Adresiniz',
            textInputAction: TextInputAction.next,
            validateFunction: Regex.validateEmail,
            onSaved: (String value) {
              viewModel.setEmail(value);
            },
            focusNode: viewModel.emailFocusNode,
            nextFocusNode: viewModel.passwordFocusNode,
            whichPage: "login",
          ),
          const SizedBox(height: 10.0),
          PasswordFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.lock_closed,
            suffix: Ionicons.eye_outline,
            hintText: "Şifreniz",
            textInputAction: TextInputAction.done,
            validateFunction: Regex.validatePassword,
            submitAction: () => viewModel.loginUser(context),
            obscureText: true,
            onSaved: (String val) {
              viewModel.setPassword(val);
            },
            focusNode: viewModel.passwordFocusNode,
            whichPage: "login",
          ),
          const SizedBox(
            height: 10.0,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: InkWell(
                onTap: () => viewModel.forgotPassword(context),
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Şifrenimi Unuttun?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          SizedBox(
            height: 40.0,
            width: 200.0,
            child: FloatingActionButton(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Text(
                'Giriş Yap',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => viewModel.loginUser(context),
            ),
          ),
        ]),
      );
    }

    return FlutterWebFrame(
      builder: (context) {

        return LoadingOverlay(
          progressIndicator: circularProgress(context, const Color(0xFFFF9800)),
          opacity: 0.5,
          color: Theme.of(context).colorScheme.background,
          isLoading: viewModel.loading,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: AppBar(
                automaticallyImplyLeading: false,
              ),
            ),
            extendBodyBehindAppBar: true,
            backgroundColor: Theme.of(context).colorScheme.background,
            key: viewModel.loginScaffoldKey,
            body: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              children: [
                SizedBox(
                  height: kIsWeb == false ? MediaQuery.of(context).size.height * 0.50 : MediaQuery.of(context).size.height * 0.40,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'assets/images/login_img.png',
                  ),
                ),
                const Center(
                  child: Text(
                    'Tekrar Hoşgeldin!',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'Giriş yap. Eğlencen seni bekliyor!',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(height: 25.0),
                buildForm(context, viewModel),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Henüz bir hesabınız yok mu?',
                        style: TextStyle(fontSize: 15.0)),
                    const SizedBox(width: 5.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Kayıt Ol.',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      maximumSize: const Size(475.0, 812.0),
      enabled: kIsWeb,
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
