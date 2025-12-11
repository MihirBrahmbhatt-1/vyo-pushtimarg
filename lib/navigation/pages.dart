import 'package:get/get.dart';

import '../view/change_password/change_password_view.dart';
import '../view/forgot_password/forgot_password/forgot_password_view.dart';
import '../view/forgot_password/otp/otp_view.dart';
import '../view/forgot_password/reset_password/reset_password_view.dart';
import '../view/home/home_view.dart';
import '../view/language/language_selection_view.dart';
import '../view/login/login_view.dart';
import '../view/media/audio_list/audio_list_view.dart';
import '../view/media/audio_list/audio_list_view_controller.dart';
import '../view/media/image_list/image_list_view.dart';
import '../view/media/image_list/image_list_view_controller.dart';
import '../view/media/pdf_list/pdf_list_view.dart';
import '../view/media/video_list/video_list_view.dart';
import '../view/otp/otp_view.dart';
import '../view/sign_up/sign_up_view.dart';
import '../view/splash/splash_view.dart';
import '../view/sub_category/sub_category_view.dart';
import '../view/sub_category/sub_category_view_controller.dart';
import '../view/user_details/user_details_view.dart';
import '../view/user_details/user_details_view_controller.dart';

part 'routes.dart';

class Pages {
  static List<GetPage> routes = [
    GetPage(
      name: _Paths.signin,
      page: () => LoginView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: _Paths.languageselection,
      page: () => LanguageSelectionView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: _Paths.splash,
      page: () => SplashView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: _Paths.home,
      page: () => HomeView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: _Paths.verifyotp,
      page: () => VerifyOtpView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: _Paths.signup,
      page: () => SignUpView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: _Paths.changepassword,
      page: () => ChangePasswordView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: _Paths.forgotpassword,
      page: () => ForgotPasswordView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: _Paths.forgotpasswordverifyotp,
      page: () => OtpView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: _Paths.resetpassword,
      page: () => ResetPasswordView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: _Paths.videolist,
      page: () => VideoListView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: _Paths.imagelist,
      page: () => ImageListView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
      binding: BindingsBuilder(() {
        Get.put(ImageListViewController());
      }),
    ),
    GetPage(
      name: _Paths.pdflist,
      page: () => PdfListView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: _Paths.audiolist,
      page: () => AudioListView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
      binding: BindingsBuilder(() {
        Get.put(AudioListViewController());
      }),
    ),
    GetPage(
      name: _Paths.userprofile,
      page: () => UserDetailsView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
      binding: BindingsBuilder(() {
        Get.put(UserDetailsViewController());
      }),
    ),
    GetPage(
      name: _Paths.subCategoryview,
      page: () => SubCategoryView(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 200),
      binding: BindingsBuilder(() {
        Get.put(SubCategoryViewController());
      }),
    ),
  ];
}
