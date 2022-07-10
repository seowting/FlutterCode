import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/cart.dart';
import '../models/user.dart';
import '../models/order.dart';
import 'package:http/http.dart' as http;

class SubscribeScreen extends StatefulWidget {
  final User user;

  const SubscribeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  List<Order> subsList = <Order>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yy hh:mm a');
  double serviceCharge = 1.0;

  @override
  void initState() {
    super.initState();
    _loadSubscribe();
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
      appBar: AppBar(
        title: const Text('My Subscribes'),
      ),
      body: subsList.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(titlecenter,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Your Subscribes",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const Divider(color: Colors.grey),
                  Expanded(
                      child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (1 / 1),
                          children: List.generate(subsList.length, (index) {
                            return Card(
                              child: InkWell(
                                onTap: () {
                                  _onSubscribeDetails(index);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Table(
                                          columnWidths: const {
                                            0: FlexColumnWidth(4),
                                            1: FlexColumnWidth(6),
                                          },
                                          children: [
                                            TableRow(children: [
                                              const TableCell(
                                                child: Text(
                                                  "Order ID",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  subsList[index]
                                                      .orderId
                                                      .toString(),
                                                ),
                                              )
                                            ]),
                                            TableRow(children: [
                                              const TableCell(
                                                child: Text(
                                                  "Receipt",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  subsList[index]
                                                      .receiptId
                                                      .toString(),
                                                ),
                                              )
                                            ]),
                                            TableRow(children: [
                                              const TableCell(
                                                child: Text(
                                                  "Paid",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  "RM " +
                                                      subsList[index]
                                                          .orderPaid
                                                          .toString(),
                                                ),
                                              )
                                            ]),
                                            TableRow(children: [
                                              const TableCell(
                                                child: Text(
                                                  "Status",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  subsList[index]
                                                      .orderStatus
                                                      .toString(),
                                                ),
                                              )
                                            ]),
                                            TableRow(children: [
                                              const TableCell(
                                                child: Text(
                                                  "Date",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  df.format(DateTime.parse(
                                                      subsList[index]
                                                          .orderDate
                                                          .toString())),
                                                ),
                                              )
                                            ]),
                                          ],
                                        ),
                                      ]),
                                ),
                              ),
                            );
                          }))),
                ]),
              ),
            ),
    );
  }

  void _loadSubscribe() {
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/load_subscribe.php"),
        body: {
          'user_email': widget.user.email,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      var extractdata = jsondata['data'];
      if (extractdata['orders'] != null) {
        subsList = <Order>[];
        extractdata['orders'].forEach((v) {
          subsList.add(Order.fromJson(v));
        });
      } else {
        titlecenter = "No Subscribe available";
      }
      setState(() {});
    });
  }

  _onSubscribeDetails(int index) {
    List<Cart> cartList = <Cart>[];
    http.post(
        Uri.parse(
            CONSTANTS.server + "/mytutor/mobile/php/load_subscribedetails.php"),
        body: {
          'user_email': widget.user.email,
          'receipt_id': subsList[index].receiptId.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response('Error', 408);
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        cartList = <Cart>[];
        extractdata['cart'].forEach((v) {
          cartList.add(Cart.fromJson(v));
        });
        if (cartList.isNotEmpty) {
          _loadSubscribeDetailsDialog(cartList);
        }
      }
    });
  }

  void _loadSubscribeDetailsDialog(List<Cart> cartList) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Subscribe Details",
              style: TextStyle(),
            ),
            content: SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (1 / 1),
                  children: List.generate(cartList.length, (index) {
                    return Card(
                        child: Column(
                      children: [
                        SizedBox(
                          width: 200,
                          height: 100,
                          child: CachedNetworkImage(
                            imageUrl: CONSTANTS.server +
                                "/mytutor/mobile/assets/courses/" +
                                cartList[index].subjectId.toString() +
                                '.PNG',
                            fit: BoxFit.cover,
                            width: resWidth,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          cartList[index].subjectName.toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          flex: 4,
                          child: SingleChildScrollView(
                            child: Column(children: [
                              Column(children: [
                                Text("Quantity: " +
                                    cartList[index].cartQty.toString()),
                                Text(
                                  "RM " +
                                      (double.parse(cartList[index]
                                                  .totalprice
                                                  .toString()) +
                                              serviceCharge)
                                          .toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                            ]),
                          ),
                        )
                      ],
                    ));
                  })),
            ),
          );
        });
  }
}
