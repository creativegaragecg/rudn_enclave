import 'package:faisal_town/Utils/Custom/customAppbar.dart';
import 'package:faisal_town/Utils/Custom/webview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:faisal_town/Utils/Constants/styles.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Data/token.dart';
import '../Models/MemberShip Model.dart';
import '../Providers/methods_provider.dart';
import '../Utils/Constants/colors.dart';
import '../Utils/Constants/images.dart';
import '../Utils/Constants/urls.dart';
import '../Utils/Custom/custom_text.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  final Set<String> _expandedIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchData());
  }

  fetchData() {
    UserToken().loadUserInfo();
    var provider = Provider.of<MethodsViewModel>(context, listen: false);
    var url = "${AppEndPoints.baseUrl}${UserToken.slung}";
    provider.fetchMemberShips(context, url, UserToken.user_id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        floatingActionButton: FloatingActionButton.extended(

          // Inside your FAB onPressed:
          onPressed: () async {
            print("object: url:https://faisaltown.com.pk/portal/members_portal/payonline_app.php?payfrom_phone=true&project=${UserToken.slungId}&username=${UserToken.user_name}&password=${UserToken.user_password}",);
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WebViewScreen(
                  url:"https://faisaltown.com.pk/portal/members_portal/payonline_app.php?payfrom_phone=true&project=${UserToken.slungId}&username=${UserToken.user_name}&password=${UserToken.user_password}",
                  isPayment: true,
                ),
              ),
            );

            if (result == 'success') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment Successful!'),
                  backgroundColor: Colors.green,
                ),
              );
              fetchData(); // Refresh data after payment
            } else if (result == 'failed') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payment Failed or Cancelled'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          backgroundColor: AppColors.primary,
          elevation: 6,
          icon: const Icon(
            Icons.payment_rounded,
            color: Colors.white,
          ),
          label: Text(
            'Pay Online',
            style: basicColorBold(14, Colors.white)
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          //  side: BorderSide(color: AppColors.golden, width: 1.5),
          ),
        ),
        floatingActionButtonLocation: _expandedIds.isNotEmpty
            ? FloatingActionButtonLocation.centerTop   // ← moves to bottom-right when a card is open
            : FloatingActionButtonLocation.centerFloat, // ← stays centered when all collapsed
        body: Consumer<MethodsViewModel>(
          builder: (context, value, child) {
            final List<Datum> items = value.memberShipModel?.data ?? [];

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
                  CustomAppBar(text: "Properties"),
                  Expanded(
                    child: value.loading
                        ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.golden))
                        : items.isEmpty
                        ? Center(
                      child: CustomText(
                       text: 'No properties found',
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
                        return _PropertyCard(
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
// Property Card
// ─────────────────────────────────────────────────────────────────────────────
class _PropertyCard extends StatelessWidget {
  final Datum item;
  final int index;
  final bool isExpanded;
  final VoidCallback onToggle;

  const _PropertyCard({
    required this.item,
    required this.index,
    required this.isExpanded,
    required this.onToggle,
  });

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
              EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.8.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.07),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft:
                  Radius.circular(isExpanded ? 0 : 18),
                  bottomRight:
                  Radius.circular(isExpanded ? 0 : 18),
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
                    text:  '${index + 1}',
                      style: basicColorBold(13, Colors.white)
                    ),
                  ),
                  SizedBox(width: 2.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1-link Ref No
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                            text:  '1-link Ref No. ',
                              style:basicColorBold(15, AppColors.primary)
                            ),
                            Expanded(
                              child: Padding(
                                padding:  EdgeInsets.only(top: 0.3.h),
                                child: CustomText(

                                 text: item.consumerNo ?? 'N/A',
                                  style: basicColor(14, AppColors.darkBrown)
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.4.h),
                        // MS No | Plot No | Size | Block/Sector
                        CustomText(
                        text:  'MS No: ${item.plotNoo ?? 'N/A'}  |  Plot No: ${item.plotDetailAddress ?? 'N/A'}  |  Size: ${item.plotSize ?? 'N/A'}  |  Block/Sector: ${item.sectorName ?? 'N/A'}',
                          style: basicColor(14, AppColors.brown)
                        ),
                      ],
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
                endIndent: 4.w),
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                children: [
                  // ── Summary table ─────────────────────────────────
                  _SummaryTable(item: item),

                  SizedBox(height: 2.h),

                  // ── Detail rows ───────────────────────────────────
                  _InfoRow(
                      label: '1-link Ref No.',
                      value: item.consumerNo ?? 'N/A'),
                  _InfoRow(
                      label: 'MS No', value: item.plotNoo ?? 'N/A'),
                  _InfoRow(
                      label: 'Plot No',
                      value: item.plotDetailAddress ?? 'N/A'),
                  _InfoRow(
                      label: 'Size', value: item.plotSize ?? 'N/A'),
                  _InfoRow(
                      label: 'Block/Sector',
                      value: item.sectorName ?? 'N/A'),
                  _InfoRow(
                      label: 'Project',
                      value: item.projectName ?? 'N/A'),
                  _InfoRow(
                      label: 'Type', value: item.pltype ?? 'N/A'),
                  _InfoRow(
                      label: 'Status', value: item.status ?? 'N/A'),
                  _InfoRow(
                      label: 'Allotment Type',
                      value: item.atype ?? 'N/A'),

                  SizedBox(height: 1.h),
                  Divider(
                      color: AppColors.primary.withOpacity(0.1)),
                  SizedBox(height: 1.h),

                  // ── Financial rows ────────────────────────────────
                  _InfoRow(
                      label: 'Total Amount',
                      value: 'PKR ${item.totalAmount ?? 'N/A'}',
                      valueColor: AppColors.darkBrown),
                  _InfoRow(
                      label: 'Paid',
                      value: 'PKR ${item.paid ?? 'N/A'}',
                      valueColor: Colors.green.shade700),
                  _InfoRow(
                      label: 'Overdue',
                      value: 'PKR ${item.overdue ?? 'N/A'}',
                      valueColor: Colors.red.shade700),
                  _InfoRow(
                      label: 'Remaining',
                      value: 'PKR ${item.remaining ?? 'N/A'}',
                      valueColor: Colors.orange.shade800),

                  SizedBox(height: 2.5.h),

                  // ── Statement Button ──────────────────────────────
                  _StatementButton(
                      pdfUrl: item.statementPdfLink ?? ''),
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
// Summary Table (like image 2)
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
          // Header row
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
                _TH('MS No', flex: 2),
                _TH('Plot No', flex: 2),
                _TH('Size', flex: 2),
                _TH('Sector', flex: 2),
              ],
            ),
          ),
          // Data row
          Container(
            color: AppColors.primary.withOpacity(0.04),
            child: Row(
              children: [
                _TD('1', flex: 1),
                _TD(item.plotNoo ?? 'N/A', flex: 2),
                _TD(item.plotDetailAddress ?? 'N/A', flex: 2),
                _TD(item.plotSize ?? 'N/A', flex: 2),
                _TD(item.sectorName ?? 'N/A', flex: 2),
              ],
            ),
          ),
          // Financial row headers
          Container(
            color: AppColors.golden.withOpacity(0.12),
            child: Row(
              children: [
                _TH('Total', flex: 3, color: AppColors.darkBrown),
                _TH('Paid', flex: 3, color: Colors.green.shade700),
                _TH('Overdue', flex: 3, color: Colors.red.shade700),
                _TH('Remaining', flex: 3, color: Colors.orange.shade800),
              ],
            ),
          ),
          // Financial values
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
                _TD(item.totalAmount ?? 'N/A',
                    flex: 3, color: AppColors.darkBrown),
                _TD(item.paid ?? 'N/A',
                    flex: 3, color: Colors.green.shade700),
                _TD(item.overdue ?? 'N/A',
                    flex: 3, color: Colors.red.shade700),
                _TD(item.remaining ?? 'N/A',
                    flex: 3, color: Colors.orange.shade800),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _TH(String text,
    {required int flex, Color color = Colors.white}) {
  return Expanded(
    flex: flex,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: CustomText(
      text:   text,
        align: TextAlign.center,
        style: basicColorBold(14, color)
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
        text:text,
        align: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: basicColor(14,color ?? AppColors.darkBrown, )
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
              text:'$label :',
              style: basicColorBold(14, AppColors.brown)
            ),
          ),
          Expanded(
            child: CustomText(
             text: value,
              style:valueColor != null? basicColorBold(14,  valueColor ?? AppColors.darkBrown):basicColor(14,  valueColor ?? AppColors.darkBrown)

            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Statement Button — downloads PDF
// ─────────────────────────────────────────────────────────────────────────────
class _StatementButton extends StatefulWidget {
  final String pdfUrl;
  const _StatementButton({required this.pdfUrl});

  @override
  State<_StatementButton> createState() => _StatementButtonState();
}

class _StatementButtonState extends State<_StatementButton> {
  bool _downloading = false;

  Future<void> _downloadPdf() async {
    if (widget.pdfUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No statement link available')),
      );
      return;
    }

    setState(() => _downloading = true);

    try {
      // Request storage permission (Android)
      if (await Permission.storage.isDenied) {
        await Permission.storage.request();
      }

      final dir = await getApplicationDocumentsDirectory();
      final fileName =
          'statement_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final savePath = '${dir.path}/$fileName';

      final dio = Dio();
      await dio.download(
        widget.pdfUrl,
        savePath,
        onReceiveProgress: (received, total) {},
      );

      // Open the PDF
      await OpenFilex.open(savePath);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _downloading ? null : _downloadPdf,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 1.6.h),
        decoration: BoxDecoration(
          color: _downloading
              ? AppColors.primary.withOpacity(0.5)
              : AppColors.primary,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_downloading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    color: AppColors.primary, strokeWidth: 2),
              )
            else
              const Icon(Icons.download_rounded,
                  color:Colors.white, size: 18),
            SizedBox(width: 2.w),
            CustomText(
            text:  _downloading ? 'Downloading...' : 'Statement',
              style: basicColorBold(15, Colors.white)
            ),
          ],
        ),
      ),
    );
  }
}