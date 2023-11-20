import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:janin/services/tentangService.dart';
import 'package:janin/theme.dart';

class Tentang extends StatelessWidget {
  const Tentang({super.key});

  @override
  Widget build(BuildContext context) {
    TentangService tentangService = TentangService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: blackColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Tentang Kami',
          style: appBarStyle,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: 80,
                      width: 80,
                      child: Image.asset('assets/image/logo.png'),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Fetal Healt',
                      style: appBarStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<QuerySnapshot<Object?>>(
                  stream: tentangService.streamTentang(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView(
                      shrinkWrap: true,
                      primary: false,
                      children: snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                data['penjelasan'],
                                style: descriptionText,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          );
                        },
                      ).toList(),
                    );
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
