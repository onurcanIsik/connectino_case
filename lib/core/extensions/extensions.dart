import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double dynamicWidth(double val) => MediaQuery.sizeOf(this).width * val;
  double dynamicHeight(double val) => MediaQuery.sizeOf(this).height * val;

  ThemeData get theme => Theme.of(this);
}

extension PaddingExtension on BuildContext {
  EdgeInsets get paddingAll => EdgeInsets.all(dynamicHeight(0.01));
  EdgeInsets get paddingBottom => EdgeInsets.only(bottom: dynamicHeight(0.01));
  EdgeInsets get paddingTop => EdgeInsets.only(top: dynamicHeight(0.01));
  EdgeInsets get paddingLeft => EdgeInsets.only(left: dynamicHeight(0.01));
  EdgeInsets get paddingRight => EdgeInsets.only(right: dynamicHeight(0.01));
}
