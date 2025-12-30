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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 14,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            flex: 3,
                            child: Text("Waiter Name", style: headerStyle),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text("Sex", style: headerStyle),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text("Age", style: headerStyle),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text("Exp", style: headerStyle),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text("Phone No.", style: headerStyle),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Text("Orders", style: headerStyle),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Sales Amount",
                              style: headerStyle,
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Actions",
                              style: headerStyle,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
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
                          List<dynamic> prices = (item['price'] as List?) ?? [];
                          List<dynamic> tables =
                              (item['tablesServed'] as List?)?.cast<int>() ??
                              [];

                          final totalSales = prices.fold<double>(0.0, (
                            sum,
                            price,
                          ) {
                            if (price == null) return sum;
                            if (price is num) return sum + price.toDouble();
                            final parsed = double.tryParse(price.toString());
                            return sum + (parsed ?? 0.0);
                          });
                          final completedOrders = tables.length;

                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.grey.shade200,
                                          child: Text(
                                            (item['name'] != null &&
                                                    item['name']
                                                        .toString()
                                                        .isNotEmpty)
                                                ? item['name']
                                                      .toString()[0]
                                                      .toUpperCase()
                                                : '?',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            item['name'] ?? '',
                                            style: itemStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        item['sex'] ?? '',
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
                                        item['phoneNumber'] ?? '',
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          tooltip: 'Edit waiter',
                                          onPressed: () =>
                                              handleUpdateWaiter(item),
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 20,
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: 'Delete waiter',
                                          onPressed: () =>
                                              handleDeleteWaiter(item),
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            flex: 2,
                            child: Text("Table Number", style: headerStyle),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Text("Capacity", style: headerStyle),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Center(
                              child: Text(
                                "Completed Orders",
                                style: headerStyle,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Sales Generated",
                              style: headerStyle,
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Actions",
                              style: headerStyle,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
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
                          List<dynamic> prices = (item['price'] as List?) ?? [];
                          List<dynamic> payments =
                              (item['payment'] as List?)?.cast<String>() ?? [];

                          final totalSales = prices.fold<double>(0.0, (
                            sum,
                            price,
                          ) {
                            if (price == null) return sum;
                            if (price is num) return sum + price.toDouble();
                            final parsed = double.tryParse(price.toString());
                            return sum + (parsed ?? 0.0);
                          });
                          final completedOrders = payments
                              .where((p) => p == "Paid")
                              .length;
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 18,
                                          backgroundColor: Colors.grey.shade100,
                                          child: const Icon(
                                            Icons.table_chart,
                                            color: Colors.black54,
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          "${item['tableNo']}",
                                          style: itemStyle,
                                        ),
                                      ],
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          tooltip: 'Edit table',
                                          onPressed: () =>
                                              handleTableUpdate(item),
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 20,
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: 'Delete table',
                                          onPressed: () =>
                                              handleDeleteTable(item),
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
