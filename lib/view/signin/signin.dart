import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:janin/provider/auth.dart';
import 'package:janin/provider/iconkatasandi.dart';
import 'package:janin/theme.dart';
import 'package:janin/view/signin/lupasandi.dart';
import 'package:janin/view/signin/signup.dart';
import 'package:janin/view/splashscreen/onboardingpage.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: pinkColor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OnBoardingPage(),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          color: whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Text judul
                Center(
                  child: Text(
                    'Selamat Datang',
                    style: titleText,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    'Masuk dengan akun yang kamu miliki',
                    style: descriptionText.copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //Image
                Container(
                  height: 180,
                  width: 400,
                  child: Image.asset('assets/image/logo.png'),
                ),
                const SizedBox(
                  height: 30,
                ),
                //Email
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: labelText,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        controller: emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: 'Masukkan Email',
                          hintStyle: greyTextStyle.copyWith(fontSize: 14),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //Kata Sandi
                      Text(
                        'Kata Sandi',
                        style: labelText,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Consumer<IconKataSandi>(
                        builder: (context, data, _) {
                          return TextFormField(
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              hintText: 'Masukkan Kata Sandi',
                              hintStyle: greyTextStyle.copyWith(fontSize: 14),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  data.changeVisible(data.isvisible);
                                },
                                icon: Icon(
                                  data.isvisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            obscureText: !data.isvisible,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                //Lupa Sandi
                Container(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LupaSandi(),
                        ),
                      );
                    },
                    child: Text(
                      'Lupa Kata Sandi?',
                      style: labelText,
                    ),
                  ),
                ),
                //Button
                Center(
                  child: Container(
                    height: 40,
                    width: 277,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: pinkColor,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) ;
                        auth.SignInProvider(
                          emailController.text,
                          passwordController.text,
                          context,
                        );
                      },
                      child: Text(
                        'Masuk',
                        style: buttonText.copyWith(
                          color: whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
                //Google
                // Center(
                //   child: FloatingActionButton.extended(
                //     onPressed: () async {
                //       await auth.signInWithGoogle();
                //       if (mounted) {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => Navbar(),
                //           ),
                //         );
                //       }
                //     },
                //     icon: Image.asset(
                //       'assets/image/google.png',
                //       height: 24,
                //       width: 24,
                //     ),
                //     label: Text(
                //       'Masuk Dengan Google',
                //       style: GoogleFonts.poppins(fontSize: 12),
                //     ),
                //     backgroundColor: Colors.white,
                //     foregroundColor: Colors.black,
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text('Belum Punya Akun?',
                          style: GoogleFonts.poppins(fontSize: 12)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ),
                        );
                      },
                      child: Text(
                        'Daftar',
                        style: buttonlabelText.copyWith(
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
