import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/tutors.dart';

class TutorsScreen extends StatefulWidget {
  const TutorsScreen({Key? key}) : super(key: key);

  @override
  State<TutorsScreen> createState() => _TutorsScreenState();
}

class _TutorsScreenState extends State<TutorsScreen> {
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  List<Tutors> tutorsList = <Tutors>[];
  String titlecenter = "Loading...";
  var numofpage, curpage = 1;
  var color;

  @override
  void initState() {
    super.initState();
    _loadTutors(1);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }

    return Scaffold(
      body: tutorsList.isEmpty
          ? Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: [
                  Center(
                      child: Text(titlecenter,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                ],
              ),
            )
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text("Tutors Available",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (1 / 1),
                        children: List.generate(tutorsList.length, (index) {
                          return InkWell(
                              splashColor: Colors.redAccent,
                              onTap: () => {_loadTutorsDetails(index)},
                              child: Card(
                                  child: Column(
                                children: [
                                  Flexible(
                                    flex: 6,
                                    child: CachedNetworkImage(
                                      imageUrl: CONSTANTS.server +
                                          "/mytutor/mobile/assets/tutors/" +
                                          tutorsList[index].tutorId.toString() +
                                          '.jpg',
                                      fit: BoxFit.cover,
                                      width: resWidth,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 4,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 20),
                                            Text(
                                              tutorsList[index]
                                                  .tutorName
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Tel: " +
                                                  tutorsList[index]
                                                      .tutorPhone
                                                      .toString(),
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              "Email: " +
                                                  tutorsList[index]
                                                      .tutorEmail
                                                      .toString(),
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                ],
                              )));
                        }))),
                SizedBox(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if ((curpage - 1) == index) {
                        color = Colors.red;
                      } else {
                        color = Colors.black;
                      }
                      return SizedBox(
                        width: 40,
                        child: TextButton(
                            onPressed: () => {_loadTutors(index + 1)},
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color),
                            )),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void _loadTutors(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/load_tutors.php"),
        body: {'pageno': pageno.toString()}).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['tutors'] != null) {
          tutorsList = <Tutors>[];
          extractdata['tutors'].forEach((v) {
            tutorsList.add(Tutors.fromJson(v));
          });
          titlecenter = tutorsList.length.toString() + " Products Available";
        } else {
          titlecenter = "No Subject Available";
          tutorsList.clear();
        }
        setState(() {});
      }
    });
  }

  _loadTutorsDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            title: const Text(
              "Tutors Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
                child: Column(children: [
              CachedNetworkImage(
                imageUrl: CONSTANTS.server +
                    "/mytutor/mobile/assets/tutors/" +
                    tutorsList[index].tutorId.toString() +
                    '.jpg',
                fit: BoxFit.cover,
                width: resWidth,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(height: 20),
              Text(
                tutorsList[index].tutorName.toString(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  "Tutor ID: " + tutorsList[index].tutorId.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text("Phone No: " + tutorsList[index].tutorPhone.toString(),
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                Text("Email: " + tutorsList[index].tutorEmail.toString(),
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                Text(
                    "Tutor Description: \n" +
                        tutorsList[index].tutorDescription.toString(),
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                Text("Password: " + tutorsList[index].tutorPassword.toString(),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(
                    "Date Register: " +
                        df.format(DateTime.parse(
                            tutorsList[index].tutorDatereg.toString())),
                    style: const TextStyle(fontSize: 14, color: Colors.red)),
              ]),
            ])),
            actions: [
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
