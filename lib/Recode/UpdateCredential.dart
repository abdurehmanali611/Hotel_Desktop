// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:hotcol/utils/apptheme.dart';

class Updatecredential extends StatelessWidget {
  final String HotelName;
  final List<dynamic> credentials;
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback handleAdminUpdate;
  final VoidCallback handleCredUpdate;
  final String dropValue;
  final void Function(String?) handleStake;
  final String Kitchen;
  final String barista;
  final String cashier;

  const Updatecredential({
    super.key,
    required this.credentials,
    required this.HotelName,
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.handleAdminUpdate,
    required this.handleCredUpdate,
    required this.handleStake,
    required this.dropValue,
    required this.Kitchen,
    required this.barista,
    required this.cashier,
    required this.confirmPasswordController,
    required this.usernameController,
    required this.passwordController
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(40), 
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildSectionColumn(
                title: "Change Admin Password",
                children: [
                  _buildLabel("Old Password:"),
                  _buildTextField(controller: oldPasswordController, hint: "Enter password", obscure: true),
                  _buildLabel("New Password:"),
                  _buildTextField(controller: newPasswordController, hint: "Enter password", obscure: true),
                  _buildLabel("Confirm Password:"),
                  _buildTextField(controller: confirmPasswordController, hint: "Enter password", obscure: true),
                  const SizedBox(height: 30),
                  _buildUpdateButton(type: "admin"),
                ],
              ),
            ),

            const VerticalDivider(width: 100, thickness: 1, color: Color(0xFFEEEEEE)),

            Expanded(
              child: _buildSectionColumn(
                title: "Update Other Credentials",
                children: [
                  _buildLabel("Select Credential:"),
                  _buildDropdown(),
                  _buildLabel("Credential UserName:"),
                  _buildTextField(controller: usernameController, hint: "Enter Username"),
                  _buildLabel("Credential Password:"),
                  _buildTextField(controller: passwordController, hint: "Enter password", obscure: true),
                  const SizedBox(height: 30),
                  _buildUpdateButton(type: "cred"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionColumn({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 25),
        ...children,
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, bool obscure = false}) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        cursorColor: Colors.redAccent,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          fillColor: Apptheme.mostbgcolor,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Apptheme.mostbgcolor,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropValue,
          items: [
            DropdownMenuItem(value: Kitchen, child: Text(Kitchen)),
            DropdownMenuItem(value: barista, child: Text(barista)),
            DropdownMenuItem(value: cashier, child: Text(cashier)),
          ],
          onChanged: handleStake,
          isExpanded: true,
          dropdownColor: Apptheme.mostbgcolor,
          borderRadius: BorderRadius.circular(12),
          icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Colors.grey),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Apptheme.buttontxt,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton({required String type}) {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: type == "admin" ? handleAdminUpdate : handleCredUpdate,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          "Update",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}