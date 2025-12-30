// ignore_for_file: non_constant_identifier_names

import 'package:hotcol/utils/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Chef extends StatefulWidget {
  final String HotelName;
  final String Logo;
  const Chef({super.key, required this.HotelName, required this.Logo});

  @override
  State<Chef> createState() => _ChefState();
}

class _ChefState extends State<Chef> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Apptheme.loginscaffold,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image(
                image: Image.network(widget.Logo).image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Text(
              "${widget.HotelName} Chef",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: "NotoSerif",
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
                return SizedBox(
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 80,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems.elementAt(index);
                      return Container(
                        width: 150,
                        height: 440,
                        padding: const EdgeInsets.all(25),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 370,
                          vertical: 40,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    runMutation({
                                      "id": item['id'],
                                      "status": "Cancelled",
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 218, 70, 70),
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
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
