import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:janin/theme.dart';
import '../../services/berandaservices.dart';

class ProdukDetail extends StatelessWidget {
  final String idDoc;
  const ProdukDetail({
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
        title: Text('Produk Detail', style: appBarStyle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: berandaService.getByIDProduk(idDoc),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var datas = snapshot.data!;
              final data = snapshot.data!.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Image.network(
                      data["logo"],
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      data["nama"],
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
                        data["deskripsi"],
                        style: descriptionText,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
