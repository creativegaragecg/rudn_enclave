import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:faisal_town/Utils/Constants/styles.dart';
import 'package:faisal_town/Utils/Constants/utils.dart';
import 'package:faisal_town/Utils/Custom/customAppbar.dart';
import '../Data/token.dart';
import '../Models/Transfers Model.dart';
import '../Providers/methods_provider.dart';
import '../Utils/Constants/colors.dart';
import '../Utils/Constants/images.dart';
import '../Utils/Constants/urls.dart';
import '../Utils/Custom/custom_text.dart';

class TransfersScreen extends StatefulWidget {
  const TransfersScreen({super.key});

  @override
  State<TransfersScreen> createState() => _TransfersScreenState();
}

class _TransfersScreenState extends State<TransfersScreen> {
  final Set<String> _expandedIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchData());
  }

  void fetchData() {
    UserToken().loadUserInfo();
    final provider = Provider.of<MethodsViewModel>(context, listen: false);
    var url = "${AppEndPoints.baseUrl}${UserToken.slung}";

    provider.fetchTransfers(context, url, UserToken.user_id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
       /* floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.golden,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const CreateTransferRequestScreen()),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),*/
        body: Consumer<MethodsViewModel>(
          builder: (context, value, child) {
            final List<Datum> items = value.transfersModel?.data ?? [];

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
                  // ── Same CustomAppBar as Properties ──────────────────
                  CustomAppBar(text: "Transfer History"),

                  Expanded(
                    child: value.loading
                        ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.golden))
                        : items.isEmpty
                        ? Center(
                      child: CustomText(
                       text: 'No transfer history found',
                        style: basicColor(15, AppColors.primary)
                      ),
                    )
                        : ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 2.h),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final cardId =
                            item.id?.toString() ?? '$index';
                        final isExpanded =
                        _expandedIds.contains(cardId);
                        return _TransferCard(
                          item: item,
                          index: index,
                          isExpanded: isExpanded,
                          onToggle: () => setState(() {
                            if (isExpanded) {
                              _expandedIds.remove(cardId);
                            } else {
                              _expandedIds.add(cardId);
                            }
                          }),
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
// Transfer Card  (mirrors _PropertyCard exactly)
// ─────────────────────────────────────────────────────────────────────────────
class _TransferCard extends StatelessWidget {
  final Datum item;
  final int index;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _TransferCard({
    required this.item,
    required this.index,
    required this.isExpanded,
    required this.onToggle,
  });

  // Status badge colour
  Color get _statusColor {
    final s = (item.status ?? '').toLowerCase();
    if (s == 'approved') return Colors.green;
    if (s == 'rejected') return Colors.red;
    return AppColors.golden; // Sales / pending / etc.
  }

  @override
  Widget build(BuildContext context) {
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
        children: [
          // ── Collapsed Header ──────────────────────────────────────────
          GestureDetector(
            onTap: onToggle,
            child: Container(
              padding:
              EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.8.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.07),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isExpanded ? 0 : 18),
                  bottomRight: Radius.circular(isExpanded ? 0 : 18),
                ),
                border: Border(
                  left: BorderSide(color: AppColors.golden, width: 4),
                ),
              ),
              child: Row(
                children: [
                  // Serial badge
                  Container(
                    width: 7.w,
                    height: 7.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: CustomText(
                     text: '${index + 1}',
                      style: basicColorBold(14, Colors.white)
                    ),
                  ),
                  SizedBox(width: 3.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Plot No
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Plot No. ',
                              style: basicColorBold(15.5, AppColors.primary),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 0.3.h),
                                child: CustomText(
                                  text: item.plotNo ?? 'N/A',
                                  style: basicColor(14, AppColors.darkBrown),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.4.h),
                        // FROM → TO summary line
                        CustomText(
                          text:
                          'From: ${item.memberFrom ?? 'N/A'}  →  To: ${item.memberTo ?? 'N/A'}',
                          style: basicColor(14.5, AppColors.brown),
                        ),
                      ],
                    ),
                  ),

                  // Status badge
                  Container(
                    margin: EdgeInsets.only(right: 1.w),
                    padding: EdgeInsets.symmetric(
                        horizontal: 2.w, vertical: 0.4.h),
                    decoration: BoxDecoration(
                      color: _statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.status ?? 'N/A',
                      style: basicColor(13, _statusColor),
                    ),
                  ),

                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded Detail ───────────────────────────────────────────
          if (isExpanded) ...[
            Divider(
              height: 1,
              color: AppColors.primary.withOpacity(0.12),
              indent: 4.w,
              endIndent: 4.w,
            ),
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Summary table ─────────────────────────────────
                  _SummaryTable(item: item),

                  SizedBox(height: 2.h),

                  // ── General details ───────────────────────────────
                  _InfoRow(
                      label: 'Plot No',
                      value: item.plotNo ?? 'N/A'),
                  _InfoRow(
                      label: 'Status',
                      value: item.status ?? 'N/A',
                      valueColor: _statusColor),
                  _InfoRow(
                      label: 'Financial Status',
                      value: item.fstatus ?? 'N/A'),
                  _InfoRow(
                      label: 'Share',
                      value: '${item.share ?? 'N/A'}%'),
                  _InfoRow(
                      label: 'Amount',
                      value: 'PKR ${item.amount ?? 'N/A'}'),
                  _InfoRow(
                      label: 'Comment',
                      value: item.cmnt ?? 'N/A'),
                  _InfoRow(
                      label: 'Created Date',
                      value: formatDate(item.createDate.toString()) ?? 'N/A'),
                  _InfoRow(
                      label: 'Modified Date',
                      value: formatDate(item.modifyDate.toString()) ?? 'N/A'),

                  SizedBox(height: 1.h),
                  Divider(color: AppColors.primary.withOpacity(0.1)),
                  SizedBox(height: 0.5.h),

                  // ── Transfer From ─────────────────────────────────
                  _SectionHeader('Transfer From'),
                  _InfoRow(
                      label: 'Name',
                      value: item.memberFrom ?? 'N/A'),

                  SizedBox(height: 1.h),
                  Divider(color: AppColors.primary.withOpacity(0.1)),
                  SizedBox(height: 0.5.h),

                  // ── Transfer To ───────────────────────────────────
                  _SectionHeader('Transfer To'),
                  _InfoRow(
                      label: 'Name',
                      value: item.memberTo ?? 'N/A'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }


}

// ─────────────────────────────────────────────────────────────────────────────
// Summary Table
// ─────────────────────────────────────────────────────────────────────────────
class _SummaryTable extends StatelessWidget {
  final Datum item;
  const _SummaryTable({required this.item});

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
                _TH('#', flex: 1),
                _TH('Plot No', flex: 3),
                _TH('Share', flex: 2),
                _TH('Amount', flex: 3),
              ],
            ),
          ),
          // Data row
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(11),
                bottomRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                _TD('1', flex: 1),
                _TD(item.plotNo ?? 'N/A', flex: 3),
                _TD('${item.share ?? 'N/A'}%', flex: 2),
                _TD('PKR ${item.amount ?? 'N/A'}', flex: 3,
                    color: AppColors.darkBrown),
              ],
            ),
          ),
          // From → To row
          Container(
            color: AppColors.golden.withOpacity(0.12),
            child: Row(
              children: [
                _TH('From', flex: 5, color: AppColors.darkBrown),
                _TH('To', flex: 5, color: Colors.green.shade700),
              ],
            ),
          ),
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
                _TD(item.memberFrom ?? 'N/A', flex: 5,
                    color: AppColors.darkBrown),
                _TD(item.memberTo ?? 'N/A', flex: 5,
                    color: Colors.green.shade700),
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
        style: basicColorBold(14, color),
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
        style: basicColor(14, color ?? AppColors.darkBrown),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Info Row  (identical to Properties)
// ─────────────────────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow(
      {required this.label, required this.value, this.valueColor});

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
                  ? basicColorBold(14, valueColor ?? AppColors.darkBrown)
                  : basicColor(14, AppColors.darkBrown),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Header  (identical to Properties)
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.8.h, top: 0.5.h),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 2.w),
          CustomText(
           text: title,
            style: basicColorBold(14, AppColors.primary)
          ),
        ],
      ),
    );
  }
}