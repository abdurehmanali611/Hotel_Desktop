// ignore_for_file: avoid_function_literals_in_foreach_calls, non_constant_identifier_names

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:hotcol/Recode/UpdateCredential.dart';
import 'package:hotcol/Recode/grantcredential.dart';
import 'package:hotcol/Recode/itemcreationform.dart';
import 'package:hotcol/Recode/reports.dart';
import 'package:hotcol/Recode/updateScreen.dart';
import 'package:hotcol/Recode/updateTable.dart';
import 'package:hotcol/Recode/updateWaiter.dart';
import 'package:hotcol/Recode/updatedeleteintro.dart';
import 'package:hotcol/Recode/waiter_And_Table.dart';
import 'package:hotcol/main.dart';
import 'package:hotcol/utils/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_compression_flutter/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminHome extends StatefulWidget {
  final String HotelName;
  final String Logo;
  const AdminHome({super.key, required this.HotelName, required this.Logo});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String dropdownvalue = "Daily Report";
  DateTime calenderValue = DateTime(2025, 10, 30);
  String itemName = "";
  double itemPrice = 100.0;
  String itemCat = "Food";
  Map<int, String> catValueMap = {};
  String waiter = "";
  File? _selectedImageFile;
  String foodImage = "";
  bool isUploading = false;
  String? _selectedSex;
  String stakeType = "Kitchen";
  Map<int, TextEditingController> nameController = {};
  Map<int, TextEditingController> priceController = {};
  Map<int, TextEditingController> imageController = {};
  Map<int, TextEditingController> noController = {};
  Map<int, TextEditingController> capacityController = {};
  final TextEditingController waiterName = TextEditingController();
  final TextEditingController waiterAge = TextEditingController();
  final TextEditingController waiterExperience = TextEditingController();
  final TextEditingController waiterPhone = TextEditingController();
  final TextEditingController tableNumber = TextEditingController();
  final TextEditingController tableCapacity = TextEditingController();
  final TextEditingController credUsername = TextEditingController();
  final TextEditingController credPassword = TextEditingController();
  final TextEditingController OldPasswordController = TextEditingController();
  final TextEditingController NewPasswordController = TextEditingController();
  final TextEditingController ConfirmPasswordController =
      TextEditingController();

  final String grantCredentialMutation = """
  mutation CreateCredential(\$UserName: String!, \$Password: String!, \$Role: String!, \$HotelName: String!){
  CreateCredential(UserName: \$UserName, Password: \$Password, Role: \$Role, HotelName: \$HotelName){
  id
  UserName
  HotelName
  Password
  Role
  }
  }
""";

  final String adminUpdateCredentialMutation = """
  mutation UpdateAdminCredential(\$Password: String!, \$HotelName: String!){
  UpdateAdminCredential(Password: \$Password, HotelName: \$HotelName){
  id
  HotelName
  Password
  }
  }
""";

  final String credUpdateCredentialMutation = """
  mutation UpdateCredential(\$UserName: String!, \$Password: String!, \$HotelName: String!, \$Role: String!) {
  UpdateCredential(UserName: \$UserName, Password: \$Password, HotelName: \$HotelName, Role: \$Role) {
  id
  UserName
  Password
  HotelName
  Role
  }
  }
""";

  final String itemCreateMutation = """
  mutation CreateItem(\$name: String!, \$price: Float!, \$category: String!, \$imageUrl: String!, \$HotelName: String!) {
  CreateItem(name: \$name, price: \$price, category: \$category, imageUrl: \$imageUrl, HotelName: \$HotelName) {
  name
  price
  category
  HotelName
  imageUrl
  }
  }
""";

  final String itemListsQuery = """
  query {
  items{
    id
    name
    price
    category
    HotelName
    imageUrl
    createdAt
  }
  }
""";

  final String getCredentialsQuery = """
  query {
  users {
  id
  UserName
  Password
  Role
  HotelName
  LogoUrl
  }
  }
""";

  final String createWaiterMutation = """
  mutation CreateWaiter(\$name: String!, \$HotelName: String!, \$sex: String!, \$age: Int!, \$experience: Int!, \$phoneNumber: String!) {
  CreateWaiter(name: \$name, HotelName: \$HotelName, sex: \$sex, age: \$age, experience: \$experience, phoneNumber: \$phoneNumber) {
  name
  HotelName
  age
  sex
  experience
  phoneNumber
  }
  }
""";

  final String createTableMutation = """
  mutation CreateTable(\$tableNo: Int!, \$HotelName: String!, \$capacity: Int!) {
  CreateTable(tableNo: \$tableNo, HotelName: \$HotelName, capacity: \$capacity) {
  tableNo
  HotelName
  capacity
  }
  }
""";

  final String waiterQuery = """
  query {
  waiters {
    id 
    name
    HotelName
    age
    sex
    experience
    phoneNumber
    tablesServed
    price
    payment
    createdAt
  }}
  """;

  final String VERIFY_PASSWORD_MUTATION = """
  mutation VerifyAdminPassword(\$HotelName: String!, \$passwordInput: String!) {
    verifyAdminPassword(HotelName: \$HotelName, passwordInput: \$passwordInput)
  }
""";

  final String tableQuery = """ 
  query {
  tables {
    id
    tableNo
    HotelName
    capacity
    status
    price
    payment
    createdAt
  }
  }
  """;

  final String deleteWaiterMutation = """
  mutation DeleteWaiter(\$id: Int!) {
  DeleteWaiter(id: \$id) {
  id
  }
  }
""";

  final String deleteTableMutation = """
  mutation DeleteTable(\$id: Int!) {
  DeleteTable(id: \$id) {
  id
  }
  }
""";

  final String updateWaiterMutation = """
  mutation UpdateWaiter(\$id: Int!, \$name: String!, \$age: Int!, \$sex: String!, \$experience: Int!, \$phoneNumber: String!, \$HotelName: String!) {
  UpdateWaiter(id: \$id, name: \$name, age: \$age, sex: \$sex, experience: \$experience, phoneNumber: \$phoneNumber, HotelName: \$HotelName) {
   id
   name
   age
   sex
   experience
   phoneNumber
   HotelName
  }
  }
""";

  final String updateTableMutation = """
  mutation UpdateTable(\$id: Int!, \$tableNo: Int!, \$capacity: Int!, \$HotelName: String!) {
  UpdateTable(id: \$id, tableNo: \$tableNo, capacity: \$capacity, HotelName: \$HotelName) {
   id
   tableNo
   capacity
   HotelName
  }
  }
""";

  final String getOrderQuery = """
  query{
  orders {
  id
  title
  imageUrl
  tableNo
  HotelName
  orderAmount
  category
  price
  waiterName
  status
  payment
  createdAt
  }
  }
""";

  final String deleteItemMutation = """
  mutation DeleteItem(\$id: Int!) {
  DeleteItem(id: \$id) {
  id
  name
  }
  }
""";

  final String updateItemMutation = """
 mutation UpdateItem(\$id: Int!, \$name: String!, \$price: Float!, \$category: String!, \$imageUrl: String!, \$HotelName: String!){
 UpdateItem(id: \$id, name: \$name, price: \$price, category: \$category, imageUrl: \$imageUrl, HotelName: \$HotelName) {
 id
 name
 price
 HotelName
 category
 imageUrl
 }
 }
""";

  Future<File?> imageCompression(File file) async {
    try {
      final compressedData = await FlutterImageCompress.compressWithFile(
        file.path,
        quality: 80,
        minWidth: 1080,
        minHeight: 1080,
        format: CompressFormat.jpeg,
      );
      if (compressedData != null) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File(
          "${tempDir.path}/compressed ${file}_${DateTime.now().millisecondsSinceEpoch}.jpg",
        );

        await tempFile.writeAsBytes(compressedData);

        return tempFile;
      }
    } catch (error) {
      return null;
    }
    return null;
  }

  Future<void> handleFileUpload([StateSetter? dialogSetState]) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      final File file = File(pickedFile.path);

      (dialogSetState ?? setState)(() {
        isUploading = true;
        _selectedImageFile = file;
      });

      try {
        final compressedFile = await imageCompression(file);
        final fileupload = compressedFile ?? file;
        final cloudinary = CloudinaryPublic(
          'dpyads5wb',
          'Item_Images',
          cache: true,
        );
        final CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            fileupload.path,
            resourceType: CloudinaryResourceType.Image,
            folder: 'Hotel_Items/${widget.HotelName}',
            identifier: pickedFile.name,
          ),
        );

        final String imageUrl = response.secureUrl;

        (dialogSetState ?? setState)(() {
          foodImage = imageUrl;
          isUploading = false;
        });
      } catch (e) {
        (dialogSetState ?? setState)(() {
          isUploading = false;
          _selectedImageFile = null;
          foodImage = "";
        });
        _showSnackBar(
          context,
          "Image upload failed.${e.toString()}",
          Colors.red,
        );
      }
    }
  }

  Future<void> exportDataToExcel(
    List<dynamic> dataList,
    String sheetName,
  ) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel[sheetName];

    List<String> header = sheetName == "Waiters"
        ? [
            'Name',
            'Hotel Name',
            'Age',
            'Sex',
            'Experience',
            'Completed Orders',
            'Total Sales',
          ]
        : sheetName == "Tables"
        ? ['Table No', 'Capacity', 'Total Sales', 'Completed Orders']
        : [
            'Food Name',
            'Category',
            'Price',
            'Order Amount',
            'Waiter Name',
            'Table No',
            'Daily Sales',
          ];

    sheetObject.insertRowIterables(
      header.map((e) => TextCellValue(e.toString())).toList(),
      0,
    );

    for (int i = 0; i < dataList.length; i++) {
      List<CellValue> row = [];
      final item = dataList[i];
      if (sheetName == "Waiters") {
        List<dynamic> prices = (item['price'] as List?)?.cast<double>() ?? [];
        List<dynamic> tables =
            (item['tablesServed'] as List?)?.cast<int>() ?? [];

        final totalSales = prices.fold(0.0, (sum, price) => sum + price);
        final completedOrders = tables.length;

        row.addAll([
          TextCellValue(item['name'] ?? ''),
          TextCellValue(item['HotelName'] ?? ''),
          IntCellValue(item['age']),
          TextCellValue(item['sex'] ?? ''),
          IntCellValue(item['experience']),
          IntCellValue(completedOrders),
          DoubleCellValue(totalSales),
        ]);
      } else if (sheetName == "Tables") {
        List<dynamic> prices = (item['price'] as List?)?.cast<double>() ?? [];
        List<dynamic> payments =
            (item['payment'] as List?)?.cast<String>() ?? [];

        final totalSales = prices.fold(0.0, (sum, price) => sum + price);
        final completedOrders = payments.where((p) => p == "Paid").length;
        row.addAll([
          IntCellValue(item['tableNo']),
          IntCellValue(item['capacity']),
          DoubleCellValue(totalSales),
          IntCellValue(completedOrders),
        ]);
      } else {
        row.addAll([
          TextCellValue(item['title'] ?? ''),
          TextCellValue(item['category'] ?? ''),
          DoubleCellValue(item['price']),
          IntCellValue(item['orderAmount']),
          TextCellValue(item['waiterName'] ?? ''),
          IntCellValue(item['tableNo']),
          DoubleCellValue(item['price'] * item['orderAmount']),
        ]);
      }
      sheetObject.insertRowIterables(row, i + 1);
    }

    List<int>? fileBytes = excel.save(fileName: '$sheetName.xlsx');

    if (fileBytes != null) {
      final directory = await getApplicationDocumentsDirectory();
      final appSpecificPath = '${directory.path}/Hotel Reports';

      if (!await Directory(appSpecificPath).exists()) {
        await Directory(appSpecificPath).create(recursive: true);
      }
      final path =
          '$appSpecificPath/${sheetName != "" ? sheetName : "Monthly Report"}.xlsx';

      final file = File(path);
      if (await File(file.path).exists()) {
        await File(file.path).create(recursive: true);
      }
      await file.writeAsBytes(fileBytes as Uint8List);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Apptheme.loginscaffold,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${widget.HotelName} Admin Panel",
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 20, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 240,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Apptheme.mostbgcolor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "I want to see about:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Apptheme.mostbgcolor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: DropdownButton(
                        value: dropdownvalue,
                        items: [
                          DropdownMenuItem(
                            value: "Daily Report",
                            child: Text("Daily Report"),
                          ),
                          DropdownMenuItem(
                            value: "Monthly Report",
                            child: Text("Monthly Report"),
                          ),
                          DropdownMenuItem(
                            value: "Create an Item",
                            child: Text("Create an Item"),
                          ),
                          DropdownMenuItem(
                            value: "Update/Delete Item",
                            child: Text("Update/Delete Item"),
                          ),
                          DropdownMenuItem(
                            value: "Grant Credential",
                            child: Text("Grant Credential"),
                          ),
                          DropdownMenuItem(
                            value: "Waiter and Table",
                            child: Text("Waiter and Table Info"),
                          ),
                          DropdownMenuItem(
                            value: "Update Credential",
                            child: Text("Update Credential"),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                          if (dropdownvalue == "Create an Item") {
                            _selectedImageFile = null;
                            foodImage = "";
                          }
                        },
                        underline: Container(),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        style: TextStyle(
                          color: Apptheme.buttontxt,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 120),
            Column(
              children: [
                Text(
                  dropdownvalue,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                dropdownvalue == "Daily Report"
                    ? Query(
                        options: QueryOptions(document: gql(getOrderQuery)),
                        builder:
                            (
                              QueryResult result, {
                              VoidCallback? refetch,
                              FetchMore? fetchMore,
                            }) {
                              if (result.isLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (result.hasException) {
                                return Center(
                                  child: Text(
                                    "Error happened while displaying/fetching",
                                  ),
                                );
                              }
                              final orderItems =
                                  (result.data?['orders'] as List<dynamic>?) ??
                                  [];
                              return Reports(
                                handleCalender: handleCalender,
                                calenderResult: calenderValue,
                                revenuePrefix: "Daily",
                                dateStyle: "dd-MM-yyyy",
                                orderItems: orderItems,
                                HotelName: widget.HotelName,
                                handleReportExcel: () async {
                                  if (orderItems.isNotEmpty) {
                                    await exportDataToExcel(
                                      orderItems,
                                      "Daily Report",
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Successfully Exported"),
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Something Went Wrong.Please try Again",
                                        ),
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                      )
                    : dropdownvalue == "Monthly Report"
                    ? Query(
                        options: QueryOptions(document: gql(getOrderQuery)),
                        builder:
                            (
                              QueryResult result, {
                              VoidCallback? refetch,
                              FetchMore? fetchMore,
                            }) {
                              if (result.isLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (result.hasException) {
                                return Center(
                                  child: Text(
                                    "Error happened while displaying/fetching",
                                  ),
                                );
                              }
                              final orderItems =
                                  (result.data?['orders'] as List<dynamic>?) ??
                                  [];
                              return Reports(
                                handleCalender: handleCalender,
                                calenderResult: calenderValue,
                                revenuePrefix: "Monthly",
                                dateStyle: "MMMM-yyyy",
                                orderItems: orderItems,
                                HotelName: widget.HotelName,
                                handleReportExcel: () async {
                                  if (orderItems.isNotEmpty) {
                                    await exportDataToExcel(
                                      orderItems,
                                      "Monthly Report",
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Successfully Exported"),
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "something Went Wrong.Please Try Again",
                                        ),
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                      )
                    : dropdownvalue == "Create an Item"
                    ? Mutation(
                        options: MutationOptions(
                          document: gql(itemCreateMutation),
                          onCompleted: (data) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Item Created Successfully"),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.green,
                              ),
                            );
                            setState(() {
                              _selectedImageFile = null;
                              foodImage = "";
                            });
                          },
                          onError: (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Something Went Wrong. Please Try Again",
                                ),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                        ),
                        builder:
                            (RunMutation runMutation, QueryResult? result) {
                              return Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: ItemCreationForm(
                                  nameChanged: (value) {
                                    setState(() {
                                      itemName = value;
                                    });
                                  },
                                  imageFood: _selectedImageFile,
                                  priceChanged: (value) {
                                    setState(() {
                                      itemPrice = value;
                                    });
                                  },
                                  isUploading: isUploading,
                                  foodCat: "Food",
                                  drinkCat: "Drink",
                                  catSelect: (value) {
                                    if (value != null) {
                                      setState(() {
                                        itemCat = value;
                                      });
                                    }
                                  },
                                  catValue: itemCat,
                                  fileUpload: handleFileUpload,
                                  action: "Create",
                                  handleCreation: () {
                                    runMutation({
                                      "name": itemName,
                                      "price": itemPrice,
                                      "category": itemCat,
                                      "imageUrl": foodImage,
                                      "HotelName": widget.HotelName,
                                    });
                                  },
                                ),
                              );
                            },
                      )
                    : dropdownvalue == "Update/Delete Item"
                    ? Query(
                        options: QueryOptions(document: gql(itemListsQuery)),
                        builder:
                            (
                              QueryResult result, {
                              VoidCallback? refetch,
                              FetchMore? fetchMore,
                            }) {
                              if (result.isLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (result.hasException) {
                                return Center(
                                  child: Text(
                                    "Error happened while Fetching/Displaying",
                                  ),
                                );
                              }
                              final items =
                                  (result.data?['items'] as List<dynamic>?) ??
                                  [];
                              return Mutation(
                                options: MutationOptions(
                                  document: gql(deleteItemMutation),
                                  onCompleted: (data) {
                                    refetch?.call();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Item Deleted Successfully!",
                                        ),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  onError: (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Failed to delete the Item. Please try again.",
                                        ),
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                                ),
                                builder: (RunMutation runDelete, QueryResult? result) {
                                  return Mutation(
                                    options: MutationOptions(
                                      document: gql(updateItemMutation),
                                      onCompleted: (data) {
                                        refetch?.call();
                                        Navigator.of(context).pop();
                                        setState(() {
                                          _selectedImageFile = null;
                                          foodImage = "";
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Item Updated Successfully!",
                                            ),
                                            duration: Duration(seconds: 2),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      },
                                      onError: (error) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Failed to update item. Please try again.",
                                            ),
                                            duration: Duration(seconds: 2),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      },
                                    ),
                                    builder: (RunMutation runUpdate, QueryResult? result) {
                                      return UpdateDeleteIntro(
                                        update: (item) {
                                          int itemId = item['id'];
                                          setState(() {
                                            foodImage = item['imageUrl'];
                                          });
                                          if (!catValueMap.containsKey(
                                            itemId,
                                          )) {
                                            catValueMap[itemId] =
                                                item['category'];
                                          }
                                          if (!nameController.containsKey(
                                            itemId,
                                          )) {
                                            nameController[itemId] =
                                                TextEditingController(
                                                  text: item['name'],
                                                );
                                            priceController[itemId] =
                                                TextEditingController(
                                                  text: "${item['price']}",
                                                );
                                            imageController[itemId] =
                                                TextEditingController(
                                                  text: item['imageUrl'],
                                                );
                                          }
                                          showDialog(
                                            context: context,
                                            builder: (_) => Dialog(
                                              child: StatefulBuilder(
                                                builder:
                                                    (
                                                      BuildContext context,
                                                      StateSetter
                                                      setDialogueState,
                                                    ) {
                                                      void
                                                      dialogFileUpload() async {
                                                        await handleFileUpload(
                                                          setDialogueState,
                                                        );
                                                      }

                                                      return UpdateScreen(
                                                        isUploading:
                                                            isUploading,
                                                        currentImageUrl:
                                                            item['imageUrl'],
                                                        nameChanged: (value) {
                                                          setDialogueState(() {
                                                            itemName = value;
                                                          });
                                                        },
                                                        priceChanged: (value) {
                                                          setDialogueState(() {
                                                            itemPrice = value;
                                                          });
                                                        },
                                                        foodCat: "Food",
                                                        drinkCat: "Drink",
                                                        catSelect: (value) {
                                                          if (value != null) {
                                                            setDialogueState(() {
                                                              catValueMap[itemId] =
                                                                  value;
                                                            });
                                                          }
                                                        },
                                                        imageFood:
                                                            _selectedImageFile,
                                                        catValue:
                                                            catValueMap[itemId]!,
                                                        fileUpload:
                                                            dialogFileUpload,
                                                        action: "Update",
                                                        nameController:
                                                            nameController[itemId]!,
                                                        priceController:
                                                            priceController[itemId]!,
                                                        handleCreation: () {
                                                          final updatedValue =
                                                              itemName
                                                                  .isNotEmpty
                                                              ? itemName
                                                              : nameController[itemId]!
                                                                    .text;
                                                          final updatedPrice =
                                                              itemPrice != 0
                                                              ? itemPrice
                                                              : double.tryParse(
                                                                      priceController[itemId]!
                                                                          .text,
                                                                    ) ??
                                                                    0;
                                                          final updatedImage =
                                                              foodImage != ""
                                                              ? foodImage
                                                              : item['imageUrl'];
                                                          runUpdate({
                                                            "id": item['id'],
                                                            "name":
                                                                updatedValue,
                                                            "price":
                                                                updatedPrice,
                                                            "category":
                                                                catValueMap[itemId]!,
                                                            "imageUrl":
                                                                updatedImage,
                                                            "HotelName": widget
                                                                .HotelName,
                                                          });
                                                        },
                                                      );
                                                    },
                                              ),
                                            ),
                                          );
                                        },
                                        delete: (item) async {
                                          runDelete({"id": item['id']});
                                        },
                                        items: items,
                                        HotelName: widget.HotelName,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                      )
                    : dropdownvalue == "Grant Credential"
                    ? Mutation(
                        options: MutationOptions(
                          document: gql(grantCredentialMutation),
                          onCompleted: (data) {
                            _showSnackBar(
                              context,
                              "Credential Granted Successfully",
                              Colors.green,
                            );
                            credUsername.clear();
                            credPassword.clear();
                            stakeType = "Kitchen";
                          },
                          onError: (error) {
                            String errorMessage;
                            if (error?.linkException != null) {
                              errorMessage =
                                  "Connection Timeout or Network Error. Please check your server status (10.0.2.2:4000) and connection.";
                            } else if (error!.graphqlErrors.isNotEmpty) {
                              errorMessage =
                                  "Login failed: ${error.graphqlErrors.first.message}";
                            } else {
                              errorMessage =
                                  "Login failed due to an unknown error.";
                            }
                            _showSnackBar(context, errorMessage, Colors.red);
                          },
                        ),
                        builder:
                            (RunMutation runMutation, QueryResult? result) {
                              return GrantCredential(
                                kitchen: "Kitchen",
                                barista: "Barista",
                                cashier: "Cashier",
                                handleStake: (value) {
                                  if (value != null) {
                                    setState(() {
                                      stakeType = value;
                                    });
                                  }
                                },
                                dropValue: stakeType,
                                title_1: "Username:",
                                credUsername: credUsername,
                                title_2: "Password",
                                credPassword: credPassword,
                                handleGrant: () {
                                  runMutation({
                                    "UserName": credUsername.text,
                                    "Password": credPassword.text,
                                    "Role": stakeType,
                                    "HotelName": widget.HotelName,
                                  });
                                },
                              );
                            },
                      )
                    : dropdownvalue == "Update Credential"
                    ? Query(
                        options: QueryOptions(
                          document: gql(getCredentialsQuery),
                        ),
                        builder:
                            (
                              QueryResult result, {
                              VoidCallback? refetch,
                              FetchMore? fetchMore,
                            }) {
                              if (result.isLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (result.hasException) {
                                return Center(
                                  child: Text(
                                    "Error happened while fetching/displaying",
                                  ),
                                );
                              }

                              final credentials =
                                  (result.data?['users'] as List<dynamic>?) ??
                                  [];
                              return Mutation(
                                options: MutationOptions(
                                  document: gql(adminUpdateCredentialMutation),
                                  onCompleted: (data) {
                                    _showSnackBar(
                                      context,
                                      "Admin Password Updated Successfully",
                                      Colors.green,
                                    );
                                    refetch?.call();
                                  },
                                  onError: (error) {
                                    _showSnackBar(
                                      context,
                                      "Failed to update Admin Password. Please try again. ${error.toString()}",
                                      Colors.red,
                                    );
                                  },
                                ),
                                builder: (RunMutation updateAdmin, QueryResult? result) {
                                  return Mutation(
                                    options: MutationOptions(
                                      document: gql(
                                        credUpdateCredentialMutation,
                                      ),
                                      onCompleted: (data) {
                                        _showSnackBar(
                                          context,
                                          "Credential Updated Successfully",
                                          Colors.green,
                                        );
                                        refetch?.call();
                                      },
                                      onError: (error) {
                                        _showSnackBar(
                                          context,
                                          "Failed to update Credential. Please try again.",
                                          Colors.red,
                                        );
                                      },
                                    ),
                                    builder: (RunMutation updateCred, QueryResult? result) {
                                      return Updatecredential(
                                        credentials: credentials,
                                        HotelName: widget.HotelName,
                                        oldPasswordController:
                                            OldPasswordController,
                                        newPasswordController:
                                            NewPasswordController,
                                        confirmPasswordController:
                                            ConfirmPasswordController,
                                        usernameController: credUsername,
                                        passwordController: credPassword,
                                        handleAdminUpdate: () async {
                                          if (NewPasswordController.text !=
                                              ConfirmPasswordController.text) {
                                            _showSnackBar(
                                              context,
                                              "You didn't confirmed your password correctly",
                                              Colors.red,
                                            );
                                          }
                                          final client = GraphQLProvider.of(
                                            context,
                                          ).value;
                                          final QueryResult
                                          verifyResult = await client.mutate(
                                            MutationOptions(
                                              document: gql(
                                                VERIFY_PASSWORD_MUTATION,
                                              ),
                                              variables: {
                                                'HotelName': widget.HotelName,
                                                'passwordInput':
                                                    OldPasswordController.text,
                                              },
                                            ),
                                          );
                                          if (verifyResult.hasException) {
                                            final exception =
                                                verifyResult.exception!;

                                            if (exception.linkException !=
                                                null) {
                                              final msg =
                                                  exception.linkException;
                                              _showSnackBar(
                                                context,
                                                "Cannot reach server. Check IP/Wi-Fi.$msg",
                                                Colors.orange,
                                              );
                                            } else if (exception
                                                .graphqlErrors
                                                .isNotEmpty) {
                                              final msg = exception
                                                  .graphqlErrors
                                                  .first
                                                  .message;
                                              _showSnackBar(
                                                context,
                                                "Server Logic Error: $msg",
                                                Colors.red,
                                              );
                                            }
                                            return;
                                          }

                                          bool isCorrect =
                                              verifyResult
                                                  .data?['verifyAdminPassword'] ??
                                              false;

                                          if (isCorrect) {
                                            updateAdmin({
                                              "Password":
                                                  NewPasswordController.text,
                                              "HotelName": widget.HotelName,
                                            });
                                            OldPasswordController.clear();
                                            NewPasswordController.clear();
                                            ConfirmPasswordController.clear();
                                          } else {
                                            _showSnackBar(
                                              context,
                                              "The old password you entered is incorrect",
                                              Colors.red,
                                            );
                                          }
                                        },
                                        handleCredUpdate: () {
                                          updateCred({
                                            "UserName": credUsername.text,
                                            "Password": credPassword.text,
                                            "HotelName": widget.HotelName,
                                            "Role": stakeType,
                                          });
                                        },
                                        Kitchen: "Kitchen",
                                        barista: "Barista",
                                        cashier: "Cashier",
                                        handleStake: (value) {
                                          if (value != null) {
                                            setState(() {
                                              stakeType = value;
                                            });
                                          }
                                        },
                                        dropValue: stakeType,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                      )
                    : dropdownvalue == "Waiter and Table"
                    ? Query(
                        options: QueryOptions(document: gql(waiterQuery)),
                        builder:
                            (
                              QueryResult waiterResult, {
                              VoidCallback? refetch,
                              FetchMore? fetchMore,
                            }) {
                              if (waiterResult.isLoading) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (waiterResult.hasException) {
                                return Center(
                                  child: Text(
                                    "Error happened while fetching/displaying",
                                  ),
                                );
                              }

                              final waiters =
                                  (waiterResult.data?['waiters']
                                      as List<dynamic>?) ??
                                  [];
                              final VoidCallback? waiterRefetch = refetch;

                              return Query(
                                options: QueryOptions(
                                  document: gql(tableQuery),
                                ),
                                builder:
                                    (
                                      QueryResult tableResult, {
                                      VoidCallback? refetch,
                                      FetchMore? fetchMore,
                                    }) {
                                      if (tableResult.isLoading) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      if (tableResult.hasException) {
                                        return Center(
                                          child: Text(
                                            "Error happened while fetching/displaying",
                                          ),
                                        );
                                      }
                                      final tables =
                                          (tableResult.data?['tables']
                                              as List<dynamic>?) ??
                                          [];
                                      final VoidCallback? tableRefetch =
                                          refetch;

                                      return Mutation(
                                        options: MutationOptions(
                                          document: gql(deleteWaiterMutation),
                                          onCompleted: (data) {
                                            waiterRefetch?.call();
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Waiter Deleted Successfully!",
                                                ),
                                                duration: Duration(seconds: 2),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          },
                                          onError: (error) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Failed to delete the Waiter. Please try again.",
                                                ),
                                                duration: Duration(seconds: 2),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          },
                                        ),
                                        builder:
                                            (
                                              RunMutation waiterDeletion,
                                              QueryResult? resultDeleteWaiter,
                                            ) {
                                              return Mutation(
                                                options: MutationOptions(
                                                  document: gql(
                                                    deleteTableMutation,
                                                  ),
                                                  onCompleted: (data) {
                                                    tableRefetch?.call();
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          "Table Deleted Successfully!",
                                                        ),
                                                        duration: Duration(
                                                          seconds: 2,
                                                        ),
                                                        backgroundColor:
                                                            Colors.green,
                                                      ),
                                                    );
                                                  },
                                                  onError: (error) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          "Failed to delete the Table. Please try again.",
                                                        ),
                                                        duration: Duration(
                                                          seconds: 2,
                                                        ),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                builder:
                                                    (
                                                      RunMutation deleteTable,
                                                      QueryResult?
                                                      resultDeleteTable,
                                                    ) {
                                                      return WaiterAndTable(
                                                        tableAddition: () {
                                                          setState(() {
                                                            waiter = "table";
                                                          });
                                                        },
                                                        handleDeleteWaiter:
                                                            (item) {
                                                              waiterDeletion({
                                                                "id":
                                                                    item['id'],
                                                              });
                                                            },
                                                        handleUpdateWaiter: (item) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              final waiter =
                                                                  item;
                                                              final nameController =
                                                                  TextEditingController(
                                                                    text:
                                                                        waiter['name']
                                                                            ?.toString() ??
                                                                        '',
                                                                  );
                                                              final ageController =
                                                                  TextEditingController(
                                                                    text:
                                                                        waiter['age']
                                                                            ?.toString() ??
                                                                        '',
                                                                  );
                                                              final experienceController =
                                                                  TextEditingController(
                                                                    text:
                                                                        waiter['experience']
                                                                            ?.toString() ??
                                                                        '',
                                                                  );
                                                              final phoneController =
                                                                  TextEditingController(
                                                                    text:
                                                                        waiter['phoneNumber']
                                                                            ?.toString() ??
                                                                        '',
                                                                  );
                                                              String?
                                                              initialSex =
                                                                  waiter['sex']
                                                                      ?.toString();

                                                              return Query(
                                                                options: QueryOptions(
                                                                  document: gql(
                                                                    waiterQuery,
                                                                  ),
                                                                ),
                                                                builder:
                                                                    (
                                                                      QueryResult
                                                                      waiterResult, {
                                                                      VoidCallback?
                                                                      refetch,
                                                                      FetchMore?
                                                                      fetchMore,
                                                                    }) {
                                                                      if (waiterResult
                                                                          .isLoading) {
                                                                        return const Center(
                                                                          child:
                                                                              CircularProgressIndicator(),
                                                                        );
                                                                      }

                                                                      return StatefulBuilder(
                                                                        builder:
                                                                            (
                                                                              context,
                                                                              setState,
                                                                            ) {
                                                                              return Mutation(
                                                                                options: MutationOptions(
                                                                                  document: gql(
                                                                                    updateWaiterMutation,
                                                                                  ),
                                                                                  onCompleted:
                                                                                      (
                                                                                        data,
                                                                                      ) {
                                                                                        waiterRefetch?.call();
                                                                                        Navigator.of(
                                                                                          context,
                                                                                        ).pop();
                                                                                        _showSnackBar(
                                                                                          context,
                                                                                          "Waiter Updated Successfully!",
                                                                                          Colors.green,
                                                                                        );
                                                                                      },
                                                                                  onError:
                                                                                      (
                                                                                        error,
                                                                                      ) {
                                                                                        _showSnackBar(
                                                                                          context,
                                                                                          "Failed to update Waiter: ${error.toString()}",
                                                                                          Colors.red,
                                                                                        );
                                                                                      },
                                                                                ),
                                                                                builder:
                                                                                    (
                                                                                      RunMutation waiterUpdate,
                                                                                      QueryResult? waiterResult,
                                                                                    ) {
                                                                                      return AlertDialog(
                                                                                        title: const Text(
                                                                                          "Update Waiter Details",
                                                                                        ),
                                                                                        content: ConstrainedBox(
                                                                                          constraints: const BoxConstraints(
                                                                                            maxWidth: 600,
                                                                                            maxHeight: 600,
                                                                                          ),
                                                                                          child: Updatewaiter(
                                                                                            HotelName: widget.HotelName,
                                                                                            initialWaiterData: waiter,
                                                                                            nameController: nameController,
                                                                                            ageController: ageController,
                                                                                            experienceController: experienceController,
                                                                                            phoneController: phoneController,
                                                                                            selectedSex: initialSex,
                                                                                            onSexChanged:
                                                                                                (
                                                                                                  newSex,
                                                                                                ) {
                                                                                                  setState(
                                                                                                    () {
                                                                                                      initialSex = newSex;
                                                                                                    },
                                                                                                  );
                                                                                                },
                                                                                            onCancel: () => Navigator.of(
                                                                                              context,
                                                                                            ).pop(),
                                                                                            onUpdate: () {
                                                                                              final name = nameController.text;
                                                                                              final age = int.tryParse(
                                                                                                ageController.text,
                                                                                              );
                                                                                              final experience = int.tryParse(
                                                                                                experienceController.text,
                                                                                              );
                                                                                              final phone = phoneController.text;

                                                                                              if (name.isNotEmpty &&
                                                                                                  age !=
                                                                                                      null &&
                                                                                                  experience !=
                                                                                                      null &&
                                                                                                  phone.isNotEmpty &&
                                                                                                  initialSex !=
                                                                                                      null) {
                                                                                                waiterUpdate(
                                                                                                  {
                                                                                                    "id": item['id'],
                                                                                                    "name": name,
                                                                                                    "age": age,
                                                                                                    "sex": initialSex,
                                                                                                    "experience": experience,
                                                                                                    "phoneNumber": phone,
                                                                                                    "HotelName": widget.HotelName,
                                                                                                  },
                                                                                                );
                                                                                              } else {
                                                                                                _showSnackBar(
                                                                                                  context,
                                                                                                  "Please fill all fields with valid data.",
                                                                                                  Colors.orange,
                                                                                                );
                                                                                              }
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                              );
                                                                            },
                                                                      );
                                                                    },
                                                              );
                                                            },
                                                          );
                                                        },
                                                        handleTableUpdate: (item) {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              final table =
                                                                  item;
                                                              final tableNoController =
                                                                  TextEditingController(
                                                                    text:
                                                                        table['tableNo']
                                                                            ?.toString() ??
                                                                        '',
                                                                  );
                                                              final capacityController =
                                                                  TextEditingController(
                                                                    text:
                                                                        table['capacity']
                                                                            ?.toString() ??
                                                                        '',
                                                                  );

                                                              return Query(
                                                                options: QueryOptions(
                                                                  document: gql(
                                                                    tableQuery,
                                                                  ),
                                                                ),
                                                                builder:
                                                                    (
                                                                      QueryResult
                                                                      tableResult, {
                                                                      VoidCallback?
                                                                      refetch,
                                                                      FetchMore?
                                                                      fetchMore,
                                                                    }) {
                                                                      if (tableResult
                                                                          .isLoading) {
                                                                        return const Center(
                                                                          child:
                                                                              CircularProgressIndicator(),
                                                                        );
                                                                      }
                                                                      return Mutation(
                                                                        options: MutationOptions(
                                                                          document: gql(
                                                                            updateTableMutation,
                                                                          ),
                                                                          onCompleted:
                                                                              (
                                                                                data,
                                                                              ) {
                                                                                tableRefetch?.call();
                                                                                Navigator.of(
                                                                                  context,
                                                                                ).pop();
                                                                                _showSnackBar(
                                                                                  context,
                                                                                  "Table Updated Successfully!",
                                                                                  Colors.green,
                                                                                );
                                                                              },
                                                                          onError:
                                                                              (
                                                                                error,
                                                                              ) {
                                                                                _showSnackBar(
                                                                                  context,
                                                                                  "Failed to update Table: ${error.toString()}",
                                                                                  Colors.red,
                                                                                );
                                                                              },
                                                                        ),
                                                                        builder:
                                                                            (
                                                                              RunMutation
                                                                              tableUpdate,
                                                                              QueryResult?
                                                                              tableResult,
                                                                            ) {
                                                                              return AlertDialog(
                                                                                title: const Text(
                                                                                  "Update Table Details",
                                                                                ),
                                                                                content: ConstrainedBox(
                                                                                  constraints: const BoxConstraints(
                                                                                    maxWidth: 500,
                                                                                    maxHeight: 400,
                                                                                  ),
                                                                                  child: Updatetable(
                                                                                    HotelName: widget.HotelName,
                                                                                    initialTableData: table,
                                                                                    tableNoController: tableNoController,
                                                                                    capacityController: capacityController,
                                                                                    onCancel: () => Navigator.of(
                                                                                      context,
                                                                                    ).pop(),
                                                                                    onUpdate: () {
                                                                                      final tableNo = int.tryParse(
                                                                                        tableNoController.text,
                                                                                      );
                                                                                      final capacity = int.tryParse(
                                                                                        capacityController.text,
                                                                                      );

                                                                                      if (tableNo !=
                                                                                              null &&
                                                                                          capacity !=
                                                                                              null) {
                                                                                        tableUpdate(
                                                                                          {
                                                                                            "id": item['id'],
                                                                                            "tableNo": tableNo,
                                                                                            "capacity": capacity,
                                                                                            "HotelName": widget.HotelName,
                                                                                          },
                                                                                        );
                                                                                      } else {
                                                                                        _showSnackBar(
                                                                                          context,
                                                                                          "Please enter valid numbers for Table No and Capacity.",
                                                                                          Colors.orange,
                                                                                        );
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                      );
                                                                    },
                                                              );
                                                            },
                                                          );
                                                        },
                                                        handleDeleteTable:
                                                            (item) {
                                                              deleteTable({
                                                                "id":
                                                                    item['id'],
                                                              });
                                                            },
                                                        waiterAddition: () {
                                                          setState(() {
                                                            waiter = "waiter";
                                                          });
                                                        },
                                                        selected: waiter,
                                                        waiterList: waiters,
                                                        tablesList: tables,
                                                        handleTableExcel: () async {
                                                          if (tables
                                                              .isNotEmpty) {
                                                            await exportDataToExcel(
                                                              tables,
                                                              "Tables",
                                                            );
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  "Successfully Exported",
                                                                ),
                                                                duration:
                                                                    Duration(
                                                                      seconds:
                                                                          3,
                                                                    ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                              ),
                                                            );
                                                          } else {
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  "Somrthing Went Wrong.Please Try Again",
                                                                ),
                                                                duration:
                                                                    Duration(
                                                                      seconds:
                                                                          3,
                                                                    ),
                                                                backgroundColor:
                                                                    Colors.red,
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        handleWaiterExcel: () async {
                                                          if (waiters
                                                              .isNotEmpty) {
                                                            await exportDataToExcel(
                                                              waiters,
                                                              "Waiters",
                                                            );
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  "Successfully Exported",
                                                                ),
                                                                duration:
                                                                    Duration(
                                                                      seconds:
                                                                          3,
                                                                    ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .green,
                                                              ),
                                                            );
                                                          } else {
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                content: Text(
                                                                  "Something Went wrong.Please try Again",
                                                                ),
                                                                duration:
                                                                    Duration(
                                                                      seconds:
                                                                          3,
                                                                    ),
                                                                backgroundColor:
                                                                    Colors.red,
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        handleWaiter: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return Mutation(
                                                                options: MutationOptions(
                                                                  document: gql(
                                                                    createWaiterMutation,
                                                                  ),
                                                                  onCompleted: (data) {
                                                                    waiterName
                                                                        .clear();
                                                                    waiterAge
                                                                        .clear();
                                                                    waiterExperience
                                                                        .clear();
                                                                    waiterPhone
                                                                        .clear();
                                                                    _selectedSex =
                                                                        null;
                                                                    Navigator.of(
                                                                      context,
                                                                    ).pop();
                                                                    ScaffoldMessenger.of(
                                                                      context,
                                                                    ).showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            Text(
                                                                              "Waiter Added Successfully",
                                                                            ),
                                                                        duration: Duration(
                                                                          seconds:
                                                                              3,
                                                                        ),
                                                                        backgroundColor:
                                                                            Colors.green,
                                                                      ),
                                                                    );
                                                                    waiterRefetch
                                                                        ?.call();
                                                                  },
                                                                  onError: (error) {
                                                                    waiterName
                                                                        .clear();
                                                                    waiterAge
                                                                        .clear();
                                                                    waiterExperience
                                                                        .clear();
                                                                    waiterPhone
                                                                        .clear();
                                                                    _selectedSex =
                                                                        null;
                                                                    ScaffoldMessenger.of(
                                                                      context,
                                                                    ).showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            Text(
                                                                              "Something Went Wrong. Please Try Again",
                                                                            ),
                                                                        duration: Duration(
                                                                          seconds:
                                                                              3,
                                                                        ),
                                                                        backgroundColor:
                                                                            Colors.red,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                                builder:
                                                                    (
                                                                      RunMutation
                                                                      waiterMutation,
                                                                      QueryResult?
                                                                      waiterResult,
                                                                    ) {
                                                                      return AlertDialog(
                                                                        constraints: BoxConstraints(
                                                                          maxWidth:
                                                                              600,
                                                                          maxHeight:
                                                                              600,
                                                                        ),
                                                                        title: Text(
                                                                          "Enter Waiter Details",
                                                                        ),
                                                                        content: StatefulBuilder(
                                                                          builder:
                                                                              (
                                                                                BuildContext
                                                                                context,
                                                                                StateSetter
                                                                                setDialogState,
                                                                              ) {
                                                                                return SingleChildScrollView(
                                                                                  child: Column(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      TextField(
                                                                                        controller: waiterName,
                                                                                        decoration: InputDecoration(
                                                                                          labelText: "Name",
                                                                                          border: OutlineInputBorder(),
                                                                                        ),
                                                                                        keyboardType: TextInputType.name,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 16,
                                                                                      ),
                                                                                      DropdownButton<
                                                                                        String
                                                                                      >(
                                                                                        value: _selectedSex,
                                                                                        hint: const Text(
                                                                                          "Choose Sex...",
                                                                                        ),
                                                                                        icon: const Icon(
                                                                                          Icons.arrow_drop_down,
                                                                                        ),
                                                                                        iconSize: 24,
                                                                                        elevation: 16,
                                                                                        isExpanded: true,
                                                                                        items: [
                                                                                          DropdownMenuItem<
                                                                                            String
                                                                                          >(
                                                                                            value: "Male",
                                                                                            child: Text(
                                                                                              "Male",
                                                                                            ),
                                                                                          ),
                                                                                          DropdownMenuItem<
                                                                                            String
                                                                                          >(
                                                                                            value: "Female",
                                                                                            child: Text(
                                                                                              "Female",
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                        onChanged:
                                                                                            (
                                                                                              String? newValue,
                                                                                            ) {
                                                                                              setDialogState(
                                                                                                () {
                                                                                                  _selectedSex = newValue;
                                                                                                },
                                                                                              );
                                                                                            },
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 16,
                                                                                      ),
                                                                                      TextField(
                                                                                        controller: waiterAge,
                                                                                        decoration: InputDecoration(
                                                                                          labelText: "Age",
                                                                                          border: OutlineInputBorder(),
                                                                                        ),
                                                                                        keyboardType: TextInputType.number,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 16,
                                                                                      ),
                                                                                      TextField(
                                                                                        controller: waiterExperience,
                                                                                        decoration: InputDecoration(
                                                                                          labelText: "Experience",
                                                                                          border: OutlineInputBorder(),
                                                                                        ),
                                                                                        keyboardType: TextInputType.number,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        height: 16,
                                                                                      ),
                                                                                      TextField(
                                                                                        controller: waiterPhone,
                                                                                        decoration: InputDecoration(
                                                                                          labelText: "Phone Number",
                                                                                          border: OutlineInputBorder(),
                                                                                        ),
                                                                                        keyboardType: TextInputType.phone,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              },
                                                                        ),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed: () {
                                                                              Navigator.of(
                                                                                context,
                                                                              ).pop();
                                                                            },
                                                                            child: const Text(
                                                                              "Cancel",
                                                                            ),
                                                                          ),
                                                                          ElevatedButton(
                                                                            onPressed: () {
                                                                              final name = waiterName.text;
                                                                              final age = int.tryParse(
                                                                                waiterAge.text,
                                                                              );
                                                                              final experience = int.tryParse(
                                                                                waiterExperience.text,
                                                                              );
                                                                              final phone = waiterPhone.text;

                                                                              if (name.isNotEmpty &&
                                                                                  age !=
                                                                                      null &&
                                                                                  experience !=
                                                                                      null &&
                                                                                  phone.isNotEmpty &&
                                                                                  _selectedSex!.isNotEmpty) {
                                                                                waiterMutation(
                                                                                  {
                                                                                    "name": name,
                                                                                    "age": age,
                                                                                    "sex": _selectedSex,
                                                                                    "phoneNumber": phone,
                                                                                    "experience": experience,
                                                                                    "HotelName": widget.HotelName,
                                                                                  },
                                                                                );
                                                                              } else {
                                                                                ScaffoldMessenger.of(
                                                                                  context,
                                                                                ).showSnackBar(
                                                                                  SnackBar(
                                                                                    content: Text(
                                                                                      "Please Fill the Required Input Fields.",
                                                                                    ),
                                                                                    duration: Duration(
                                                                                      seconds: 3,
                                                                                    ),
                                                                                    backgroundColor: Colors.red,
                                                                                  ),
                                                                                );
                                                                              }
                                                                            },
                                                                            child: const Text(
                                                                              "Submit",
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                              );
                                                            },
                                                          );
                                                        },
                                                        handleTable: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return Mutation(
                                                                options: MutationOptions(
                                                                  document: gql(
                                                                    createTableMutation,
                                                                  ),
                                                                  onCompleted: (data) {
                                                                    tableNumber
                                                                        .clear();
                                                                    tableCapacity
                                                                        .clear();
                                                                    Navigator.of(
                                                                      context,
                                                                    ).pop();
                                                                    ScaffoldMessenger.of(
                                                                      context,
                                                                    ).showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            Text(
                                                                              "Table Created Successfully",
                                                                            ),
                                                                        duration: Duration(
                                                                          seconds:
                                                                              3,
                                                                        ),
                                                                        backgroundColor:
                                                                            Colors.green,
                                                                      ),
                                                                    );
                                                                    tableRefetch
                                                                        ?.call();
                                                                  },
                                                                  onError: (error) {
                                                                    tableNumber
                                                                        .clear();
                                                                    tableCapacity
                                                                        .clear();
                                                                    ScaffoldMessenger.of(
                                                                      context,
                                                                    ).showSnackBar(
                                                                      SnackBar(
                                                                        content:
                                                                            Text(
                                                                              "Something Went Wrong.Please Try Again",
                                                                            ),
                                                                        duration: Duration(
                                                                          seconds:
                                                                              3,
                                                                        ),
                                                                        backgroundColor:
                                                                            Colors.red,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                                builder:
                                                                    (
                                                                      RunMutation
                                                                      tableMutation,
                                                                      QueryResult?
                                                                      tableResult,
                                                                    ) {
                                                                      return AlertDialog(
                                                                        constraints: BoxConstraints(
                                                                          maxWidth:
                                                                              500,
                                                                          maxHeight:
                                                                              400,
                                                                        ),
                                                                        title: Text(
                                                                          "Enter Table Details",
                                                                        ),
                                                                        content: SingleChildScrollView(
                                                                          child: Column(
                                                                            children: [
                                                                              TextField(
                                                                                controller: tableNumber,
                                                                                decoration: InputDecoration(
                                                                                  hintText: "Table Number",
                                                                                  border: OutlineInputBorder(),
                                                                                ),
                                                                                keyboardType: TextInputType.number,
                                                                              ),
                                                                              SizedBox(
                                                                                height: 16,
                                                                              ),
                                                                              TextField(
                                                                                controller: tableCapacity,
                                                                                decoration: InputDecoration(
                                                                                  labelText: "Table Capacity",
                                                                                  border: OutlineInputBorder(),
                                                                                ),
                                                                                keyboardType: TextInputType.number,
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed: () {
                                                                              Navigator.of(
                                                                                context,
                                                                              ).pop();
                                                                            },
                                                                            child: const Text(
                                                                              "Cancel",
                                                                            ),
                                                                          ),
                                                                          ElevatedButton(
                                                                            onPressed: () {
                                                                              final tableNo = int.tryParse(
                                                                                tableNumber.text,
                                                                              );
                                                                              final capacity = int.tryParse(
                                                                                tableCapacity.text,
                                                                              );
                                                                              tableMutation(
                                                                                {
                                                                                  "tableNo": tableNo,
                                                                                  "capacity": capacity,
                                                                                  "HotelName": widget.HotelName,
                                                                                },
                                                                              );
                                                                            },
                                                                            child: const Text(
                                                                              "Submit",
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                              );
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                              );
                                            },
                                      );
                                    },
                              );
                            },
                      )
                    : Text("Select an option from the dropdown"),
              ],
            ),
          ],
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
    // ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void handleCalender() async {
    if (dropdownvalue == "Daily Report") {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialDate: calenderValue,
      );
      if (pickedDate != null) {
        setState(() {
          calenderValue = pickedDate;
        });
      }
    } else {
      DateTime? pickedMonth = await showMonthPicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        initialDate: calenderValue,
      );
      if (pickedMonth != null) {
        setState(() {
          calenderValue = pickedMonth;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.values.forEach((c) => c.dispose());
    priceController.values.forEach((c) => c.dispose());
    imageController.values.forEach((c) => c.dispose());
    waiterName.dispose();
    waiterAge.dispose();
    waiterExperience.dispose();
    waiterPhone.dispose();
    tableNumber.dispose();
    tableCapacity.dispose();
    catValueMap.clear();
    super.dispose();
  }
}
