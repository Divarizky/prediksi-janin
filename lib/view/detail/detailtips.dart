import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:janin/services/berandaservices.dart';
import 'package:janin/theme.dart';

class TipsDetail extends StatelessWidget {
  final String idDoc;
  const TipsDetail({
    Key? key,
    required this.idDoc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BerandaService berandaService = BerandaService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: blackColor,
          ),
        ),
        title: Text('Tips Detail', style: appBarStyle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: berandaService.getByIDTips(idDoc),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var datas = snapshot.data!;
                final data = snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Image.network(
                      data["logoT"],
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      data["namaT"],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: pinkColor,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        data["deskripsiT"],
                        style: descriptionText,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
