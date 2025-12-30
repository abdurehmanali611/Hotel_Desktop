import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hotcol/ResponsiveDisplays/CreatingItem/desktopResponsive.dart';
import 'package:hotcol/ResponsiveDisplays/CreatingItem/responsiveCreater.dart';

class ItemCreationForm extends StatelessWidget {
  final void Function(String) nameChanged;
  final void Function(double) priceChanged;
  final void Function(String?) catSelect;
  final VoidCallback fileUpload;
  final VoidCallback handleCreation;
  final String action;
  final File? imageFood;
  final String? imageUrl;
  final String catValue;
  final String foodCat;
  final String drinkCat;
  final bool isUploading;
  const ItemCreationForm({
    super.key,
    required this.nameChanged,
    required this.priceChanged,
    required this.drinkCat,
    required this.foodCat,
    required this.catSelect,
    required this.catValue,
    required this.fileUpload,
    this.imageFood,
    this.imageUrl,
    required this.handleCreation,
    required this.action,
    required this.isUploading,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1200) {
          return Responsivecreater(
            nameChanged: nameChanged,
            priceChanged: priceChanged,
            drinkCat: drinkCat,
            foodCat: foodCat,
            catSelect: catSelect,
            catValue: catValue,
            fileUpload: fileUpload,
            imageFood: imageFood,
            imageUrl: imageUrl,
            handleCreation: handleCreation,
            action: action,
            isUploading: isUploading,
          );
        } else {
          return Desktopresponsive(
            nameChanged: nameChanged,
            priceChanged: priceChanged,
            drinkCat: drinkCat,
            foodCat: foodCat,
            catSelect: catSelect,
            catValue: catValue,
            fileUpload: fileUpload,
            imageFood: imageFood,
            imageUrl: imageUrl,
            handleCreation: handleCreation,
            action: action,
            isUploading: isUploading,
          );
        }
      },
    );
  }
}
