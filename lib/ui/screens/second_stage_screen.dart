import 'package:aplinkos_ministerija/bloc/how_to_use/how_to_use_bloc.dart';
import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:aplinkos_ministerija/constants/images.dart';
import 'package:aplinkos_ministerija/model/second_stage_models/second_category.dart';
import 'package:aplinkos_ministerija/model/sub_categories.dart';
import 'package:aplinkos_ministerija/ui/widgets/button.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../../constants/strings.dart';
import '../../model/category.dart';
import '../../model/items.dart';
import '../../model/second_stage_models/questions.dart';
import '../styles/app_style.dart';
import '../styles/text_styles.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';
import '../widgets/back_btn.dart';
import '../widgets/how_to_use_tool.dart';
import '../widgets/not_found.dart';
import 'dart:html' as html;

class SecondStageScreen extends StatefulWidget {
  final FirstStageBloc firstStageBloc;

  final List<Category> listOfCategories;
  final HowToUseBloc howToUseBloc;
  final RouteControllerBloc routeControllerBloc;

  const SecondStageScreen({
    super.key,
    required this.firstStageBloc,
    required this.listOfCategories,
    required this.howToUseBloc,
    required this.routeControllerBloc,
  });

  @override
  State<SecondStageScreen> createState() => _SecondStageScreenState();
}

class _SecondStageScreenState extends State<SecondStageScreen> {
  late AccessibilityControllerState _state;
  OverlayEntry? overlay;
  bool backHover = false;
  bool frontHover = false;
  bool isLastQuestionPassed = false;
  int index = 0;
  bool isQuestionsHidden = false;
  List<Items> trashList = [];
  List<String> otherList = [];
  Items? specificTrash;
  int reformedQuestionListIndex = 0;
  List<Items> importantTrashList = [];

  @override
  void initState() {
    super.initState();
    _state = BlocProvider.of<AccessibilityControllerCubit>(context).state;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccessibilityControllerCubit,
        AccessibilityControllerState>(
      listener: (context, state) {
        _state = state;
        setState(() {});
      },
      child: BlocBuilder<FirstStageBloc, FirstStageState>(
        builder: (context, state) {
          if (state is SecondStageOpenState) {
            return SingleChildScrollView(
              child: isLastQuestionPassed
                  ? Column(
                      children: [
                        _buildTitle(state.category.title!),
                        const SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              BackButtonWidget(
                                firstStageBloc: widget.firstStageBloc,
                                routeControllerBloc: widget.routeControllerBloc,
                                customBackFunction: trashList.isNotEmpty ||
                                        otherList.isNotEmpty
                                    ? () {
                                        trashList.clear();
                                        otherList.clear();
                                        importantTrashList.clear();
                                        setState(() {});
                                        html.window.parent!
                                            .postMessage({'goUp': true}, '*');
                                      }
                                    : index != 0
                                        ? () {
                                            index--;
                                            if (importantTrashList.isNotEmpty) {
                                              importantTrashList.clear();
                                            }
                                            setState(() {});
                                            html.window.parent!.postMessage(
                                                {'goUp': true}, '*');
                                          }
                                        : null,
                              ),
                            ],
                          ),
                        ),
                        trashList.isNotEmpty || importantTrashList.isNotEmpty
                            ? Column(
                                children: [
                                  _buildFinishContent(state.trashTitle,
                                      state.trashCode, state.trashType),
                                  (MediaQuery.of(context).size.width > 768)
                                      ? _buildInfoRow(state)
                                      : _buildMobileInfoRow(state),
                                  const SizedBox(height: 20),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    )
                  : Column(
                      children: [
                        _buildTitle(state.category.title!),
                        const SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              BackButtonWidget(
                                firstStageBloc: widget.firstStageBloc,
                                routeControllerBloc: widget.routeControllerBloc,
                                customBackFunction: trashList.isNotEmpty ||
                                        otherList.isNotEmpty
                                    ? () {
                                        trashList.clear();
                                        otherList.clear();
                                        importantTrashList.clear();
                                        setState(() {});
                                        html.window.parent!
                                            .postMessage({'goUp': true}, '*');
                                      }
                                    : index != 0
                                        ? () {
                                            index--;
                                            if (importantTrashList.isNotEmpty) {
                                              importantTrashList.clear();
                                            }
                                            setState(() {});
                                            html.window.parent!.postMessage(
                                                {'goUp': true}, '*');
                                          }
                                        : null,
                              ),
                            ],
                          ),
                        ),
                        trashList.isEmpty && otherList.isEmpty
                            ? Column(
                                children: [
                                  _buildQuestionCounter(
                                      state.category.questionsList!,
                                      state.category),
                                  _buildQuestion(state.category.questionsList!),
                                  (MediaQuery.of(context).size.width > 768)
                                      ? _buildButtons(
                                          state.category,
                                          state.trashCode,
                                          state.trashTitle,
                                          state.trashType)
                                      : _buildMobileButtons(
                                          state.category,
                                          state.trashCode,
                                          state.trashTitle,
                                          state.trashType),
                                ],
                              )
                            : const SizedBox(height: 10),
                        trashList.isNotEmpty || importantTrashList.isNotEmpty
                            ? Column(
                                children: [
                                  (index == 3 && state.category.id == 0)
                                      ? Column(
                                          children: [
                                            _buildRecomendations(
                                                index, state.category.id!),
                                            const SizedBox(height: 20),
                                          ],
                                        )
                                      : const SizedBox(),
                                  (MediaQuery.of(context).size.width > 768)
                                      ? _buildInfoRow(state)
                                      : _buildMobileInfoRow(state),
                                  const SizedBox(height: 20),
                                ],
                              )
                            : otherList.isNotEmpty
                                ? (MediaQuery.of(context).size.width > 768)
                                    ? _buildInfoRow(state)
                                    : _buildMobileInfoRow(state)
                                : (index == 0 && state.category.id == 0 ||
                                        index == 2 && state.category.id == 0)
                                    ? Column(
                                        children: [
                                          _buildRecomendations(
                                              index, state.category.id!),
                                          const SizedBox(height: 20),
                                        ],
                                      )
                                    : const SizedBox(),
                      ],
                    ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: AppStyle.blue,
                )
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildRecomendations(int index, int categoryId) {
    return SelectionArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width > 768) ? 50 : 25,
        ),
        child: Container(
          decoration: (index == 2 && categoryId == 0)
              ? BoxDecoration(
                  color: AppStyle.scaffoldColor,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(),
                )
              : BoxDecoration(
                  color: AppStyle.appBarWebColor,
                  borderRadius: BorderRadius.circular(7),
                ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 50,
            ),
            child: Column(
              crossAxisAlignment: (MediaQuery.of(context).size.width > 768)
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                (index == 3 && categoryId == 0)
                    ? _buildRecomendationTitle('Paaiškinimas')
                    : (index == 2 && categoryId == 0)
                        ? _buildRecomendationTitle('Pavojingumo ženklai')
                        : _buildRecomendationTitle('Kaip atlikti vertinimą?'),
                const SizedBox(height: 20),
                (index == 3 && categoryId == 0)
                    ? _buildDotText(
                        'Nepavojingosios pakuočių atliekos, klasifikuojamos pagal medžiagą, iš kurios yra pagaminta pakuotė.')
                    : (index == 2 && categoryId == 0)
                        ? _buildImages(
                            images: _state.blindness ==
                                    AccessibilityControllerBlindness.blind
                                ? SymbolImages.othersMonochrome
                                : SymbolImages.othersNew,
                            names: SymbolImages.othersDescription,
                          )
                        : _buildDotText(
                            'Praktiškai tuščia pakuotė yra tinkamai ištuštinta (be tokių likučių, kaip milteliai, nuosėdos ir lašai; pakuotė išvalyta šepečiu ar mentele), išskyrus neišvengiamus likučius, kurių negalima pašalinti netaikant papildomų pakuotės valymo priemonių, tokių kaip šildymas (toliau – praktiškai tuščia pakuotė). Iš praktiškai tuščios pakuotės, vėl bandant ją tuštinti, pavyzdžiui, pakuotę apvertus, turi niekas nelašėti ir nekristi kieti medžiagų likučiai. Tai netaikoma talpyklų valymui.'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImages({
    required List<String> images,
    required List<String> names,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Wrap(
        alignment: WrapAlignment.center,
        children: List.generate(
          images.length,
          (i) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(images[i], width: 120, height: 120),
                  const SizedBox(height: 10),
                  SelectableText(
                    names[i],
                    style: _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.searchDescStyle
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.searchDescStyle
                            : TextStyles.searchDescStyle,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDotText(String text) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• ',
                style: _state.status == AccessibilityControllerStatus.big
                    ? TextStylesBigger.descriptionNormal
                    : _state.status == AccessibilityControllerStatus.biggest
                        ? TextStylesBiggest.descriptionNormal
                        : TextStyles.descriptionNormal,
              ),
              Expanded(
                child: Text(
                  text,
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.descriptionNormal
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.descriptionNormal
                          : TextStyles.descriptionNormal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecomendationTitle(String title) {
    if (MediaQuery.of(context).size.width < 768) {
      return Align(
        alignment: Alignment.center,
        child: Text(
          title,
          style: _state.status == AccessibilityControllerStatus.big
              ? TextStylesBigger.recommendationTitleStyle
              : _state.status == AccessibilityControllerStatus.biggest
                  ? TextStylesBiggest.recommendationTitleStyle
                  : TextStyles.recommendationTitleStyle,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return Text(
        title,
        style: _state.status == AccessibilityControllerStatus.big
            ? TextStylesBigger.recommendationTitleStyle
            : _state.status == AccessibilityControllerStatus.biggest
                ? TextStylesBiggest.recommendationTitleStyle
                : TextStyles.recommendationTitleStyle,
      );
    }
  }

  Widget _buildFinishContent(
      String trashTitle, String trashCode, String trashType) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.06,
        vertical: 50,
      ),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Text(
              'Ar tai jūsų ieškoma atlieka/os?',
              textAlign: TextAlign.center,
              style: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.contentDescription
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.contentDescription
                      : TextStyles.contentDescription,
            ),
          ),
          const SizedBox(height: 20),
          DefaultAccentButton(
            title: 'Ne',
            textPadding: _state.status == AccessibilityControllerStatus.normal
                ? const EdgeInsets.only(top: 5)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? const EdgeInsets.only(top: 10)
                    : const EdgeInsets.only(top: 7),
            paddingFromTop: 10,
            btnColor: AppStyle.importantMark,
            textStyle: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.footerBold
                    .copyWith(color: AppStyle.scaffoldColor)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.footerBold
                        .copyWith(color: AppStyle.scaffoldColor)
                    : TextStyles.footerBold
                        .copyWith(color: AppStyle.scaffoldColor),
            onPressed: () {
              codeNotFoundDialog(
                  context: context,
                  trashTitle: trashTitle,
                  trashCode: trashCode,
                  trashType: trashType);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileInfoRow(SecondStageOpenState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: AppStyle.greenBtnUnHoover,
            width: 6,
          ),
        ),
        child: _buildMobileInfo(state),
      ),
    );
  }

  Widget _buildMobileInfo(SecondStageOpenState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SelectableText(
            (otherList.isEmpty) ? 'Numanomi atliekos kodai' : 'Rezultatas',
            style: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.smallNavTitleStyle
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.smallNavTitleStyle
                    : TextStyles.smallNavTitleStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: (otherList.isEmpty)
                ? List.generate(
                    trashList.length,
                    (i) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 340,
                            child: SelectableText(
                              'Atliekos Apibūdinimas',
                              style: _state.status ==
                                      AccessibilityControllerStatus.big
                                  ? TextStylesBigger.mobileTrashDescription
                                  : _state.status ==
                                          AccessibilityControllerStatus.biggest
                                      ? TextStylesBiggest.mobileTrashDescription
                                      : TextStyles.mobileTrashDescription,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 340,
                            child: SelectableText(
                              trashList[i].itemName!.toCapitalized(),
                              style: _state.status ==
                                      AccessibilityControllerStatus.big
                                  ? TextStylesBigger.mobileTrashDescriptionStyle
                                  : _state.status ==
                                          AccessibilityControllerStatus.biggest
                                      ? TextStylesBiggest
                                          .mobileTrashDescriptionStyle
                                      : TextStyles.mobileTrashDescriptionStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 340,
                            child: SelectableText(
                              'Atliekos Kodas',
                              style: _state.status ==
                                      AccessibilityControllerStatus.big
                                  ? TextStylesBigger.mobileTrashDescription
                                  : _state.status ==
                                          AccessibilityControllerStatus.biggest
                                      ? TextStylesBiggest.mobileTrashDescription
                                      : TextStyles.mobileTrashDescription,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            children: [
                              Image.asset(
                                trashList[i].type == "AN"
                                    ? (_state.blindness ==
                                            AccessibilityControllerBlindness
                                                .blind)
                                        ? Strings.approved_mark_monochrome
                                        : Strings.approved_mark
                                    : (trashList[i].type == "VP" ||
                                            trashList[i].type == "VN")
                                        ? (_state.blindness ==
                                                AccessibilityControllerBlindness
                                                    .blind)
                                            ? Strings.question_mark_monochrome
                                            : Strings.question_mark
                                        : (_state.blindness ==
                                                AccessibilityControllerBlindness
                                                    .blind)
                                            ? Strings
                                                .red_exclemation_mark_monochrome
                                            : Strings.red_exclemation_mark,
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(width: 10),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: SizedBox(
                                  width: 280,
                                  child: SelectableText(
                                    trashList[i].type! == "AN"
                                        ? 'Absoliučiai nepavojinga atlieka'
                                        : trashList[i].type == "AP"
                                            ? 'Absoliučiai pavojinga atlieka'
                                            : trashList[i].type == "VP"
                                                ? 'Veidrodinė pavojinga atlieka'
                                                : 'Veidrodinė nepavojinga atlieka',
                                    style: _state.status ==
                                            AccessibilityControllerStatus.big
                                        ? TextStylesBigger.mobileItemCodeStyle
                                        : _state.status ==
                                                AccessibilityControllerStatus
                                                    .biggest
                                            ? TextStylesBiggest
                                                .mobileItemCodeStyle
                                            : TextStyles.mobileItemCodeStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 340,
                            child: _buildItemCode(trashList[i]),
                          ),
                          const SizedBox(height: 30),
                          DefaultAccentButton(
                            btnWidth: 180,
                            title: 'Eiti toliau',
                            textPadding: _state.status ==
                                    AccessibilityControllerStatus.normal
                                ? const EdgeInsets.only(top: 5)
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? const EdgeInsets.only(top: 10)
                                    : const EdgeInsets.only(top: 7),
                            textStyle: _state.status ==
                                    AccessibilityControllerStatus.big
                                ? TextStylesBigger.searchBtnStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.searchBtnStyle
                                    : TextStyles.searchBtnStyle,
                            onPressed: () {
                              if (trashList.isNotEmpty) {
                                if (trashList[i].type == "VP" ||
                                    trashList[i].type == "VN") {
                                  widget.firstStageBloc.add(
                                    CodeFoundEvent(
                                      title: trashList[i].itemName,
                                      trashCode: trashList[i].code,
                                      trashType: trashList[i].type,
                                      isKnown: true,
                                      fromEntryPoint: state.fromEntryPoint,
                                    ),
                                  );
                                } else if (trashList[i].type == "AP" ||
                                    trashList[i].type == "AN") {
                                  widget.firstStageBloc.add(
                                    CodeFoundEvent(
                                      title: trashList[i].itemName,
                                      trashCode: trashList[i].code,
                                      trashType: trashList[i].type,
                                      fromEntryPoint: state.fromEntryPoint,
                                    ),
                                  );
                                } else {
                                  widget.firstStageBloc.add(OpenThirdStageEvent(
                                    trashTitle: trashList[i].itemName!,
                                    trashCode: trashList[i].code!,
                                    trashType: trashList[i].type!,
                                    listOfCategories: widget.listOfCategories,
                                    fromEntryPoint: state.fromEntryPoint,
                                  ));
                                }
                              } else {
                                if (importantTrashList[i].type == "VP" ||
                                    importantTrashList[i].type == "VN") {
                                  widget.firstStageBloc.add(
                                    CodeFoundEvent(
                                      title: importantTrashList[i].itemName,
                                      trashCode: importantTrashList[i].code,
                                      trashType: importantTrashList[i].type,
                                      isKnown: true,
                                      fromEntryPoint: state.fromEntryPoint,
                                    ),
                                  );
                                } else if (importantTrashList[i].type == "AP" ||
                                    importantTrashList[i].type == "AN") {
                                  widget.firstStageBloc.add(
                                    CodeFoundEvent(
                                      title: importantTrashList[i].itemName,
                                      trashCode: importantTrashList[i].code,
                                      trashType: importantTrashList[i].type,
                                      fromEntryPoint: state.fromEntryPoint,
                                    ),
                                  );
                                } else {
                                  widget.firstStageBloc.add(OpenThirdStageEvent(
                                    trashTitle: importantTrashList[i].itemName!,
                                    trashCode: importantTrashList[i].code!,
                                    trashType: importantTrashList[i].type!,
                                    listOfCategories: widget.listOfCategories,
                                    fromEntryPoint: state.fromEntryPoint,
                                  ));
                                }
                              }
                              html.window.parent!
                                  .postMessage({'goUp': true}, '*');
                            },
                          ),
                        ],
                      );
                    },
                  )
                : List.generate(
                    otherList.length,
                    (i) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 340,
                            child: SelectableText(
                              'Atliekos Apibūdinimas',
                              style: _state.status ==
                                      AccessibilityControllerStatus.big
                                  ? TextStylesBigger.mobileTrashDescription
                                  : _state.status ==
                                          AccessibilityControllerStatus.biggest
                                      ? TextStylesBiggest.mobileTrashDescription
                                      : TextStyles.mobileTrashDescription,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 340,
                            child: SelectableText(
                              otherList[i].toCapitalized(),
                              style: _state.status ==
                                      AccessibilityControllerStatus.big
                                  ? TextStylesBigger.mobileTrashDescriptionStyle
                                  : _state.status ==
                                          AccessibilityControllerStatus.biggest
                                      ? TextStylesBiggest
                                          .mobileTrashDescriptionStyle
                                      : TextStyles.mobileTrashDescriptionStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 30),
                          DefaultAccentButton(
                            btnWidth: 180,
                            title: 'Grįžti',
                            textPadding: _state.status ==
                                    AccessibilityControllerStatus.normal
                                ? const EdgeInsets.only(top: 5)
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? const EdgeInsets.only(top: 10)
                                    : const EdgeInsets.only(top: 7),
                            textStyle: _state.status ==
                                    AccessibilityControllerStatus.big
                                ? TextStylesBigger.searchBtnStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.searchBtnStyle
                                    : TextStyles.searchBtnStyle,
                            onPressed: () {
                              if (state.fromEntryPoint != null &&
                                  state.fromEntryPoint == true) {
                                widget.firstStageBloc
                                    .add(StartFromSecondStageEvent());
                              } else {
                                widget.firstStageBloc
                                    .add(OpenFirstStageEvent());
                              }
                              html.window.parent!
                                  .postMessage({'goUp': true}, '*');
                            },
                          ),
                        ],
                      );
                    },
                  ),
          ),
          specificTrash != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    SelectableText(
                      'Arba atlikite III etapą',
                      style: _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.smallNavTitleStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.smallNavTitleStyle
                              : TextStyles.smallNavTitleStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    DefaultAccentButton(
                        btnWidth: 180,
                        title: 'III etapas',
                        textPadding: _state.status ==
                                AccessibilityControllerStatus.normal
                            ? const EdgeInsets.only(top: 5)
                            : _state.status ==
                                    AccessibilityControllerStatus.biggest
                                ? const EdgeInsets.only(top: 10)
                                : const EdgeInsets.only(top: 7),
                        textStyle:
                            _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.searchBtnStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.searchBtnStyle
                                    : TextStyles.searchBtnStyle,
                        onPressed: () {
                          widget.firstStageBloc.add(
                            OpenThirdStageEvent(
                              trashTitle: specificTrash!.itemName!,
                              listOfCategories: widget.listOfCategories,
                              trashType: specificTrash!.type!,
                              trashCode: specificTrash!.code!,
                              fromEntryPoint: state.fromEntryPoint,
                            ),
                          );
                          html.window.parent!.postMessage({'goUp': true}, '*');
                        }),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(SecondStageOpenState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: AppStyle.greenBtnUnHoover,
            width: 6,
          ),
        ),
        child: _buildInfo(state),
      ),
    );
  }

  Widget _buildInfo(SecondStageOpenState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SelectableText(
            (otherList.isEmpty) ? 'Numanomi atliekos kodai' : 'Rezultatas',
            style: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.itemTitleStyle
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.itemTitleStyle
                    : TextStyles.itemTitleStyle,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: (otherList.isEmpty)
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.start,
              children: [
                SelectableText(
                  'Atliekos apibūdinimas',
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.selectorDescriptionTitleStyle
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.selectorDescriptionTitleStyle
                          : TextStyles.selectorDescriptionTitleStyle,
                ),
                otherList.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(right: 150),
                        child: SelectableText(
                          'Atliekos kodas',
                          style: _state.status ==
                                  AccessibilityControllerStatus.big
                              ? TextStylesBigger.selectorDescriptionTitleStyle
                              : _state.status ==
                                      AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest
                                      .selectorDescriptionTitleStyle
                                  : TextStyles.selectorDescriptionTitleStyle,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: (trashList.isNotEmpty || importantTrashList.isNotEmpty)
                  ? List.generate(
                      (trashList.isNotEmpty)
                          ? trashList.length
                          : (importantTrashList.isNotEmpty)
                              ? importantTrashList.length
                              : 0,
                      (i) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: const BoxDecoration(
                              color: AppStyle.appBarWebColor,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SelectableText(
                                      trashList.isNotEmpty
                                          ? trashList[i]
                                              .itemName!
                                              .toCapitalized()
                                          : importantTrashList.isNotEmpty
                                              ? importantTrashList[i]
                                                  .itemName!
                                                  .toCapitalized()
                                              : '',
                                      style: _state.status ==
                                              AccessibilityControllerStatus.big
                                          ? TextStylesBigger.contentDescription
                                          : _state.status ==
                                                  AccessibilityControllerStatus
                                                      .biggest
                                              ? TextStylesBiggest
                                                  .contentDescription
                                              : TextStyles.contentDescription,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      trashList.isNotEmpty
                                          ? Image.asset(
                                              trashList[i].type == "AN"
                                                  ? (_state.blindness ==
                                                          AccessibilityControllerBlindness
                                                              .blind)
                                                      ? Strings
                                                          .approved_mark_monochrome
                                                      : Strings.approved_mark
                                                  : (_state.blindness ==
                                                          AccessibilityControllerBlindness
                                                              .blind)
                                                      ? Strings
                                                          .red_exclemation_mark_monochrome
                                                      : Strings
                                                          .red_exclemation_mark,
                                              width: 30,
                                              height: 30,
                                            )
                                          : importantTrashList.isNotEmpty
                                              ? Image.asset(
                                                  importantTrashList[i].type ==
                                                          "AN"
                                                      ? (_state.blindness ==
                                                              AccessibilityControllerBlindness
                                                                  .blind)
                                                          ? Strings
                                                              .approved_mark_monochrome
                                                          : Strings
                                                              .approved_mark
                                                      : (_state.blindness ==
                                                              AccessibilityControllerBlindness
                                                                  .blind)
                                                          ? Strings
                                                              .red_exclemation_mark_monochrome
                                                          : Strings
                                                              .red_exclemation_mark,
                                                  width: 30,
                                                  height: 30,
                                                )
                                              : const SizedBox(),
                                      const SizedBox(width: 10),
                                      Padding(
                                        padding: _state.status ==
                                                AccessibilityControllerStatus
                                                    .normal
                                            ? const EdgeInsets.only(top: 5)
                                            : _state.status ==
                                                    AccessibilityControllerStatus
                                                        .biggest
                                                ? const EdgeInsets.only(top: 10)
                                                : const EdgeInsets.only(top: 5),
                                        child: SelectableText(
                                          trashList.isNotEmpty
                                              ? trashList[i].type!
                                              : importantTrashList.isNotEmpty
                                                  ? importantTrashList[i].type!
                                                  : '',
                                          style: _state.status ==
                                                  AccessibilityControllerStatus
                                                      .big
                                              ? TextStylesBigger.itemCodeStyle
                                              : _state.status ==
                                                      AccessibilityControllerStatus
                                                          .biggest
                                                  ? TextStylesBiggest
                                                      .itemCodeStyle
                                                  : TextStyles.itemCodeStyle,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      SelectionArea(
                                        child:
                                            _buildItemCode(trashList.isNotEmpty
                                                ? trashList[i]
                                                : importantTrashList.isNotEmpty
                                                    ? importantTrashList[i]
                                                    : trashList[i]),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: DefaultAccentButton(
                                      title: 'Eiti toliau',
                                      btnColor: AppStyle.greenBtnUnHoover,
                                      textPadding: _state.status ==
                                              AccessibilityControllerStatus
                                                  .normal
                                          ? const EdgeInsets.only(top: 5)
                                          : _state.status ==
                                                  AccessibilityControllerStatus
                                                      .biggest
                                              ? const EdgeInsets.only(top: 10)
                                              : const EdgeInsets.only(top: 7),
                                      onPressed: () {
                                        if (trashList.isNotEmpty) {
                                          if (trashList[i].type == "VP" ||
                                              trashList[i].type == "VN") {
                                            widget.firstStageBloc.add(
                                              CodeFoundEvent(
                                                title: trashList[i].itemName,
                                                trashCode: trashList[i].code,
                                                trashType: trashList[i].type,
                                                isKnown: true,
                                                fromEntryPoint:
                                                    state.fromEntryPoint,
                                              ),
                                            );
                                          } else if (trashList[i].type ==
                                                  "AP" ||
                                              trashList[i].type == "AN") {
                                            widget.firstStageBloc.add(
                                              CodeFoundEvent(
                                                title: trashList[i].itemName,
                                                trashCode: trashList[i].code,
                                                trashType: trashList[i].type,
                                                fromEntryPoint:
                                                    state.fromEntryPoint,
                                              ),
                                            );
                                          } else {
                                            widget.firstStageBloc
                                                .add(OpenThirdStageEvent(
                                              trashTitle:
                                                  trashList[i].itemName!,
                                              trashCode: trashList[i].code!,
                                              trashType: trashList[i].type!,
                                              listOfCategories:
                                                  widget.listOfCategories,
                                              fromEntryPoint:
                                                  state.fromEntryPoint,
                                            ));
                                          }
                                        } else {
                                          if (importantTrashList[i].type ==
                                                  "VP" ||
                                              importantTrashList[i].type ==
                                                  "VN") {
                                            widget.firstStageBloc.add(
                                              CodeFoundEvent(
                                                title: importantTrashList[i]
                                                    .itemName,
                                                trashCode:
                                                    importantTrashList[i].code,
                                                trashType:
                                                    importantTrashList[i].type,
                                                isKnown: true,
                                                fromEntryPoint:
                                                    state.fromEntryPoint,
                                              ),
                                            );
                                          } else if (importantTrashList[i]
                                                      .type ==
                                                  "AP" ||
                                              importantTrashList[i].type ==
                                                  "AN") {
                                            widget.firstStageBloc.add(
                                              CodeFoundEvent(
                                                title: importantTrashList[i]
                                                    .itemName,
                                                trashCode:
                                                    importantTrashList[i].code,
                                                trashType:
                                                    importantTrashList[i].type,
                                                fromEntryPoint:
                                                    state.fromEntryPoint,
                                              ),
                                            );
                                          } else {
                                            widget.firstStageBloc
                                                .add(OpenThirdStageEvent(
                                              trashTitle: importantTrashList[i]
                                                  .itemName!,
                                              trashCode:
                                                  importantTrashList[i].code!,
                                              trashType:
                                                  importantTrashList[i].type!,
                                              listOfCategories:
                                                  widget.listOfCategories,
                                              fromEntryPoint:
                                                  state.fromEntryPoint,
                                            ));
                                          }
                                        }
                                        html.window.parent!.postMessage({'goUp': true}, '*');
                                      },
                                      textStyle: _state.status ==
                                              AccessibilityControllerStatus.big
                                          ? TextStylesBigger.searchBtnStyle
                                          : _state.status ==
                                                  AccessibilityControllerStatus
                                                      .biggest
                                              ? TextStylesBiggest.searchBtnStyle
                                              : TextStyles.searchBtnStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : List.generate(
                      otherList.length,
                      (i) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: const BoxDecoration(
                              color: AppStyle.appBarWebColor,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: SelectableText(
                                      otherList[i].toCapitalized(),
                                      style: _state.status ==
                                              AccessibilityControllerStatus.big
                                          ? TextStylesBigger.contentDescription
                                          : _state.status ==
                                                  AccessibilityControllerStatus
                                                      .biggest
                                              ? TextStylesBiggest
                                                  .contentDescription
                                              : TextStyles.contentDescription,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: DefaultAccentButton(
                                      title: 'Grįžti',
                                      btnColor: AppStyle.greenBtnUnHoover,
                                      textPadding: _state.status ==
                                              AccessibilityControllerStatus
                                                  .normal
                                          ? const EdgeInsets.only(top: 5)
                                          : _state.status ==
                                                  AccessibilityControllerStatus
                                                      .biggest
                                              ? const EdgeInsets.only(top: 10)
                                              : const EdgeInsets.only(top: 7),
                                      onPressed: () {
                                        if (state.fromEntryPoint != null &&
                                            state.fromEntryPoint == true) {
                                          widget.firstStageBloc
                                              .add(StartFromSecondStageEvent());
                                        } else {
                                          widget.firstStageBloc
                                              .add(OpenFirstStageEvent());
                                        }
                                        html.window.parent!.postMessage({'goUp': true}, '*');
                                      },
                                      textStyle: _state.status ==
                                              AccessibilityControllerStatus.big
                                          ? TextStylesBigger.searchBtnStyle
                                          : _state.status ==
                                                  AccessibilityControllerStatus
                                                      .biggest
                                              ? TextStylesBiggest.searchBtnStyle
                                              : TextStyles.searchBtnStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          specificTrash != null
              ? Column(
                  children: [
                    const SizedBox(height: 20),
                    SelectableText(
                      'Arba atlikite III etapą',
                      style: _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.itemTitleStyle
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.itemTitleStyle
                              : TextStyles.itemTitleStyle,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 150,
                      child: DefaultAccentButton(
                        title: 'III etapas',
                        btnColor: AppStyle.greenBtnUnHoover,
                        textPadding: _state.status ==
                                AccessibilityControllerStatus.normal
                            ? const EdgeInsets.only(top: 5)
                            : _state.status ==
                                    AccessibilityControllerStatus.biggest
                                ? const EdgeInsets.only(top: 10)
                                : const EdgeInsets.only(top: 7),
                        onPressed: () {
                          widget.firstStageBloc.add(
                            OpenThirdStageEvent(
                              trashTitle: specificTrash!.itemName!,
                              listOfCategories: widget.listOfCategories,
                              trashType: specificTrash!.type!,
                              trashCode: specificTrash!.code!,
                              fromEntryPoint: state.fromEntryPoint,
                            ),
                          );
                          html.window.parent!.postMessage({'goUp': true}, '*');
                        },
                        textStyle:
                            _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.searchBtnStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.searchBtnStyle
                                    : TextStyles.searchBtnStyle,
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget _buildItemCode(Items trashItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCodeWindow(trashItem.code!.split(' ')[0], trashItem),
        _buildCodeWindow(trashItem.code!.split(' ')[1], trashItem),
        _buildCodeWindow(
            trashItem.code!.split(' ')[2].split('*')[0], trashItem),
        _buildCodeWindow(
            trashItem.code!.split(' ').length > 3
                ? trashItem.code!.split(' ')[3].replaceAll('*', '')
                : '',
            trashItem),
        _buildCodeWindow(trashItem.code!.contains('*') ? '*' : '', trashItem),
      ],
    );
  }

  Widget _buildCodeWindow(String codePart, Items trashItem) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Container(
        width: _state.status == AccessibilityControllerStatus.biggest ? 50 : 34,
        decoration: BoxDecoration(
          color: AppStyle.scaffoldColor,
          border: Border.all(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                codePart,
                style: _state.status == AccessibilityControllerStatus.big
                    ? TextStylesBigger.itemCodeStyle
                    : _state.status == AccessibilityControllerStatus.biggest
                        ? TextStylesBiggest.itemCodeStyle
                        : TextStyles.itemCodeStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileButtons(SecondCategory category, String trashCode,
      String trashTitle, String trashType) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 150,
            child: DefaultAccentButton(
              title: 'Taip',
              textPadding: _state.status == AccessibilityControllerStatus.normal
                  ? const EdgeInsets.only(top: 5)
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? const EdgeInsets.only(top: 0)
                      : const EdgeInsets.only(top: 7),
              textStyle: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.footerBold
                      .copyWith(color: AppStyle.scaffoldColor)
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.footerBold
                          .copyWith(color: AppStyle.scaffoldColor)
                      : TextStyles.footerBold
                          .copyWith(color: AppStyle.scaffoldColor),
              onPressed: () => _yesController(
                category: category,
                trashCode: trashCode,
                trashTitle: trashTitle,
                trashType: trashType,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: DefaultAccentButton(
              title: 'Ne',
              textPadding: _state.status == AccessibilityControllerStatus.normal
                  ? const EdgeInsets.only(top: 5)
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? const EdgeInsets.only(top: 0)
                      : const EdgeInsets.only(top: 7),
              btnColor: AppStyle.importantMark,
              textStyle: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.footerBold
                      .copyWith(color: AppStyle.scaffoldColor)
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.footerBold
                          .copyWith(color: AppStyle.scaffoldColor)
                      : TextStyles.footerBold
                          .copyWith(color: AppStyle.scaffoldColor),
              onPressed: () => _noController(
                category: category,
                trashCode: trashCode,
                trashTitle: trashTitle,
                trashType: trashType,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(SecondCategory category, String trashCode,
      String trashTitle, String trashType) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DefaultAccentButton(
            title: 'Taip',
            textPadding: _state.status == AccessibilityControllerStatus.normal
                ? const EdgeInsets.only(top: 5)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? const EdgeInsets.only(top: 10)
                    : const EdgeInsets.only(top: 7),
            isHooverAnimationEnabled: true,
            textStyle: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.footerBold
                    .copyWith(color: AppStyle.scaffoldColor)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.footerBold
                        .copyWith(color: AppStyle.scaffoldColor)
                    : TextStyles.footerBold
                        .copyWith(color: AppStyle.scaffoldColor),
            // paddingFromTop: 10,
            onPressed: () => _yesController(
              category: category,
              trashCode: trashCode,
              trashTitle: trashTitle,
              trashType: trashType,
            ),
          ),
          const SizedBox(width: 30),
          DefaultAccentButton(
            title: 'Ne',
            isHooverAnimationEnabled: true,
            textPadding: _state.status == AccessibilityControllerStatus.normal
                ? const EdgeInsets.only(top: 5)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? const EdgeInsets.only(top: 10)
                    : const EdgeInsets.only(top: 7),
            btnColor: AppStyle.importantMark,
            textStyle: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.footerBold
                    .copyWith(color: AppStyle.scaffoldColor)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.footerBold
                        .copyWith(color: AppStyle.scaffoldColor)
                    : TextStyles.footerBold
                        .copyWith(color: AppStyle.scaffoldColor),
            // paddingFromTop: 10,
            onPressed: () => _noController(
              category: category,
              trashCode: trashCode,
              trashTitle: trashTitle,
              trashType: trashType,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(List<Questions> questions) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.06,
        vertical: (MediaQuery.of(context).size.width > 768) ? 50 : 20,
      ),
      child: SelectionArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text(
            questions[index].question!,
            textAlign: TextAlign.center,
            style: (MediaQuery.of(context).size.width > 768)
                ? _state.status == AccessibilityControllerStatus.big
                    ? TextStylesBigger.contentDescription
                    : _state.status == AccessibilityControllerStatus.biggest
                        ? TextStylesBiggest.contentDescription
                        : TextStyles.contentDescription
                : _state.status == AccessibilityControllerStatus.big
                    ? TextStylesBigger.mobileContentDescription
                    : _state.status == AccessibilityControllerStatus.biggest
                        ? TextStylesBiggest.mobileContentDescription
                        : TextStyles.mobileContentDescription,
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCounter(
      List<Questions> questions, SecondCategory category) {
    if (category.id == 3 || category.id == 4) {
      reformedQuestionListIndex = questions.length - 1;
    } else {
      reformedQuestionListIndex = questions.length;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // MouseRegion(
          //   onEnter: (e) {
          //     if (index != 0) {
          //       setState(() {
          //         backHover = true;
          //       });
          //     } else {
          //       setState(() {
          //         backHover = false;
          //       });
          //     }
          //   },
          //   onExit: (e) {
          //     if (index != 0) {
          //       setState(() {
          //         backHover = false;
          //       });
          //     } else {
          //       setState(() {
          //         backHover = false;
          //       });
          //     }
          //   },
          //   child: RotatedBox(
          //     quarterTurns: 2,
          //     child: IconButton(
          //       iconSize: 30,
          //       hoverColor: (index != 0)
          //           ? AppStyle.greyHooverColor
          //           : Colors.transparent,
          //       splashRadius: (index != 0) ? 30 : 1,
          //       onPressed: () {
          //         if (index != 0) {
          //           setState(() {
          //             index--;
          //           });
          //         }
          //       },
          //       icon: Icon(
          //         Icons.play_circle,
          //         color: backHover
          //             ? AppStyle.greenBtnUnHoover
          //             : AppStyle.helpIconColor,
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              '${index + 1}/$reformedQuestionListIndex',
              style: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.questionsCounter
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.questionsCounter
                      : TextStyles.questionsCounter,
            ),
          ),
          // MouseRegion(
          //   onEnter: (e) {
          //     if (index < reformedQuestionListIndex - 1) {
          //       setState(() {
          //         frontHover = true;
          //       });
          //     } else {
          //       setState(() {
          //         frontHover = false;
          //       });
          //     }
          //   },
          //   onExit: (e) {
          //     if (index < reformedQuestionListIndex - 1) {
          //       setState(() {
          //         frontHover = false;
          //       });
          //     } else {
          //       setState(() {
          //         frontHover = false;
          //       });
          //     }
          //   },
          //   child: IconButton(
          //     hoverColor: (index < reformedQuestionListIndex - 1)
          //         ? AppStyle.greyHooverColor
          //         : Colors.transparent,
          //     iconSize: 30,
          //     onPressed: () {
          //       if (index < reformedQuestionListIndex - 1) {
          //         setState(() {
          //           index++;
          //         });
          //       }
          //     },
          //     splashRadius: (index < reformedQuestionListIndex - 1) ? 30 : 1,
          //     icon: Icon(
          //       Icons.play_circle,
          //       color: frontHover
          //           ? AppStyle.greenBtnUnHoover
          //           : AppStyle.helpIconColor,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppStyle.greenBtnUnHoover,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
          vertical: 20,
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              // height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppStyle.scaffoldColor,
              ),
              child: Center(
                child: Padding(
                  padding: _state.status == AccessibilityControllerStatus.normal
                      ? const EdgeInsets.only(top: 15)
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? const EdgeInsets.only(top: 20)
                          : const EdgeInsets.only(top: 20),
                  child: Text(
                    '2',
                    style: _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.numberTextStyle
                            .copyWith(color: AppStyle.greenBtnUnHoover)
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.numberTextStyle
                                .copyWith(color: AppStyle.greenBtnUnHoover)
                            : TextStyles.numberTextStyle
                                .copyWith(color: AppStyle.greenBtnUnHoover),
                  ),
                ),
              ),
            ),
            (MediaQuery.of(context).size.width > 768)
                ? const SizedBox(width: 50)
                : const SizedBox(width: 20),
            (MediaQuery.of(context).size.width > 768)
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SelectableText(
                        title,
                        style: (MediaQuery.of(context).size.width > 768)
                            ? _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.howToUseTitleStyle
                                    .copyWith(color: AppStyle.scaffoldColor)
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.howToUseTitleStyle
                                        .copyWith(color: AppStyle.scaffoldColor)
                                    : TextStyles.howToUseTitleStyle
                                        .copyWith(color: AppStyle.scaffoldColor)
                            : _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.greenSectionMobileStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.greenSectionMobileStyle
                                    : TextStyles.greenSectionMobileStyle,
                      ),
                    ),
                  )
                : Expanded(
                    child: SelectableText(
                      title,
                      style: (MediaQuery.of(context).size.width > 768)
                          ? _state.status == AccessibilityControllerStatus.big
                              ? TextStylesBigger.howToUseTitleStyle
                                  .copyWith(color: AppStyle.scaffoldColor)
                              : _state.status ==
                                      AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.howToUseTitleStyle
                                      .copyWith(color: AppStyle.scaffoldColor)
                                  : TextStyles.howToUseTitleStyle
                                      .copyWith(color: AppStyle.scaffoldColor)
                          : _state.status == AccessibilityControllerStatus.big
                              ? TextStylesBigger.greenSectionMobileStyle
                              : _state.status ==
                                      AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.greenSectionMobileStyle
                                  : TextStyles.greenSectionMobileStyle,
                    ),
                  ),
            (MediaQuery.of(context).size.width > 768)
                ? HowToUseTool(howToUseBloc: widget.howToUseBloc)
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  void _getTrashList(Questions questions) {
    trashList.clear();
    if (questions.newCode != null) {
      List<dynamic> codesList = questions.newCode;
      for (var i = 0; i < codesList.length; i++) {
        for (var category in widget.listOfCategories) {
          for (var sub in category.subCategories!) {
            for (var item in sub.items!) {
              if (item.code == codesList[i]) {
                trashList.add(item);
              }
            }
          }
        }
      }
    }
  }

  void _getImportantTrashList(Questions questions) {
    importantTrashList.clear();
    if (questions.suggestion != null) {
      List<dynamic> codesList = questions.suggestion!;
      for (var i = 0; i < codesList.length; i++) {
        for (var category in widget.listOfCategories) {
          for (var sub in category.subCategories!) {
            for (var item in sub.items!) {
              if (item.code == codesList[i]) {
                importantTrashList.add(item);
              }
            }
          }
        }
      }
    }
  }

  Items _getSpecificTrash({required String code, required int id}) {
    List<String> codeSplitList = code.split(' ');
    List<Category> allData = widget.firstStageBloc.allData!;
    int index = allData.indexWhere((e) => e.categoryId == codeSplitList[0]);
    int subIndex = allData[index].subCategories!.indexWhere(
        (e) => e.codeId == '${codeSplitList[0]} ${codeSplitList[1]}');
    int itemIndex = allData[index]
        .subCategories![subIndex]
        .items!
        .indexWhere((e) => e.code == code);
    specificTrash = allData[index].subCategories![subIndex].items![itemIndex];
    return specificTrash!;
  }

  void codeNotFoundDialog(
      {required BuildContext context,
      required String trashTitle,
      required String trashCode,
      required String trashType,
      String? information}) {
    return Overlay.of(context).insert(
      overlay = OverlayEntry(
        builder: (context) {
          return NotFoundWidget(
            firstStageBloc: widget.firstStageBloc,
            overlayEntry: overlay!,
            trashTitle: trashTitle,
            listOfCategories: widget.listOfCategories,
            trashCode: trashCode,
            trashType: trashType,
            information: information,
          );
        },
      ),
    );
  }

  _yesController({
    required SecondCategory category,
    required String trashCode,
    required String trashTitle,
    required String trashType,
  }) {
    importantTrashList.clear();
    if (index + 1 != category.questionsList!.length) {
      if (category.questionsList![index].answerToNextQuestion != null) {
        if (category.questionsList![index].answerToNextQuestion == true) {
          if ((category.questionsList![index + 1].newCode as List<dynamic>)
                  .isEmpty &&
              category.questionsList![index + 1].otherAnswer != null) {
            otherList.clear();
            otherList.add(category.questionsList![index + 1].otherAnswer!);
          } else {
            if (category.questionsList![index].suggestion != null) {
              _getImportantTrashList(category.questionsList![index]);
            }
            trashList.clear();
            index++;
          }
        } else {
          if (category.questionsList![index].newCode != null) {
            if ((category.questionsList![index].newCode as List<dynamic>)
                .isEmpty) {
              otherList.clear();
              otherList.add(category.questionsList![index].otherAnswer!);
            } else {
              _getTrashList(category.questionsList![index]);
            }
          } else {
            codeNotFoundDialog(
                context: context,
                trashTitle: trashTitle,
                trashCode: trashCode,
                trashType: trashType);
          }
        }
      }
    } else {
      if (category.id == 2) {
        _getTrashList(category.questionsList![index]);
      } else if (category.id == 0 && index == 3 ||
          category.id == 5 && index == 1 ||
          category.id == 6 && index == 1) {
        trashList.add(
          _getSpecificTrash(
            code: index == 1 && category.id == 5
                ? '15 02 02*'
                : index == 1 && category.id == 6
                    ? '16 03 05*'
                    : index == 3 && category.id == 0
                        ? '15 01 10*'
                        : '',
            id: category.id!,
          ),
        );
        // codeNotFoundDialog(
        //     context: context,
        //     trashTitle: trashTitle,
        //     trashCode: trashCode,
        //     trashType: trashType,
        //     information: index == 1 && category.id == 5
        //         ? 'Jei nėra galimybių nustatyti, kokiomis medžiagomis yra užterštos atliekos, rekomenduojama šias atliekas priskirti prie pavojingųjų atliekų, suteikiant 15 02 02* atliekos kodą.'
        //         : index == 1 && category.id == 6
        //             ? 'Jei nėra galimybių nustatyti, kokiomis medžiagomis yra užterštos atliekos, rekomenduojama šias atliekas priskirti prie pavojingųjų atliekų, suteikiant 16 03 05* atliekos kodą.'
        //             : index == 3 && category.id == 0
        //                 ? 'Pakuočių atliekos klasifikuojamos kaip pavojingosios - Pakuotės, kuriose yra pavojingų medžiagų likučių arba kurios yra jomis užterštos 15 01 10*'
        //                 : null);
      } else if (category.id == 4) {
        codeNotFoundDialog(
            context: context,
            trashTitle: trashTitle,
            trashCode: trashCode,
            trashType: trashType);
      } else {
        trashList.clear();
        if (category.questionsList![index].newCode != null) {
          if ((category.questionsList![index].newCode as List<dynamic>)
                  .isEmpty &&
              category.questionsList![index].otherAnswer != null) {
            otherList.clear();
            otherList.add(category.questionsList![index].otherAnswer!);
          } else {
            _getTrashList(category.questionsList![index]);
          }
        } else {
          codeNotFoundDialog(
              context: context,
              trashTitle: trashTitle,
              trashCode: trashCode,
              trashType: trashType);
        }
      }
    }
    setState(() {});
    html.window.parent!.postMessage({'goUp': true}, '*');
  }

  _noController({
    required SecondCategory category,
    required String trashCode,
    required String trashTitle,
    required String trashType,
  }) {
    importantTrashList.clear();
    if (index + 1 != category.questionsList!.length) {
      if (category.questionsList![index].answerToNextQuestion != null) {
        if (category.questionsList![index].answerToNextQuestion == false) {
          if (category.id == 7) {
            trashList.clear();
            index++;
          } else {
            if (category.questionsList![index + 1].newCode != null &&
                (category.questionsList![index + 1].newCode as List<dynamic>)
                    .isEmpty &&
                category.questionsList![index + 1].otherAnswer != null) {
              otherList.clear();
              otherList.add(category.questionsList![index + 1].otherAnswer!);
            } else {
              trashList.clear();
              index++;
            }
          }
        } else {
          if (category.questionsList![index].newCode != null) {
            if ((category.questionsList![index].newCode as List<dynamic>)
                    .isEmpty &&
                category.questionsList![index].otherAnswer != null) {
              otherList.clear();
              otherList.add(category.questionsList![index].otherAnswer!);
            } else {
              _getTrashList(category.questionsList![index]);
            }
          } else {
            codeNotFoundDialog(
                context: context,
                trashTitle: trashTitle,
                trashCode: trashCode,
                trashType: trashType);
          }
        }
      }
    } else {
      if (category.id == 2) {
        _getImportantTrashList(category.questionsList![index]);
      } else if (category.id == 1 ||
          category.id == 3 ||
          category.id == 4 ||
          category.id == 7) {
        codeNotFoundDialog(
            context: context,
            trashTitle: trashTitle,
            trashCode: trashCode,
            trashType: trashType);
      } else {
        trashList.clear();
        if (category.questionsList![index].newCode != null) {
          _getTrashList(category.questionsList![index]);
        } else {
          codeNotFoundDialog(
              context: context,
              trashTitle: trashTitle,
              trashCode: trashCode,
              trashType: trashType);
        }
      }
    }
    setState(() {});
    html.window.parent!.postMessage({'goUp': true}, '*');
  }
}
