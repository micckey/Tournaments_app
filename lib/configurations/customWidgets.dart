import 'package:flutter/material.dart';
import 'package:karateclash/configurations/colors.dart';

SizedBox myButtonWidget(text, VoidCallback action) {
  return SizedBox(
    height: 50,
    width: 200,
    child: ElevatedButton(
      onPressed: action,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(CustomColors().mainColor),
          foregroundColor: MaterialStateProperty.all(CustomColors().textColor),
          overlayColor: MaterialStateProperty.all(CustomColors().colorAKA),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      child: Text(text,
          style: const TextStyle(
              fontFamily: 'Eczar', fontSize: 15, fontWeight: FontWeight.bold)),
    ),
  );
}

SizedBox myButtonWidget2(text, VoidCallback action) {
  return SizedBox(
    height: 50,
    width: 200,
    child: ElevatedButton(
      onPressed: action,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(CustomColors().colorAO),
          foregroundColor: MaterialStateProperty.all(CustomColors().textColor),
          overlayColor: MaterialStateProperty.all(CustomColors().colorAKA),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
      child: Text(text,
          style: const TextStyle(
              fontFamily: 'Eczar', fontSize: 15, fontWeight: FontWeight.bold)),
    ),
  );
}

Text myTextWidget(label, size) {
  return Text(label,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: size,
          color: CustomColors().textColor,
          fontFamily: 'Eczar'));
}

TextField myTextField(label, controller) {
  return TextField(
    controller: controller,
    textAlign: TextAlign.start,
    decoration: InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      labelText: label,
      labelStyle:
          const TextStyle(fontFamily: 'Eczar', fontWeight: FontWeight.w800),
    ),
  );
}
