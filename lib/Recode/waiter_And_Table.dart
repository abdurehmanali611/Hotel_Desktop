// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

class WaiterAndTable extends StatelessWidget {
  final VoidCallback tableAddition;
  final VoidCallback waiterAddition;
  final String selected;
  final List<dynamic> waiterList;
  final List<dynamic> tablesList;
  final VoidCallback handleWaiter;
  final VoidCallback handleTable;
  final VoidCallback handleWaiterExcel;
  final VoidCallback handleTableExcel;
  final void Function(dynamic) handleDeleteWaiter;
  final void Function(dynamic) handleDeleteTable;
  final void Function(dynamic) handleUpdateWaiter;
  final void Function(dynamic) handleTableUpdate;
  const WaiterAndTable({
    super.key,
    required this.tableAddition,
    required this.waiterAddition,
    required this.selected,
    required this.handleTable,
    required this.handleWaiter,
    required this.tablesList,
    required this.waiterList,
    required this.handleTableExcel,
    required this.handleWaiterExcel,
    required this.handleDeleteWaiter,
    required this.handleDeleteTable,
    required this.handleUpdateWaiter,
    required this.handleTableUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final thisMonth = DateTime.now();
    final filteredWaiterList = waiterList.where((item) {
      DateTime createdAt = DateTime.fromMillisecondsSinceEpoch(
        item['createdAt'],
      );
      return createdAt.month == thisMonth.month &&
          createdAt.year == thisMonth.year;
    });
    final filteredTableList = tablesList.where((item) {
      DateTime createdAt = DateTime.fromMillisecondsSinceEpoch(
        item['createdAt'],
      );
      return createdAt.month == thisMonth.month &&
          createdAt.year == thisMonth.year;
    });

    const TextStyle headerStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      fontFamily: "NotoSerif",
      fontStyle: FontStyle.italic,
    );

    const TextStyle itemStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    return Container(
      margin: const EdgeInsets.only(top: 50, left: 80, right: 80, bottom: 50),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: tableAddition,
                child: const Text("Table Details"),
              ),
              ElevatedButton(
                onPressed: waiterAddition,
                child: const Text("Waiter Details"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          selected.isEmpty
              ? const Text("Select a table or waiter to view details")
              : selected.toLowerCase() == "waiter"
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text("Waiter Name", style: headerStyle),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Center(child: Text("Sex", style: headerStyle)),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Center(child: Text("Age", style: headerStyle)),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Center(child: Text("Exp", style: headerStyle)),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Center(
                            child: Text("Phone No.", style: headerStyle),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Center(
                            child: Text("Orders", style: headerStyle),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Text(
                            "Sales Amount",
                            style: headerStyle,
                            textAlign: TextAlign.end,
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Text(
                            "Actions",
                            style: headerStyle,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    if (filteredWaiterList.isEmpty)
                      const Center(
                        child: Text(
                          "No Data",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredWaiterList.length,
                        itemBuilder: (context, index) {
                          final item = filteredWaiterList.elementAt(index);
                          List<dynamic> prices =
                              (item['price'] as List?)?.cast<double>() ?? [];
                          List<dynamic> tables =
                              (item['tablesServed'] as List?)?.cast<int>() ??
                              [];

                          final totalSales = prices.fold(
                            0.0,
                            (sum, price) => sum + price,
                          );
                          final completedOrders = tables.length;

                          return Column(
                            children: [
                              Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 0,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          item['name'],
                                          style: itemStyle,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            item['sex'],
                                            style: itemStyle,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            "${item['age']}",
                                            style: itemStyle,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            "${item['experience']}",
                                            style: itemStyle,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Text(
                                            item['phoneNumber'],
                                            style: itemStyle,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: Text(
                                            "$completedOrders",
                                            style: itemStyle,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          totalSales.toStringAsFixed(2),
                                          style: itemStyle.copyWith(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () =>
                                                  handleUpdateWaiter(item),
                                              icon: Icon(Icons.edit),
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  handleDeleteWaiter(item),
                                              icon: Icon(Icons.delete),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: handleWaiter,
                          child: const Text("Add Waiter"),
                        ),
                        ElevatedButton(
                          onPressed: handleWaiterExcel,
                          child: const Text("Export To Excel"),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text("Table Number", style: headerStyle),
                        ),
                        const Expanded(
                          flex: 3,
                          child: Center(
                            child: Text("Capacity", style: headerStyle),
                          ),
                        ),
                        const Expanded(
                          flex: 3,
                          child: Center(
                            child: Text("Completed Orders", style: headerStyle),
                          ),
                        ),
                        const Expanded(
                          flex: 3,
                          child: Text(
                            "Sales Generated",
                            style: headerStyle,
                            textAlign: TextAlign.end,
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "Actions",
                            style: headerStyle,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    if (filteredTableList.isEmpty)
                      const Center(
                        child: Text(
                          "No Data",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredTableList.length,
                        itemBuilder: (context, index) {
                          final item = filteredTableList.elementAt(index);
                          List<dynamic> prices =
                              (item['price'] as List?)?.cast<double>() ?? [];
                          List<dynamic> payments =
                              (item['payment'] as List?)?.cast<String>() ?? [];

                          final totalSales = prices.fold(
                            0.0,
                            (sum, price) => sum + price,
                          );
                          final completedOrders = payments
                              .where((p) => p == "Paid")
                              .length;
                          return Column(
                            children: [
                              Card(
                                elevation: 2,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 0,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "${item['tableNo']}",
                                          style: itemStyle,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            "${item['capacity']}",
                                            style: itemStyle,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            "$completedOrders",
                                            style: itemStyle,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          totalSales.toStringAsFixed(2),
                                          style: itemStyle.copyWith(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () =>
                                                  handleTableUpdate(item),
                                              icon: Icon(Icons.edit),
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  handleDeleteTable(item),
                                              icon: Icon(Icons.delete),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: handleTable,
                          child: const Text("Add Table"),
                        ),
                        ElevatedButton(
                          onPressed: handleTableExcel,
                          child: const Text("Export To Excel"),
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
