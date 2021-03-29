import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const fieldStyle = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black,
    )
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.black,
    ),
  ),
  errorStyle: TextStyle(
    color: Colors.red,
  ),
);