
import 'package:flutter/material.dart';

class SpecModel {
  String? name;
  late String thumbPath;
  Color? color;
  late String deeparPath;
  bool isSelected;

  SpecModel(this.name, this.thumbPath, this.color, this.deeparPath,
      {this.isSelected = false});
}