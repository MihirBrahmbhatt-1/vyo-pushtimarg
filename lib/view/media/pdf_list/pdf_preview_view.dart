import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';

import '../../../const/app_color.dart';
import '../../../const/app_constant.dart';
import '../../../localization/dynamic_app_localizations.dart';
import '../../../widget/custom_text_widget.dart';

class PdfViewerScreen extends StatefulWidget {
  final String title;
  final String pdfUrl;

  const PdfViewerScreen({super.key, required this.title, required this.pdfUrl});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  Future<File>? _cachedPdfFile;

  @override
  void initState() {
    super.initState();
    _cachedPdfFile = _cachePdfFile(widget.pdfUrl);
  }

  Future<File> _cachePdfFile(String url) async {
    return DefaultCacheManager().getSingleFile(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: CustomTextWidget(
          textString: widget.title,
          textSize: FontSize().appBar,
          isFontBold: false,
          fontColor: AppColors.white,
          isFontUnderline: false,
          fontStyle: FontStyle.normal,
        ),
      ),
      body: FutureBuilder<File>(
        future: _cachedPdfFile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  CustomTextWidget(
                    textString: DynamicAppLocalizations.of(
                      Get.context!,
                    ).t("failed_to_load_pdf"),
                    textSize: FontSize().large,
                    fontColor: AppColors.grey800,
                  ),
                  CustomTextWidget(
                    textString: DynamicAppLocalizations.of(
                      Get.context!,
                    ).t("retry"),
                    textSize: FontSize().small,
                    fontColor: AppColors.grey,
                  ),
                ],
              ),
            );
          }

          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(
                context,
              ).colorScheme.copyWith(primary: AppColors.primaryColor),
            ),
            child: SfPdfViewer.file(
              snapshot.data!,
              onDocumentLoadFailed: (details) {
                debugPrint('PDF rendering failed: ${details.description}');
              },
            ),
          );
        },
      ),
    );
  }
}
