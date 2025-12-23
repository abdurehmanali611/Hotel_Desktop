// ignore_for_file: non_constant_identifier_names
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hotcol/main.dart';
import 'package:hotcol/utils/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:upgrader/upgrader.dart';

class Chef extends StatefulWidget {
  final String HotelName;
  final String Logo;
  const Chef({super.key, required this.HotelName, required this.Logo});

  @override
  State<Chef> createState() => _ChefState();
}

class _ChefState extends State<Chef> {
  @override
  Widget build(BuildContext context) {
    final String chefOrderQuery = """
  query {
  orders {
  id 
  title
  imageUrl
  category
  orderAmount
  HotelName
  price
  tableNo
  waiterName
  status
  payment
  }
  }
""";

    final String statusUpdateMutation = """
  mutation UpdateStatus(\$id: Int!, \$status: String) {
  UpdateStatus(id: \$id, status: \$status) {
  id
  status
  }
  }
""";

  void checkForUpdate(String latestVersion) {
    String updateUrl = Platform.isWindows ? "" : "";
    CupertinoAlertDialog(
      title: Text(
        "Update Available",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          "A new version of the app is available. version $latestVersion, please update to continue.",
          style: TextStyle(fontSize: 16),
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () async {
            Uri uri = Uri.parse(updateUrl);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
            } else {
              _showSnackBar(
                context,
                "Couldn't open the Update Link",
                Colors.red,
              );
            }
          },
          child: Text(
            "Update Now",
            style: TextStyle(color: CupertinoColors.activeBlue),
          ),
        ),
      ],
    );
  }

  checkForVersionUpdate() {
    final storedVersion = upgrader.versionInfo?.appStoreVersion;
    final installedVersion = upgrader.versionInfo?.installedVersion;

    if (storedVersion != null && installedVersion != null) {
      if (storedVersion > installedVersion) {
        checkForUpdate(storedVersion.toString());
      } else {
        _showSnackBar(
          context,
          "You are using the latest version.",
          Colors.green,
        );
      }
    } else {
      _showSnackBar(
        context,
        "Version Info is not available.",
        const Color.fromARGB(255, 110, 105, 53),
      );
    }
  }

    return Scaffold(
      backgroundColor: Apptheme.loginscaffold,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${widget.HotelName} Chef Panel",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: "NotoSerif",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Future.delayed(Duration(seconds: 2)).then((value) {
                  checkForVersionUpdate();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Apptheme.buttontxt,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(90),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: Image(
                  image: Image.network(widget.Logo).image,
                  width: 20,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Query(
          options: QueryOptions(document: gql(chefOrderQuery)),
          builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
            if (result.isLoading) {
              return Center(child: CircularProgressIndicator());
            }

            // 💡 IMPROVED: Display the actual exception details
            if (result.hasException) {
              // Log the error for better debugging
              return Center(
                child: Text(
                  "Error fetching data. Details: ${result.exception.toString().split(':')[0]}",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              );
            }

            final items = (result.data?['orders'] as List<dynamic>?) ?? [];
            Iterable<dynamic> filteredItems = [];

            // Data filtering remains wrapped in try-catch
            try {
              filteredItems = items.where((item) {
                return item['category'].toString().toLowerCase() == "food" &&
                    item['status'] == null &&
                    item['HotelName'] == widget.HotelName;
              });
            } catch (e) {
              return Center(
                child: Text(
                  "Internal error: Could not process fetched data.",
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            }

            return Mutation(
              options: MutationOptions(
                document: gql(statusUpdateMutation),
                onCompleted: (data) {
                  refetch?.call();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Status Updated Successfully"),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                onError: (error) {
                  // Log mutation error for debugging
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Something Went Wrong.Please Try Again"),
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              ),
              builder: (RunMutation runMutation, QueryResult? result) {
                // 🚀 CRITICAL FIX: Removed the Expanded widget, allowing ListView
                // to be constrained by the Center/Scaffold body.
                return ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems.elementAt(index);
                    return Container(
                      width: 250,
                      height: 440,
                      padding: const EdgeInsets.all(25),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 450,
                        vertical: 80,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: "NotoSerif",
                              color: Apptheme.mosttxtcolor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              item['imageUrl'],
                              width: 250,
                              height: 220,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.broken_image, size: 200);
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Table No:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Apptheme.mosttxtcolor,
                                ),
                              ),
                              Text(
                                " ${item['tableNo']}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  runMutation({
                                    "id": item['id'],
                                    "status": "Cancelled",
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    116,
                                    44,
                                    44,
                                  ),
                                  foregroundColor: Apptheme.buttontxt,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 5,
                                ),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  runMutation({
                                    "id": item['id'],
                                    "status": "Completed",
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Apptheme.buttonbglogin,
                                  foregroundColor: Apptheme.buttontxt,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 5,
                                ),
                                child: const Text(
                                  "Done",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: color,
      ),
    );
  }
}
