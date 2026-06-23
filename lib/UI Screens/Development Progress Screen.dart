import 'package:faisal_town/Utils/Constants/utils.dart';
import 'package:faisal_town/Utils/Custom/customAppbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:faisal_town/Utils/Constants/styles.dart';
import '../Data/token.dart';
import '../Models/DevelopmentProgressModel.dart';
import '../Providers/methods_provider.dart';
import '../Utils/Constants/colors.dart';
import '../Utils/Constants/images.dart';
import '../Utils/Constants/urls.dart';
import '../Utils/Custom/custom_text.dart';

class DevelopmentProgressScreen extends StatefulWidget {
  const DevelopmentProgressScreen({super.key});

  @override
  State<DevelopmentProgressScreen> createState() =>
      _DevelopmentProgressScreenState();
}

class _DevelopmentProgressScreenState
    extends State<DevelopmentProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchData());
  }

  fetchData() {
    UserToken().loadUserInfo();
    var provider = Provider.of<MethodsViewModel>(context, listen: false);
    var url = "${AppEndPoints.baseUrl}${UserToken.slung}";
    print("ur;:$url");
    provider.fetchProgress(context, url);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Consumer<MethodsViewModel>(
          builder: (context, value, child) {
            final List<Datum> items =
                value.developmentProgressModel?.data ?? [];

            return Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppImages.bg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  CustomAppBar(text: "Development status"),
                  Expanded(
                    child: value.loading
                        ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary))
                        : items.isEmpty
                        ? Center(
                      child: Text(
                        'No development updates found',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 15.sp,
                          color: AppColors.darkBrown,
                        ),
                      ),
                    )
                        : ListView.separated(
                      padding: EdgeInsets.symmetric(
                          horizontal: 5.w, vertical: 2.h),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 1.h),
                        child: Divider(
                            color: Colors.brown.withOpacity(0.2),
                            thickness: 1),
                      ),
                      itemBuilder: (context, index) {
                        return _DevelopmentCard(
                          item: items[index],
                          index: index + 1,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// App Bar
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// Development Card
// ─────────────────────────────────────────────────────────────────────────────
class _DevelopmentCard extends StatelessWidget {
  final Datum item;
  final int index;

  const _DevelopmentCard({required this.item, required this.index});

  // Check if image URL is valid (not just a folder path)
  bool get _hasValidImage {
    final url = item.pic ?? '';
    return url.isNotEmpty &&
        (url.endsWith('.jpg') ||
            url.endsWith('.jpeg') ||
            url.endsWith('.png') ||
            url.endsWith('.webp'));
  }

  // Status label
  String get _statusLabel {
    switch (item.status) {
      case '1':
        return 'Completed';
      case '2':
        return 'In Progress';
      case '0':
        return 'Pending';
      default:
        return item.status ?? 'N/A';
    }
  }

  Color get _statusColor {
    switch (item.status) {
      case 'Active':
        return Colors.green.shade600;
      case '2':
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section title ──────────────────────────────────────────────
        Row(
          children: [
            Container(
              width: 4,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(width: 2.5.w),
            Expanded(
              child: Text(
                (item.title ?? '').toUpperCase(),
                style: GoogleFonts.playfairDisplay(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
            // Status badge
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _statusColor.withOpacity(0.4)),
              ),
              child: CustomText(
              text:  _statusLabel,
                style:
                  basicColor(13.5, _statusColor)
                /*GoogleFonts.playfairDisplay(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: _statusColor,
                ),*/
              ),
            ),
          ],
        ),

        SizedBox(height: 1.5.h),

        // ── Image ──────────────────────────────────────────────────────
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              // Image or placeholder
              _hasValidImage
                  ? Image.network(
                item.pic!,
                width: double.infinity,
                height: 28.h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _ImagePlaceholder(),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    width: double.infinity,
                    height: 28.h,
                    color: Colors.grey.shade100,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              )
                  : _ImagePlaceholder(),

              // Gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.55),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Index badge — top right
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.85),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$index',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 1.2.h),

        // ── Detail ─────────────────────────────────────────────────────
        if (item.detail != null && item.detail!.isNotEmpty)
          Row(
            children: [
              Icon(Icons.construction, size: 16, color: AppColors.primary),
              SizedBox(width: 2.w),
              Expanded(
                child: CustomText(
                text:   item.detail ??"".toTitleCase(),
                  style: basicColor(14, AppColors.darkBrown)
                  /*GoogleFonts.playfairDisplay(
                    fontSize: 13.sp,
                    color: AppColors.darkBrown,
                    letterSpacing: 1,
                  ),*/
                ),
              ),
            ],
          ),

        SizedBox(height: 1.5.h),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Image Placeholder — shown when URL has no filename
// ─────────────────────────────────────────────────────────────────────────────
class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 28.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction,
              size: 12.w, color: AppColors.primary.withOpacity(0.5)),
          SizedBox(height: 1.h),
          CustomText(
           text:  'Image Coming Soon',
            style: basicColor(14, AppColors.textPrimary)
            /*GoogleFonts.playfairDisplay(
              fontSize: 12.sp,
              color: Colors.grey.shade500,
            ),*/
          ),
        ],
      ),
    );
  }
}