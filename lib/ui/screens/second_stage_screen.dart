import 'dart:async';

import 'package:aplinkos_ministerija/bloc/how_to_use/how_to_use_bloc.dart';
import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:aplinkos_ministerija/model/second_stage_models/second_category.dart';
import 'package:aplinkos_ministerija/ui/widgets/button.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../constants/information_strings.dart';
import '../../constants/strings.dart';
import '../../model/category.dart';
import '../../model/items.dart';
import '../../model/second_stage_models/questions.dart';
import '../../utils/app_dialogs.dart';
import '../styles/text_styles.dart';
import '../widgets/back_btn.dart';
import '../widgets/how_to_use_tool.dart';
import '../widgets/not_found.dart';

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
  OverlayEntry? overlay;
  bool backHover = false;
  bool frontHover = false;
  bool isLastQuestionPassed = false;
  int index = 0;
  bool isQuestionsHidden = false;
  List<Items> trashList = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirstStageBloc, FirstStageState>(
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
                            ),
                          ],
                        ),
                      ),
                      trashList.isNotEmpty
                          ? Column(
                              children: [
                                _buildFinishContent(state.trashTitle,
                                    state.trashCode, state.trashType),
                                (MediaQuery.of(context).size.width > 768)
                                    ? _buildInfoRow()
                                    : _buildMobileInfoRow(),
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
                            ),
                          ],
                        ),
                      ),
                      isQuestionsHidden
                          ? const SizedBox(height: 10)
                          : Column(
                              children: [
                                _buildQuestionCounter(
                                    state.category.questionsList!),
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
                            ),
                      trashList.isNotEmpty
                          ? Column(
                              children: [
                                (MediaQuery.of(context).size.width > 768)
                                    ? _buildInfoRow()
                                    : _buildMobileInfoRow(),
                                const SizedBox(height: 20),
                              ],
                            )
                          : (index == 0 && state.category.id == 0)
                              ? Column(
                                  children: [
                                    _buildRecomendations(),
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
                color: AppColors.blue,
              )
            ],
          );
        }
      },
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
              crossAxisAlignment: (MediaQuery.of(context).size.width > 768)
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
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
                  'Praktiškai tuščia pakuotė yra tinkamai ištuštinta (be tokių likučių, kaip milteliai, nuosėdos ir lašai; pakuotė išvalyta šepečiu ar mentele), išskyrus neišvengiamus likučius, kurių negalima pašalinti netaikant papildomų pakuotės valymo priemonių, tokių kaip šildymas (toliau – praktiškai tuščia pakuotė). Iš praktiškai tuščios pakuotės, vėl bandant ją tuštinti, pavyzdžiui, pakuotę apvertus, turi niekas nelašėti ir nekristi kieti medžiagų likučiai. Tai netaikoma talpyklų valymui.',
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
    if (MediaQuery.of(context).size.width < 768) {
      return const Align(
        alignment: Alignment.center,
        child: Text(
          'Kaip atlikti vertinimą?',
          style: TextStyles.recommendationTitleStyle,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return const Text(
        'Kaip atlikti vertinimą?',
        style: TextStyles.recommendationTitleStyle,
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
            child: const Text(
              'Ar tai jūsų ieškoma atlieka/os?',
              textAlign: TextAlign.center,
              style: TextStyles.contentDescription,
            ),
          ),
          const SizedBox(height: 20),
          DefaultAccentButton(
            title: 'Ne',
            paddingFromTop: 10,
            btnColor: AppColors.importantMark,
            textStyle:
                TextStyles.footerBold.copyWith(color: AppColors.scaffoldColor),
            onPressed: () {
              codeNotFoundDialog(context, trashTitle, trashCode, trashType);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileInfoRow() {
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
        child: _buildMobileInfo(),
      ),
    );
  }

  Widget _buildMobileInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SelectableText(
            'Numanomi atliekos kodai',
            style: TextStyles.smallNavTitleStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                trashList.length,
                (i) {
                  return Column(
                    children: [
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
                          trashList[i].itemName!.toCapitalized(),
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
                      Wrap(
                        children: [
                          Image.asset(
                            trashList[i].type == "AN"
                                ? Strings.approved_mark
                                : (trashList[i].type == "VP" ||
                                        trashList[i].type == "VN")
                                    ? Strings.question_mark
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
                                style: TextStyles.mobileItemCodeStyle,
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
                        title: 'Eiti toliau',
                        textStyle: TextStyles.mobileTitleStyle,
                        paddingFromTop: 10,
                        onPressed: () {
                          if (trashList[i].type == "AP" ||
                              trashList[i].type == "AN") {
                            widget.firstStageBloc.add(
                              CodeFoundEvent(
                                title: trashList[i].itemName,
                                trashCode: trashList[i].code,
                                trashType: trashList[i].type,
                              ),
                            );
                          } else {
                            widget.firstStageBloc.add(OpenThirdStageEvent(
                              trashTitle: trashList[i].itemName!,
                              trashCode: trashList[i].code!,
                              trashType: trashList[i].type!,
                              listOfCategories: widget.listOfCategories,
                            ));
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
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
        child: _buildInfo(),
      ),
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SelectableText(
            'Numanomi atliekos kodai',
            style: TextStyles.itemTitleStyle,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SelectableText(
                  'Atliekos apibūdinimas',
                  style: TextStyles.selectorDescriptionTitleStyle,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 150),
                  child: SelectableText(
                    'Atliekos kodas',
                    style: TextStyles.selectorDescriptionTitleStyle,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: List.generate(
                trashList.length,
                (i) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
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
                              child: SelectableText(
                                trashList[i].itemName!.toCapitalized(),
                                style: TextStyles.contentDescription,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Image.asset(
                                  trashList[i].type == "AN"
                                      ? Strings.approved_mark
                                      : Strings.red_exclemation_mark,
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(width: 10),
                                SelectableText(
                                  trashList[i].type!,
                                  style: TextStyles.itemCodeStyle,
                                ),
                                const SizedBox(width: 10),
                                SelectionArea(
                                  child: _buildItemCode(trashList[i]),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 150,
                              child: DefaultAccentButton(
                                title: 'Eiti toliau',
                                btnColor: AppColors.greenBtnUnHoover,
                                onPressed: () {
                                  if (trashList[i].type == "AP" ||
                                      trashList[i].type == "AN") {
                                    widget.firstStageBloc.add(
                                      CodeFoundEvent(
                                        title: trashList[i].itemName,
                                        trashCode: trashList[i].code,
                                        trashType: trashList[i].type,
                                      ),
                                    );
                                  } else {
                                    widget.firstStageBloc
                                        .add(OpenThirdStageEvent(
                                      trashTitle: trashList[i].itemName!,
                                      trashCode: trashList[i].code!,
                                      trashType: trashList[i].type!,
                                      listOfCategories: widget.listOfCategories,
                                    ));
                                  }
                                },
                                textStyle: TextStyles.searchBtnStyle,
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
        ],
      ),
    );
  }

  Widget _buildItemCode(Items trashItem) {
    return Row(
      children: [
        _buildCodeWindow(trashItem.code!.split(' ')[0], trashItem),
        _buildCodeWindow(trashItem.code!.split(' ')[1], trashItem),
        _buildCodeWindow(
            trashItem.code!.split(' ')[2].split('*')[0], trashItem),
        _buildCodeWindow('', trashItem),
        _buildCodeWindow(trashItem.code!.contains('*') ? '*' : '', trashItem),
      ],
    );
  }

  Widget _buildCodeWindow(String codePart, Items trashItem) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: AppColors.scaffoldColor,
          border: Border.all(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                codePart,
                style: TextStyles.itemCodeStyle,
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
              textStyle: TextStyles.footerBold
                  .copyWith(color: AppColors.scaffoldColor),
              paddingFromTop: 10,
              onPressed: () {
                trashList.clear();
                index++;
                _getTrashList(category.questionsList![index - 1]);
                if (category.id != 1) {
                  if (index > category.questionsList!.length - 1) {
                    isLastQuestionPassed = true;
                  }
                  if (trashList.isEmpty && isLastQuestionPassed) {
                    codeNotFoundDialog(context, trashTitle, trashCode, trashType);
                  }
                } else {
                  isQuestionsHidden = true;
                  if (trashList.isEmpty) {
                    codeNotFoundDialog(
                        context, trashTitle, trashCode, trashType);
                  }
                }
                setState(() {});
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
                trashList.clear();
                index++;
                _getTrashList(category.questionsList![index - 1]);
                if (index > category.questionsList!.length - 1) {
                  isLastQuestionPassed = true;
                }
                if (trashList.isEmpty && isLastQuestionPassed) {
                  codeNotFoundDialog(context, trashTitle, trashCode, trashType);
                }
                setState(() {});
              },
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
            textStyle:
                TextStyles.footerBold.copyWith(color: AppColors.scaffoldColor),
            paddingFromTop: 10,
            onPressed: () {
              trashList.clear();
              index++;
              _getTrashList(category.questionsList![index - 1]);
              if (category.id != 1) {
                if (index > category.questionsList!.length - 1) {
                  isLastQuestionPassed = true;
                }
                if (trashList.isEmpty && isLastQuestionPassed) {
                  codeNotFoundDialog(context, trashTitle, trashCode, trashType);
                }
              } else {
                isQuestionsHidden = true;
                if (trashList.isEmpty) {
                  codeNotFoundDialog(context, trashTitle, trashCode, trashType);
                }
              }
              setState(() {});
            },
          ),
          const SizedBox(width: 30),
          DefaultAccentButton(
            title: 'Ne',
            btnColor: AppColors.importantMark,
            textStyle:
                TextStyles.footerBold.copyWith(color: AppColors.scaffoldColor),
            paddingFromTop: 10,
            onPressed: () {
              trashList.clear();
              index++;
              _getTrashList(category.questionsList![index - 1]);
              if (index > category.questionsList!.length - 1) {
                isLastQuestionPassed = true;
              }
              if (trashList.isEmpty && isLastQuestionPassed) {
                codeNotFoundDialog(context, trashTitle, trashCode, trashType);
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
        vertical: (MediaQuery.of(context).size.width > 768) ? 50 : 20,
      ),
      child: SelectionArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Text(
            questions[index].question!,
            textAlign: TextAlign.center,
            style: (MediaQuery.of(context).size.width > 768)
                ? TextStyles.contentDescription
                : TextStyles.mobileContentDescription,
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
              if (index != 0) {
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
              if (index != 0) {
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
                hoverColor: (index != 0)
                    ? AppColors.greyHooverColor
                    : Colors.transparent,
                splashRadius: (index != 0) ? 30 : 1,
                onPressed: () {
                  if (index != 0) {
                    setState(() {
                      index--;
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
              '${index + 1}/${questions.length}',
              style: TextStyles.questionsCounter,
            ),
          ),
          MouseRegion(
            onEnter: (e) {
              if (index < questions.length - 1) {
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
              if (index < questions.length - 1) {
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
              hoverColor: (index < questions.length - 1)
                  ? AppColors.greyHooverColor
                  : Colors.transparent,
              iconSize: 30,
              onPressed: () {
                if (index < questions.length - 1) {
                  setState(() {
                    index++;
                  });
                }
              },
              splashRadius: (index < questions.length - 1) ? 30 : 1,
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
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    '2',
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

  void codeNotFoundDialog(BuildContext context, String trashTitle,
      String trashCode, String trashType) {
    return Overlay.of(context)!.insert(
      overlay = OverlayEntry(
        builder: (context) {
          return NotFoundWidget(
            firstStageBloc: widget.firstStageBloc,
            overlayEntry: overlay!,
            trashTitle: trashTitle,
            listOfCategories: widget.listOfCategories,
            trashCode: trashCode,
            trashType: trashType,
          );
        },
      ),
    );
  }
}
