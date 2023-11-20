import 'package:flutter/material.dart';
import 'package:janin/view/signin/kodeotp.dart';
import 'package:janin/view/signin/signin.dart';
import 'package:janin/view/signin/wrapper.dart';
import 'package:provider/provider.dart';

import '../../provider/auth.dart';
import '../../theme.dart';

class LupaSandi extends StatefulWidget {
  const LupaSandi({super.key});

  @override
  State<LupaSandi> createState() => _LupaSandiState();
}

class _LupaSandiState extends State<LupaSandi> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

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
                builder: (context) => Wrapper(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          color: whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Lupa Kata Sandi?',
                    style: titleText,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    'Masukkan email dibawah ini untuk mengatur kata sandi ulang',
                    style: descriptionText.copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 220,
                ),
                Form(
                  key: formKey,
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
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: blackColor, width: 1),
                          ),
                          hintText: 'Masukkan Email Anda',
                          hintStyle: greyTextStyle.copyWith(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 130,
                ),
                Center(
                  child: Container(
                    height: 40,
                    width: 277,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // side: BorderSide(
                        //     color: blackColor,
                        //     width: 1,
                        //   ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: pinkColor,
                      ),
                      onPressed: () {
                        auth.resetPassword(
                          _emailController.text,
                          context,
                        );
                      },
                      child: Text(
                        'Kirim',
                        style: buttonText.copyWith(color: whiteColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
