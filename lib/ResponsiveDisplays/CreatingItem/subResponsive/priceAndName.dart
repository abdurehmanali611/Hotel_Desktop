// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Priceandname extends StatelessWidget {
  final void Function(String) nameChanged;
  final void Function(double) priceChanged;
  const Priceandname({
    super.key,
    required this.nameChanged,
    required this.priceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 600) {
          return Column(
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
                          hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
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
                          hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
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
          );
        } else {
          return Row(
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
                          hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
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
                          hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
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
          );
        }
      },
    );
  }
}
