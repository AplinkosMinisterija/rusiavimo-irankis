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
import '../widgets/button.dart';

class ThirdStageScreen extends StatefulWidget {
  final FirstStageBloc firstStageBloc;

  const ThirdStageScreen({
    super.key,
    required this.firstStageBloc,
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
                _buildRecomendations(),
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
          DefaultAccentButton(
            title: 'Eiti toliau',
            textStyle: TextStyles.mobileTitleStyle,
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
                        state.trashTitle.toCapitalized(),
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
                        title: 'Eiti toliau',
                        btnColor: AppColors.greenBtnUnHoover,
                        onPressed: () {
                          widget.firstStageBloc.add(
                            CodeFoundAfterThirdStageEvent(
                              trashTitle: state.trashTitle,
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
              horizontal: 50,
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
            children: [
              const Text(
                '* ',
                style: TextStyles.descriptionNormal,
              ),
              Expanded(
                child: Text(
                  InformationStrings.recommendationsListStrings[0],
                  style: TextStyles.descriptionNormal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '* ',
                style: TextStyles.descriptionNormal,
              ),
              Expanded(
                child: Text(
                  InformationStrings.recommendationsListStrings[0],
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
        horizontal: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 150,
            child: DefaultAccentButton(
              title: 'Taip',
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
      padding: EdgeInsets.symmetric(
        vertical: 50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DefaultAccentButton(
            title: 'Taip',
            textStyle:
                TextStyles.footerBold.copyWith(color: AppColors.scaffoldColor),
            onPressed: () {
              _yesController(finalList, state);
            },
          ),
          const SizedBox(width: 30),
          DefaultAccentButton(
            title: 'Ne',
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
