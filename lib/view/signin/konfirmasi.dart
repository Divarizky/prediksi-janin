import 'package:flutter/material.dart';
import 'package:janin/theme.dart';
import 'package:janin/view/signin/lupasandi.dart';
import 'package:janin/view/signin/wrapper.dart';

class KonfirmasiPassword extends StatefulWidget {
  const KonfirmasiPassword({super.key});

  @override
  State<KonfirmasiPassword> createState() => _KonfirmasiPasswordState();
}

class _KonfirmasiPasswordState extends State<KonfirmasiPassword> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

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
                builder: (context) => LupaSandi(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Ubah Kata Sandi',
                  style: titleText,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Identitasmu telah terverifikasi buat kata sandi baru ',
                  style: descriptionText.copyWith(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 145,
              ),
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Kata Sandi Baru
                    Text(
                      'Kata Sandi Baru',
                      style: labelText,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: blackColor, width: 1),
                        ),
                        hintText: 'Masukkan Kata Sandi Baru',
                        hintStyle: greyTextStyle.copyWith(fontSize: 14),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    //Konfirmasi Kata Sandi Baru
                    Text(
                      'Konfirmasi Kata Sandi Baru',
                      style: labelText,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: blackColor,
                            width: 1,
                          ),
                        ),
                        hintText: 'Konfirmasi Kata Sandi Baru',
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
                    onPressed: () async {},
                    child: Text(
                      'Selanjutnya',
                      style: buttonText.copyWith(color: whiteColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
