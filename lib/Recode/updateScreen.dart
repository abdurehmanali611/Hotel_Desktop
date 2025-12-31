// ignore_for_file: file_names

import 'dart:io';
import 'dart:math';

import 'package:hotcol/utils/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:hotcol/utils/responsive.dart';

class UpdateScreen extends StatelessWidget {
  final void Function(String) nameChanged;
  final void Function(double) priceChanged;
  final void Function(String?) catSelect;
  final VoidCallback handleCreation;
  final File? imageFood;
  final String? currentImageUrl;
  final bool isUploading;
  final VoidCallback fileUpload;
  final String action;
  final String catValue;
  final String foodCat;
  final String drinkCat;
  final TextEditingController nameController;
  final TextEditingController priceController;

  const UpdateScreen({
    super.key,
    required this.nameChanged,
    required this.priceChanged,
    required this.drinkCat,
    required this.foodCat,
    required this.catSelect,
    required this.catValue,
    required this.fileUpload,
    required this.handleCreation,
    required this.action,
    required this.nameController,
    required this.priceController,
    this.imageFood,
    this.currentImageUrl,
    required this.isUploading,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxContentWidth = min(780.0, constraints.maxWidth);
      final outerPadding = Responsive.horizontalPadding(context, desktop: 16, tablet: 16, mobile: 16, verticalDesktop: 30, verticalMobile: 20);

      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxContentWidth),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: outerPadding,
              child: Container(
                decoration: BoxDecoration(
                  color: Apptheme.mostbgcolor,
                  borderRadius: BorderRadius.circular(20),
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
                  padding: Responsive.horizontalPadding(context, desktop: 100, tablet: 48, mobile: 16, verticalDesktop: 40, verticalMobile: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "$action Item",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Apptheme.mosttxtcolor.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 30),

                      LayoutBuilder(builder: (context, inner) {
                        if (inner.maxWidth < 700) {
                          return Column(
                            children: [
                              _buildNameField(),
                              const SizedBox(height: 16),
                              _buildPriceField(),
                            ],
                          );
                        }
                        return Row(
                          children: [
                            Expanded(child: _buildNameField()),
                            const SizedBox(width: 40),
                            Expanded(child: _buildPriceField()),
                          ],
                        );
                      }),

                      const SizedBox(height: 30),

                      // Category Dropdown
                      _buildCategoryDropdown(),
                      const SizedBox(height: 30),

                      // Image Uploading field
                      _buildImageUploadArea(context),
                      const SizedBox(height: 40),

                      // Action Button
                      _buildActionButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Apptheme.buttontxt,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 45,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            style: const TextStyle(color: Apptheme.buttontxt),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
              fillColor: Apptheme.textfieldlogin,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return _buildTextField(
      label: "Food/Drink Name:",
      hintText: "Enter name",
      onChanged: nameChanged,
      controller: nameController,
    );
  }

  Widget _buildPriceField() {
    return _buildTextField(
      label: "Price:",
      hintText: "Enter price",
      controller: priceController,
      onChanged: (value) {
        final parsedValue = double.tryParse(value);
        if (parsedValue != null) {
          priceChanged(parsedValue);
        }
      },
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Category:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Apptheme.buttontxt,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Apptheme.textfieldlogin,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: catValue,
              isExpanded: true,
              style: const TextStyle(color: Apptheme.buttontxt),
              dropdownColor: Apptheme.mostbgcolor,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF666666)),
              items: [
                DropdownMenuItem<String>(value: foodCat, child: Text(foodCat)),
                DropdownMenuItem<String>(
                  value: drinkCat,
                  child: Text(drinkCat),
                ),
              ],
              onChanged: (value) {
                catSelect(value);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadArea(BuildContext context) {
    final imageSize = Responsive.imageSizeFor(context, max: 230);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Image:",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 10),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: fileUpload,
            child: Center(
              child: Container(
                height: imageSize,
                width: imageSize,
                decoration: BoxDecoration(
                  color: Apptheme.mostbgcolor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey, width: 1.5),
                ),
                child: Center(child: _buildImage()),
              ),
            ),
          ),
        ),
      ],
    );
  }

Widget _buildImage() {
  if (imageFood != null) {
    return Image.file(
      imageFood!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  } 
  else if (currentImageUrl != null && currentImageUrl!.isNotEmpty) {
    return Image.network(
      currentImageUrl!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    );
  } 
  else {
    return _buildPlaceholder();
  }
}
  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.cloud_upload, color: Color(0xFF666666), size: 40),
        const SizedBox(height: 8),
        const Text(
          "Tap to upload/change image",
          style: TextStyle(color: Color(0xFF666666), fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isUploading ? null : handleCreation,
        style: ElevatedButton.styleFrom(
          backgroundColor: Apptheme.buttonbglogin,
          foregroundColor: Apptheme.buttontxt,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: Text(
          isUploading ? "Generating Link" : action,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}