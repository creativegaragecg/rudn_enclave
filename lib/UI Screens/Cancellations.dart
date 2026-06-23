import 'package:faisal_town/Utils/Custom/customAppbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:faisal_town/Utils/Constants/styles.dart';
import '../Data/token.dart';
import '../Providers/methods_provider.dart';
import '../Utils/Constants/colors.dart';
import '../Utils/Constants/images.dart';
import '../Utils/Constants/urls.dart';
import '../Utils/Custom/custom_text.dart';

class CancellationsScreen extends StatefulWidget {
  const CancellationsScreen({super.key});

  @override
  State<CancellationsScreen> createState() => _CancellationsScreenState();
}

class _CancellationsScreenState extends State<CancellationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchData());
  }

  fetchData() {
    UserToken().loadUserInfo();
    var provider = Provider.of<MethodsViewModel>(context, listen: false);
    var url = "${AppEndPoints.baseUrl}${UserToken.slung}";
    provider.fetchCancellation(context, url, UserToken.user_id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Consumer<MethodsViewModel>(
          builder: (context, value, child) {
            // Adjust model field to whatever your provider exposes for cancellations
            final items = value.cancellationsModel?.data ?? [];

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
                  CustomAppBar(text: "Cancellations"),
                  Expanded(
                    child: value.loading
                        ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.golden))
                        : items.isEmpty
                        ? Center(
                      child: Text(
                        'No cancellations found',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 15.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                        : ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 2.h),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return _CancellationCard(
                            item: item, index: index);
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
// Cancellation Card — flat, no expand
// ─────────────────────────────────────────────────────────────────────────────
class _CancellationCard extends StatelessWidget {
  final dynamic item; // replace with your actual model type
  final int index;

  const _CancellationCard({required this.item, required this.index});

  // Status color helper
  Color _statusBg(String? status) {
    switch ((status ?? '').toLowerCase()) {
      case 'approved':
        return Colors.green.shade100;
      case 'refund':
        return Colors.blue.shade100;
      default:
        return Colors.orange.shade100;
    }
  }

  Color _statusText(String? status) {
    switch ((status ?? '').toLowerCase()) {
      case 'approved':
        return Colors.green.shade700;
      case 'refund':
        return Colors.blue.shade700;
      default:
        return Colors.orange.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String comment  = item.mpcomment ?? 'N/A';
    final String plotNo   = item.plotNoo ?? 'N/A';
    final String plotAddr = item.plotDetailAddress ?? 'N/A';
    final String size     = item.plotSize ?? 'N/A';
    final String project  = item.projectName ?? 'N/A';
    final String sector   = item.sectorName ?? 'N/A';
    final String street   = item.streetName ?? 'N/A';
    final String type     = item.pltype ?? 'N/A';
    final String price    = item.ppprice ?? item.msPrice ?? 'N/A';
    final String cdate    = _formatDate(item.cdate?.toString());
    final String crdate   = _formatDate(item.crDate?.toString());

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: AppColors.btnColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Header strip ─────────────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.07),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              border: Border(
                left: BorderSide(color: AppColors.golden, width: 4),
              ),
            ),
            child: Row(
              children: [
                // Index badge
                Container(
                  width: 7.w,
                  height: 7.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'MS No: $plotNo',
                        style: basicColorBold(15, AppColors.primary),
                      ),
                      SizedBox(height: 0.3.h),
                      CustomText(
                        text: 'Project: $project  |  Type: $type',
                        style: basicColor(13, AppColors.brown),
                      ),
                    ],
                  ),
                ),

                // Status / comment badge
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 2.5.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _statusBg(comment),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomText(
                    text: comment,
                    style: basicColorBold(12, _statusText(comment)),
                  ),
                ),
              ],
            ),
          ),

          // ── Info grid ────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              children: [
                // Summary table
                _SummaryTable(
                  plotNo: plotNo,
                  size: size,
                  sector: sector,
                  price: price,
                ),

                SizedBox(height: 2.h),

                // Detail rows
                _InfoRow(label: 'Plot No',       value: plotAddr),
                _InfoRow(label: 'Plot Size',     value: size),
                _InfoRow(label: 'Street',        value: street),
                _InfoRow(label: 'Sector',        value: sector),
                _InfoRow(label: 'Project',       value: project),
                _InfoRow(label: 'Type',          value: type),
                _InfoRow(label: 'Price',         value: 'PKR $price'),
                _InfoRow(label: 'Cancel Date',   value: cdate),
                _InfoRow(label: 'Creation Date', value: crdate),
                _InfoRow(
                  label: 'Comment',
                  value: comment,
                  valueColor: _statusText(comment),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(raw);
      return '${dt.day.toString().padLeft(2, '0')}-'
          '${dt.month.toString().padLeft(2, '0')}-'
          '${dt.year}';
    } catch (_) {
      return raw.split(' ').first;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Summary Table (same pattern as PropertiesScreen)
// ─────────────────────────────────────────────────────────────────────────────
class _SummaryTable extends StatelessWidget {
  final String plotNo;
  final String size;
  final String sector;
  final String price;

  const _SummaryTable({
    required this.plotNo,
    required this.size,
    required this.sector,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                _TH('MS No',   flex: 3),
                _TH('Size',    flex: 2),
                _TH('Sector',  flex: 3),
                _TH('Price',   flex: 3),
              ],
            ),
          ),
          // Data
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.04),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(11),
                bottomRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                _TD(plotNo,           flex: 3),
                _TD(size,             flex: 2),
                _TD(sector,           flex: 3),
                _TD('PKR $price',     flex: 3, color: AppColors.darkBrown),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _TH(String text, {required int flex, Color color = Colors.white}) {
  return Expanded(
    flex: flex,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: CustomText(
        text: text,
        align: TextAlign.center,
        style: basicColorBold(13, color),
      ),
    ),
  );
}

Widget _TD(String text, {required int flex, Color? color}) {
  return Expanded(
    flex: flex,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 9),
      child: CustomText(
        text: text,
        align: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: basicColor(13, color ?? AppColors.darkBrown),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Info Row
// ─────────────────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 35.w,
            child: CustomText(
              text: '$label :',
              style: basicColorBold(14, AppColors.brown),
            ),
          ),
          Expanded(
            child: CustomText(
              text: value,
              style: valueColor != null
                  ? basicColorBold(14, valueColor!)
                  : basicColor(14, AppColors.darkBrown),
            ),
          ),
        ],
      ),
    );
  }
}