import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/subjects.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({Key? key}) : super(key: key);

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  late double screenHeight, screenWidth, resWidth;
  List<Subjects> subjectsList = <Subjects>[];
  String titlecenter = "Loading...";
  var numofpage, curpage = 1;
  var color;

  @override
  void initState() {
    super.initState();
    _loadSubjects(1);
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
      body: subjectsList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)))
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text("Subjects Available",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                    child: GridView.count(
                        crossAxisCount: 1,
                        childAspectRatio: (1 / 1),
                        children: List.generate(subjectsList.length, (index) {
                          return InkWell(
                              splashColor: Colors.redAccent,
                              onTap: () => {_loadSubjectsDetails(index)},
                              child: Card(
                                  child: Column(
                                children: [
                                  Flexible(
                                    flex: 6,
                                    child: CachedNetworkImage(
                                      imageUrl: CONSTANTS.server +
                                          "/mytutor/mobile/assets/courses/" +
                                          subjectsList[index]
                                              .subjectId
                                              .toString() +
                                          '.PNG',
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
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          Text(
                                            subjectsList[index]
                                                .subjectName
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "RM" +
                                                double.parse(subjectsList[index]
                                                        .subjectPrice
                                                        .toString())
                                                    .toStringAsFixed(2),
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "Rating: " +
                                                subjectsList[index]
                                                    .subjectRating
                                                    .toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.red),
                                          ),
                                        ],
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
                            onPressed: () => {_loadSubjects(index + 1)},
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

  void _loadSubjects(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/load_subjects.php"),
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
        if (extractdata['subjects'] != null) {
          subjectsList = <Subjects>[];
          extractdata['subjects'].forEach((v) {
            subjectsList.add(Subjects.fromJson(v));
          });
          titlecenter = subjectsList.length.toString() + " Products Available";
        } else {
          titlecenter = "No Subject Available";
          subjectsList.clear();
        }
        setState(() {});
      }
    });
  }

  _loadSubjectsDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            title: const Text(
              "Subjects Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
                child: Column(children: [
              CachedNetworkImage(
                imageUrl: CONSTANTS.server +
                    "/mytutor/mobile/assets/courses/" +
                    subjectsList[index].subjectId.toString() +
                    '.PNG',
                fit: BoxFit.cover,
                width: resWidth,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(height: 20),
              Text(
                subjectsList[index].subjectName.toString(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  "Subject ID: " + subjectsList[index].subjectId.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 5),
                Text(
                    "Subject Description: \n" +
                        subjectsList[index].subjectDescription.toString(),
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                Text(
                    "Price: RM " +
                        double.parse(
                                subjectsList[index].subjectPrice.toString())
                            .toStringAsFixed(2),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text("Tutor ID: " + subjectsList[index].tutorId.toString(),
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                Text(
                    "Subject Session: " +
                        subjectsList[index].subjectSessions.toString(),
                    style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 5),
                Text("Rating: " + subjectsList[index].subjectRating.toString(),
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