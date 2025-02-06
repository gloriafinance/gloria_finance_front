import 'package:flutter/material.dart';

import '../theme/app_color.dart';
import '../theme/app_fonts.dart';

Widget buildTitle(String txt) {
  return Center(
    child: Text(
      txt,
      style: const TextStyle(
        fontSize: 18,
        fontFamily: AppFonts.fontTitle,
      ),
    ),
  );
}

Widget buildDetailRow(bool isMobile, String title, String value,
    {Color? statusColor}) {
  return isMobile
      ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 16, fontFamily: AppFonts.fontTitle),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: AppFonts.fontText,
                    color: statusColor, // Aplica el color aquí
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, // Añade esto
                ),
              )
            ],
          ),
        )
      : Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 6,
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontFamily: AppFonts.fontTitle),
                  )),
              Expanded(
                flex: 6,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: AppFonts.fontText,
                    color: statusColor, // Aplica el color aquí
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis, // Añade esto
                ),
              ),
            ],
          ),
        );
}

Widget buildSectionTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 18,
      fontFamily: AppFonts.fontTitle,
      color: AppColors.purple,
    ),
  );
}
