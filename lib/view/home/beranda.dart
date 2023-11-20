import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
          //app_bar
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),

                //user_name
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

                //prediksi_form
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xffffe0d0),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  //prediksi_animation
                  child: Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                      ),
                      SizedBox(
                        width: 20,
                      ),

                      //content_prediksiForm
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Untuk mengetahui kondisi janin anda dapat mengisi form dengan klik button prediksi janin',
                              style: descriptionText.copyWith(fontSize: 12),
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            //prediksiForm_button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(12),
                                backgroundColor: pinkColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PrediksiForm()));
                              },
                              child: Center(
                                child: Text('Prediksi Janin'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Produk Untuk Moms',
                      style: GoogleFonts.poppins(
                        color: pinkColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Produk(),
                          ),
                        );
                      },
                      child: Text(
                        'Lihat Semua',
                        style: buttonlabelhomeText.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot<Object?>>(
                  stream: berandaService.streamProduk(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      var data = snapshot.data!.docs;
                      return SizedBox(
                        height: 280,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.9,
                            mainAxisExtent: 190,
                          ),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            final dataProduk =
                                data[index].data() as Map<String, dynamic>;
                            return ProdukCard(
                              produkModel: ProdukModel(
                                logo: dataProduk['logo'],
                                nama: dataProduk['nama'],
                                kategori: dataProduk['kategori'],
                                rate: dataProduk['rate'],
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProdukDetail(
                                      idDoc: data[index].id,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tips',
                      style: GoogleFonts.poppins(
                        color: pinkColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TipsBeranda(),
                          ),
                        );
                      },
                      child: Text(
                        'Lihat Semua',
                        style: buttonlabelhomeText.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot<Object?>>(
                  stream: berandaService.streamTips(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      var data = snapshot.data!.docs;
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        primary: false,
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          final dataTips =
                              data[index].data() as Map<String, dynamic>;
                          return TipsCard(
                              tipsModel: TipsModel(
                                logoT: dataTips['logoT'],
                                namaT: dataTips['namaT'],
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TipsDetail(
                                      idDoc: data[index].id,
                                    ),
                                  ),
                                );
                              });
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
