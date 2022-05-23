// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'weatherprovider.dart';


void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => WeatherProvider()),
    ], child: const MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController locEditingController = TextEditingController();
    return MaterialApp(
      title: 'Weather App',
      home:Scaffold(
      appBar: AppBar(title: const Text("Weather APP Provider")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Simple Weather APP",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            TextField(
                controller: locEditingController,
                decoration: InputDecoration(
                    hintText: 'Location name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              const SizedBox(height: 10),
            SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      if (locEditingController.text.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "Please enter a location",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        return;
                      }
                      context
                          .read<WeatherProvider>()
                          .getProvider(locEditingController.text);
                    },
                    child: const Text("Get")),
              ),
            const SizedBox(height: 10),
            Text(context.watch<WeatherProvider>().desc,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
    );
  }
}