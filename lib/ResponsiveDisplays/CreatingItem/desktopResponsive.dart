// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';

class Desktopresponsive extends StatelessWidget {
  final void Function(String) nameChanged;
  final void Function(double) priceChanged;
  final void Function(String?) catSelect;
  final VoidCallback fileUpload;
  final VoidCallback handleCreation;
  final String action;
  final File? imageFood;
  final String catValue;
  final String foodCat;
  final String drinkCat;
  final bool isUploading;
  const Desktopresponsive({
    super.key,
    required this.nameChanged,
    required this.priceChanged,
    required this.drinkCat,
    required this.foodCat,
    required this.catSelect,
    required this.catValue,
    required this.fileUpload,
    this.imageFood,
    required this.handleCreation,
    required this.action,
    required this.isUploading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF0F4F8), Color(0xFFE4E8ED)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 250, vertical: 50),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Food/Drink Name:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 45,
                            child: TextField(
                              onChanged: nameChanged,
                              decoration: InputDecoration(
                                hintText: "Enter name",
                                hintStyle: const TextStyle(
                                  color: Color(0xFFB0B0B0),
                                ),
                                fillColor: const Color(0xFFF5F5F5),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Price:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 45,
                            child: TextField(
                              onChanged: (value) {
                                final parsedValue = double.tryParse(value);
                                if (parsedValue != null) {
                                  priceChanged(parsedValue);
                                }
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Enter price",
                                hintStyle: const TextStyle(
                                  color: Color(0xFFB0B0B0),
                                ),
                                fillColor: const Color(0xFFF5F5F5),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Category:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: const Color(0xFFE0E0E0),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: catValue,
                          isExpanded: true,
                          style: const TextStyle(color: Color(0xFF333333)),
                          dropdownColor: Colors.white,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Color(0xFF666666),
                          ),
                          items: [
                            DropdownMenuItem<String>(
                              value: foodCat,
                              child: Text(foodCat),
                            ),
                            DropdownMenuItem<String>(
                              value: drinkCat,
                              child: Text(drinkCat),
                            ),
                          ],
                          onChanged: catSelect,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Upload an Image",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 15),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: fileUpload,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFE0E0E0),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: imageFood != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.file(
                                    imageFood!,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_rounded,
                                      size: 80,
                                      color: Colors.grey.shade500,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Tap to upload",
                                      style: TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: isUploading ? null : handleCreation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        isUploading ? "Generating Link" : action,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
