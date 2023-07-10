import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class PdfViewPage {
  static Future generateTransactionPDf({required String qr, required List list}) async {
    final pdf = pw.Document();
    var appLogo = pw.MemoryImage(
      (await NetworkAssetBundle(Uri.parse(qr))
              .load(qr))
          .buffer
          .asUint8List()
          .buffer
          .asUint8List(),
    );

    pdf.addPage(
      pw.MultiPage(
        margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        build: (context) => [
          pw.GridView(
              crossAxisCount: 5,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              children: list
                  .map((e) => pw.Container(
                      width: 25.4,
                      height: 25.4,
                      child: pw.Row(children: [
                        pw.Container(
                          width: 96,
                          height: 96,
                          child: pw.Image(appLogo,fit: pw.BoxFit.cover),
                          color: PdfColors.yellow,
                        )
                      ])))
                  .toList())
        ],
      ),
    );

    if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      final File file = File('${dir.path}/Qr_${list.length}.pdf');
      await file.writeAsBytes(await pdf.save());
      await OpenFile.open("${dir.path}/Qr_${list.length}.pdf");
    }

    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        status = await Permission.storage.request();
      }
      if (status.isGranted) {
        final Directory dir = await getApplicationDocumentsDirectory();
        final File file = File("${dir.path}/Qr_${list.length}.pdf");
        await file.writeAsBytes(await pdf.save());
        await OpenFile.open("${dir.path}/Qr_${list.length}.pdf");
      }
    }
  }
}
