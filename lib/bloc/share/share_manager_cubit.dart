import 'dart:convert';
import 'dart:html';

import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/font_family.dart';
import 'package:aplinkos_ministerija/constants/information_strings.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';

part 'share_manager_state.dart';

class ShareManagerCubit extends Cubit<ShareManagerState> {
  ShareManagerCubit() : super(const ShareManagerInitial());

  Future<void> getFinalPdf({
    required String title,
    required String trashType,
  }) async {
    final pdf = pw.Document();

    //fonts

    final font = pw.Font.ttf((await rootBundle
            .load('fonts/founders_grotesk/FoundersGrotesk-Regular.ttf'))
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
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "${title}_$trashType.pdf")
      ..click();
  }

  Future<void> getPdf({
    required String title,
    required String trashType,
    required String code,
  }) async {
    final pdf = pw.Document();

    //fonts

    final font = pw.Font.ttf((await rootBundle
            .load('fonts/founders_grotesk/FoundersGrotesk-Regular.ttf'))
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
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "${title}_$trashType.pdf")
      ..click();
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
                '*',
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
