import 'dart:convert';

import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/images.dart';
import 'package:aplinkos_ministerija/constants/information_strings.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'dart:html' as html;

part 'share_manager_state.dart';

class ShareManagerCubit extends Cubit<ShareManagerState> {
  ShareManagerCubit() : super(const ShareManagerInitial());

  Future<void> getFinalPdf({
    required String title,
    required String trashType,
    required String social,
  }) async {
    final pdf = pw.Document();

    String url = Uri.base.origin.toString();

    //fonts

    final font = pw.Font.ttf((await rootBundle
            .load('assets/fonts/founders_grotesk/FoundersGrotesk-Regular.ttf'))
        .buffer
        .asByteData());

    //images
    final approvedMark = pw.MemoryImage(
        (await rootBundle.load(Strings.approved_mark)).buffer.asUint8List());
    final attentionMark = pw.MemoryImage(
        (await rootBundle.load(Strings.red_exclemation_mark))
            .buffer
            .asUint8List());
    final amLogo = pw.MemoryImage(
        (await rootBundle.load(Strings.am_logo)).buffer.asUint8List());
    final norwayLogo = pw.MemoryImage(
        (await rootBundle.load(Strings.norway_logo)).buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Column(
              children: [
                pw.SizedBox(height: 40),
                pw.SizedBox(
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Expanded(
                        child: pw.Container(
                          padding: const pw.EdgeInsets.all(20),
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromInt(
                                AppColors.greenBtnUnHoover.value),
                            boxShadow: [
                              pw.BoxShadow(
                                color: PdfColor.fromInt(
                                    AppColors.black.withOpacity(0.09).value),
                                offset: const PdfPoint(0, 4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: pw.Text(
                            title,
                            style: pw.TextStyle(
                              fontSize: 15,
                              fontWeight: pw.FontWeight.bold,
                              font: font,
                              color: PdfColor.fromInt(
                                  AppColors.scaffoldColor.value),
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 10),
                      pw.Expanded(
                        child: pw.Container(
                          child: pw.Column(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Image(
                                      trashType == 'AN'
                                          ? approvedMark
                                          : attentionMark,
                                      width: 40,
                                      height: 40,
                                    ),
                                    pw.SizedBox(width: 10),
                                    pw.Expanded(
                                      child: trashType == 'AN'
                                          ? pw.SizedBox(
                                              child: pw.Text(
                                                'ši atlieka yra nepavojinga',
                                                style: pw.TextStyle(
                                                  font: font,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                  fontSize: 13,
                                                  color: PdfColor.fromInt(
                                                      AppColors.black.value),
                                                ),
                                              ),
                                            )
                                          : pw.SizedBox(
                                              child: pw.Text(
                                                'ši atlieka yra pavojinga',
                                                style: pw.TextStyle(
                                                  font: font,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                  fontSize: 13,
                                                  color: PdfColor.fromInt(
                                                      AppColors.black.value),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      children: [
                        _buildTitle(
                          text: 'Kaip rūšiuoti?',
                          style: pw.TextStyle(
                            font: font,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 21,
                            color: PdfColor.fromInt(AppColors.orange.value),
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        _buildText(
                            text: InformationStrings.howToRecycle, font: font),
                        pw.SizedBox(height: 20),
                        _buildTitle(
                          text: 'Kam atiduoti?',
                          style: pw.TextStyle(
                            font: font,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 21,
                            color: PdfColor.fromInt(
                                AppColors.greenBtnUnHoover.value),
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        _buildText(
                            text: InformationStrings.whoToGiveAway[0],
                            font: font),
                        _buildText(
                            text: InformationStrings.whoToGiveAway[1],
                            font: font),
                      ],
                    ),
                    pw.Column(
                      children: [
                        _buildTitle(
                          text: 'Kaip laikyti?',
                          style: pw.TextStyle(
                            font: font,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 21,
                            color: PdfColor.fromInt(AppColors.orange.value),
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        _buildText(
                            text: InformationStrings.howToStore[0], font: font),
                        _buildText(
                            text: InformationStrings.howToStore[1], font: font),
                        _buildText(
                            text: InformationStrings.howToStore[2], font: font),
                        pw.SizedBox(height: 20),
                        _buildTitle(
                          text: 'Reikia konsultacijos?',
                          style: pw.TextStyle(
                            font: font,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 21,
                            color: PdfColor.fromInt(
                                AppColors.greenBtnUnHoover.value),
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        _buildText(
                            text: InformationStrings.helpString, font: font)
                      ],
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.UrlLink(
                  destination: url,
                  child: pw.Text('Failas eksportuotas iš: $url',
                      style: pw.TextStyle(
                        font: font,
                        decoration: pw.TextDecoration.underline,
                        color: PdfColor.fromInt(Colors.blue.value),
                      )),
                )
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.SizedBox(
                      width: 250,
                      child: pw.Text(
                        'Pavojingųjų atliekų identifikavimo ir klasifikavimo e. įrankis sukurtas projekto "Haz-ident", finansuoto Norvegijos finansinio mechanizmo programos "Aplinkosauga, energija ir klimato kaita", lėšomis.',
                        style: pw.TextStyle(font: font),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Image(
                      norwayLogo,
                      width: 80,
                      height: 80,
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.SizedBox(
                      width: 250,
                      child: pw.Text(
                        'Autorinės teisės priklauso Aplinkos ministerijai.',
                        style: pw.TextStyle(font: font),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Image(
                      amLogo,
                      width: 80,
                      height: 80,
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    List<int> bytes = await pdf.save();
    String base64 = base64Encode(bytes);
    if (social == "facebook") {
      html.window.parent!.postMessage({'facebook': base64, 'desc': title}, '*');
    } else if (social == "messenger") {
      html.window.parent!
          .postMessage({'messenger': base64, 'desc': title}, '*');
    } else if (social == "linkedin") {
      html.window.parent!.postMessage({'linkedin': base64, 'desc': title}, '*');
    } else if (social == "email") {
      html.window.parent!.postMessage({'email': base64, 'desc': title}, '*');
    } else {
      html.window.parent!.postMessage({'others': base64, 'desc': title}, '*');
    }

    // html.AnchorElement(
    //     href:
    //         "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
    //   ..setAttribute("download", "${title}_$trashType.pdf")
    //   ..click();
  }

  Future<void> saveResident({
    required List<String> howToRecycle,
    required List<String> info,
    required List<String> giveAway,
    required String title,
    required bool isDangerous,
    required String social,
    int? level,
  }) async {
    final pdf = pw.Document();

    String url = Uri.base.origin.toString();

    List<String> imagesNew = [];
    List<String> imagesOld = [];
    List<String> namesNew = [];
    List<String> namesOld = [];
    List<dynamic> convertedNewImages = [];
    List<dynamic> convertedOldImages = [];

    level = null;

    // if (level != null) {
    //   if (level == 1) {
    //     imagesNew = SymbolImages.level1New;
    //     imagesOld = SymbolImages.level1Old;
    //     namesNew = SymbolImages.level1NewDescriptions;
    //     namesOld = SymbolImages.level1OldDescriptions;
    //   } else if (level == 2) {
    //     imagesNew = SymbolImages.level2New;
    //     imagesOld = SymbolImages.level2Old;
    //     namesNew = SymbolImages.level2NewDescriptions;
    //     namesOld = SymbolImages.level2OldDescription;
    //   }
    //   for (var i = 0; i < imagesNew.length; i++) {
    //     var convertedImage = pw.MemoryImage(
    //         (await rootBundle.load(imagesNew[i])).buffer.asUint8List());
    //     convertedNewImages.add(convertedImage);
    //   }
    //   for (var i = 0; i < imagesOld.length; i++) {
    //     var convertedImage = pw.MemoryImage(
    //         (await rootBundle.load(imagesOld[i])).buffer.asUint8List());
    //     convertedOldImages.add(convertedImage);
    //   }
    // }

    //fonts

    final font = pw.Font.ttf((await rootBundle
            .load('assets/fonts/founders_grotesk/FoundersGrotesk-Regular.ttf'))
        .buffer
        .asByteData());

    //images
    final approvedMark = pw.MemoryImage(
        (await rootBundle.load(Strings.approved_mark)).buffer.asUint8List());
    final attentionMark = pw.MemoryImage(
        (await rootBundle.load(Strings.red_exclemation_mark))
            .buffer
            .asUint8List());
    final amLogo = pw.MemoryImage(
        (await rootBundle.load(Strings.am_logo)).buffer.asUint8List());
    final norwayLogo = pw.MemoryImage(
        (await rootBundle.load(Strings.norway_logo)).buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        // pageFormat: PdfPageFormat.a3.landscape,
        build: (pw.Context context) {
          return [
            pw.Text(
              title,
              style: pw.TextStyle(
                font: font,
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromInt(AppColors.greenBtnHoover.value),
              ),
            ),
            pw.Row(
              children: [
                pw.Image(
                  isDangerous ? attentionMark : approvedMark,
                  width: 24,
                  height: 24,
                ),
                pw.SizedBox(width: 5),
                pw.Text(
                  isDangerous
                      ? 'Atkreipkite dėmesį, šios atliekos tvarkomos kaip pavojingos.'
                      : 'Šios atliekos tvarkomos įprastine tvarka.',
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                pw.Wrap(
                  direction: pw.Axis.vertical,
                  children: [
                    pw.Text(
                      'Kaip rūšiuot?',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(AppColors.orange.value),
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    for (var i = 0; i < howToRecycle.length; i++)
                      pw.SizedBox(
                        width: 250,
                        child: pw.Text(
                          howToRecycle[i],
                          style: pw.TextStyle(
                            font: font,
                          ),
                        ),
                      ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Papildoma informacija:',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(AppColors.blue.value),
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    for (var i = 0; i < info.length; i++)
                      pw.SizedBox(
                        width: 250,
                        child: pw.Text(
                          info[i],
                          style: pw.TextStyle(
                            font: font,
                          ),
                        ),
                      ),
                  ],
                ),
                pw.SizedBox(width: 10),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Kur atiduoti?',
                      style: pw.TextStyle(
                          font: font,
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromInt(
                              AppColors.greenBtnUnHoover.value)),
                    ),
                    pw.SizedBox(height: 10),
                    for (var i = 0; i < giveAway.length; i++)
                      pw.SizedBox(
                        width: 200,
                        child: pw.Text(
                          giveAway[i],
                          style: pw.TextStyle(font: font),
                        ),
                      ),
                    pw.SizedBox(height: 20),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.UrlLink(
                          destination: url,
                          child: pw.Text('Failas eksportuotas iš: $url',
                              style: pw.TextStyle(
                                font: font,
                                decoration: pw.TextDecoration.underline,
                                color: PdfColor.fromInt(Colors.blue.value),
                              )),
                        )
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Image(
                              norwayLogo,
                              width: 60,
                              height: 60,
                            ),
                            pw.SizedBox(width: 10),
                            pw.SizedBox(
                              width: 200,
                              child: pw.Text(
                                'Pavojingųjų atliekų identifikavimo ir klasifikavimo e. įrankis sukurtas projekto "Haz-ident", finansuoto Norvegijos finansinio mechanizmo programos "Aplinkosauga, energija ir klimato kaita", lėšomis.',
                                style: pw.TextStyle(font: font),
                                textAlign: pw.TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 20),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Image(
                              amLogo,
                              width: 60,
                              height: 60,
                            ),
                            pw.SizedBox(width: 10),
                            pw.SizedBox(
                              width: 200,
                              child: pw.Text(
                                'Autorinės teisės priklauso Aplinkos ministerijai.',
                                style: pw.TextStyle(font: font),
                                textAlign: pw.TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            level != null
                ? pw.Wrap(
                    children: [
                      for (var i = 0; i < convertedNewImages.length; i++)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(right: 10),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Image(
                                convertedNewImages[i],
                                width: 60,
                                height: 60,
                              ),
                              pw.SizedBox(height: 10),
                              pw.Text(
                                namesNew[i],
                                style: pw.TextStyle(font: font),
                                textAlign: pw.TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      pw.SizedBox(height: 20),
                      pw.Text(
                        'Jei atliekomis tapę produktai pagaminti anksčiau nei 2015 m., ant gaminio pakuotės galite rasti ir tokius pavojingumą nusakančius simbolius:',
                        style: pw.TextStyle(font: font),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(height: 20),
                      for (var i = 0; i < convertedOldImages.length; i++)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(right: 10),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Image(
                                convertedOldImages[i],
                                width: 60,
                                height: 60,
                              ),
                              pw.SizedBox(height: 10),
                              pw.Text(
                                namesOld[i],
                                style: pw.TextStyle(font: font),
                                textAlign: pw.TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                    ],
                  )
                : pw.SizedBox(),
          ];
        },
      ),
    );

    List<int> bytes = await pdf.save();
    String base64 = base64Encode(bytes);
    if (social == "facebook") {
      html.window.parent!.postMessage({'facebook': base64, 'desc': title}, '*');
    } else if (social == "messenger") {
      html.window.parent!.postMessage({'messenger': base64, 'desc': title}, '*');
    } else if (social == "linkedin") {
      html.window.parent!.postMessage({'linkedin': base64, 'desc': title}, '*');
    } else if (social == "email") {
      html.window.parent!.postMessage({'email': base64, 'desc': title}, '*');
    } else {
      html.window.parent!.postMessage({'others': base64, 'desc': title}, '*');
    }

    // html.AnchorElement(
    //     href:
    //         "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
    //   ..setAttribute("download", "Gyventojai_$title.pdf")
    //   ..click();
  }

  Future<void> getPdf({
    required String title,
    required String trashType,
    required String code,
    required String social,
  }) async {
    final pdf = pw.Document();

    String url = Uri.base.origin.toString();

    //fonts

    final font = pw.Font.ttf((await rootBundle
            .load('assets/fonts/founders_grotesk/FoundersGrotesk-Regular.ttf'))
        .buffer
        .asByteData());

    //images
    final approvedMark = pw.MemoryImage(
        (await rootBundle.load(Strings.approved_mark)).buffer.asUint8List());
    final attentionMark = pw.MemoryImage(
        (await rootBundle.load(Strings.red_exclemation_mark))
            .buffer
            .asUint8List());
    final questionMark = pw.MemoryImage(
        (await rootBundle.load(Strings.question_mark)).buffer.asUint8List());
    final amLogo = pw.MemoryImage(
        (await rootBundle.load(Strings.am_logo)).buffer.asUint8List());
    final norwayLogo = pw.MemoryImage(
        (await rootBundle.load(Strings.norway_logo)).buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.SizedBox(height: 40),
            pw.Column(
              children: [
                pw.SizedBox(
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        child: pw.Container(
                          padding: const pw.EdgeInsets.all(20),
                          decoration: pw.BoxDecoration(
                            color: PdfColor.fromInt(
                                AppColors.greenBtnUnHoover.value),
                            boxShadow: [
                              pw.BoxShadow(
                                color: PdfColor.fromInt(
                                    AppColors.black.withOpacity(0.09).value),
                                offset: const PdfPoint(0, 4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: pw.Text(
                            title,
                            style: pw.TextStyle(
                              fontSize: 15,
                              fontWeight: pw.FontWeight.bold,
                              font: font,
                              color: PdfColor.fromInt(
                                  AppColors.scaffoldColor.value),
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 10),
                      pw.Expanded(
                        child: pw.Container(
                          child: pw.Column(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Image(
                                      trashType == 'AN'
                                          ? approvedMark
                                          : trashType == 'VP'
                                              ? questionMark
                                              : trashType == 'VN'
                                                  ? questionMark
                                                  : attentionMark,
                                      width: 40,
                                      height: 40,
                                    ),
                                    pw.Expanded(
                                      child: pw.Padding(
                                        padding:
                                            const pw.EdgeInsets.only(top: 10),
                                        child: pw.SizedBox(
                                          child: pw.Text(
                                            trashType == 'AN'
                                                ? '$trashType - ši atlieka yra absoliučiai nepavojinga'
                                                : trashType == 'AP'
                                                    ? '$trashType - ši atlieka yra absoliučiai pavojinga'
                                                    : trashType == 'VP'
                                                        ? '$trashType - ši atlieka yra pavojinga'
                                                        : '$trashType - ši atlieka yra nepavojinga',
                                            style: pw.TextStyle(
                                              font: font,
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 13,
                                              color: PdfColor.fromInt(
                                                  AppColors.black.value),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                pw.SizedBox(height: 10),
                                pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    _buildCodeWindow(
                                        codePart: code.split(' ')[0],
                                        font: font),
                                    _buildCodeWindow(
                                        codePart: code.split(' ')[1],
                                        font: font),
                                    _buildCodeWindow(
                                        codePart:
                                            code.split(' ')[2].split('*')[0],
                                        font: font),
                                    _buildCodeWindow(
                                        codePart: code.split(' ').length > 3
                                            ? code
                                                .split(' ')[3]
                                                .replaceAll('*', '')
                                            : '',
                                        font: font),
                                    _buildCodeWindow(
                                        codePart: code.contains('*') ? '*' : '',
                                        font: font),
                                    pw.Expanded(
                                      child: pw.Text(
                                        '- atliekos kodas',
                                        style: pw.TextStyle(
                                          font: font,
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 13,
                                          color: PdfColor.fromInt(
                                              AppColors.black.value),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      children: [
                        _buildTitle(
                          text: 'Kaip rūšiuoti?',
                          style: pw.TextStyle(
                            font: font,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 21,
                            color: PdfColor.fromInt(AppColors.orange.value),
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        _buildText(
                            text: InformationStrings.howToRecycle, font: font),
                        pw.SizedBox(height: 20),
                        _buildTitle(
                          text: 'Kam atiduoti?',
                          style: pw.TextStyle(
                            font: font,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 21,
                            color: PdfColor.fromInt(
                                AppColors.greenBtnUnHoover.value),
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        _buildText(
                            text: InformationStrings.whoToGiveAway[0],
                            font: font),
                        _buildText(
                            text: InformationStrings.whoToGiveAway[1],
                            font: font),
                      ],
                    ),
                    pw.Column(
                      children: [
                        _buildTitle(
                          text: 'Kaip laikyti?',
                          style: pw.TextStyle(
                            font: font,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 21,
                            color: PdfColor.fromInt(AppColors.orange.value),
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        _buildText(
                            text: InformationStrings.howToStore[0], font: font),
                        _buildText(
                            text: InformationStrings.howToStore[1], font: font),
                        _buildText(
                            text: InformationStrings.howToStore[2], font: font),
                        pw.SizedBox(height: 20),
                        _buildTitle(
                          text: 'Reikia konsultacijos?',
                          style: pw.TextStyle(
                            font: font,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 21,
                            color: PdfColor.fromInt(
                                AppColors.greenBtnUnHoover.value),
                          ),
                        ),
                        pw.SizedBox(height: 10),
                        _buildText(
                            text: InformationStrings.helpString, font: font)
                      ],
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.UrlLink(
                  destination: url,
                  child: pw.Text('Failas eksportuotas iš: $url',
                      style: pw.TextStyle(
                        font: font,
                        decoration: pw.TextDecoration.underline,
                        color: PdfColor.fromInt(Colors.blue.value),
                      )),
                )
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.SizedBox(
                      width: 250,
                      child: pw.Text(
                        'Pavojingųjų atliekų identifikavimo ir klasifikavimo e. įrankis sukurtas projekto "Haz-ident", finansuoto Norvegijos finansinio mechanizmo programos "Aplinkosauga, energija ir klimato kaita", lėšomis.',
                        style: pw.TextStyle(font: font),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Image(
                      norwayLogo,
                      width: 80,
                      height: 80,
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.SizedBox(
                      width: 250,
                      child: pw.Text(
                        'Autorinės teisės priklauso Aplinkos ministerijai.',
                        style: pw.TextStyle(font: font),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Image(
                      amLogo,
                      width: 80,
                      height: 80,
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    List<int> bytes = await pdf.save();
    String base64 = base64Encode(bytes);
    if (social == "facebook") {
      html.window.parent!.postMessage({'facebook': base64, 'desc': title}, '*');
    } else if (social == "messenger") {
      html.window.parent!
          .postMessage({'messenger': base64, 'desc': title}, '*');
    } else if (social == "linkedin") {
      html.window.parent!.postMessage({'linkedin': base64, 'desc': title}, '*');
    } else if (social == "email") {
      html.window.parent!.postMessage({'email': base64, 'desc': title}, '*');
    } else {
      html.window.parent!.postMessage({'others': base64, 'desc': title}, '*');
    }

    // html.AnchorElement(
    //     href:
    //         "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
    //   ..setAttribute("download", "${title}_$trashType.pdf")
    //   ..click();
  }

  _buildTitle({
    required String text,
    required pw.TextStyle style,
  }) {
    return pw.SizedBox(
      width: 200,
      child: pw.Text(text.toCapitalized(),
          style: style, textAlign: pw.TextAlign.center),
    );
  }

  _buildText({
    required String text,
    required pw.Font font,
  }) {
    return pw.SizedBox(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '•',
                style: pw.TextStyle(
                  font: font,
                  fontSize: 12,
                ),
              ),
              pw.SizedBox(
                width: 240,
                child: pw.Text(
                  text,
                  style: pw.TextStyle(
                    font: font,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
        ],
      ),
    );
  }

  _buildCodeWindow({
    required String codePart,
    required pw.Font font,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(right: 5),
      child: pw.Container(
        height: 16,
        width: 16,
        decoration: pw.BoxDecoration(
          color: PdfColor.fromInt(AppColors.scaffoldColor.value),
          border: pw.Border.all(),
        ),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 5),
              child: pw.Text(
                codePart,
                style: pw.TextStyle(
                  font: font,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                  color: PdfColor.fromInt(AppColors.black.value),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
