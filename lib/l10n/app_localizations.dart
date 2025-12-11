import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'VYO'**
  String get appName;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordLengthValidation.
  ///
  /// In en, this message translates to:
  /// **'Password must contain 8-20 characters without space.'**
  String get passwordLengthValidation;

  /// No description provided for @forgotPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordLabel;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// No description provided for @checkInternet.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connectivity'**
  String get checkInternet;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password. Ensure that your new password is different from the previous one for better security.'**
  String get changePasswordDescription;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get enterCurrentPassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @currentAndNewPasswordValidation.
  ///
  /// In en, this message translates to:
  /// **'New password should not be same as current password.'**
  String get currentAndNewPasswordValidation;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @enterConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter confirm password'**
  String get enterConfirmPassword;

  /// No description provided for @passwordDoesNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Confirm password does not matched.'**
  String get passwordDoesNotMatch;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @aboutAppWebLoginUrl.
  ///
  /// In en, this message translates to:
  /// **'Web Login'**
  String get aboutAppWebLoginUrl;

  /// No description provided for @aboutAppOfficialWebsiteUrl.
  ///
  /// In en, this message translates to:
  /// **'Official Site'**
  String get aboutAppOfficialWebsiteUrl;

  /// No description provided for @shutOffValve.
  ///
  /// In en, this message translates to:
  /// **'Shut Off Valve'**
  String get shutOffValve;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @aboutAppTypeApproval.
  ///
  /// In en, this message translates to:
  /// **'Type approval'**
  String get aboutAppTypeApproval;

  /// No description provided for @aboutAppModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get aboutAppModel;

  /// No description provided for @aboutAppAppVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get aboutAppAppVersion;

  /// No description provided for @aboutAppCertificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get aboutAppCertificate;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @cheque.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get cheque;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Un-paid'**
  String get unpaid;

  /// No description provided for @invoiceDownloadSuccessfull.
  ///
  /// In en, this message translates to:
  /// **'Invoice downloaded successfully'**
  String get invoiceDownloadSuccessfull;

  /// No description provided for @billingFileUrlDoesNotExist.
  ///
  /// In en, this message translates to:
  /// **'Billing File URL does not exist'**
  String get billingFileUrlDoesNotExist;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @billing.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get billing;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @payableAmount.
  ///
  /// In en, this message translates to:
  /// **'Payable Amount'**
  String get payableAmount;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @downloadWillBeFinished.
  ///
  /// In en, this message translates to:
  /// **'Download will soon be finished'**
  String get downloadWillBeFinished;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @downloadData.
  ///
  /// In en, this message translates to:
  /// **'Download Data'**
  String get downloadData;

  /// No description provided for @payOffline.
  ///
  /// In en, this message translates to:
  /// **'Pay offline'**
  String get payOffline;

  /// No description provided for @noBillingFound.
  ///
  /// In en, this message translates to:
  /// **'No bill found'**
  String get noBillingFound;

  /// No description provided for @billMonth.
  ///
  /// In en, this message translates to:
  /// **'Bill Month'**
  String get billMonth;

  /// No description provided for @noDueBillingFound.
  ///
  /// In en, this message translates to:
  /// **'No due bills found'**
  String get noDueBillingFound;

  /// No description provided for @noLicencekeyFound.
  ///
  /// In en, this message translates to:
  /// **'Licence Key Not Found'**
  String get noLicencekeyFound;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter by'**
  String get filter;

  /// No description provided for @tenantName.
  ///
  /// In en, this message translates to:
  /// **'Tenant Name'**
  String get tenantName;

  /// No description provided for @billingMonth.
  ///
  /// In en, this message translates to:
  /// **'Billing Month'**
  String get billingMonth;

  /// No description provided for @invoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice Number'**
  String get invoiceNumber;

  /// No description provided for @meterNumber.
  ///
  /// In en, this message translates to:
  /// **'Meter Number'**
  String get meterNumber;

  /// No description provided for @payBill.
  ///
  /// In en, this message translates to:
  /// **'Pay Bill'**
  String get payBill;

  /// No description provided for @paymentType.
  ///
  /// In en, this message translates to:
  /// **'Payment Type'**
  String get paymentType;

  /// No description provided for @transactionSpaceType.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionSpaceType;

  /// No description provided for @selectPaymentType.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Type'**
  String get selectPaymentType;

  /// No description provided for @chequeNumber.
  ///
  /// In en, this message translates to:
  /// **'Check number'**
  String get chequeNumber;

  /// No description provided for @enterChequeNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Check number'**
  String get enterChequeNumber;

  /// No description provided for @partialPayment.
  ///
  /// In en, this message translates to:
  /// **'Partial Payment'**
  String get partialPayment;

  /// No description provided for @enterPayableAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter payable amount'**
  String get enterPayableAmount;

  /// No description provided for @moreThanPayableAmountNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'More than payable amount is not allowed.'**
  String get moreThanPayableAmountNotAllowed;

  /// No description provided for @minimumAmountPayableValidation.
  ///
  /// In en, this message translates to:
  /// **'Amount must be at least \\\$0.50 USD'**
  String get minimumAmountPayableValidation;

  /// No description provided for @maximumAmountPayable.
  ///
  /// In en, this message translates to:
  /// **'Maximum payable amount is \\\$100,000 USD'**
  String get maximumAmountPayable;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Invalid amount'**
  String get invalidAmount;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @gallon.
  ///
  /// In en, this message translates to:
  /// **'Gallon'**
  String get gallon;

  /// No description provided for @cubicFt.
  ///
  /// In en, this message translates to:
  /// **'Cubic ft.'**
  String get cubicFt;

  /// No description provided for @liter.
  ///
  /// In en, this message translates to:
  /// **'Liter'**
  String get liter;

  /// No description provided for @flowRate.
  ///
  /// In en, this message translates to:
  /// **'Flow Rate'**
  String get flowRate;

  /// No description provided for @consumption.
  ///
  /// In en, this message translates to:
  /// **'Consumption'**
  String get consumption;

  /// No description provided for @flow.
  ///
  /// In en, this message translates to:
  /// **'Flow'**
  String get flow;

  /// No description provided for @highConsumptionChart.
  ///
  /// In en, this message translates to:
  /// **'High Consumption'**
  String get highConsumptionChart;

  /// No description provided for @selectYear.
  ///
  /// In en, this message translates to:
  /// **'Select Year'**
  String get selectYear;

  /// No description provided for @noTenantFound.
  ///
  /// In en, this message translates to:
  /// **'No tenants found'**
  String get noTenantFound;

  /// No description provided for @selectWaterMeter.
  ///
  /// In en, this message translates to:
  /// **'Select Water Meter'**
  String get selectWaterMeter;

  /// No description provided for @selectWaterMeterFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select Water Meter'**
  String get selectWaterMeterFirst;

  /// No description provided for @noWaterMeterFound.
  ///
  /// In en, this message translates to:
  /// **'No Water Meter found'**
  String get noWaterMeterFound;

  /// No description provided for @totalConsumptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Consumption: '**
  String get totalConsumptionLabel;

  /// No description provided for @checkboxChartValidation.
  ///
  /// In en, this message translates to:
  /// **'No chart is available to display. Please select one checkbox.'**
  String get checkboxChartValidation;

  /// No description provided for @noChartDataFound.
  ///
  /// In en, this message translates to:
  /// **'No Chart data is found'**
  String get noChartDataFound;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transaction;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @pleaseTryAgainAfterSometime.
  ///
  /// In en, this message translates to:
  /// **'Please try again after some time'**
  String get pleaseTryAgainAfterSometime;

  /// No description provided for @unitNumber.
  ///
  /// In en, this message translates to:
  /// **'Unit No'**
  String get unitNumber;

  /// No description provided for @meterId.
  ///
  /// In en, this message translates to:
  /// **'Meter ID'**
  String get meterId;

  /// No description provided for @consumptionMonthly.
  ///
  /// In en, this message translates to:
  /// **'Consumption(Monthly)'**
  String get consumptionMonthly;

  /// No description provided for @currentMeterReading.
  ///
  /// In en, this message translates to:
  /// **'Current Meter Reading'**
  String get currentMeterReading;

  /// No description provided for @lastReportDateTime.
  ///
  /// In en, this message translates to:
  /// **'Last Report Date-Time'**
  String get lastReportDateTime;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @gatewayMac.
  ///
  /// In en, this message translates to:
  /// **'Gateway MAC'**
  String get gatewayMac;

  /// No description provided for @noNotificationFound.
  ///
  /// In en, this message translates to:
  /// **'No Notification found'**
  String get noNotificationFound;

  /// No description provided for @supportCenter.
  ///
  /// In en, this message translates to:
  /// **'Support Center'**
  String get supportCenter;

  /// No description provided for @searchByDescription.
  ///
  /// In en, this message translates to:
  /// **'Search by description'**
  String get searchByDescription;

  /// No description provided for @createdDate.
  ///
  /// In en, this message translates to:
  /// **'Created Date'**
  String get createdDate;

  /// No description provided for @createdDateJoint.
  ///
  /// In en, this message translates to:
  /// **'CreatedDate'**
  String get createdDateJoint;

  /// No description provided for @issueType.
  ///
  /// In en, this message translates to:
  /// **'Issue Type'**
  String get issueType;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @issueDescription.
  ///
  /// In en, this message translates to:
  /// **'Issue Description'**
  String get issueDescription;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment from Admin'**
  String get comment;

  /// No description provided for @calibrationDataIsNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Calibration data is not available'**
  String get calibrationDataIsNotAvailable;

  /// No description provided for @dropdownClose.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get dropdownClose;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @tierOne.
  ///
  /// In en, this message translates to:
  /// **'Tier 1'**
  String get tierOne;

  /// No description provided for @tierTwo.
  ///
  /// In en, this message translates to:
  /// **'Tier 2'**
  String get tierTwo;

  /// No description provided for @tierThree.
  ///
  /// In en, this message translates to:
  /// **'Tier 3'**
  String get tierThree;

  /// No description provided for @dropdownAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get dropdownAccount;

  /// No description provided for @dropdwownGateway.
  ///
  /// In en, this message translates to:
  /// **'Gateway/Hub'**
  String get dropdwownGateway;

  /// No description provided for @waterMeter.
  ///
  /// In en, this message translates to:
  /// **'Water Meter'**
  String get waterMeter;

  /// No description provided for @gateway.
  ///
  /// In en, this message translates to:
  /// **'Gateway'**
  String get gateway;

  /// No description provided for @valve.
  ///
  /// In en, this message translates to:
  /// **'Valve'**
  String get valve;

  /// No description provided for @sensor.
  ///
  /// In en, this message translates to:
  /// **'Sensor'**
  String get sensor;

  /// No description provided for @dropdownOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get dropdownOther;

  /// No description provided for @raiseAnIssue.
  ///
  /// In en, this message translates to:
  /// **'Raise an Issue'**
  String get raiseAnIssue;

  /// No description provided for @enterDesctriptionValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter description'**
  String get enterDesctriptionValidation;

  /// No description provided for @enterBriefDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter a brief description'**
  String get enterBriefDescription;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @tenantList.
  ///
  /// In en, this message translates to:
  /// **'Tenant List'**
  String get tenantList;

  /// No description provided for @tenantRiserList.
  ///
  /// In en, this message translates to:
  /// **'Tenant/Riser List'**
  String get tenantRiserList;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @topology.
  ///
  /// In en, this message translates to:
  /// **'Topology'**
  String get topology;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @gatewayName.
  ///
  /// In en, this message translates to:
  /// **'Gateway Name'**
  String get gatewayName;

  /// No description provided for @topologyMeter.
  ///
  /// In en, this message translates to:
  /// **'Meter '**
  String get topologyMeter;

  /// No description provided for @topologyMac.
  ///
  /// In en, this message translates to:
  /// **'MAC '**
  String get topologyMac;

  /// No description provided for @meterName.
  ///
  /// In en, this message translates to:
  /// **'Meter Name'**
  String get meterName;

  /// No description provided for @valveName.
  ///
  /// In en, this message translates to:
  /// **'Valve Name'**
  String get valveName;

  /// No description provided for @valveNumber.
  ///
  /// In en, this message translates to:
  /// **'Valve Number'**
  String get valveNumber;

  /// No description provided for @sensorDetail.
  ///
  /// In en, this message translates to:
  /// **'Sensor Details'**
  String get sensorDetail;

  /// No description provided for @valveDetail.
  ///
  /// In en, this message translates to:
  /// **'Valve Details'**
  String get valveDetail;

  /// No description provided for @meterDetail.
  ///
  /// In en, this message translates to:
  /// **'Meter Details'**
  String get meterDetail;

  /// No description provided for @sensorNumber.
  ///
  /// In en, this message translates to:
  /// **'Sensor MAC'**
  String get sensorNumber;

  /// No description provided for @sensorName.
  ///
  /// In en, this message translates to:
  /// **'Sensor Name'**
  String get sensorName;

  /// No description provided for @attachWaterMeterList.
  ///
  /// In en, this message translates to:
  /// **'Attach Water Meter List'**
  String get attachWaterMeterList;

  /// No description provided for @attachValveList.
  ///
  /// In en, this message translates to:
  /// **'Attach Valve List'**
  String get attachValveList;

  /// No description provided for @valveId.
  ///
  /// In en, this message translates to:
  /// **'Valve Id'**
  String get valveId;

  /// No description provided for @tenantLocation.
  ///
  /// In en, this message translates to:
  /// **'Tenant Location'**
  String get tenantLocation;

  /// No description provided for @serialNumber.
  ///
  /// In en, this message translates to:
  /// **'Serial Number'**
  String get serialNumber;

  /// No description provided for @valveStatus.
  ///
  /// In en, this message translates to:
  /// **'Valve Status'**
  String get valveStatus;

  /// No description provided for @waterMeterList.
  ///
  /// In en, this message translates to:
  /// **'Water Meter List'**
  String get waterMeterList;

  /// No description provided for @valveList.
  ///
  /// In en, this message translates to:
  /// **'Valve List'**
  String get valveList;

  /// No description provided for @sensorList.
  ///
  /// In en, this message translates to:
  /// **'Sensor List'**
  String get sensorList;

  /// No description provided for @gatewayList.
  ///
  /// In en, this message translates to:
  /// **'Gateway List'**
  String get gatewayList;

  /// No description provided for @openValveConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure, you want to Open Valve?'**
  String get openValveConfirmation;

  /// No description provided for @closeValveConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure, you want to Close Valve?'**
  String get closeValveConfirmation;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @tenant.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get tenant;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @waterMeterStatus.
  ///
  /// In en, this message translates to:
  /// **'Water meter Status'**
  String get waterMeterStatus;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'After logging out, you will not be able to receive any events or notifications.\n\nDo you still want to logout?'**
  String get logoutConfirmation;

  /// No description provided for @logoutSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Logout successful'**
  String get logoutSuccessful;

  /// No description provided for @passwordChangedAndLogOutSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed and logged out successfully'**
  String get passwordChangedAndLogOutSuccessfully;

  /// No description provided for @youAreOffline.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get youAreOffline;

  /// No description provided for @internetConnectivity.
  ///
  /// In en, this message translates to:
  /// **'No internet... Please check your \n internet connection!'**
  String get internetConnectivity;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Please Wait....'**
  String get loading;

  /// No description provided for @resolve.
  ///
  /// In en, this message translates to:
  /// **'Resolve'**
  String get resolve;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @uploadImagesVia.
  ///
  /// In en, this message translates to:
  /// **'Upload image(s) via'**
  String get uploadImagesVia;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @imageSizeValidation.
  ///
  /// In en, this message translates to:
  /// **'Image size should not be more than 2 MB'**
  String get imageSizeValidation;

  /// No description provided for @imageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Image not found'**
  String get imageNotFound;

  /// No description provided for @addCheckImage.
  ///
  /// In en, this message translates to:
  /// **'Add Check Image'**
  String get addCheckImage;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **' (Optional)'**
  String get optional;

  /// No description provided for @viewTransaction.
  ///
  /// In en, this message translates to:
  /// **'View Transaction'**
  String get viewTransaction;

  /// No description provided for @mainForecast.
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get mainForecast;

  /// No description provided for @gatewayZoneMeter.
  ///
  /// In en, this message translates to:
  /// **'(Gateway Name -> Tenant Name -> Meter)'**
  String get gatewayZoneMeter;

  /// No description provided for @chooseWaterMeter.
  ///
  /// In en, this message translates to:
  /// **'Choose Water Meter'**
  String get chooseWaterMeter;

  /// No description provided for @viewBill.
  ///
  /// In en, this message translates to:
  /// **'View Bill'**
  String get viewBill;

  /// No description provided for @selectSnoozeTime.
  ///
  /// In en, this message translates to:
  /// **'Select Snooze Time'**
  String get selectSnoozeTime;

  /// No description provided for @snooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get snooze;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMore;

  /// No description provided for @summaryOfUsage.
  ///
  /// In en, this message translates to:
  /// **'Summary of Usage'**
  String get summaryOfUsage;

  /// No description provided for @usageByFixture.
  ///
  /// In en, this message translates to:
  /// **'Usage by Fixture'**
  String get usageByFixture;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Current month forecast'**
  String get nextMonth;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get lastMonth;

  /// No description provided for @currentMonth.
  ///
  /// In en, this message translates to:
  /// **'Current month'**
  String get currentMonth;

  /// No description provided for @billingDetails.
  ///
  /// In en, this message translates to:
  /// **'Billing Details'**
  String get billingDetails;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @notificationLocalTime.
  ///
  /// In en, this message translates to:
  /// **'NotificationLocalTime'**
  String get notificationLocalTime;

  /// No description provided for @falseAlarm.
  ///
  /// In en, this message translates to:
  /// **'False Alarm'**
  String get falseAlarm;

  /// No description provided for @applianceLeakDetected.
  ///
  /// In en, this message translates to:
  /// **'Appliance Leak Detected'**
  String get applianceLeakDetected;

  /// No description provided for @wetFloorDetected.
  ///
  /// In en, this message translates to:
  /// **'Wet Floor Detected'**
  String get wetFloorDetected;

  /// No description provided for @fiveMinute.
  ///
  /// In en, this message translates to:
  /// **'5 Minutes'**
  String get fiveMinute;

  /// No description provided for @tenMinute.
  ///
  /// In en, this message translates to:
  /// **'10 Minutes'**
  String get tenMinute;

  /// No description provided for @fifteenMinute.
  ///
  /// In en, this message translates to:
  /// **'15 Minutes'**
  String get fifteenMinute;

  /// No description provided for @oneHour.
  ///
  /// In en, this message translates to:
  /// **'1 Hour'**
  String get oneHour;

  /// No description provided for @twoHour.
  ///
  /// In en, this message translates to:
  /// **'2 Hour'**
  String get twoHour;

  /// No description provided for @threeHour.
  ///
  /// In en, this message translates to:
  /// **'3 Hour'**
  String get threeHour;

  /// No description provided for @sixHour.
  ///
  /// In en, this message translates to:
  /// **'6 Hour'**
  String get sixHour;

  /// No description provided for @eightHour.
  ///
  /// In en, this message translates to:
  /// **'8 Hour'**
  String get eightHour;

  /// No description provided for @twelveHour.
  ///
  /// In en, this message translates to:
  /// **'12 Hour'**
  String get twelveHour;

  /// No description provided for @twentyFourHour.
  ///
  /// In en, this message translates to:
  /// **'24 Hour'**
  String get twentyFourHour;

  /// No description provided for @debit.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get debit;

  /// No description provided for @credit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get credit;

  /// No description provided for @timeout.
  ///
  /// In en, this message translates to:
  /// **'Time out'**
  String get timeout;

  /// No description provided for @attachedImage.
  ///
  /// In en, this message translates to:
  /// **'Attached Images'**
  String get attachedImage;

  /// No description provided for @referenceId.
  ///
  /// In en, this message translates to:
  /// **'Reference Id '**
  String get referenceId;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @applyFiltersToShowResult.
  ///
  /// In en, this message translates to:
  /// **'Apply filters to show results'**
  String get applyFiltersToShowResult;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// No description provided for @cameraPermissionIsRequiredToProceed.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to proceed.'**
  String get cameraPermissionIsRequiredToProceed;

  /// No description provided for @galleryPermissionIsRequiredToProceed.
  ///
  /// In en, this message translates to:
  /// **'Gallery permission is required to proceed.'**
  String get galleryPermissionIsRequiredToProceed;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @valveNameSearch.
  ///
  /// In en, this message translates to:
  /// **'Search by Valve Name'**
  String get valveNameSearch;

  /// No description provided for @sensorNameSearch.
  ///
  /// In en, this message translates to:
  /// **'Search by Sensor Name'**
  String get sensorNameSearch;

  /// No description provided for @searchByGatewayMac.
  ///
  /// In en, this message translates to:
  /// **'Search by Gateway MAC'**
  String get searchByGatewayMac;

  /// No description provided for @developerModeCheck.
  ///
  /// In en, this message translates to:
  /// **'Developer Mode is On.\n\nPlease Turn off Developer Mode from App Settings and restart application.'**
  String get developerModeCheck;

  /// No description provided for @emulatorCheck.
  ///
  /// In en, this message translates to:
  /// **'Run the app on a real and physical device. For security reasons, we have restricted app access.'**
  String get emulatorCheck;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @endDateValidation.
  ///
  /// In en, this message translates to:
  /// **'End date cannot be before start date'**
  String get endDateValidation;

  /// No description provided for @invalidDateRange.
  ///
  /// In en, this message translates to:
  /// **'Invalid Date Range'**
  String get invalidDateRange;

  /// No description provided for @validDateValidation.
  ///
  /// In en, this message translates to:
  /// **'Invalid Date Rang select valid Date'**
  String get validDateValidation;

  /// No description provided for @youDidNotGetTenantID.
  ///
  /// In en, this message translates to:
  /// **'you did\'t get tenantID'**
  String get youDidNotGetTenantID;

  /// No description provided for @searchByTenantName.
  ///
  /// In en, this message translates to:
  /// **'Search by Tenant name'**
  String get searchByTenantName;

  /// No description provided for @searchByInvoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Search by Invoice Number'**
  String get searchByInvoiceNumber;

  /// No description provided for @searchByGatewayName.
  ///
  /// In en, this message translates to:
  /// **'Search by Gateway Name'**
  String get searchByGatewayName;

  /// No description provided for @searchByGatewayType.
  ///
  /// In en, this message translates to:
  /// **'Search by Gateway Type'**
  String get searchByGatewayType;

  /// No description provided for @searchByMeterNumber.
  ///
  /// In en, this message translates to:
  /// **'Search by Meter Number'**
  String get searchByMeterNumber;

  /// No description provided for @searchByUnitNumber.
  ///
  /// In en, this message translates to:
  /// **'Search by Unit Number'**
  String get searchByUnitNumber;

  /// No description provided for @searchByMeterName.
  ///
  /// In en, this message translates to:
  /// **'Search by Meter Name'**
  String get searchByMeterName;

  /// No description provided for @searchBySerialNumber.
  ///
  /// In en, this message translates to:
  /// **'Search by Serial Number'**
  String get searchBySerialNumber;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// No description provided for @storageDidNotHavePermission.
  ///
  /// In en, this message translates to:
  /// **'Storage permission did not have access'**
  String get storageDidNotHavePermission;

  /// No description provided for @forgotPasswordDiscription.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email address, and we\'ll send you a link to reset your password.'**
  String get forgotPasswordDiscription;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @scheduleList.
  ///
  /// In en, this message translates to:
  /// **'Schedule list'**
  String get scheduleList;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noDataFound;

  /// No description provided for @valveAction.
  ///
  /// In en, this message translates to:
  /// **'Valve action'**
  String get valveAction;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @selectAction.
  ///
  /// In en, this message translates to:
  /// **'Select action'**
  String get selectAction;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @selectSchedule.
  ///
  /// In en, this message translates to:
  /// **'Select schedule'**
  String get selectSchedule;

  /// No description provided for @selectActionTime.
  ///
  /// In en, this message translates to:
  /// **'Select action time'**
  String get selectActionTime;

  /// No description provided for @openValve.
  ///
  /// In en, this message translates to:
  /// **'Open Valve'**
  String get openValve;

  /// No description provided for @closeValve.
  ///
  /// In en, this message translates to:
  /// **'Close Valve'**
  String get closeValve;

  /// No description provided for @pleaseSelectDays.
  ///
  /// In en, this message translates to:
  /// **'Please select days'**
  String get pleaseSelectDays;

  /// No description provided for @pleaseSelectActionTime.
  ///
  /// In en, this message translates to:
  /// **'Please select action time'**
  String get pleaseSelectActionTime;

  /// No description provided for @pleaseSelectScheduleType.
  ///
  /// In en, this message translates to:
  /// **'Please select schedule type'**
  String get pleaseSelectScheduleType;

  /// No description provided for @pleaseSelectADate.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get pleaseSelectADate;

  /// No description provided for @selectADate.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get selectADate;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @once.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get once;

  /// No description provided for @selectDays.
  ///
  /// In en, this message translates to:
  /// **'Selected day(s)'**
  String get selectDays;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @addScheduleTime.
  ///
  /// In en, this message translates to:
  /// **'Add schedule time'**
  String get addScheduleTime;

  /// No description provided for @updateScheduleTime.
  ///
  /// In en, this message translates to:
  /// **'Update schedule time'**
  String get updateScheduleTime;

  /// No description provided for @scheduleTime.
  ///
  /// In en, this message translates to:
  /// **'Schedule time'**
  String get scheduleTime;

  /// No description provided for @timeSetDiscription.
  ///
  /// In en, this message translates to:
  /// **'Time can not be set in past time'**
  String get timeSetDiscription;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @therearenochangesdetected.
  ///
  /// In en, this message translates to:
  /// **'There are no changes detected'**
  String get therearenochangesdetected;

  /// No description provided for @meterconfiguration.
  ///
  /// In en, this message translates to:
  /// **'Meter Configuration'**
  String get meterconfiguration;

  /// No description provided for @valveconfiguration.
  ///
  /// In en, this message translates to:
  /// **'Valve Configuration'**
  String get valveconfiguration;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Happy to help! Can you please explain a bit more about the issue you’re experiencing so we can find the best solution?'**
  String get contactUs;

  /// No description provided for @updateEmail.
  ///
  /// In en, this message translates to:
  /// **'Update Email'**
  String get updateEmail;

  /// No description provided for @emailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Email not verified!!\n\nPlease verify your email to access all features.'**
  String get emailNotVerified;

  /// No description provided for @remindMeLater.
  ///
  /// In en, this message translates to:
  /// **'Remind me later'**
  String get remindMeLater;

  /// No description provided for @profileDetails.
  ///
  /// In en, this message translates to:
  /// **'Profile Details'**
  String get profileDetails;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @enterFirstNameValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter First Name'**
  String get enterFirstNameValidation;

  /// No description provided for @enterLastNameValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter Last Name'**
  String get enterLastNameValidation;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @selectDateFormat.
  ///
  /// In en, this message translates to:
  /// **'Select date format'**
  String get selectDateFormat;

  /// No description provided for @enteravalidnewemailaddress.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid new email address'**
  String get enteravalidnewemailaddress;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otp;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @sentOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sentOtp;

  /// No description provided for @enterotp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterotp;

  /// No description provided for @invalidotp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP'**
  String get invalidotp;

  /// No description provided for @enternewemail.
  ///
  /// In en, this message translates to:
  /// **'Enter new email'**
  String get enternewemail;

  /// No description provided for @newemail.
  ///
  /// In en, this message translates to:
  /// **'New email'**
  String get newemail;

  /// No description provided for @existingEmail.
  ///
  /// In en, this message translates to:
  /// **'Exisitng email'**
  String get existingEmail;

  /// No description provided for @changedemail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get changedemail;

  /// No description provided for @enterValidOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter valid OTP'**
  String get enterValidOtp;

  /// No description provided for @emailCanTSame.
  ///
  /// In en, this message translates to:
  /// **'Existing email and new email should not be same.'**
  String get emailCanTSame;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get unsavedChanges;

  /// No description provided for @changesDescription.
  ///
  /// In en, this message translates to:
  /// **'Profile have detected changes.\nSave data?'**
  String get changesDescription;

  /// No description provided for @waterMeterOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening'**
  String get waterMeterOpening;

  /// No description provided for @waterMeterClosing.
  ///
  /// In en, this message translates to:
  /// **'Closing'**
  String get waterMeterClosing;

  /// No description provided for @keepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get keepEditing;

  /// No description provided for @emailIsNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Email is not verified, '**
  String get emailIsNotVerified;

  /// No description provided for @otpVerifySuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Otp verified successfully'**
  String get otpVerifySuccessfully;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP verification'**
  String get otpVerification;

  /// No description provided for @clickHere.
  ///
  /// In en, this message translates to:
  /// **'click here'**
  String get clickHere;

  /// No description provided for @otpExpiredDescription.
  ///
  /// In en, this message translates to:
  /// **'Entered OTP is expired, please try again'**
  String get otpExpiredDescription;

  /// No description provided for @emailIsVerified.
  ///
  /// In en, this message translates to:
  /// **'Email is verified'**
  String get emailIsVerified;

  /// No description provided for @otpVerificationCancelFlowDescription.
  ///
  /// In en, this message translates to:
  /// **'OTP verification is currently in progress, canceling will require you to restart the email verification process. Still want to exit the flow?'**
  String get otpVerificationCancelFlowDescription;

  /// No description provided for @afterSendingOtpDescriptionOne.
  ///
  /// In en, this message translates to:
  /// **'Enter the OTP code that we sent to '**
  String get afterSendingOtpDescriptionOne;

  /// No description provided for @afterSendingOtpDescriptionTwo.
  ///
  /// In en, this message translates to:
  /// **' It may take up to few minutes for you to receive this code.'**
  String get afterSendingOtpDescriptionTwo;

  /// No description provided for @mustBeContainerASpecialChar.
  ///
  /// In en, this message translates to:
  /// **'Must contain a special character.'**
  String get mustBeContainerASpecialChar;

  /// No description provided for @mustBeContainerALowerCase.
  ///
  /// In en, this message translates to:
  /// **'Must contain a lowercase letter.'**
  String get mustBeContainerALowerCase;

  /// No description provided for @mustBeContainerAUpperCase.
  ///
  /// In en, this message translates to:
  /// **'Must contain an uppercase letter.'**
  String get mustBeContainerAUpperCase;

  /// No description provided for @mustBeContainerANumber.
  ///
  /// In en, this message translates to:
  /// **'Must contain a number.'**
  String get mustBeContainerANumber;

  /// No description provided for @waterMeterAreAttached.
  ///
  /// In en, this message translates to:
  /// **'water meter(s) are attached'**
  String get waterMeterAreAttached;

  /// No description provided for @valveAreAttached.
  ///
  /// In en, this message translates to:
  /// **'valve(s) are attached'**
  String get valveAreAttached;

  /// No description provided for @filterNotification.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterNotification;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @lastThreeMonth.
  ///
  /// In en, this message translates to:
  /// **'Last 3 month'**
  String get lastThreeMonth;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @selectDataRange.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get selectDataRange;

  /// No description provided for @scrollToTop.
  ///
  /// In en, this message translates to:
  /// **'Scroll to top'**
  String get scrollToTop;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @dataMismatch.
  ///
  /// In en, this message translates to:
  /// **'Data Mismatch'**
  String get dataMismatch;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @mobileApplication.
  ///
  /// In en, this message translates to:
  /// **'Mobile Application'**
  String get mobileApplication;

  /// No description provided for @searchByEmail.
  ///
  /// In en, this message translates to:
  /// **'Search by Email'**
  String get searchByEmail;

  /// No description provided for @configurationNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification Configuration'**
  String get configurationNotification;

  /// No description provided for @updateConfigurationNotification.
  ///
  /// In en, this message translates to:
  /// **'Update Configure'**
  String get updateConfigurationNotification;

  /// No description provided for @addConfigurationNotification.
  ///
  /// In en, this message translates to:
  /// **'Add Configuration'**
  String get addConfigurationNotification;

  /// No description provided for @billingNotificationType.
  ///
  /// In en, this message translates to:
  /// **'Biling Notification'**
  String get billingNotificationType;

  /// No description provided for @toEmail.
  ///
  /// In en, this message translates to:
  /// **'To Email'**
  String get toEmail;

  /// No description provided for @notificationTypes.
  ///
  /// In en, this message translates to:
  /// **'Notification Types'**
  String get notificationTypes;

  /// No description provided for @configurationNotificationNotes.
  ///
  /// In en, this message translates to:
  /// **'Note \n\n• Please enter a valid email.\n• Entered email will receive email notifications from Saya for selected Notification Type(s).\n• Only 10 email addresses can be added for each individual service.'**
  String get configurationNotificationNotes;

  /// No description provided for @historicaldata.
  ///
  /// In en, this message translates to:
  /// **'Historical Data'**
  String get historicaldata;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get toDate;

  /// No description provided for @selecttenant.
  ///
  /// In en, this message translates to:
  /// **'Select Tenant'**
  String get selecttenant;

  /// No description provided for @selectedTenantList.
  ///
  /// In en, this message translates to:
  /// **'Selected tenant list'**
  String get selectedTenantList;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @dailyMeterReading.
  ///
  /// In en, this message translates to:
  /// **'Daily Meter Reading'**
  String get dailyMeterReading;

  /// No description provided for @dailyAccumulated.
  ///
  /// In en, this message translates to:
  /// **'Daily Accumulated'**
  String get dailyAccumulated;

  /// No description provided for @dailyConsumption.
  ///
  /// In en, this message translates to:
  /// **'Daily Consumption'**
  String get dailyConsumption;

  /// No description provided for @pleaseSelectTenant.
  ///
  /// In en, this message translates to:
  /// **'Please Select at least one tenant'**
  String get pleaseSelectTenant;

  /// No description provided for @historicalDataDownloadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'History data downloaded successfully'**
  String get historicalDataDownloadedSuccessfully;

  /// No description provided for @dataDownloadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Data downloaded successfully'**
  String get dataDownloadedSuccessfully;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @budgetUsage.
  ///
  /// In en, this message translates to:
  /// **'Budget Usage'**
  String get budgetUsage;

  /// No description provided for @threshold.
  ///
  /// In en, this message translates to:
  /// **'Threshold'**
  String get threshold;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @thresholdAreEmpty.
  ///
  /// In en, this message translates to:
  /// **'Threshold are empty'**
  String get thresholdAreEmpty;

  /// No description provided for @valuesMustBeAtleast50.
  ///
  /// In en, this message translates to:
  /// **'Values must be greater than'**
  String get valuesMustBeAtleast50;

  /// No description provided for @thresholdValuesMustNotBeTheSame.
  ///
  /// In en, this message translates to:
  /// **'Threshold values must not be the same.'**
  String get thresholdValuesMustNotBeTheSame;

  /// No description provided for @mediumThresholdMustBeGreaterThanLowThreshold.
  ///
  /// In en, this message translates to:
  /// **'Medium Threshold must be greater than Low Threshold.'**
  String get mediumThresholdMustBeGreaterThanLowThreshold;

  /// No description provided for @highThresholdMustBeGreaterThanOtherThreshold.
  ///
  /// In en, this message translates to:
  /// **'High Threshold must be greater than other Threshold.'**
  String get highThresholdMustBeGreaterThanOtherThreshold;

  /// No description provided for @maximumValueIs1000.
  ///
  /// In en, this message translates to:
  /// **'Values must be lesser than'**
  String get maximumValueIs1000;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @searchByCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Search by Customer Name'**
  String get searchByCustomerName;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// No description provided for @gatewayType.
  ///
  /// In en, this message translates to:
  /// **'Gateway Type'**
  String get gatewayType;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @systemInformation.
  ///
  /// In en, this message translates to:
  /// **'System Information'**
  String get systemInformation;

  /// No description provided for @thresholdCantEmpty.
  ///
  /// In en, this message translates to:
  /// **'Threshold can\'t empty'**
  String get thresholdCantEmpty;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter Full Name'**
  String get enterFullName;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'In Active'**
  String get inactive;

  /// No description provided for @noMoreDataFound.
  ///
  /// In en, this message translates to:
  /// **'No more data found'**
  String get noMoreDataFound;

  /// No description provided for @only2ImageAllow.
  ///
  /// In en, this message translates to:
  /// **'Only 2 images allowed!'**
  String get only2ImageAllow;

  /// No description provided for @only5ImageAllow.
  ///
  /// In en, this message translates to:
  /// **'Only 5 images allowed!'**
  String get only5ImageAllow;

  /// No description provided for @billingCheckImageUploadNotes.
  ///
  /// In en, this message translates to:
  /// **'Note \n\n• The file size should not more than 2 MB.\n• Only 1 check number should be accepted.\n• Maximum 2 image is allowed.'**
  String get billingCheckImageUploadNotes;

  /// No description provided for @notificationTypeIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Notification Type is required.'**
  String get notificationTypeIsRequired;

  /// No description provided for @isRequired.
  ///
  /// In en, this message translates to:
  /// **'is required.'**
  String get isRequired;

  /// No description provided for @isInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get isInvalid;

  /// No description provided for @cannotExceed.
  ///
  /// In en, this message translates to:
  /// **'cannot exceed'**
  String get cannotExceed;

  /// No description provided for @characters.
  ///
  /// In en, this message translates to:
  /// **'characters.'**
  String get characters;

  /// No description provided for @mustContainAtLeast.
  ///
  /// In en, this message translates to:
  /// **'must contain at least'**
  String get mustContainAtLeast;

  /// No description provided for @mustBeBetween.
  ///
  /// In en, this message translates to:
  /// **'must be between'**
  String get mustBeBetween;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @digits.
  ///
  /// In en, this message translates to:
  /// **'digits.'**
  String get digits;

  /// No description provided for @payableAmountIs.
  ///
  /// In en, this message translates to:
  /// **'payable amount is'**
  String get payableAmountIs;

  /// No description provided for @minimum.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get minimum;

  /// No description provided for @maximum.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get maximum;

  /// No description provided for @isCharactersAreRequired.
  ///
  /// In en, this message translates to:
  /// **'characters are required.'**
  String get isCharactersAreRequired;

  /// No description provided for @issueTypeIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Issue type is required.'**
  String get issueTypeIsRequired;

  /// No description provided for @skeleton.
  ///
  /// In en, this message translates to:
  /// **'Skeleton'**
  String get skeleton;

  /// Resend OTP
  ///
  /// In en, this message translates to:
  /// **'Did not receive OTP? Resend in {remainingSeconds}'**
  String didNotReceiveOtpString(Object remainingSeconds);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
