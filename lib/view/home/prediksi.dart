import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:janin/provider/prediksi.dart';
import 'package:provider/provider.dart';
import 'package:janin/provider/auth.dart';
import 'package:http/http.dart' as http;
import 'package:janin/view/home/navbar.dart';
import '../../theme.dart';
import 'dart:convert';

class PrediksiForm extends StatefulWidget {
  const PrediksiForm({super.key});

  @override
  State<PrediksiForm> createState() => _PrediksiFormState();
}

class _PrediksiFormState extends State<PrediksiForm> {
  final TextEditingController usia_ibu = TextEditingController();
  final TextEditingController usia_kandungan = TextEditingController();
  final TextEditingController riwayat_caesar = TextEditingController();

  String result = "";

  // List DropDown Golongan Darah
  String? selectedGolongan_darah;
  final List<String> golongan_darah = [
    "A",
    "B",
    "AB",
    "O",
    "Tidak Tahu",
  ];

  // List Dropdown Jenis Rhesus
  String? selectedRhesus;
  final List<String> rhesus = [
    "Positif (+)",
    "Negatif (-)",
    "Tidak Tahu",
  ];

  // List Dropdown Hamil ke Berapa
  String? selectedHamil;
  final List<String> jml_hamil = [
    "Ke-1",
    "Ke-2",
    "Ke-3",
    "Ke-4",
    "Lebih dari 4",
  ];

  // List Dropdown Jumlah Persalinan
  String? selectedLahir;
  final List<String> jml_lahir = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "Lebih dari 4",
  ];

  // List dropdown jumlah keguguran
  String? selectedGugur;
  final List<String> jml_keguguran = [
    "0",
    "1",
    "2",
    "3",
    "Lebih dari 3",
  ];

  // value RadioButton
  String selectedKehamilan_diinginkan = '';
  String selectedPenggunaan_alkohol = '';
  String selected_perokok = '';
  String selected_narkoba = '';
  String selected_polusi = '';
  String selectedPendarahaan_pasca_lahir = '';
  String selectedPendarahan_ketika_hamil = '';
  String selected_gadget = '';
  String selectedRiwayat_kelainan = '';
  String selected_alergi = '';
  String selectedPernah_caesar = '';

  // checkboxformValues
  List<Map> riwayat_penyakit = [
    {'name': 'Anemia', 'isChecked': false},
    {'name': 'Hipertensi', 'isChecked': false},
    {'name': 'Preeklampsi', 'isChecked': false},
    {'name': 'Diabetes', 'isChecked': false},
    {'name': 'Paru-paru', 'isChecked': false},
    {'name': 'Ginjal', 'isChecked': false},
    {'name': 'Jantung', 'isChecked': false},
    {'name': 'Lainnya', 'isChecked': false},
    {'name': 'Tidak ada', 'isChecked': false},
  ];

  List<Map> penyakit_turunan = [
    {'name': 'Anemia', 'isChecked': false},
    {'name': 'Hipertensi', 'isChecked': false},
    {'name': 'Preeklampsi', 'isChecked': false},
    {'name': 'Diabetes', 'isChecked': false},
    {'name': 'Paru-paru', 'isChecked': false},
    {'name': 'Ginjal', 'isChecked': false},
    {'name': 'Jantung', 'isChecked': false},
    {'name': 'Lainnya', 'isChecked': false},
    {'name': 'Tidak ada', 'isChecked': false},
  ];

  Future<void> predictJanin() async {
    final url =
        'http://153.92.4.162:5002/predict'; // Ganti dengan alamat Flask server
    final headers = {'Content-Type': 'application/json'};
    final data = {
      'usia_ibu': usia_ibu.text,
      'usia_kandungan': usia_kandungan.text,
      'golongan_darah': selectedGolongan_darah,
      'rhesus': selectedRhesus,
      'hamil_ke_brp': selectedHamil,
      'jumlah_persalinan': selectedLahir,
      'jumlah_keguguran': selectedGugur,
      'kehamilan_diinginkan': selectedKehamilan_diinginkan,
      'penggunaan_alkohol': selectedPenggunaan_alkohol,
      'perokok': selected_perokok,
      'narkoba': selected_narkoba,
      'polusi': selected_polusi,
      'pendarahaan_pasca_lahir': selectedPendarahaan_pasca_lahir,
      'pendarahan_ketika_hamil': selectedPendarahan_ketika_hamil,
      'gadget': selected_gadget,
      'riwayat_kelainan': selectedRiwayat_kelainan,
      'alergi': selected_alergi,
      'pernah_caesar': selectedPernah_caesar,
      'riwayat_caesar': riwayat_caesar.text,
      'riwayat_penyakit': riwayat_penyakit,
      'penyakit_turunan': penyakit_turunan,
    };

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      PrediksiProvider prediksiProvider =
          Provider.of<PrediksiProvider>(context, listen: false);
      Auth auth = Provider.of<Auth>(context, listen: false);

      final responseData = jsonDecode(response.body);
      setState(() {
        prediksiProvider.setResult(
          responseData['result'] == 0
              ? 'Berisiko Tinggi'
              : responseData['result'] == 1
                  ? 'Normal'
                  : responseData['result'] == 2
                      ? 'Berisiko Rendah'
                      : 'Sangat Berisiko',
        );

        // firestore
        FirebaseFirestore.instance.collection("hasil_prediksi").add({
          'id': auth.id,
          'result': prediksiProvider.result,
          'timestamp': FieldValue.serverTimestamp(),
        });
      });
    } else {
      setState(() {
        result = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: pinkColor,
          ),
        ),
        title: Text(
          'Prediksi Janin',
          style: appBarStyle,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: whiteColor,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      'Usia Ibu Hamil (Tahun)',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    // Tooltip_fitur1
                    Tooltip(
                      message: 'Isikan usia atau umur ibu hamil.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 4),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: usia_ibu,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Contoh: 23',
                    hintStyle: greyTextStyle.copyWith(fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'Usia Kandungan (Minggu)',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur2
                    Tooltip(
                      message:
                          'Isikan minggu kehamilan.\notValue(Isikan lebih dari 1 Minggu atau kurang dari 42 Minggu)',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 5),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                TextFormField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: usia_kandungan,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Contoh: 23',
                    hintStyle: greyTextStyle.copyWith(fontSize: 14),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Text(
                      'Golongan Darah',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur3
                    Tooltip(
                      message: 'Pilih golongan darah ibu hamil.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 3),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),

                Container(
                  padding: EdgeInsets.only(
                      left: 16, right: 16), // padding text in box
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: DropdownButton<String?>(
                    hint: Text("Pilih golongan darah"),
                    underline: SizedBox(),
                    isExpanded: true,
                    value: selectedGolongan_darah,
                    onChanged: (value) {
                      setState(() {
                        selectedGolongan_darah = value;
                      });
                    },
                    items: golongan_darah
                        .map((e) => DropdownMenuItem(
                              child: Text(e.toString()),
                              value: e,
                            ))
                        .toList(),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Text(
                      'Rhesus',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur4
                    Tooltip(
                      message: 'Pilih rhesus ibu hamil.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 3),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),

                Container(
                  padding: EdgeInsets.only(
                      left: 16, right: 16), // padding text in box
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: DropdownButton<String?>(
                    hint: Text("Pilih opsi"),
                    underline: SizedBox(),
                    isExpanded: true,
                    value: selectedRhesus,
                    onChanged: (value) {
                      setState(() {
                        selectedRhesus = value;
                      });
                    },
                    items: rhesus
                        .map((e) => DropdownMenuItem(
                              child: Text(e.toString()),
                              value: e,
                            ))
                        .toList(),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Text(
                      'Hamil ke Berapa',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur5
                    Tooltip(
                      message: 'Jelas.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 3),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),

                Container(
                  padding: EdgeInsets.only(
                      left: 16, right: 16), // padding text in box
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: DropdownButton<String?>(
                    hint: Text("Pilih opsi"),
                    underline: SizedBox(),
                    isExpanded: true,
                    value: selectedHamil,
                    onChanged: (value) {
                      setState(() {
                        selectedHamil = value;
                      });
                    },
                    items: jml_hamil
                        .map((e) => DropdownMenuItem(
                              child: Text(e.toString()),
                              value: e,
                            ))
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Text(
                      'Jumlah Persalinan',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur6
                    Tooltip(
                      message: 'Jelas.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 3),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),

                Container(
                  padding: EdgeInsets.only(
                      left: 16, right: 16), // padding text in box
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: DropdownButton<String?>(
                    hint: Text("Pilih opsi"),
                    underline: SizedBox(),
                    isExpanded: true,
                    value: selectedLahir,
                    onChanged: (value) {
                      setState(() {
                        selectedLahir = value;
                      });
                    },
                    items: jml_lahir
                        .map((e) => DropdownMenuItem(
                              child: Text(e.toString()),
                              value: e,
                            ))
                        .toList(),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Text(
                      'Jumlah Keguguran',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur7
                    Tooltip(
                      message: 'Jelas.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 3),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),

                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: DropdownButton<String?>(
                    hint: Text("Pilih opsi"),
                    underline: SizedBox(),
                    isExpanded: true,
                    value: selectedGugur,
                    onChanged: (value) {
                      setState(() {
                        selectedGugur = value;
                      });
                    },
                    items: jml_keguguran
                        .map((e) => DropdownMenuItem(
                              child: Text(e.toString()),
                              value: e,
                            ))
                        .toList(),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Text(
                      'Apakah Kehamilan Ini Diinginkan?',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur8
                    Tooltip(
                      message: 'Jelas.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 3),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),

                // radioForm-1
                Row(
                  children: [
                    Radio(
                        value: 'yes',
                        groupValue: selectedKehamilan_diinginkan,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selectedKehamilan_diinginkan = value as String;
                          });
                        }),
                    Text("Ya"),
                    Padding(
                      padding: EdgeInsets.only(left: 75),
                    ),
                    Radio(
                        value: 'no',
                        groupValue: selectedKehamilan_diinginkan,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selectedKehamilan_diinginkan = value as String;
                          });
                        }),
                    Text("Tidak"),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Text(
                      'Apakah Anda Pengguna Alkohol?',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur9
                    Tooltip(
                      message: 'Jelas.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 3),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),

                // radioForm-2
                Row(
                  children: [
                    Radio(
                        value: 'yes',
                        groupValue: selectedPenggunaan_alkohol,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selectedPenggunaan_alkohol = value as String;
                          });
                        }),
                    Text("Ya"),
                    Padding(
                      padding: EdgeInsets.only(left: 75),
                    ),
                    Radio(
                        value: 'no',
                        groupValue: selectedPenggunaan_alkohol,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selectedPenggunaan_alkohol = value as String;
                          });
                        }),
                    Text("Tidak"),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Text(
                      'Apakah Anda Perokok?',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur10
                    Tooltip(
                      message: 'Jelas.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 3),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),

                // radioForm-3
                Row(
                  children: [
                    Radio(
                        value: 'yes',
                        groupValue: selected_perokok,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selected_perokok = value as String;
                          });
                        }),
                    Text("Ya"),
                    Padding(
                      padding: EdgeInsets.only(left: 75),
                    ),
                    Radio(
                        value: 'no',
                        groupValue: selected_perokok,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selected_perokok = value as String;
                          });
                        }),
                    Text("Tidak"),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Text(
                      'Apakah Anda Pengguna Narkoba?',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur11
                    Tooltip(
                      message: 'Jelas.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 3),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),

                // radioForm-4
                Row(
                  children: [
                    Radio(
                        value: 'yes',
                        groupValue: selected_narkoba,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selected_narkoba = value as String;
                          });
                        }),
                    Text("Ya"),
                    Padding(
                      padding: EdgeInsets.only(left: 75),
                    ),
                    Radio(
                        value: 'no',
                        groupValue: selected_narkoba,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selected_narkoba = value as String;
                          });
                        }),
                    Text("Tidak"),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Text(
                      'Apakah Anda Sering Terpapar Polusi?',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur12
                    Tooltip(
                      message:
                          'Seperti: \nasap rokok, asap kendaraan (mengendarai motor), lingkungan (air, udara).',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 5),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),

                // radioForm-5
                Row(
                  children: [
                    Radio(
                        value: 'yes',
                        groupValue: selected_polusi,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selected_polusi = value as String;
                          });
                        }),
                    Text("Ya"),
                    Padding(
                      padding: EdgeInsets.only(left: 75),
                    ),
                    Radio(
                        value: 'no',
                        groupValue: selected_polusi,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selected_polusi = value as String;
                          });
                        }),
                    Text("Tidak"),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Apakah Anda Memiliki Riwayat Pendarahan Pasca Persalinan?',
                        style: labelText,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur13
                    Tooltip(
                      message:
                          'Pilih "Ya" jika ada tindakan pasca persalinan.\notValue'
                          'Misalkan: pasang infus.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 5),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),

                // radioForm-6
                Row(
                  children: [
                    Radio(
                        value: 'yes',
                        groupValue: selectedPendarahaan_pasca_lahir,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selectedPendarahaan_pasca_lahir = value as String;
                          });
                        }),
                    Text("Ya"),
                    Padding(
                      padding: EdgeInsets.only(left: 75),
                    ),
                    Radio(
                        value: 'no',
                        groupValue: selectedPendarahaan_pasca_lahir,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selectedPendarahaan_pasca_lahir = value as String;
                          });
                        }),
                    Text("Tidak"),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Apakah Anda Pernah Mengalami Pendarahan Ketika Hamil?',
                        style: labelText,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur14
                    Tooltip(
                      message:
                          'Pilih "Ya" jika flek atau ada perlakuan tindakan.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 5),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),

                // radioForm-7
                Row(
                  children: [
                    Radio(
                        value: 'yes',
                        groupValue: selectedPendarahan_ketika_hamil,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selectedPendarahan_ketika_hamil = value as String;
                          });
                        }),
                    Text("Ya"),
                    Padding(
                      padding: EdgeInsets.only(left: 75),
                    ),
                    Radio(
                        value: 'no',
                        groupValue: selectedPendarahan_ketika_hamil,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selectedPendarahan_ketika_hamil = value as String;
                          });
                        }),
                    Text("Tidak"),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Text(
                      'Apakah Anda Sering Menggunakan Gadget?',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur15
                    Tooltip(
                      message: 'Alat elektronik, terutama Handphone.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 4),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),

                // radioForm-8
                Row(
                  children: [
                    Radio(
                        value: 'yes',
                        groupValue: selected_gadget,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selected_gadget = value as String;
                          });
                        }),
                    Text("Ya"),
                    Padding(
                      padding: EdgeInsets.only(left: 75),
                    ),
                    Radio(
                        value: 'no',
                        groupValue: selected_gadget,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selected_gadget = value as String;
                          });
                        }),
                    Text("Tidak"),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Apakah Anda Memiliki Riwayat Kelainan Bawaan?',
                        style: labelText,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur16
                    Tooltip(
                      message:
                          'Jika mengalami gejala alergi, seperti:\ngatal-gatal, bintik merah di kulit, muntah-muntah.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 5),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),

                // radioForm-9
                Row(
                  children: [
                    Radio(
                        value: 'yes',
                        groupValue: selectedRiwayat_kelainan,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selectedRiwayat_kelainan = value as String;
                          });
                        }),
                    Text("Ya"),
                    Padding(
                      padding: EdgeInsets.only(left: 75),
                    ),
                    Radio(
                        value: 'no',
                        groupValue: selectedRiwayat_kelainan,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selectedRiwayat_kelainan = value as String;
                          });
                        }),
                    Text("Tidak"),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Text(
                      'Apakah Anda Memiliki Riwayat Alergi?',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur17
                    Tooltip(
                      message:
                          'Pilih "Ya" jika pernah mengalami gatal yang berlebih.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 4),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),

                // radioForm-10
                Row(
                  children: [
                    Radio(
                        value: 'yes',
                        groupValue: selected_alergi,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selected_alergi = value as String;
                          });
                        }),
                    Text("Ya"),
                    Padding(
                      padding: EdgeInsets.only(left: 75),
                    ),
                    Radio(
                        value: 'no',
                        groupValue: selected_alergi,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selected_alergi = value as String;
                          });
                        }),
                    Text("Tidak"),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Text(
                      'Apakah Anda Pernah Operasi Caesar?',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur18
                    Tooltip(
                      message: 'Tindakan operasi persalinan.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 4),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),

                // radioForm-11
                Row(
                  children: [
                    Radio(
                        value: 'yes',
                        groupValue: selectedPendarahan_ketika_hamil,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selectedPernah_caesar = value as String;
                          });
                        }),
                    Text("Ya"),
                    Padding(
                      padding: EdgeInsets.only(left: 75),
                    ),
                    Radio(
                        value: 'no',
                        groupValue: selectedPernah_caesar,
                        activeColor: Colors.redAccent,
                        onChanged: (value) {
                          setState(() {
                            selectedPernah_caesar = value as String;
                          });
                        }),
                    Text("Tidak"),
                  ],
                ),

                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Text(
                      'Jumlah Riwayat Caesar\n(Isi 0 Bila Tidak Pernah)',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur19
                    Tooltip(
                      message: 'Jelas.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 3),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),

                TextFormField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: riwayat_caesar,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Contoh: 0',
                    hintStyle: greyTextStyle.copyWith(fontSize: 14),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                // checkboxTitle-1
                Row(
                  children: [
                    Text(
                      'Riwayat Penyakit:',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur20
                    Tooltip(
                      message: 'Pilih "Lainnya" jika tidak ada di dalam list.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 4),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),

                // checkbox-1
                Column(
                    children: riwayat_penyakit.map((sick) {
                  return CheckboxListTile(
                      activeColor: Colors.redAccent,
                      title: Text(sick['name']),
                      value: sick['isChecked'],
                      onChanged: (val) {
                        setState(() {
                          sick['isChecked'] = val;
                        });
                      });
                }).toList()),

                const Divider(
                  color: Colors.grey,
                ),
                const SizedBox(
                  height: 20,
                ),

                // checkboxTitle-2
                Row(
                  children: [
                    Text(
                      'Penyakit Keturunan:',
                      style: labelText,
                    ),
                    SizedBox(
                      width: 5,
                    ),

                    //Tooltip_fitur21
                    Tooltip(
                      message: 'Pilih "Lainnya" jika tidak ada di dalam list.',
                      decoration: BoxDecoration(
                        color: pinkColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 30,
                        width: 20,
                        child: Icon(
                          Icons.info_outline,
                          color: pinkColor,
                        ),
                      ),
                      showDuration: Duration(seconds: 4),
                      waitDuration: Duration(seconds: 1),
                      triggerMode: TooltipTriggerMode.tap,
                      textStyle: labelText.copyWith(color: Colors.white),
                      preferBelow: false,
                      verticalOffset: 20,
                    )
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),

                // checkbox-2
                Column(
                    children: penyakit_turunan.map((inherited) {
                  return CheckboxListTile(
                      activeColor: Colors.redAccent,
                      title: Text(inherited['name']),
                      value: inherited['isChecked'],
                      onChanged: (val) {
                        setState(() {
                          inherited['isChecked'] = val;
                        });
                      });
                }).toList()),

                const Divider(
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 16,
                ),

                // Button Submit
                Center(
                  child: Container(
                    width: 277,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: pinkColor,
                      ),
                      onPressed: () {
                        // Pop up konfirmasi
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              content: Text(
                                'Apakah anda sudah mengisi seluruh form dengan benar?',
                                style: labelText,
                              ),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: pinkColor,
                                  ),
                                  child: Text(
                                    'Kembali',
                                    style:
                                        buttonText.copyWith(color: whiteColor),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: pinkColor,
                                  ),
                                  child: Text(
                                    'Berikutnya',
                                    style:
                                        buttonText.copyWith(color: whiteColor),
                                  ),
                                  onPressed: () {
                                    // Pop Up "Baru" Hasil Prediksi Janin
                                    predictJanin();
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        final prediksiProvider =
                                            Provider.of<PrediksiProvider>(
                                                context,
                                                listen: false);
                                        return AlertDialog(
                                          title: Text('Hasil Prediksi'),
                                          content: Text(
                                            "Janin anda dalam keadaan ${prediksiProvider.result} \n \v Status kesehatan: ${prediksiProvider.result}",
                                          ),
                                          actions: [
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                  backgroundColor: pinkColor),
                                              child: Text(
                                                'OK',
                                                style: buttonText.copyWith(
                                                    color: whiteColor),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Navbar(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        'Prediksi',
                        style: buttonText.copyWith(
                          color: whiteColor,
                        ),
                      ),
                    ),
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
