import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:janin/models/produkmodel.dart';
import 'package:janin/models/tipsmodel.dart';
import 'package:janin/provider/auth.dart';
import 'package:janin/services/berandaservices.dart';
import 'package:janin/theme.dart';
import 'package:janin/view/detail/detailtips.dart';
import 'package:janin/view/detail/produk.dart';
import 'package:janin/view/home/prediksi.dart';
import 'package:janin/view/home/produk.dart';
import 'package:janin/view/home/tips_beranda.dart';
import 'package:janin/view/home/widget/produkcard.dart';
import 'package:janin/view/home/widget/tipscard.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Beranda extends StatefulWidget {
  // final String idDoc;
  Beranda({
    Key? key,
    // required this.idDoc,
  }) : super(key: key);

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  String? id = "";

  @override
  void initState() {
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // Auth auth = Provider.of<Auth>(context, listen: false);
    setState(() {
      id = pref.getString("uid");
    });
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context, listen: false);
    BerandaService berandaService = BerandaService();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),

                // username
                Text(
                  'Hi, Moms',
                  style: labelText.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                FutureBuilder<void>(
                  future: Future.delayed(Duration(milliseconds: 1)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return StreamBuilder<DocumentSnapshot<Object?>>(
                        stream: berandaService.streamUserByUID(id!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData && snapshot.data!.exists) {
                              var dataUsers =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              String namaController =
                                  dataUsers['namaController'] ??
                                      'Nama Pengguna Tidak Ditemukan';
                              return Text(
                                namaController,
                                style: descriptionText.copyWith(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              );
                            } else {
                              return Text('Data pengguna tidak ditemukan');
                            }
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      );
                    } else {
                      return Text('Terjadi kesalahan');
                    }
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                // Banner Prediksi Janin
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xffffe0d0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/image/prediction.svg',
                        height: 100,
                      ),
                      SizedBox(width: 20),

                      // Konten Banner
                      Expanded(
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Untuk mengetahui kondisi janin klik Prediksi Janin',
                                style: descriptionText.copyWith(fontSize: 12)),

                            SizedBox(
                              height: 10,
                            ),

                            // Button Prediksi Form
                            TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 10),
                                  backgroundColor: pinkColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: Text(
                                'Prediksi Janin',
                                style: buttonText.copyWith(color: whiteColor),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PrediksiForm()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
