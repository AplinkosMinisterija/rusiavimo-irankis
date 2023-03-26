import 'package:aplinkos_ministerija/bloc/how_to_use/how_to_use_bloc.dart';
import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:aplinkos_ministerija/constants/information_strings.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/stages_cotroller/first_stage_bloc.dart';
import '../../constants/app_colors.dart';
import '../../model/final_stage_models/final_list.dart';
import '../../model/final_stage_models/final_questions.dart';
import '../styles/text_styles.dart';
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
  bool backHover = false;
  bool frontHover = false;
  bool isFound = false;
  int index = 0;
  int questionIndex = 0;
  int questionAnsweredCounter = 1;
  String foundString = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirstStageBloc, FirstStageState>(
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
                (index == 1 && questionIndex == 0)
                    ? _buildRecomendations()
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
                color: AppColors.blue,
              )
            ],
          );
        }
      },
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
            color: AppColors.greenBtnUnHoover,
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
          const SelectableText(
            'Atliekos identifikavimas baigtas',
            style: TextStyles.smallNavTitleStyle,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: [
                const SizedBox(height: 30),
                const SizedBox(
                  width: 340,
                  child: SelectableText(
                    'Atliekos Apibūdinimas',
                    style: TextStyles.mobileTrashDescription,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 340,
                  child: SelectableText(
                    state.trashTitle!.toCapitalized(),
                    style: TextStyles.mobileTrashDescriptionStyle,
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  width: 340,
                  child: SelectableText(
                    'Atliekos Kodas',
                    style: TextStyles.mobileTrashDescription,
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
                        style: TextStyles.mobileItemCodeStyle,
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
            textStyle: TextStyles.mobileTitleStyle,
            paddingFromTop: 10,
            onPressed: () {
              widget.firstStageBloc.add(
                CodeFoundAfterThirdStageEvent(
                  trashTitle: state.trashTitle,
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
            color: AppColors.greenBtnUnHoover,
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
          const Text(
            'Atliekos identifikavimas baigtas',
            style: TextStyles.itemTitleStyle,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Atliekos apibūdinimas',
                  style: TextStyles.selectorDescriptionTitleStyle,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Text(
                    'Atliekos įvertinimas',
                    style: TextStyles.selectorDescriptionTitleStyle,
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
                color: AppColors.appBarWebColor,
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
                        style: TextStyles.contentDescription,
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
                          style: TextStyles.itemCodeStyle,
                        )
                      ],
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 150,
                      child: DefaultAccentButton(
                        title: 'Skaityti daugiau',
                        btnColor: AppColors.greenBtnUnHoover,
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
                        textStyle: TextStyles.searchBtnStyle,
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

  Widget _buildRecomendations() {
    return SelectionArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.appBarWebColor,
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
                _buildDotText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDotText() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '* ',
                style: TextStyles.descriptionNormal,
              ),
              Expanded(
                child: Text(
                  'Vertinama informacija, pateikta produkto, kurio atlieka vertinama, sudėtį apibūdinančiuose dokumentuose (pavyzdžiui, žaliavų gamintojo informacija, saugos duomenų lapai, etiketės, vardinių parametrų lentelės, geriausių prieinamų gamybos būdų informacinių dokumentų ataskaitos, pramonės procesų vadovai, procesų aprašai ir žaliavų sąrašai ir pan.).',
                  style: TextStyles.descriptionNormal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecomendationTitle() {
    return const Text(
      'Kaip atlikti vertinimą?',
      style: TextStyles.recommendationTitleStyle,
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
              paddingFromTop: 10,
              textStyle: TextStyles.footerBold
                  .copyWith(color: AppColors.scaffoldColor),
              onPressed: () {
                _yesController(finalList, state);
              },
            ),
          ),
          SizedBox(
            width: 150,
            child: DefaultAccentButton(
              title: 'Ne',
              paddingFromTop: 10,
              btnColor: AppColors.importantMark,
              textStyle: TextStyles.footerBold
                  .copyWith(color: AppColors.scaffoldColor),
              onPressed: () {
                _noController(finalList, state);
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
            paddingFromTop: 10,
            textStyle:
                TextStyles.footerBold.copyWith(color: AppColors.scaffoldColor),
            onPressed: () {
              _yesController(finalList, state);
            },
          ),
          const SizedBox(width: 30),
          DefaultAccentButton(
            title: 'Ne',
            paddingFromTop: 10,
            btnColor: AppColors.importantMark,
            textStyle:
                TextStyles.footerBold.copyWith(color: AppColors.scaffoldColor),
            onPressed: () {
              _noController(finalList, state);
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
          MouseRegion(
            onEnter: (e) {
              if (questionIndex > 0) {
                setState(() {
                  backHover = true;
                });
              } else {
                setState(() {
                  backHover = false;
                });
              }
            },
            onExit: (e) {
              if (questionIndex > 0) {
                setState(() {
                  backHover = false;
                });
              } else {
                setState(() {
                  backHover = false;
                });
              }
            },
            child: RotatedBox(
              quarterTurns: 2,
              child: IconButton(
                iconSize: 30,
                hoverColor: (questionIndex > 0)
                    ? AppColors.greyHooverColor
                    : Colors.transparent,
                splashRadius: (questionIndex > 0) ? 30 : 1,
                onPressed: () {
                  if (questionIndex > 0) {
                    questionIndex = questionIndex - 1;
                  }
                  setState(() {});
                },
                icon: Icon(
                  Icons.play_circle,
                  color: backHover
                      ? AppColors.greenBtnUnHoover
                      : AppColors.helpIconColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Text(
              '$questionAnsweredCounter/X',
              style: TextStyles.questionsCounter,
            ),
          ),
          MouseRegion(
            onEnter: (e) {
              if (questionIndex != questions!.length - 1) {
                setState(() {
                  frontHover = true;
                });
              } else {
                setState(() {
                  frontHover = false;
                });
              }
            },
            onExit: (e) {
              if (questionIndex != questions!.length - 1) {
                setState(() {
                  frontHover = false;
                });
              } else {
                setState(() {
                  frontHover = false;
                });
              }
            },
            child: IconButton(
              hoverColor:
                  frontHover ? AppColors.greyHooverColor : Colors.transparent,
              iconSize: 30,
              onPressed: () {
                if (questionIndex != questions!.length - 1) {
                  questionIndex = questionIndex + 1;
                  setState(() {});
                }
              },
              icon: Icon(
                Icons.play_circle,
                color: frontHover
                    ? AppColors.greenBtnUnHoover
                    : AppColors.helpIconColor,
              ),
            ),
          )
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
                ? TextStyles.contentDescription
                : TextStyles.mobileContentDescription,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      color: AppColors.greenBtnUnHoover,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.scaffoldColor,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    '3',
                    style: TextStyles.numberTextStyle
                        .copyWith(color: AppColors.greenBtnUnHoover),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 50),
            Expanded(
              child: SelectableText(
                title,
                style: (MediaQuery.of(context).size.width > 768)
                    ? TextStyles.howToUseTitleStyle
                        .copyWith(color: AppColors.scaffoldColor)
                    : TextStyles.mobileTitleStyle,
              ),
            ),
            HowToUseTool(howToUseBloc: widget.howToUseBloc),
          ],
        ),
      ),
    );
  }

  void _yesController(List<FinalList> finalList, ThirdStageOpenState state) {
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
    questionAnsweredCounter++;
    setState(() {});
  }

  void _noController(List<FinalList> finalList, ThirdStageOpenState state) {
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
    questionAnsweredCounter++;
    setState(() {});
  }
}
