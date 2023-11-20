import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:janin/services/berandaservices.dart';
import 'package:janin/view/home/beranda.dart';
import 'package:janin/view/home/navbar.dart';
import 'package:janin/view/home/widget/tipscard.dart';
import '../../models/tipsmodel.dart';
import '../../theme.dart';
import '../detail/detailtips.dart';

class Tips extends StatelessWidget {
  Tips({super.key});

  BerandaService berandaService = BerandaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Tips', style: appBarStyle),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot<Object?>>(
                stream: berandaService.streamTips(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    var data = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      primary: false,
                      itemCount: data.length,
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
                          },
                        );
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
    );
  }
}
