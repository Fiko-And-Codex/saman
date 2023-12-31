import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:saman/components/text_form_builder.dart';
import 'package:saman/widgets/progress_indicators.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../components/pass_form_builder.dart';
import '../utilities/regex.dart';
import '../view_models/auth/register_view_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  @override
  Widget build(BuildContext context) {
    RegisterViewModel viewModel = Provider.of<RegisterViewModel>(context);

    buildForm(RegisterViewModel viewModel, BuildContext context){

      return Form(
        key: viewModel.registerFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormBuilder(
              capitalization: false,
              enabled: !viewModel.loading,
              prefix: CupertinoIcons.person_solid,
              hintText: "Kullanıcı Adı",
              textInputAction: TextInputAction.next,
              validateFunction: Regex.validateUsername,
              onSaved: (String val) {
                viewModel.setUsername(val);
              },
              focusNode: viewModel.usernameFocusNode,
              nextFocusNode: viewModel.emailFocusNode,
              whichPage: "signup",
            ),
            const SizedBox(height: 10.0),
            TextFormBuilder(
              capitalization: false,
              enabled: !viewModel.loading,
              prefix: CupertinoIcons.mail_solid,
              hintText: "E-Mail",
              textInputAction: TextInputAction.next,
              validateFunction: Regex.validateEmail,
              onSaved: (String val) {
                viewModel.setEmail(val);
              },
              focusNode: viewModel.emailFocusNode,
              nextFocusNode: viewModel.countryFocusNode,
              whichPage: "signup",
            ),
            const SizedBox(height: 10.0),
            TextFormBuilder(
              capitalization: true,
              enabled: !viewModel.loading,
              prefix: CupertinoIcons.globe,
              hintText: "Ülke",
              textInputAction: TextInputAction.next,
              validateFunction: Regex.validateCountry,
              onSaved: (String val) {
                viewModel.setCountry(val);
              },
              focusNode: viewModel.countryFocusNode,
              nextFocusNode: viewModel.passFocusNode,
              whichPage: "signup",
            ),
            const SizedBox(height: 10.0),
            PasswordFormBuilder(
              enabled: !viewModel.loading,
              prefix: Ionicons.lock_closed,
              suffix: Ionicons.eye_outline,
              hintText: "Şifre",
              textInputAction: TextInputAction.next,
              validateFunction: Regex.validatePassword,
              obscureText: true,
              onSaved: (String val) {
                viewModel.setPassword(val);
              },
              focusNode: viewModel.passFocusNode,
              nextFocusNode: viewModel.cPassFocusNode,
              whichPage: "signup",
            ),
            const SizedBox(height: 10.0),
            PasswordFormBuilder(
              enabled: !viewModel.loading,
              prefix: Ionicons.lock_open,
              suffix: Ionicons.eye_outline,
              hintText: "Şifre Tekrarı",
              textInputAction: TextInputAction.done,
              validateFunction: Regex.validatePassword,
              submitAction: () => viewModel.register(context),
              obscureText: true,
              onSaved: (String val) {
                viewModel.setConfirmPass(val);
              },
              focusNode: viewModel.cPassFocusNode,
              whichPage: "signup",
            ),
            const SizedBox(height: 10.0),
            const Text(
              textAlign: TextAlign.center,
              'Kaydolarak Kullanım Koşullarımızı ve Gizlilik Politikamızı kabul etmiş olursunuz.',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 40.0,
              width: 200.0,
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Text(
                  'Kayıt Ol',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => viewModel.register(context),
              ),
            ),
          ],
        ),
      );
    }

    return FlutterWebFrame(
      builder: (context) {

        return LoadingOverlay(
            isLoading: viewModel.loading,
            progressIndicator: circularProgress(context, const Color(0XFF03A9F4)),
            opacity: 0.5,
            color: Theme.of(context).colorScheme.background,
            child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    icon: const Icon(CupertinoIcons.chevron_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    iconSize: 30.0,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                extendBodyBehindAppBar: true,
                backgroundColor: Theme.of(context).colorScheme.background,
                key: viewModel.registerScaffoldKey,
                body: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 10),
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        GradientText(
                          "Sinoord'a hoş geldiniz.\nYeni bir hesap oluşturun & \nArkadaşlarınızla bağlantı kurun.",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ), colors: const [
                          Colors.blue,
                          Colors.purple,
                          Colors.pink,
                        ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    buildForm(viewModel, context),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Zaten bir hesabınız var'mı?",
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Text(
                            ' Giriş Yap.',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
            ));
      },
      maximumSize: const Size(475.0, 812.0),
      enabled: kIsWeb,
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}
