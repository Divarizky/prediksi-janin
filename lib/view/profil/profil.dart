import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:janin/provider/auth.dart';
import 'package:janin/services/berandaservices.dart';
import 'package:janin/theme.dart';
import 'package:janin/view/home/beranda.dart';
import 'package:janin/view/profil/editprofil.dart';
import 'package:janin/view/profil/tentang.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
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

  BerandaService berandaService = BerandaService();
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                builder: (context) => Beranda(),
              ),
            );
          },
        ),
        title: Text(
          'Profil',
          style: appBarStyle,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<void>(
                future: Future.delayed(Duration(milliseconds: 1)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show loading indicator during delay
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return StreamBuilder<DocumentSnapshot<Object?>>(
                      stream: berandaService.streamUserByUID(
                          id!), // Ganti dengan metode yang benar
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.hasData && snapshot.data!.exists) {
                            var dataUsers =
                                snapshot.data!.data() as Map<String, dynamic>;
                            final imageUrl = dataUsers['image'] as String?;
                            return Center(
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl ??
                                        "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.flaticon.com%2Ffree-icon%2Fperson_2815428&psig=AOvVaw1e-b3qtOkgeGh5i5T4Cn3V&ust=1692548372281000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCIja1JaQ6YADFQAAAAAdAAAAABAE"),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<void>(
              future: Future.delayed(Duration(milliseconds: 1)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show loading indicator during delay
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return StreamBuilder<DocumentSnapshot<Object?>>(
                    stream: berandaService.streamUserByUID(id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData && snapshot.data!.exists) {
                          var dataUsers =
                              snapshot.data!.data() as Map<String, dynamic>;
                          String namaController = dataUsers['namaController'] ??
                              'Nama Pengguna Tidak Ditemukan';
                          return Text(namaController);
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
            FutureBuilder<void>(
                future: Future.delayed(Duration(milliseconds: 1)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Show loading indicator during delay
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return StreamBuilder<DocumentSnapshot<Object?>>(
                      stream: berandaService.streamUserByUID(
                          id!), // Ganti dengan metode yang sesuai
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.hasData && snapshot.data!.exists) {
                            var dataUsers =
                                snapshot.data!.data() as Map<String, dynamic>;

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfil(
                                      email: dataUsers['emailController'],
                                      nama: dataUsers['namaController'],
                                      no: dataUsers['noController'],
                                      image: dataUsers['image'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 44,
                                width: 325,
                                decoration: BoxDecoration(
                                  border: Border.all(color: blackColor),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: pinkColor,
                                      ),
                                      // const SizedBox(
                                      //   width: 30,
                                      // ),
                                      Text(
                                        'Edit Profile',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: blackColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 150,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Text('Data not found');
                          }
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Tentang(),
                  ),
                );
              },
              child: Container(
                height: 44,
                width: 325,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: blackColor),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.info,
                        color: pinkColor,
                      ),
                      // const SizedBox(
                      //   width: 30,
                      // ),
                      Text(
                        'Tentang Kami',
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: blackColor),
                      ),
                      const SizedBox(
                        width: 120,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                width: 277,
                child: ElevatedButton.icon(
                  onPressed: () {
                    auth.logOut(context);
                  },
                  icon: Icon(
                    Icons.logout,
                    color: whiteColor,
                  ),
                  label: Text(
                    'Keluar',
                    style: buttonText.copyWith(color: whiteColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    // side: BorderSide(width: 2, color: blackColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: pinkColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
