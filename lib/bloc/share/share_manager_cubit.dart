import 'dart:convert';

import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/information_strings.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';


part 'share_manager_state.dart';

class ShareManagerCubit extends Cubit<ShareManagerState> {
  ShareManagerCubit() : super(const ShareManagerInitial());

  Future<void> getFinalPdf({
    required String title,
    required String trashType,
    required String social,
  }) async {
    final pdf = pw.Document();

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

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Column(
              children: [
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
          ];
        },
      ),
    );

    List<int> bytes = await pdf.save();
    String base64 = base64Encode(bytes);
    if(social == "facebook") {
      html.window.parent!.postMessage({'facebook': base64}, '*');
    } else if (social == "messenger") {
      html.window.parent!.postMessage({'messenger': base64}, '*');
    } else if (social == "linkedin") {
      html.window.parent!.postMessage({'linkedin': base64}, '*');
    } else if (social == "email") {
      html.window.parent!.postMessage({'email': base64}, '*');
    } else {
      html.window.parent!.postMessage({'others': base64}, '*');
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
  }) async {
    final pdf = pw.Document();

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

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
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
            pw.SizedBox(height: 20),
            pw.Text(
              'Sąlyga/atliekos apibūdinimas',
              style: pw.TextStyle(
                font: font,
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),
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
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
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
                      pw.Column(
                        children: [
                          pw.SizedBox(
                            width: 300,
                            child: pw.Text(
                              howToRecycle[i],
                              style: pw.TextStyle(
                                font: font,
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 10),
                        ],
                      ),
                  ],
                ),
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
                      pw.Column(
                        children: [
                          pw.SizedBox(
                            width: 300,
                            child: pw.Text(
                              giveAway[i],
                              style: pw.TextStyle(font: font),
                            ),
                          ),
                          pw.SizedBox(height: 10),
                        ],
                      ),
                  ],
                ),
              ],
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
              pw.Column(
                children: [
                  pw.SizedBox(
                    width: 300,
                    child: pw.Text(
                      info[i],
                      style: pw.TextStyle(
                        font: font,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 10),
                ],
              ),
          ];
        },
      ),
    );

    List<int> bytes = await pdf.save();
    String base64 = base64Encode(bytes);
    if(social == "facebook") {
      html.window.parent!.postMessage({'facebook': base64}, '*');
    } else if (social == "messenger") {
      html.window.parent!.postMessage({'messenger': base64}, '*');
    } else if (social == "linkedin") {
      html.window.parent!.postMessage({'linkedin': base64}, '*');
    } else if (social == "email") {
      html.window.parent!.postMessage({'email': base64}, '*');
    } else {
      html.window.parent!.postMessage({'others': base64}, '*');
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

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
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
                                          : attentionMark,
                                      width: 40,
                                      height: 40,
                                    ),
                                    pw.Expanded(
                                      child: pw.Padding(
                                        padding:
                                            const pw.EdgeInsets.only(top: 10),
                                        child: trashType == 'AN'
                                            ? pw.SizedBox(
                                                child: pw.Text(
                                                  '$trashType - ši atlieka yra absoliučiai nepavojinga',
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
                                                  '$trashType - ši atlieka yra absoliučiai pavojinga',
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
                                    _buildCodeWindow(codePart: '', font: font),
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
          ];
        },
      ),
    );

    List<int> bytes = await pdf.save();
    String base64 = base64Encode(bytes);
    if(social == "facebook") {
      html.window.parent!.postMessage({'facebook': base64}, '*');
    } else if (social == "messenger") {
      html.window.parent!.postMessage({'messenger': base64}, '*');
    } else if (social == "linkedin") {
      html.window.parent!.postMessage({'linkedin': base64}, '*');
    } else if (social == "email") {
      html.window.parent!.postMessage({'email': base64}, '*');
    } else {
      html.window.parent!.postMessage({'others': base64}, '*');
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
