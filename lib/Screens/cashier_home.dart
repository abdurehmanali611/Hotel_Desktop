// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:hotcol/CashierJobs/order.dart';
import 'package:hotcol/CashierJobs/payment.dart';
import 'package:hotcol/utils/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CashierHome extends StatefulWidget {
  final String HotelName;
  final String Logo;
  const CashierHome({super.key, required this.HotelName, required this.Logo});

  @override
  State<CashierHome> createState() => _CashierHomeState();
}

class _CashierHomeState extends State<CashierHome> {
  bool order = true;

  final _tableNoController = TextEditingController();
  final _waiterNameController = TextEditingController();
  final _orderAmount = TextEditingController();

  final String orderCreationMutation = """
  	mutation OrderCreation(\$title: String!, \$imageUrl: String!, \$tableNo: Int!, \$waiterName: String!, \$status: String, \$payment: String, \$category: String!, \$price: Float!, \$HotelName: String!, \$orderAmount: Int!){
  	 	OrderCreation(title: \$title, imageUrl: \$imageUrl, tableNo: \$tableNo, waiterName: \$waiterName, status: \$status, payment: \$payment, category: \$category, price: \$price, HotelName: \$HotelName, orderAmount: \$orderAmount) {
  	 	 	title
  	 	 	imageUrl
  	 	 	tableNo
  	 	 	orderAmount
  	 	 	category
  	 	 	HotelName
  	 	 	price
  	 	 	waiterName
  	 	 	status
  	 	 	payment
  	 	}
  	}
  """;

  final String getItemsQuery = """
  	query {
  	 	items {
  	 	 	id
  	 	 	name
  	 	 	price
  	 	 	HotelName
  	 	 	category
  	 	 	imageUrl
  	 	 	createdAt
  	 	}
  	}
  """;

  final String getOrdersQuery = """
  query{
  orders{
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
   }
  }
""";

  final String tablesQuery = """
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

  final String getUnpaidOrdersQuery = """
    query {
      orders {
        id
        tableNo
        HotelName
        payment
      }
    }
  """;

  final String payUpdateMutation = """
  mutation UpdatePayment(\$id: Int!, \$payment: String){
  UpdatePayment(id: \$id, payment: \$payment) {
  id
  title
  payment
  }
  }
""";

  final String paymentWaiterUpdate = """
 mutation UpdatePaymentWaiter(\$id: Int!, \$payment: JSON!, \$price: JSON!, \$tablesServed: JSON!, \$HotelName: String!) {
  UpdatePaymentWaiter(id: \$id, payment: \$payment, price: \$price, tablesServed: \$tablesServed, HotelName: \$HotelName) {
    id
    HotelName
    payment
    tablesServed
    price
  }
 }
""";

  final String paymentUpdateTable = """
  mutation UpdatePaymentTable(\$id: Int!, \$payment: JSON!, \$price: JSON!, \$HotelName: String!) {
    UpdatePaymentTable(id: \$id, payment: \$payment, price: \$price, HotelName: \$HotelName) {
      id
      HotelName
      payment
      price
    }
  }
""";

  void _updateWaiterPayment({
    required RunMutation waiterMutation,
    required String waiterName,
    required int tableNo,
    required double sales,
    required String HotelName,
  }) {
    final client = GraphQLProvider.of(context).value;

    client
        .query(
          QueryOptions(
            document: gql(waiterQuery),
            variables: {'name': waiterName, 'HotelName': HotelName},
          ),
        )
        .then((result) {
          if (result.hasException) {
            return;
          }

          final waiters = result.data?['waiters'] as List<dynamic>? ?? [];
          if (waiters.isEmpty) {
            return;
          }

          final waiter = waiters.firstWhere(
            (item) =>
                item['name'] == waiterName && item['HotelName'] == HotelName,
            orElse: () => null,
          );
          if (waiter == null) {
            return;
          }
          final int waiterId = waiter['id'];
          final List<dynamic> currentPayments = waiter['payment'] ?? [];
          final List<dynamic> currentPrices = waiter['price'] ?? [];
          final List<dynamic> currentTablesServed =
              waiter['tablesServed'] ?? [];

          final List<String> newPayments = [
            ...currentPayments.map((p) => p.toString()),
            "Done",
          ];
          final List<double> newPrices = [
            ...currentPrices.map((p) => double.parse(p.toString())),
            sales,
          ];
          final List<int> newTablesServed = [
            ...currentTablesServed.map((t) => int.parse(t.toString())),
            tableNo,
          ];

          waiterMutation({
            "id": waiterId,
            "payment": newPayments,
            "price": newPrices,
            "tablesServed": newTablesServed,
            "HotelName": HotelName,
          });
        });
  }

  void _updateTablePayment({
    required RunMutation tableMutation,
    required int tableNo,
    required double sales,
    required String HotelName,
  }) {
    final client = GraphQLProvider.of(context).value;

    client
        .query(
          QueryOptions(
            document: gql(tablesQuery),
            variables: {'tableNo': tableNo, 'HotelName': HotelName},
          ),
        )
        .then((result) {
          if (result.hasException) {
            return;
          }

          final tables = result.data?['tables'] as List<dynamic>? ?? [];
          if (tables.isEmpty) {
            return;
          }

          final table = tables.firstWhere(
            (t) => t['tableNo'] == tableNo && t['HotelName'] == HotelName,
            orElse: () => null,
          );
          if (table == null) {
            return;
          }
          final int tableId = table['id'];
          final List<dynamic> currentPayments = table['payment'] ?? [];
          final List<dynamic> currentPrices = table['price'] ?? [];

          final List<String> newPayments = [
            ...currentPayments.map((p) => p.toString()),
            "Done",
          ];
          final List<double> newPrices = [
            ...currentPrices.map((p) => double.parse(p.toString())),
            sales,
          ];

          tableMutation({
            "id": tableId,
            "payment": newPayments,
            "price": newPrices,
            "HotelName": HotelName,
          });
        });
  }

  Future<void> _showOrderDetailsDialog(
    BuildContext context,
    dynamic item,
    RunMutation runMutation,
  ) async {
    try {
      _tableNoController.clear();
      _waiterNameController.clear();
      _orderAmount.clear();

      int? localSelectedTableNo;
      String? localSelectedWaiterName;

      await showDialog(
        context: context,
        builder: (context) {
          return Query(
            options: QueryOptions(document: gql(waiterQuery)),
            builder:
                (
                  QueryResult waiterResult, {
                  VoidCallback? refetch,
                  FetchMore? fetchMore,
                }) {
                  if (waiterResult.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final waiters =
                      (waiterResult.data?['waiters'] as List<dynamic>?) ?? [];
                  final List<String> waiterNames = waiters
                      .where((w) => w['HotelName'] == widget.HotelName)
                      .map<String>((w) => w['name'] as String)
                      .toList();

                  return Query(
                    options: QueryOptions(document: gql(tablesQuery)),
                    builder:
                        (
                          QueryResult tableResult, {
                          VoidCallback? refetch,
                          FetchMore? fetchMore,
                        }) {
                          if (tableResult.isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final tables =
                              (tableResult.data?['tables'] as List<dynamic>?) ??
                              [];
                          final List<int> tableNumbers =
                              tables
                                  .where(
                                    (t) =>
                                        t != null &&
                                        t['HotelName'] == widget.HotelName,
                                  )
                                  .map<int>((t) {
                                    final tableNo = t['tableNo'];
                                    if (tableNo is int) {
                                      return tableNo;
                                    } else if (tableNo is double) {
                                      return tableNo.toInt();
                                    } else if (tableNo is String) {
                                      return int.tryParse(tableNo) ?? 0;
                                    } else {
                                      return 0;
                                    }
                                  })
                                  .where((tableNo) => tableNo > 0)
                                  .toList()
                                ..sort();

                          if (waiterNames.isEmpty || tableNumbers.isEmpty) {
                            return AlertDialog(
                              title: Text('No Data Available'),
                              content: Text(
                                waiterNames.isEmpty && tableNumbers.isEmpty
                                    ? 'No waiters or tables found for ${widget.HotelName}'
                                    : waiterNames.isEmpty
                                    ? 'No waiters found for ${widget.HotelName}'
                                    : 'No tables found for ${widget.HotelName}',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          }

                          return AlertDialog(
                            title: const Text('Enter Order Details'),
                            content: StatefulBuilder(
                              builder:
                                  (
                                    BuildContext dialogContext,
                                    StateSetter setDialogState,
                                  ) {
                                    return SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: _orderAmount,
                                            decoration: const InputDecoration(
                                              labelText: 'Amount',
                                              border: OutlineInputBorder(),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                          const SizedBox(height: 16),

                                          DropdownButtonFormField<int>(
                                            decoration: const InputDecoration(
                                              labelText: 'Table Number',
                                              border: OutlineInputBorder(),
                                            ),
                                            value: localSelectedTableNo,
                                            hint: const Text("Select Table"),
                                            items: tableNumbers.map((
                                              int tableNo,
                                            ) {
                                              return DropdownMenuItem<int>(
                                                value: tableNo,
                                                child: Text('Table $tableNo'),
                                              );
                                            }).toList(),
                                            onChanged: (int? newValue) {
                                              setDialogState(() {
                                                localSelectedTableNo = newValue;
                                                _tableNoController.text =
                                                    newValue?.toString() ?? "";
                                              });
                                            },
                                          ),
                                          const SizedBox(height: 16),
                                          DropdownButtonFormField<String>(
                                            decoration: const InputDecoration(
                                              labelText: 'Waiter Name',
                                              border: OutlineInputBorder(),
                                            ),
                                            value: localSelectedWaiterName,
                                            hint: const Text("Select Waiter"),
                                            items: waiterNames.map((
                                              String name,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: name,
                                                child: Text(name),
                                              );
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setDialogState(() {
                                                localSelectedWaiterName =
                                                    newValue;
                                                _waiterNameController.text =
                                                    newValue ?? "";
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  final tableNo = int.tryParse(
                                    _tableNoController.text,
                                  );
                                  final waiterName = _waiterNameController.text;
                                  final orderAmount = int.tryParse(
                                    _orderAmount.text,
                                  );

                                  if (tableNo != null &&
                                      waiterName.isNotEmpty &&
                                      orderAmount != null) {
                                    runMutation({
                                      "title": item['name'],
                                      "imageUrl": item['imageUrl'],
                                      "tableNo": tableNo,
                                      "waiterName": waiterName,
                                      "orderAmount": orderAmount,
                                      "HotelName": widget.HotelName,
                                      "status": null,
                                      "payment": null,
                                      "category": item['category'],
                                      "price": item['price'],
                                    });
                                    Navigator.of(context).pop();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please select a Table, Waiter, and enter a valid Amount',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Submit Order'),
                              ),
                            ],
                          );
                        },
                  );
                },
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to open dialog: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _tableNoController.dispose();
    _waiterNameController.dispose();
    _orderAmount.dispose();
    super.dispose();
  }

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
              "${widget.HotelName} Cashier",
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 1200,
                maxHeight: constraints.maxHeight,
              ),
              child: order
                  ? Query(
                      options: QueryOptions(document: gql(getItemsQuery)),
                      builder:
                          (
                            QueryResult result, {
                            VoidCallback? refetch,
                            FetchMore? fetchMore,
                          }) {
                            if (result.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (result.hasException) {
                              return Text(
                                "Error: ${result.exception.toString()}",
                              );
                            }

                            final items =
                                (result.data?['items'] as List<dynamic>?) ?? [];

                            return Mutation(
                              options: MutationOptions(
                                document: gql(orderCreationMutation),
                                onCompleted: (data) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Order Sent Successfully"),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                onError: (error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Something went Wrong. Please Try Again",
                                      ),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                },
                              ),
                              builder:
                                  (
                                    RunMutation runMutation,
                                    QueryResult? mutationResult,
                                  ) {
                                    return Order(
                                      handleChange: () =>
                                          setState(() => order = false),
                                      items: items,
                                      HotelName: widget.HotelName,
                                      onItemSelected: (item) {
                                        _showOrderDetailsDialog(
                                          context,
                                          item,
                                          runMutation,
                                        );
                                      },
                                    );
                                  },
                            );
                          },
                    )
                  : Query(
                      options: QueryOptions(document: gql(getOrdersQuery)),
                      builder:
                          (
                            QueryResult result, {
                            VoidCallback? refetch,
                            FetchMore? fetchMore,
                          }) {
                            if (result.isLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (result.hasException) {
                              return Center(child: Text("Error Happened"));
                            }

                            final items =
                                (result.data?['orders'] as List<dynamic>?) ??
                                [];

                            return Mutation(
                              options: MutationOptions(
                                document: gql(payUpdateMutation),
                                onCompleted: (data) {
                                  refetch?.call();
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
                              builder: (RunMutation runMutation, QueryResult? result) {
                                return Mutation(
                                  options: MutationOptions(
                                    document: gql(paymentWaiterUpdate),
                                    onCompleted: (data) {},
                                    onError: (error) {},
                                  ),
                                  builder:
                                      (
                                        RunMutation waiterMutation,
                                        QueryResult? waiterResult,
                                      ) {
                                        return Mutation(
                                          options: MutationOptions(
                                            document: gql(paymentUpdateTable),
                                            onCompleted: (data) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Everything is Updated Successfully",
                                                  ),
                                                  duration: Duration(
                                                    seconds: 3,
                                                  ),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            },
                                            onError: (error) {},
                                          ),
                                          builder:
                                              (
                                                RunMutation tableMutation,
                                                QueryResult? tableResult,
                                              ) {
                                                return Payment(
                                                  handleChange: () {
                                                    setState(() {
                                                      order = true;
                                                    });
                                                  },
                                                  items: items,
                                                  HotelName: widget.HotelName,
                                                  handlePayment:
                                                      (
                                                        int id,
                                                        Map<String, dynamic>
                                                        item,
                                                        double sales,
                                                      ) {
                                                        runMutation({
                                                          "id": id,
                                                          "payment": "Paid",
                                                        });
                                                        _updateWaiterPayment(
                                                          waiterMutation:
                                                              waiterMutation,
                                                          waiterName:
                                                              item['waiterName']
                                                                  .toString(),
                                                          tableNo:
                                                              item['tableNo'],
                                                          sales: sales,
                                                          HotelName:
                                                              widget.HotelName,
                                                        );
                                                        _updateTablePayment(
                                                          tableMutation:
                                                              tableMutation,
                                                          tableNo:
                                                              item['tableNo'],
                                                          sales: sales,
                                                          HotelName:
                                                              widget.HotelName,
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
                    ),
            ),
          );
        },
      ),
    );
  }
}
