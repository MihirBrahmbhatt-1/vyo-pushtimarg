import 'package:flutter/material.dart';

const bool appIsLive = false;
const bool isDisplayLogs = true;

const double borderRadius = 4.0;
const int emailMaxLength = 80;
BorderRadius buttonBorderRadius = BorderRadius.circular(borderRadius);

const int resendOtpInSeconds = 120;
const int otpValidityInSeconds = 600;
const int maxAttempts = 3;
const Duration lockDuration = Duration(hours: 1);

String emailValidationRegExString =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

class FontSize {
  final double xxsmall = 8.00;
  final double xsmall = 10.00;
  final double small = 12.00;
  final double regular = 14.00;
  final double appBar = 14.00;
  final double medium = 16.00;
  final double loading = 16.00;
  final double xmedium = 18.00;
  final double large = 20.00;
  final double xlarge = 22.00;
  final double xxlarge = 24.00;
  final double heading = 40.00;
}

class WidgetPadding {
  final double xxsmall = 8.00;
  final double xsmall = 10.00;
  final double small = 12.00;
  final double regular = 14.00;
  final double medium = 16.00;
  final double xmedium = 18.00;
  final double large = 20.00;
  final double xlarge = 22.00;
  final double xxlarge = 24.00;
  final double heading = 40.00;
}
