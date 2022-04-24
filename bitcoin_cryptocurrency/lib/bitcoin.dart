import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ndialog/ndialog.dart';
import 'package:audioplayers/audioplayers.dart';

class BitCoinPage extends StatelessWidget {
  const BitCoinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text('BitCoin Cryptocurrency Value Exchange',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Flexible(
                  flex: 4,
                  child:
                      Image.asset('assets/images/bitcoinlogo.png', scale: 2.5),
                ),
                const Flexible(flex: 6, child: BitCoinForm())
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BitCoinForm extends StatefulWidget {
  const BitCoinForm({Key? key}) : super(key: key);

  @override
  State<BitCoinForm> createState() => _BitCoinFormState();
}

class _BitCoinFormState extends State<BitCoinForm> {
  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer();

  String selectType = "btc",
      description = "No value exchange.",
      name = "",
      unit = "",
      type = "";
  var rates = 0.0, valueCalc = 0.0;

  TextEditingController valueExchangeController = TextEditingController();

  List<String> typeList = [
    "btc", "eth", "ltc", "bch", "bnb", "eos", "xrp", "xlm", "link", "dot", "yfi", "bits", "sats", "usd", "aed", "ars", "aud",
    "bdt", "bhd", "bmd", "brl", "cad", "chf", "clp", "cny", "czk", "dkk", "eur", "gbp", "hkd", "huf", "idr", "ils", "inr",
    "jpy", "krw", "kwd", "lkr", "mmk", "mxn", "myr", "ngn", "nok", "nzd", "php", "pkr", "pln", "rub", "sar", "sek", "sgd",
    "thb", "try", "twd", "uah", "vef", "vnd", "zar", "xdr",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              "BitCoin Cryptocurrency Value Exchange",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: valueExchangeController,
              keyboardType: const TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                  hintText: "Please Enter Your Value",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0))),
            ),
            const SizedBox(height: 10),
            const Text("Currency Unit: ",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
            DropdownButton(
              itemHeight: 60,
              value: selectType,
              onChanged: (newValue) {
                setState(() {
                  selectType = newValue.toString();
                });
              },
              items: typeList.map((selectType) {
                return DropdownMenuItem(
                  child: Text(selectType),
                  value: selectType,
                );
              }).toList(),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.amber,
                ),
                onPressed: _valueExchange,
                child: const Text("Value Exchange")),
            const SizedBox(height: 5),
            Text(description,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Future<void> _valueExchange() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"),
        title: const Text("Value Exchange Calculating...",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)));
    progressDialog.show();

    var url = Uri.parse('https://api.coingecko.com/api/v3/exchange_rates');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      var jsonData = response.body;
      var parsedData = json.decode(jsonData);
      setState(() {
        // ignore: unnecessary_string_interpolations
        name = parsedData['rates']['$selectType']['name'];
        // ignore: unnecessary_string_interpolations
        unit = parsedData['rates']['$selectType']['unit'];
        // ignore: unnecessary_string_interpolations
        rates = parsedData['rates']['$selectType']['value'];
        // ignore: unnecessary_string_interpolations
        type = parsedData['rates']['$selectType']['type'];
        valueCalc = double.parse(valueExchangeController.text) * rates;
        description =
            "Result: \n Name of Currency: $name \n Unit of Currency: $unit \n Exchange Rates: $rates \n Value to Exchange: BTC " +
                valueExchangeController.text +
                "\n Exchange Value: $unit " +
                valueCalc.toStringAsFixed(4) +
                "\n Type: $type";
      });
      progressDialog.dismiss();
      loadDone();
    }
  }

  Future loadDone() async {
    audioPlayer = await AudioCache().play("audios/done.wav");
  }
}
