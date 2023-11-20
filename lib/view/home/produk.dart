import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:janin/services/berandaservices.dart';
import 'package:janin/view/home/beranda.dart';
import 'package:janin/view/home/widget/produkcard.dart';
import '../../models/produkmodel.dart';
import '../../theme.dart';
import '../detail/produk.dart';

class Produk extends StatelessWidget {
  Produk({super.key});

  BerandaService berandaService = BerandaService();

  @override
  Widget build(BuildContext context) {
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
        title: Text('Produk', style: appBarStyle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder(
            stream: berandaService.streamProduk(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                var data = snapshot.data!.docs;
                return Stack(
                  children: [
                    GridView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.9,
                        mainAxisExtent: 290,
                      ),
                      itemBuilder: (context, index) {
                        final dataProduk =
                            data[index].data() as Map<String, dynamic>;
                        return ProdukCard(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (contex) =>
                                    ProdukDetail(idDoc: data[index].id),
                              ),
                            );
                          },
                          produkModel: ProdukModel(
                            nama: dataProduk['nama'],
                            logo: dataProduk['logo'],
                            kategori: dataProduk['kategori'],
                            rate: dataProduk['rate'],
                          ),
                        );
                      },
                    ),
                  ],
                );
              } else {
                return const Center(
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
