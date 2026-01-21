import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../navigation/pages.dart';
import '../../widget/custom_text_widget.dart';
import '../media/video_list/unified_video_player_view.dart';
import 'habit_view_controller.dart';

class HabitView extends GetView<HabitViewController> {
  const HabitView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<HabitViewController>()) {
      Get.put(HabitViewController());
    }

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final practices = controller.apiController.pushtiPracticeResponseModel;

      if (practices.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextWidget(
              textString: DynamicAppLocalizations.of(
                Get.context!,
              ).t("no_content_available"),
              textSize: FontSize().regular,
              fontColor: AppColors.grey,
              isFontBold: false,
            ),
          ),
        );
      }

      return DefaultTabController(
        length: practices.length,
        child: Column(
          children: [
            Container(
              color: AppColors.white,
              width: double.infinity,
              child: TabBar(
                isScrollable: true,
                indicatorColor: AppColors.primaryColor,
                indicatorWeight: 3,
                labelColor: AppColors.black,
                unselectedLabelColor: AppColors.grey,
                tabs: practices
                    .map((p) => Tab(text: p.practiceName ?? ''))
                    .toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: practices.map((practice) {
                  return RefreshIndicator(
                      color: AppColors.white,
                      onRefresh: () async {
                        await controller.refreshPushtiPractices();
                      },
                      child: _buildPracticePage(context, practice));
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPracticePage(BuildContext context, dynamic practice) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const SizedBox(height: 12),
        ...?practice.sections?.map((section) {
          return _buildSectionWidget(context, section);
        }),
      ],
    );
  }

  Widget _buildSectionWidget(BuildContext context, dynamic section) {
    final content = section.content ?? '';
    if (content.isEmpty) return const SizedBox.shrink();

    switch (section.sectionType) {
      case 0:
        return _buildHtmlContent(
          content,
        );

      case 1:
        // Type 1: Single Image URL
        return _buildSingleImage(
          context,
          content,
        );

      case 2:
        // Type 2: Multiple Images Slider
        return _buildMultipleImageSlider(
          context,
          content,
        );
      case 3:
        // Type 3: Single YouTube Video URL
        return _buildSingleVideo(
          context,
          content,
        );

      case 4:
        // Type 4: Multiple YouTube Video URLs
        return _buildMultipleVideos(
          context,
          content,
        );
      case 5:
        return scrollImagesCustom(context, content);

      case 6:
        return _buildTypeSixItem(context, content);

      default:
        // Fallback for unknown type
        return const SizedBox.shrink();
    }
  }

  Color? _parseColor(String colorString) {
    if (colorString.startsWith('#') &&
        (colorString.length == 7 || colorString.length == 9)) {
      String hex = colorString.substring(1);
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    }
    switch (colorString.toLowerCase()) {
      case 'red':
        return AppColors.red;
      case 'blue':
        return AppColors.blue;
      case 'white':
        return AppColors.white;
      case 'black':
        return AppColors.black;
      case 'grey':
        return AppColors.grey;
      default:
        return null;
    }
  }

  Widget _buildHtmlContent(String content) {
    final String htmlData = content;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: HtmlWidget(htmlData,
          textStyle: const TextStyle(fontStyle: FontStyle.normal),
          customWidgetBuilder: (dom.Element element) {
        if (element.localName == 'div' &&
            element.parent?.localName == 'a' &&
            element.children.length == 2 &&
            // element.children[0].localName == 'img' &&
            element.children[1].localName == 'div') {
          final style = element.attributes['style'] ?? '';

          // Extract Background Color
          Color? bgColor;
          final bgColorMatch = RegExp(
            r'background: *([^;]+)',
          ).firstMatch(style);
          if (bgColorMatch != null) {
            bgColor = _parseColor(bgColorMatch.group(1)!.trim());
          }

          // Extract Padding
          EdgeInsets padding = EdgeInsets.zero;
          final paddingMatch = RegExp(
            r'padding: *(\d+)(px)?',
          ).firstMatch(style);
          if (paddingMatch != null) {
            double paddingValue =
                double.tryParse(paddingMatch.group(1)!) ?? 0.0;
            padding = EdgeInsets.all(paddingValue);
          }

          BoxDecoration decoration = BoxDecoration(
            color: bgColor ?? AppColors.transparent,
          );
          if (style.contains('border:2px solid #D24F16')) {
            decoration = decoration.copyWith(
              border: Border.all(color: AppColors.primaryColor, width: 2.0),
            );
          }

          // Recursively render the two child elements (img and div) using the context
          // Note: HtmlWidget context provides a method to render children safely.
          // Since we are creating a custom widget, we need to manually create the children
          // to include them in our Row layout.

          // We'll use the package's internal rendering engine to convert the children DOM
          // nodes into Flutter widgets. We need a special builder context for this.
          // Since HtmlWidget is designed to handle all rendering internally,
          // the simplest way is to manually instantiate a sub-HtmlWidget for the children,
          // or manually locate the Image and Text widgets if they are rendered by the core.

          // The most reliable way with fwfh is to build the Row and use sub-widgets for the content:

          // Convert the inner content HTML to strings for recursive rendering
          final imgHtml = element.children[0].outerHtml;
          final textDivHtml = element.children[1].outerHtml;

          return Container(
            padding: padding,
            decoration: decoration,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HtmlWidget(
                  imgHtml,
                  onLoadingBuilder: (context, element, loadingProgress) =>
                      SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.grey400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: HtmlWidget(
                    textDivHtml,
                    textStyle: const TextStyle(fontStyle: FontStyle.normal),
                  ),
                ),
              ],
            ),
          );
        }
        return null;
      }, onTapUrl: (url) async {
        try {
          if (url.startsWith('mailto:')) {
            final email = url.replaceFirst('mailto:', '');

            final uri = Uri(
              scheme: 'mailto',
              path: email,
              // optional
              queryParameters: {
                // 'subject': 'Hello',
                // 'body': 'Message here',
              },
            );

            if (await canLaunchUrl(uri)) {
              await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );
              return true;
            }
          } else {
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri);
              return true;
            }
          }
        } catch (e) {
          debugPrint('Launch error: $e');
        }

        debugPrint('Could not launch URL: $url');
        return false;
      }),
    );
  }

  Widget _buildSingleImage(BuildContext context, String url) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,
        placeholder: (context, url) => Center(
          child: SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              color: AppColors.red,
              strokeWidth: 3,
            ),
          ),
        ),
        errorWidget: (context, url, error) {
          return const Center(child: Icon(Icons.broken_image, size: 50));
        },
      ),
    );
  }

  Widget _buildMultipleImageSlider(BuildContext context, dynamic sliderData) {
    List<String> urls = [];
    try {
      urls = List<String>.from(jsonDecode(sliderData));
    } catch (_) {
      return const SizedBox.shrink();
    }

    // NOTE: This FutureBuilder is still necessary because it calculates the
    // necessary 'containerHeight' for the whole ListView based on image dimensions.
    return FutureBuilder<List<ui.Image>>(
      future: controller.getImagesDimensions(urls),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox(
            height: 200,
            child: Center(
                child: CircularProgressIndicator(
              color: AppColors.grey400,
            )),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final imgs = snapshot.data!;
        final screenMaxHeight = MediaQuery.of(context).size.height * 0.7;

        final scaledSizes = imgs.map((img) {
          final w = Get.width * 0.80;
          final h = 500.0;
          final scale = h > screenMaxHeight ? (screenMaxHeight / h) : 1.0;
          return Size(w * scale, h * scale);
        }).toList();

        final containerHeight =
            scaledSizes.map((s) => s.height).reduce(math.max);

        return SizedBox(
          height: containerHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: urls.length,
            padding: const EdgeInsets.only(left: 16.0),
            itemBuilder: (context, index) {
              final url = urls[index];
              final size = scaledSizes[index];

              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 0 : 6,
                  right: 6,
                  top: 6,
                  bottom: 6,
                ),
                child: Center(
                  child: SizedBox(
                    width: size.width,
                    height: size.height,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.grey400,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.error, size: 40)),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSingleVideo(BuildContext context, String url) {
    final youtubeId = extractYoutubeId(url);

    if (youtubeId == null || youtubeId.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: CustomTextWidget(
            textString: DynamicAppLocalizations.of(
              Get.context!,
            ).t("invalid_url"),
            textSize: FontSize().regular,
            fontColor: AppColors.red,
            isFontBold: false,
          ),
        ),
      );
    }

    final thumbnailUrl = getThumbnailUrl(youtubeId);
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: () async {
          Get.to(
            () => UnifiedVideoPlayer(
              title: '',
              url: url,
              // heroTag: heroTag,
            ),
            opaque: false,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    thumbnailUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: AppColors.red,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.videocam_off_outlined,
                          color: AppColors.grey,
                        ),
                      );
                    },
                  ),
                  const Icon(
                    Icons.play_circle_fill,
                    color: AppColors.white,
                    size: 60,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultipleVideos(BuildContext context, String jsonUrls) {
    List<String> urls = [];
    try {
      urls = List<String>.from(jsonDecode(jsonUrls));
    } catch (e) {
      return Padding(
        padding: EdgeInsets.all(16.0),
        child: CustomTextWidget(
          textString: DynamicAppLocalizations.of(
            Get.context!,
          ).t("error_loading_list"),
          textSize: FontSize().regular,
          fontColor: AppColors.red,
          isFontBold: false,
        ),
      );
    }

    if (urls.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: Get.width * 0.54,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: urls.length,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          itemBuilder: (context, index) {
            final url = urls[index];
            return _videoCard(context: context, url: url, isMulti: true);
          },
        ),
      ),
    );
  }

  String? extractYoutubeId(String url) {
    final RegExp regExp = RegExp(
      r'(?:youtu\.be\/|v\/|u\/\w\/|embed\/|live\/|watch\?v=)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  String getThumbnailUrl(String youtubeId) {
    return 'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg';
  }

  Widget _videoCard({
    required BuildContext context,
    required String url,
    required bool isMulti,
  }) {
    final youtubeId = extractYoutubeId(url);

    if (youtubeId == null || youtubeId.isEmpty) {
      return Container(
        width: isMulti ? Get.width * 0.8 : double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: CustomTextWidget(
          textString: DynamicAppLocalizations.of(Get.context!).t("invalid_url"),
          textSize: FontSize().regular,
          fontColor: AppColors.red,
          isFontBold: false,
        ),
      );
    }

    final thumbnailUrl = getThumbnailUrl(youtubeId);
    // final heroTag = 'video-hero-$youtubeId-${isMulti ? 'multi' : 'single'}';

    return Container(
      width: isMulti ? Get.width * 0.90 : double.infinity,
      margin: isMulti
          ? const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 0,
            )
          : const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 0,
            ),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: () async {
          Get.to(
            () => UnifiedVideoPlayer(
              title: '',
              url: url,
              // heroTag: heroTag,
            ),
            opaque: false,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(borderRadius),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      thumbnailUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: AppColors.red,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.videocam_off_outlined,
                            color: AppColors.grey,
                            size: 40,
                          ),
                        );
                      },
                    ),
                    const Icon(
                      Icons.play_circle_fill,
                      color: AppColors.white,
                      size: 60,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSixItem(BuildContext context, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: HtmlWidget(
            content,
            textStyle: const TextStyle(
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget scrollImagesCustom(BuildContext context, String jsonString) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
              ),
              child: HtmlWidget(
                jsonString,
                renderMode: RenderMode.column,
                textStyle: const TextStyle(
                  fontStyle: FontStyle.normal,
                  color: AppColors.black,
                ),
                customWidgetBuilder: (dom.Element element) {
                  if (element.localName == 'img') {
                    final parent = element.parent;
                    final dataInfo = parent?.attributes['data-info'];
                    final imgUrl = element.attributes['src'];

                    if (imgUrl == null) return null;

                    Map<String, dynamic>? parsedData;
                    if (dataInfo != null) {
                      try {
                        parsedData = jsonDecode(dataInfo);
                      } catch (e) {
                        debugPrint('Invalid data-info JSON');
                      }
                    }

                    return GestureDetector(
                      onTap: () {
                        debugPrint('IMAGE TAPPED');
                        debugPrint('Image URL: $imgUrl');
                        debugPrint('Data Info: $parsedData');

                        if (parsedData != null) {
                          final categoryType =
                              parsedData['category_type'].toString();
                          final subCategoryId = parsedData['subcategory_id'];
                          final subCategoryName =
                              parsedData['subcategory_name'];

                          debugPrint('Category: $categoryType');
                          debugPrint('Subcategory: $subCategoryId');
                          debugPrint('subCategoryName: $subCategoryName');
                          String? routeName;
                          if (categoryType.toString() == '2') {
                            routeName = Routes.videolist;
                          } else if (categoryType.toString() == '1') {
                            routeName = Routes.imagelist;
                          } else if (categoryType.toString() == '3') {
                            routeName = Routes.pdflist;
                          } else if (categoryType.toString() == '4') {
                            routeName = Routes.audiolist;
                          }

                          if (routeName != null) {
                            Get.toNamed(
                              routeName,
                              arguments: {
                                'subCategoryId': subCategoryId,
                                'title': subCategoryName.toString(),
                              },
                            );
                          }
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: imgUrl,
                          width: 150,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
