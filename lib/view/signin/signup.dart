import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:janin/provider/auth.dart';
import 'package:janin/provider/iconkatasandi.dart';
import 'package:janin/view/signin/signin.dart';
import 'package:provider/provider.dart';
import '../../theme.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: false);
    final _formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController namaController = TextEditingController();
    TextEditingController noController = TextEditingController();

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
                builder: (context) => SignIn(),
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
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Daftar Akun',
                      style: titleText,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Masukkan data dibawah ini untuk mempunyai akun',
                      style: descriptionText.copyWith(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(),
                      ),
                      Text(
                        'daftar',
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        child: Divider(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //namalengkap
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama Lengkap',
                          style: labelText,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: namaController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(),
                            ),
                            hintText: 'Anindira Alista',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nama tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //email
                        Text(
                          'Email',
                          style: labelText,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(),
                            ),
                            hintText: 'anindira@gmail.com',
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
                        //nohp
                        Text(
                          'No HP',
                          style: labelText,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: noController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(),
                            ),
                            hintText: '08xxxxxxxxxx',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'No HP tidak boleh kosong';
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
                    height: 50,
                  ),
                  //Button
                  Center(
                    child: Container(
                      width: 277,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // side: BorderSide(
                          //   color: blackColor,
                          //   width: 1,
                          // ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: pinkColor,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) ;
                          auth.SignUpProvider(
                            emailController.text,
                            passwordController.text,
                            namaController.text,
                            noController.text,
                            context,
                          );
                        },
                        child: Text(
                          'Daftar',
                          style: buttonText.copyWith(
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          'Sudah Punya Akun?',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Masuk',
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
        ),
      ),
    );
  }
}
