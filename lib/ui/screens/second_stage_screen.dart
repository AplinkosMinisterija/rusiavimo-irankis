import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:aplinkos_ministerija/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../model/second_stage_models/questions.dart';
import '../styles/text_styles.dart';

class SecondStageScreen extends StatefulWidget {
  final FirstStageBloc firstStageBloc;
  const SecondStageScreen({
    super.key,
    required this.firstStageBloc,
  });

  @override
  State<SecondStageScreen> createState() => _SecondStageScreenState();
}

class _SecondStageScreenState extends State<SecondStageScreen> {
  bool backHover = false;
  bool frontHover = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirstStageBloc, FirstStageState>(
      builder: (context, state) {
        if (state is SecondStageOpenState) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildTitle(state.category.title!),
                _buildQuestionCounter(state.category.questionsList!),
                _buildQuestion(state.category.questionsList!),
                _buildButtons(state.category.questionsList!),
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

  Widget _buildButtons(List<Questions> questions) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.3,
        vertical: 50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultAccentButton(
            title: 'Taip',
            textStyle:
                TextStyles.footerBold.copyWith(color: AppColors.scaffoldColor),
            onPressed: () {
              if (questions[_counter(questions)].progress == true) {
                questions[_counter(questions)].isAnswered = true;
              } else if (questions[_counter(questions)].ifWrongIsMovable ==
                  true) {
                //TODO: move to other stage
                print('TAIP -> movable!');
              } else {
                print('TAIP -> recomendations!');
                //TODO: move to recomendations
              }
              setState(() {});
            },
          ),
          DefaultAccentButton(
            title: 'Ne',
            btnColor: AppColors.importantMark,
            textStyle:
                TextStyles.footerBold.copyWith(color: AppColors.scaffoldColor),
            onPressed: () {
              if (questions[_counter(questions)].progress == false) {
                questions[_counter(questions)].isAnswered = true;
              } else if (questions[_counter(questions)].ifWrongIsMovable ==
                  true) {
                //TODO: move to other stage
                print('Ne -> movable!');
              } else {
                print('Ne -> recomendations!');
                //TODO: move to recomendations
              }
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(List<Questions> questions) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.06,
        vertical: 50,
      ),
      child: SelectionArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text(
            questions[_counter(questions) - 1].question!,
            textAlign: TextAlign.center,
            style: TextStyles.contentDescription,
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCounter(List<Questions> questions) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MouseRegion(
            onEnter: (e) {
              if (_counter(questions) != 1) {
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
              if (_counter(questions) != 1) {
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
                hoverColor: (_counter(questions) != 1)
                    ? AppColors.greyHooverColor
                    : Colors.transparent,
                splashRadius: (_counter(questions) != 1) ? 30 : 1,
                onPressed: () {
                  if (_counter(questions) != 1) {
                    setState(() {
                      questions[_counter(questions) - 2].isAnswered = null;
                    });
                  }
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
              '${_counter(questions)}/${questions.length}',
              style: TextStyles.questionsCounter,
            ),
          ),
          MouseRegion(
            onEnter: (e) {
              if (_counter(questions) < questions.length) {
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
              if (_counter(questions) < questions.length) {
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
              hoverColor: (_counter(questions) < questions.length)
                  ? AppColors.greyHooverColor
                  : Colors.transparent,
              iconSize: 30,
              onPressed: () {
                if (_counter(questions) < questions.length) {
                  setState(() {
                    questions[_counter(questions) - 1].isAnswered = false;
                  });
                }
              },
              splashRadius: (_counter(questions) < questions.length) ? 30 : 1,
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
                    '2',
                    style: TextStyles.numberTextStyle
                        .copyWith(color: AppColors.greenBtnUnHoover),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 50),
            SelectableText(
              title,
              style: TextStyles.howToUseTitleStyle
                  .copyWith(color: AppColors.scaffoldColor),
            ),
          ],
        ),
      ),
    );
  }

  int _counter(List<Questions> questions) {
    int answeredQuestions = 1;
    for (var i = 0; i < questions.length; i++) {
      if (questions[i].isAnswered != null) {
        answeredQuestions = i + 2;
      }
    }
    return answeredQuestions;
  }
}
