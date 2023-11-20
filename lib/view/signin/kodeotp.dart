import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:janin/theme.dart';
import 'package:janin/view/signin/konfirmasi.dart';
import 'package:janin/view/signin/wrapper.dart';

class Kodeotp extends StatefulWidget {
  const Kodeotp({super.key});

  @override
  State<Kodeotp> createState() => _KodeotpState();
}

class _KodeotpState extends State<Kodeotp> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: Text(
                      'Verifikasi Kode OTP',
                      style: titleText,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      'Masukkan kode OTP yang telah dikirimkan ke email anda',
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 120,
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: pinkColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KonfirmasiPassword(),
                            ),
                          );
                        },
                        child: Text(
                          'Selanjutnya',
                          style: buttonText.copyWith(color: whiteColor),
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
                        child: Text('Tidak Terima Kode OTP',
                            style: GoogleFonts.poppins(fontSize: 12)),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Kirim OTP',
                          style: buttonlabelText,
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
