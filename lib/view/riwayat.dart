import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:janin/provider/auth.dart';
import 'package:janin/provider/prediksi.dart';
import 'package:janin/services/prediksiservices.dart';
import 'package:provider/provider.dart';
import '../theme.dart';

class Riwayat extends StatelessWidget {
  const Riwayat({super.key});

  @override
  Widget build(BuildContext context) {
    PrediksiProvider prediksiProvider =
        Provider.of<PrediksiProvider>(context, listen: false);
    PrediksiService prediksiService = PrediksiService();
    Auth auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          'Riwayat Prediksi',
          style: appBarStyle,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder(
            stream: prediksiService.streamPrediksiByUserId(auth.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                var data = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final dataRiwayat =
                        data[index].data() as Map<String, dynamic>;
                    Timestamp t = dataRiwayat['timestamp'] as Timestamp;
                    DateTime date = t.toDate();
                    // final formattedTimestamp = timestamp.toDate().toString();
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          title: Text(dataRiwayat['result']),
                          subtitle: Text(
                            'Janin dalam kandungan anda ${dataRiwayat['result']}',
                          ),
                          trailing: Text(
                            '${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                );
              } else {
                return Center(
                  child: const Text("Riwayat"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
