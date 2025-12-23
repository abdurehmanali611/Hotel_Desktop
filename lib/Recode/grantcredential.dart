import 'package:hotcol/utils/apptheme.dart';
import 'package:flutter/material.dart';

class GrantCredential extends StatelessWidget {
  final String kitchen;
  final String barista;
  final String cashier;
  final String title_1;
  final String title_2;
  final String dropValue;
  final TextEditingController credUsername;
  final TextEditingController credPassword;
  final VoidCallback handleGrant;
  final void Function(String?) handleStake;
  const GrantCredential({
    super.key,
    required this.kitchen,
    required this.barista,
    required this.cashier,
    required this.handleStake,
    required this.title_1,
    required this.credUsername,
    required this.title_2,
    required this.credPassword,
    required this.handleGrant,
    required this.dropValue
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 450, vertical: 50),
      decoration: BoxDecoration(color: Colors.white),
      child: Container(
        padding: EdgeInsets.only(left: 50, top: 10, bottom: 10, right: 10),
        decoration: BoxDecoration(
          color: Apptheme.containerlogin,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 150,
                height: 38,
                padding: EdgeInsets.only(left: 10),
                alignment: Alignment.topRight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Apptheme.mostbgcolor,
                ),
                child: DropdownButton(
                  value: dropValue,
                  items: [
                    DropdownMenuItem(value: kitchen, child: Text(kitchen)),
                    DropdownMenuItem(value: barista, child: Text(barista)),
                    DropdownMenuItem(value: cashier, child: Text(cashier)),
                  ],
                  onChanged: handleStake,
                  isExpanded: true,
                  dropdownColor: Apptheme.mostbgcolor,
                  borderRadius: BorderRadius.circular(20),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Apptheme.buttontxt,
                  ),
                  underline: Container(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title_1,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 35,
                width: 250,
                child: TextField(
                  controller: credUsername,
                  decoration: InputDecoration(
                    hintText: "Enter Username",
                    fillColor: Apptheme.mostbgcolor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title_2,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 35,
                width: 250,
                child: TextField(
                  controller: credPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Enter password",
                    fillColor: Apptheme.mostbgcolor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: handleGrant,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Apptheme.buttonbglogin),
                  foregroundColor: WidgetStateProperty.all(Apptheme.buttontxt)
                ),
                child: Text("Grant", style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
