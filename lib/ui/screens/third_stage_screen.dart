import 'package:aplinkos_ministerija/bloc/how_to_use/how_to_use_bloc.dart';
import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../../bloc/stages_cotroller/first_stage_bloc.dart';
import '../../constants/app_colors.dart';
import '../../model/final_stage_models/final_list.dart';
import '../../model/final_stage_models/final_questions.dart';
import '../styles/app_style.dart';
import '../styles/text_styles.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';
import '../widgets/back_btn.dart';
import '../widgets/button.dart';
import '../widgets/how_to_use_tool.dart';

class ThirdStageScreen extends StatefulWidget {
  final FirstStageBloc firstStageBloc;
  final HowToUseBloc howToUseBloc;
  final RouteControllerBloc routeControllerBloc;

  const ThirdStageScreen({
    super.key,
    required this.firstStageBloc,
    required this.howToUseBloc,
    required this.routeControllerBloc,
  });

  @override
  State<ThirdStageScreen> createState() => _ThirdStageScreenState();
}

class _ThirdStageScreenState extends State<ThirdStageScreen> {
  final storage = LocalStorage('backTracker');
  dynamic indexValue;
  dynamic questionIndexValue;

  bool backHover = false;
  bool frontHover = false;
  bool isFound = false;
  int index = 0;
  int questionIndex = 0;
  String foundString = '';
  late AccessibilityControllerState _state;

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
          if (state is ThirdStageOpenState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildTitle(state.title!),
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
                          customBackFunction: () async {
                            await _backManager(state.finalList, state);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  isFound
                      ? const SizedBox()
                      : Column(
                          children: [
                            _buildQuestionCounter(
                                state.finalList[index].questions),
                            _buildQuestion(state.finalList[index]
                                .questions![questionIndex].question!),
                            (MediaQuery.of(context).size.width > 768)
                                ? _buildButtons(state.finalList, state)
                                : _buildMobileButtons(state.finalList, state),
                          ],
                        ),
                  const SizedBox(height: 50),
                  isFound
                      ? Column(
                          children: [
                            (MediaQuery.of(context).size.width > 768)
                                ? _buildInfoRow(state)
                                : _buildMobileInfoRow(state),
                            const SizedBox(height: 50),
                          ],
                        )
                      : const SizedBox(),
                  (index == 1 && questionIndex == 0 ||
                          index == 1 && questionIndex == 1 ||
                          index == 4 && questionIndex == 0 ||
                          index == 5 && questionIndex == 0)
                      ? _buildRecomendations(index, questionIndex)
                      : const SizedBox(),
                  const SizedBox(height: 50),
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

  Widget _buildMobileInfoRow(ThirdStageOpenState state) {
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

  Widget _buildMobileInfo(ThirdStageOpenState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SelectableText(
            'Atliekos identifikavimas baigtas',
            style: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.smallNavTitleStyle
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.smallNavTitleStyle
                    : TextStyles.smallNavTitleStyle,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: [
                const SizedBox(height: 30),
                SizedBox(
                  width: 340,
                  child: SelectableText(
                    'Atliekos Apibūdinimas',
                    style: _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.mobileTrashDescription
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.mobileTrashDescription
                            : TextStyles.mobileTrashDescription,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 340,
                  child: SelectableText(
                    foundString == "AN"
                        ? 'Atliekos turi būti klasifikuojamos labiausiai joms tinkamo apibūdinimo VN tipo atliekų kodu ir tvarkomos kaip nepavojingosios atliekos'
                        : 'Atliekos turi būti klasifikuojamos labiausiai joms tinkamo apibūdinimo VP tipo atliekų kodu ir tvarkomos kaip pavojingosios atliekos',
                    style: _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.mobileTrashDescriptionStyle
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.mobileTrashDescriptionStyle
                            : TextStyles.mobileTrashDescriptionStyle,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 340,
                  child: SelectableText(
                    'Atliekos Kodas',
                    style: _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.mobileTrashDescription
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.mobileTrashDescription
                            : TextStyles.mobileTrashDescription,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 340,
                  child: Row(
                    children: [
                      Image.asset(
                        foundString == "AN"
                            ? Strings.approved_mark
                            : Strings.red_exclemation_mark,
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                      SelectableText(
                        foundString == "AN"
                            ? 'Nepavojinga atlieka'
                            : 'Pavojinga atlieka',
                        style:
                            _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.mobileItemCodeStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.mobileItemCodeStyle
                                    : TextStyles.mobileItemCodeStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
          DefaultAccentButton(
            title: 'Skaityti daugiau',
            textPadding: _state.status == AccessibilityControllerStatus.normal
                ? const EdgeInsets.only(top: 5)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? const EdgeInsets.only(top: 10)
                    : const EdgeInsets.only(top: 7),
            textStyle: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.searchBtnStyle
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.searchBtnStyle
                    : TextStyles.searchBtnStyle,
            onPressed: () {
              widget.firstStageBloc.add(
                CodeFoundAfterThirdStageEvent(
                  trashTitle: foundString == "AN"
                      ? 'Atliekos turi būti klasifikuojamos labiausiai joms tinkamo apibūdinimo VN tipo atliekų kodu ir tvarkomos kaip nepavojingosios atliekos'
                      : 'Atliekos turi būti klasifikuojamos labiausiai joms tinkamo apibūdinimo VP tipo atliekų kodu ir tvarkomos kaip pavojingosios atliekos',
                  trashType: foundString,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(ThirdStageOpenState state) {
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

  Widget _buildInfo(ThirdStageOpenState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Atliekos identifikavimas baigtas',
            style: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.itemTitleStyle
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.itemTitleStyle
                    : TextStyles.itemTitleStyle,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Atliekos apibūdinimas',
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.selectorDescriptionTitleStyle
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.selectorDescriptionTitleStyle
                          : TextStyles.selectorDescriptionTitleStyle,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    'Atliekos įvertinimas',
                    style: _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.selectorDescriptionTitleStyle
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.selectorDescriptionTitleStyle
                            : TextStyles.selectorDescriptionTitleStyle,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: const BoxDecoration(
                color: AppStyle.appBarWebColor,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        foundString == "AN"
                            ? 'Atliekos turi būti klasifikuojamos labiausiai joms tinkamo apibūdinimo VN tipo atliekų kodu ir tvarkomos kaip nepavojingosios atliekos'
                            : 'Atliekos turi būti klasifikuojamos labiausiai joms tinkamo apibūdinimo VP tipo atliekų kodu ir tvarkomos kaip pavojingosios atliekos',
                        style:
                            _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.contentDescription
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.contentDescription
                                    : TextStyles.contentDescription,
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          foundString == "AN"
                              ? Strings.approved_mark
                              : Strings.red_exclemation_mark,
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(width: 20),
                        Text(
                          foundString == "AN" ? 'Nepavojinga' : 'Pavojinga',
                          style:
                              _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.itemCodeStyle
                                  : _state.status ==
                                          AccessibilityControllerStatus.biggest
                                      ? TextStylesBiggest.itemCodeStyle
                                      : TextStyles.itemCodeStyle,
                        )
                      ],
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 150,
                      child: DefaultAccentButton(
                        title: 'Skaityti daugiau',
                        textPadding: _state.status ==
                                AccessibilityControllerStatus.normal
                            ? const EdgeInsets.only(top: 5)
                            : _state.status ==
                                    AccessibilityControllerStatus.biggest
                                ? const EdgeInsets.only(top: 10)
                                : const EdgeInsets.only(top: 7),
                        btnColor: AppStyle.greenBtnUnHoover,
                        onPressed: () {
                          widget.firstStageBloc.add(
                            CodeFoundAfterThirdStageEvent(
                              trashTitle: foundString == "AN"
                                  ? 'Atliekos turi būti klasifikuojamos labiausiai joms tinkamo apibūdinimo VN tipo atliekų kodu ir tvarkomos kaip nepavojingosios atliekos'
                                  : 'Atliekos turi būti klasifikuojamos labiausiai joms tinkamo apibūdinimo VP tipo atliekų kodu ir tvarkomos kaip pavojingosios atliekos',
                              trashType: foundString,
                            ),
                          );
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecomendations(int index, int questionIndex) {
    return SelectionArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width > 768) ? 50 : 25,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppStyle.appBarWebColor,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRecomendationTitle(),
                const SizedBox(height: 20),
                (index == 1 && questionIndex == 0)
                    ? _buildDotText(
                        'Vertinama informacija, pateikta produkto, kurio atlieka vertinama, sudėtį apibūdinančiuose dokumentuose (pavyzdžiui, žaliavų gamintojo informacija, saugos duomenų lapai, etiketės, vardinių parametrų lentelės, geriausių prieinamų gamybos būdų informacinių dokumentų ataskaitos, pramonės procesų vadovai, procesų aprašai ir žaliavų sąrašai ir pan.).')
                    : (index == 1 && questionIndex == 1)
                        ? _buildDotText(
                            'Jei vertinamose atliekose yra vienas ar daugiau POT, nurodytų 2019 m. birželio 20 d. Europos Parlamento ir Tarybos reglamento (ES) 2019/1021 dėl patvariųjų organinių teršalų (nauja redakcija), vertinama, ar jų koncentracija neviršija tame pačiame priede jiems nustatytų ribinių koncentracijų. Jei ištirta POT koncentracija viršija Reglamente (ES) 2019/1021 jiems nustatytą ribinę vertę, šios atliekos turi būti tvarkomos vadovaujantis Reglamento (ES) 2019/1021 nuostatomis.')
                        : (index == 4 && questionIndex == 0)
                            ? Column(
                                children: [
                                  _buildDotText(
                                      '2008 m. gruodžio 16 d. Europos Parlamento ir Tarybos reglamente (EB) Nr. 1272/2008 dėl cheminių medžiagų ir mišinių klasifikavimo, ženklinimo ir pakavimo, iš dalies keičiantis ir panaikinantis direktyvas 67/548/EEB bei 1999/45/EB ir iš dalies keičiantis Reglamentą (EB) Nr. 1907/2006 (CLP reglamentas) numatyti kriterijai, pagal kuriuos siūloma vertinti medžiagų keliamus fizinius pavojus ir pavojus žmonių sveikatai ir aplinkai. Cheminė medžiaga klasifikuojama kaip pavojinga, jei atitinka vienos arba daugiau CLP reglamente nustatytų pavojingumo klasių kriterijus.'),
                                  _buildDotText(
                                      'ECHA tvarkomu klasifikavimo ir ženklinimo inventoriumi galima pasinaudoti ieškant medžiagų ar medžiagų grupės, kuri yra svarbi klasifikuojant atliekas, klasifikacijos.'),
                                  _buildDotText(
                                      'Medžiagoms ir mišiniams, klasifikuojamiems pagal CLP reglamentą kaip pavojingieji, ir neklasifikuotiems mišiniams, kuriuose yra tam tikras ribines vertes viršijančių pavojingųjų medžiagų, tiekėjas turi pateikti saugos duomenų lapą, kuriame turi būti informacija, naudinga atliekant atliekų pavojingumo vertinimą.'),
                                  _buildDotText(
                                      'Informacijos apie atliekų sudėtyje esančių medžiagų pavojingumą taip pat galima rasti ir kituose informacijos šaltiniuose, pvz., duomenys apie policiklinių angliavandenilių pavojingumo frazes nurodyti periodiškai atnaujinamose CONCAWE ataskaitose Hazard classification and labelling of petroleum substances in the European Economic Area – 2021.'),
                                  _buildDotText(
                                      'Renkant informaciją apie atliekų sudėtyje esančių medžiagų pavojingumą surinkti duomenys apie pavojingumo frazes, pavojingas savybes reikalingi atliekant atliekų pavojingumo įvertinimą (4 žingsnis).'),
                                ],
                              )
                            : (index == 5 && questionIndex == 0)
                                ? _buildDotText(
                                    'Vertinant atliekų pavojingąsias savybes vadovaujamasi 2014 m. gruodžio 18 d. Komisijos reglamento (ES) Nr. 1357/2014, kuriuo pakeičiamas Europos Parlamento ir Tarybos direktyvos 2008/98/EB dėl atliekų ir panaikinančios kai kurias direktyvas III priedas nuostatomis.. Taip nustatoma, ar atliekos dėl jose esančių pavojingų medžiagų koncentracijų pasižymi viena ar daugiau pavojingųjų savybių.')
                                : _buildDotText(''),
              ],
            ),
          ),
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

  Widget _buildRecomendationTitle() {
    return Text(
      'Kaip atlikti vertinimą?',
      style: _state.status == AccessibilityControllerStatus.big
          ? TextStylesBigger.recommendationTitleStyle
          : _state.status == AccessibilityControllerStatus.biggest
              ? TextStylesBiggest.recommendationTitleStyle
              : TextStyles.recommendationTitleStyle,
    );
  }

  Widget _buildMobileButtons(
      List<FinalList> finalList, ThirdStageOpenState state) {
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
              onPressed: () async {
                await _yesController(finalList, state);
                setState(() {});
              },
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
              onPressed: () async {
                await _noController(finalList, state);
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(List<FinalList> finalList, ThirdStageOpenState state) {
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
            onPressed: () async {
              await _yesController(finalList, state);
              setState(() {});
            },
          ),
          const SizedBox(width: 30),
          DefaultAccentButton(
            title: 'Ne',
            textPadding: _state.status == AccessibilityControllerStatus.normal
                ? const EdgeInsets.only(top: 5)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? const EdgeInsets.only(top: 10)
                    : const EdgeInsets.only(top: 7),
            isHooverAnimationEnabled: true,
            btnColor: AppStyle.importantMark,
            textStyle: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.footerBold
                    .copyWith(color: AppStyle.scaffoldColor)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.footerBold
                        .copyWith(color: AppStyle.scaffoldColor)
                    : TextStyles.footerBold
                        .copyWith(color: AppStyle.scaffoldColor),
            onPressed: () async {
              await _noController(finalList, state);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCounter(List<FinalQuestions>? questions) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // (questions!.length == 1) ? const SizedBox() : MouseRegion(
          //   onEnter: (e) {
          //     if (questionIndex > 0) {
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
          //     if (questionIndex > 0) {
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
          //       hoverColor: (questionIndex > 0)
          //           ? AppStyle.greyHooverColor
          //           : Colors.transparent,
          //       splashRadius: (questionIndex > 0) ? 30 : 1,
          //       onPressed: () {
          //         if (questionIndex > 0) {
          //           questionIndex = questionIndex - 1;
          //         }
          //         setState(() {});
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
              '${questionIndex + 1}/${questions!.length}',
              style: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.questionsCounter
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.questionsCounter
                      : TextStyles.questionsCounter,
            ),
          ),
          // (questions.length == 1) ? const SizedBox() : MouseRegion(
          //   onEnter: (e) {
          //     if (questionIndex != questions.length - 1) {
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
          //     if (questionIndex != questions.length - 1) {
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
          //     hoverColor:
          //         frontHover ? AppStyle.greyHooverColor : Colors.transparent,
          //     iconSize: 30,
          //     onPressed: () {
          //       if (questionIndex != questions.length - 1) {
          //         questionIndex = questionIndex + 1;
          //         setState(() {});
          //       }
          //     },
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

  Widget _buildQuestion(String question) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.06,
        vertical: (MediaQuery.of(context).size.width > 768) ? 50 : 20,
      ),
      child: SelectionArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text(
            question,
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
                    '3',
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

  Future<void> _yesController(
      List<FinalList> finalList, ThirdStageOpenState state) async {
    await _tracker();
    if (finalList[index].questions![questionIndex].ifYesGetType != null) {
      foundString = finalList[index].questions![questionIndex].ifYesGetType!;
      isFound = true;
    } else if (finalList[index].questions![questionIndex].ifYesGoToId != null) {
      index = finalList.indexWhere((e) =>
          e.id == finalList[index].questions![questionIndex].ifYesGoToId);
      state.title = finalList[index].title;
      questionIndex = 0;
      isFound = false;
    } else {
      questionIndex = questionIndex + 1;
      isFound = false;
    }
  }

  Future<void> _noController(
      List<FinalList> finalList, ThirdStageOpenState state) async {
    await _tracker();
    if (finalList[index].questions![questionIndex].ifNoGetType != null) {
      foundString = finalList[index].questions![questionIndex].ifNoGetType!;
      isFound = true;
    } else if (finalList[index].questions![questionIndex].ifNoGoToId != null) {
      index = finalList.indexWhere(
          (e) => e.id == finalList[index].questions![questionIndex].ifNoGoToId);
      state.title = finalList[index].title;
      questionIndex = 0;
      isFound = false;
    } else {
      questionIndex = questionIndex + 1;
      isFound = false;
    }
  }

  Future<void> _tracker() async {
    indexValue = await storage.getItem('index');
    questionIndexValue = await storage.getItem('questionIndex');
    if (indexValue != null && questionIndexValue != null) {
      List<int> indexList = indexValue;
      List<int> questionIndexList = questionIndexValue;
      indexList.add(index);
      questionIndexList.add(questionIndex);
      await storage.setItem('index', indexList);
      await storage.setItem('questionIndex', questionIndexList);
    } else {
      await storage.setItem('index', [index]);
      await storage.setItem('questionIndex', [questionIndex]);
    }
  }

  Future<void> _backManager(
      List<FinalList> finalList, ThirdStageOpenState state) async {
    indexValue = await storage.getItem('index');
    questionIndexValue = await storage.getItem('questionIndex');
    if (indexValue != null &&
        indexValue.isNotEmpty &&
        questionIndexValue != null &&
        questionIndexValue.isNotEmpty) {
      index = indexValue.last;
      questionIndex = questionIndexValue.last;
      state.title = finalList[index].title;
      indexValue.removeLast();
      questionIndexValue.removeLast();
      await storage.setItem('index', indexValue);
      await storage.setItem('questionIndex', questionIndexValue);
      if (isFound) {
        isFound = false;
        foundString = '';
      }
    } else {
      widget.firstStageBloc.add(OpenFirstStageEvent());
    }
  }
}
