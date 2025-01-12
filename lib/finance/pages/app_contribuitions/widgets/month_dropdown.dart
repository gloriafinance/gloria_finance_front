import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';

List<DropdownMenuItem<dynamic>> monthDropdown(BuildContext context) {
  List<DropdownMenuItem> menuItems = [
    DropdownMenuItem(
      value: '01',
      child: Text("Janeiro",
          style: const TextStyle(fontSize: 18, fontFamily: AppFonts.fontLight)),
    ),
    DropdownMenuItem(
      value: '02',
      child: Text("Fevereiro",
          style: const TextStyle(fontSize: 18, fontFamily: AppFonts.fontLight)),
    ),
    DropdownMenuItem(
      value: '03',
      child: Text("Março",
          style: const TextStyle(fontSize: 18, fontFamily: AppFonts.fontLight)),
    ),
    DropdownMenuItem(
      value: '04',
      child: Text("Abril",
          style: const TextStyle(fontSize: 18, fontFamily: AppFonts.fontLight)),
    ),
    DropdownMenuItem(
      value: '05',
      child: Text("Maio",
          style: const TextStyle(fontSize: 18, fontFamily: AppFonts.fontLight)),
    ),
    DropdownMenuItem(
      value: '06',
      child: Text("Junho",
          style: const TextStyle(fontSize: 18, fontFamily: AppFonts.fontLight)),
    ),
    DropdownMenuItem(
      value: '07',
      child: Text("Julho",
          style: const TextStyle(fontSize: 18, fontFamily: AppFonts.fontLight)),
    ),
    DropdownMenuItem(
      value: '08',
      child: Text("Agosto",
          style: const TextStyle(fontSize: 18, fontFamily: AppFonts.fontLight)),
    ),
    DropdownMenuItem(
      value: '09',
      child: Text("Setembro",
          style: const TextStyle(fontSize: 18, fontFamily: AppFonts.fontLight)),
    ),
    DropdownMenuItem(
      value: '10',
      child: Text("Outubro",
          style: const TextStyle(fontSize: 18, fontFamily: AppFonts.fontLight)),
    ),
    DropdownMenuItem(
      value: '11',
      child: Text("Novembro",
          style: const TextStyle(fontSize: 18, fontFamily: AppFonts.fontLight)),
    ),
    DropdownMenuItem(
      value: '12',
      child: Text("Dezembro",
          style: const TextStyle(fontSize: 18, fontFamily: AppFonts.fontLight)),
    ),
  ];

  return menuItems;
}
