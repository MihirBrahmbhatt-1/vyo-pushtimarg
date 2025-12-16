import 'dart:convert';
import 'dart:ui';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/dom.dart' as dom;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

// Assuming these paths are correct for your project
import '../../const/constant.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../model/dashboard_image_slider_response_model.dart';
import '../../widget/custom_text_widget.dart';
import '../media/image_list/image_preview_view.dart';
import '../media/video_list/unified_video_player_view.dart';
import 'dashboard_view_controller.dart';

class DashboardView extends GetView<DashboardViewController> {
  const DashboardView({super.key});

  // NOTE: Get.lazyPut should ideally be in your binding,
  // but keeping it here as per your original code.
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DashboardViewController());
    return SafeArea(
      top: false,
      child: Scaffold(
          body: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            }

            // --- Main Content Display Logic ---
            return RefreshIndicator(
              color: AppColors.white,
              onRefresh: controller.refreshDashboard,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Dynamically generate the list of widgets
                  children: [
                    controller.isImageSliderLoading.value
                        ? Center(
                            child: SizedBox(
                              width: Get.width,
                              height: 300,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          )
                        : _buildImageSlider(
                            context,
                            controller.apiController
                                .dashboardImageSliderResponseModel,
                          ),
                    controller.apiController.dashboardHtmlResponseModel.isEmpty
                        ? Center(
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
                          )
                        : Column(
                            children: [
                              ...controller
                                  .apiController.dashboardHtmlResponseModel
                                  .map((item) {
                                // The item.content field is assumed to be the URL or a complex JSON string
                                final content = item.content.toString();

                                switch (item.sectionType) {
                                  case 0:
                                    return _buildHtmlContent(
                                      content,
                                      item.sequence.toString(),
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

                                  default:
                                    // Fallback for unknown type
                                    return const SizedBox.shrink();
                                }
                              }),
                            ],
                          ),
                  ],
                ),
              ),
            );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: controller.openWhatsApp,
            backgroundColor: Colors.green,
            child: FaIcon(
              FontAwesomeIcons.whatsapp,
              color: AppColors.white,
              size: 30,
            ),
          )),
    );
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

  Widget _buildSingleImage(BuildContext context, String url) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      // 🎯 Replace Image.network with CachedNetworkImage
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width,

        placeholder: (context, url) => Center(
          child: SizedBox(
            height: 50, // Give the spinner a fixed size
            width: 50,
            child: CircularProgressIndicator(
              // The value argument of loadingProgress is not directly exposed here,
              // so we use an indeterminate spinner, which is simpler and common.
              color: AppColors.red,
              strokeWidth: 3,
            ),
          ),
        ),

        // 🎯 Use 'errorWidget' instead of 'errorBuilder'
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
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final imgs = snapshot.data!;
        final screenMaxHeight = MediaQuery.of(context).size.height * 0.7;

        // Compute scaled sizes and the maximum scaled height (UNCHANGED)
        final scaledSizes = imgs.map((img) {
          // final w = img.width.toDouble();
          final w = Get.width * 0.80;
          // final h = img.height.toDouble();
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
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
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

  Widget _buildImageSlider(
    BuildContext context,
    List<DashboardImageSliderResponseModel> sliderData,
  ) {
    if (sliderData.isEmpty) {
      return const SizedBox(
        height: 100,
      );
    }

    // 🎯 We only need ONE CachedNetworkImage widget per slide now.
    List<Widget> imageWidgets = sliderData.map((obj) {
      String imageUrl = obj.imageUrl ?? '';
      String redirectUrl = obj.redirectUrl?.toString() ?? '';

      return Builder(
        builder: (BuildContext context) {
          // --- 1. The Single Cached Network Image (Foreground) ---
          final mainCachedImage = CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit
                .contain, // Fits the image nicely in the center of the slide
            // Show loading progress
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return Center(
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  color: AppColors.red,
                  strokeWidth: 2,
                ),
              );
            },
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error)),
          );

          return Stack(
            children: [
              // 2. Background Image (Uses the Image Provider for Caching)
              // We use a Container with a DecorationImage to apply the image as a background
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    // 🎯 OPTIMIZATION: Use CachedNetworkImageProvider to load the image once.
                    // The image is cached on the first successful fetch and reused.
                    image: CachedNetworkImageProvider(imageUrl),
                    fit: BoxFit.cover, // Ensure it covers the background area
                  ),
                ),
                // --- 3. Backdrop Blur and Overlay ---
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                  child: Container(
                    // 🎯 FIX: Corrected from withValues to withOpacity
                    color: AppColors.black.withValues(alpha: 0.4),
                  ),
                ),
              ),

              // 4. Foreground Content with InkWell
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: InkWell(
                    onTap: () async {
                      // Navigate to ImageViewerPage
                      Get.to(
                        () => ImageViewerPage(
                          imageUrl: imageUrl,
                          redirectUrl: redirectUrl,
                        ),
                      );
                    },
                    // 🎯 Use the single CachedNetworkImage widget here
                    child: mainCachedImage,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }).toList();

    return CarouselSlider(
      items: imageWidgets,
      options: CarouselOptions(
        height: 200.0,
        viewportFraction: 1,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
      ),
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

    // Use the thumbnail URL to display the video card preview
    final thumbnailUrl = getThumbnailUrl(youtubeId);
    // final heroTag = 'single-video-hero-$youtubeId';

    // We are recreating the structure of the video list item from your source code
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        // Assuming 'borderRadius' is a constant available in your scope
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
            // 1. Thumbnail / Player Area (Clickable to open player)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Video Thumbnail
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

                  // Play Button Overlay
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

  String? extractYoutubeId(String url) {
    // Simple extraction logic (can be more complex for various URL formats)
    final RegExp regExp = RegExp(
      r'(?:youtu\.be\/|v\/|u\/\w\/|embed\/|live\/|watch\?v=)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  // Function to generate the default YouTube thumbnail URL
  String getThumbnailUrl(String youtubeId) {
    // Use the standard YouTube high-quality thumbnail format
    return 'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg';
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

    // Use a ListView.builder inside a fixed height container for horizontal scrolling
    // A fixed height of ~250 is usually appropriate for a 16:9 video card with padding/margin.
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: Get.width *
            0.70, // Calculate height based on screen width for responsive video aspect ratio
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: urls.length,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          itemBuilder: (context, index) {
            final url = urls[index];
            // Render each video URL as a horizontally scrollable card
            return _videoCard(context: context, url: url, isMulti: true);
          },
        ),
      ),
    );
  }

  Widget _videoCard({
    required BuildContext context,
    required String url,
    required bool isMulti,
  }) {
    final youtubeId = extractYoutubeId(url);

    if (youtubeId == null || youtubeId.isEmpty) {
      return Container(
        width: isMulti
            ? Get.width * 0.8
            : double.infinity, // Smaller width for horizontal scroll
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
      width: isMulti
          ? Get.width * 0.85
          : double
              .infinity, // For horizontal scroll, make it narrower than full width
      margin: isMulti
          ? const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 0,
            ) // Tighter margins for horizontal
          : const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 0,
            ), // Wider margins for single item

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
                    // Video Thumbnail
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
                    // Play Button Overlay
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

  Widget _buildHtmlContent(String content, String sequence) {
    final String htmlData = content;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: HtmlWidget(
        htmlData,
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

            // --- 2. Build Children ---

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
                  // Icon (img)
                  HtmlWidget(
                    imgHtml,
                    onLoadingBuilder: (context, element, loadingProgress) =>
                        const SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
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
        },
        onTapUrl: (url) async {
          final uri = Uri.tryParse(url);
          if (uri != null && await canLaunchUrl(uri)) {
            await launchUrl(uri);
            return true;
          } else {
            debugPrint('Could not launch URL: $url');
            return false;
          }
        },
      ),
    );
  }
}
