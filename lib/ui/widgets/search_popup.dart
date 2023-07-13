import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:aplinkos_ministerija/model/items.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/ui/widgets/button.dart';
import 'package:aplinkos_ministerija/ui/widgets/items_tile.dart';
import 'package:aplinkos_ministerija/ui/widgets/mobile_items_tile.dart';
import 'package:aplinkos_ministerija/ui/widgets/mobile_small_nav_bar.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../../bloc/prompt/prompt_manager_cubit.dart';
import '../../constants/app_colors.dart';
import '../../model/category.dart';
import '../styles/app_style.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';
import 'dart:html' as html;

class SearchPopUp extends StatefulWidget {
  final String title;
  final List<Category> categoriesList;
  final FirstStageBloc firstStageBloc;
  Function()? onBackToCategories;
  Function()? onBackToSubCategories;

  SearchPopUp({
    super.key,
    required this.title,
    required this.firstStageBloc,
    required this.categoriesList,
    this.onBackToCategories,
    this.onBackToSubCategories,
  });

  @override
  State<SearchPopUp> createState() => _SearchPopUpState();
}

class _SearchPopUpState extends State<SearchPopUp> {
  final ScrollController _scrollController = ScrollController();
  late AccessibilityControllerState _state;
  late PromptManagerCubit _promptManagerCubit;

  @override
  void initState() {
    super.initState();
    _state = BlocProvider.of<AccessibilityControllerCubit>(context).state;
    _promptManagerCubit = BlocProvider.of<PromptManagerCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccessibilityControllerCubit,
        AccessibilityControllerState>(
      listener: (context, state) {
        _state = state;
        setState(() {});
      },
      child: NotificationListener(
        child: SingleChildScrollView(
          child: BlocBuilder<PromptManagerCubit, PromptManagerState>(
            builder: (context, state) {
              if (state is PromptState) {
                return _buildPromptSection(state);
              } else {
                return _buildMainSection();
              }
            },
          ),
        ),
        onNotification: (notify) {
          if (notify is ScrollStartNotification) {
            html.window.parent!.postMessage({'searchScrolling': true}, '*');
          }
          if (notify is ScrollEndNotification) {
            Future.delayed(
              const Duration(seconds: 5),
              () {
                html.window.parent!
                    .postMessage({'searchScrolling': false}, '*');
              },
            );
          }
          return true;
        },
      ),
    );
  }

  Widget _buildPromptSection(PromptState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (MediaQuery.of(context).size.width > 768)
            ? _buildTitle(
                title: 'Ar norite praleisti 2 etapą?',
                width: MediaQuery.of(context).size.width * 0.25)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyle.greenBtnHoover,
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      if (_promptManagerCubit.state is PromptState) {
                        widget.firstStageBloc.add(OpenFirstStageEvent());
                        _promptManagerCubit.backToInitial();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal:
                              MediaQuery.of(context).size.width > 768 ? 20 : 0),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: SelectableText.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'Ar norite praleisti 2 etapą?'.toCapitalized(),
                            style: _state.status ==
                                    AccessibilityControllerStatus.big
                                ? TextStylesBigger.itemTitleStyleSecondary
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.itemTitleStyleSecondary
                                    : TextStyles.itemTitleStyleSecondary,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton(
              text: 'Eiti per II etapą',
              btnColor: AppStyle.greenBtnHoover,
              onPressed: () {
                widget.firstStageBloc.add(PromptMoveToSecondEvent(
                  category: state.category,
                  trashCode: state.trashCode,
                  listOfCategories: state.listOfCategories,
                  trashTitle: state.trashTitle,
                  trashType: state.trashType,
                ));
                _promptManagerCubit.backToInitial();
                if (MediaQuery.of(context).size.width > 768) {
                  Navigator.pop(context);
                }
              },
            ),
            _buildButton(
              text: 'Praleisti',
              btnColor: AppStyle.questionsCounterColor,
              onPressed: () {
                widget.firstStageBloc.add(OpenThirdStageEvent(
                  trashTitle: state.trashTitle,
                  listOfCategories: state.listOfCategories,
                  trashType: state.trashType,
                  trashCode: state.trashCode,
                ));
                _promptManagerCubit.backToInitial();
                if (MediaQuery.of(context).size.width > 768) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required Color btnColor,
    required Function() onPressed,
  }) {
    return SizedBox(
      height: 50,
      width: 120,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: btnColor),
        onPressed: onPressed,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Padding(
            padding: _state.status == AccessibilityControllerStatus.normal
                ? const EdgeInsets.only(top: 6)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? const EdgeInsets.only(top: 10)
                    : const EdgeInsets.only(top: 6),
            child: Text(
              text,
              style: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.searchBtnStyle
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.searchBtnStyle
                      : TextStyles.searchBtnStyle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainSection() {
    return Column(
      children: [
        (MediaQuery.of(context).size.width > 768)
            ? _buildTitle(title: widget.title)
            : const SizedBox(),
        (MediaQuery.of(context).size.width > 768)
            ? _buildContentList()
            : _buildMobileContent(),
        Align(
          alignment: Alignment.bottomCenter,
          child: (MediaQuery.of(context).size.width > 768)
              ? const SizedBox()
              : BlocBuilder<FirstStageBloc, FirstStageState>(
                  builder: (context, state) {
                    if (state is FirstStageOpenState) {
                      return DefaultAccentButton(
                        title: 'Grįžti į grupes',
                        textStyle:
                            _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.mobileBtnStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.mobileBtnStyle
                                    : TextStyles.mobileBtnStyle,
                        onPressed: widget.onBackToCategories ?? () {},
                      );
                    } else if (state is SelectedCategoryState) {
                      return DefaultAccentButton(
                        title: 'Grįžti į pogrupius',
                        textStyle:
                            _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.mobileBtnStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.mobileBtnStyle
                                    : TextStyles.mobileBtnStyle,
                        onPressed: widget.onBackToSubCategories ?? () {},
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMobileContent() {
    return Column(
      children: [
        MobileSmallNavBar(
          routeControllerBloc: BlocProvider.of<RouteControllerBloc>(context),
          titleFirstPart: 'Atliekos pavadinimas ',
          titleSecondPart: ',,${widget.title.toCapitalized()}’’',
          firstStageBloc: widget.firstStageBloc,
        ),
        // 20
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: List.generate(
              widget.categoriesList.length,
              (i) {
                return Column(
                  children: [
                    _buildDescription(
                        'Rezultatai grupėje „${widget.categoriesList[i].categoryName!.toCapitalized()}”'),
                    Column(
                      children: List.generate(
                        widget.categoriesList[i].subCategories!.length,
                        (index) {
                          return Column(
                            children: [
                              _buildDescription(
                                  'Rezultatai pogrupyje „${widget.categoriesList[i].subCategories![index].name}”'),
                              const SizedBox(height: 20),
                              _buildMobileContentList(widget.categoriesList[i]
                                  .subCategories![index].items!),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileContentList(List<Items> itemsList) {
    return Column(
      children: List.generate(
        itemsList.length,
        (index) {
          return Column(
            children: [
              MobileItemsTile(
                code: itemsList[index].code!,
                trashType: itemsList[index].type!,
                itemName: itemsList[index].itemName!,
                firstStageBloc: widget.firstStageBloc,
                listOfCategories: widget.categoriesList,
              ),
              (itemsList.indexOf(itemsList.last) == index)
                  ? const SizedBox(height: 30)
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContentList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: List.generate(
          widget.categoriesList.length,
          (i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDescription(
                    'Rezultatai grupėje „${widget.categoriesList[i].categoryName!.toCapitalized()}”'),
                Column(
                  children: List.generate(
                    widget.categoriesList[i].subCategories!.length,
                    (index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDescription(
                              'Rezultatai pogrupyje „${widget.categoriesList[i].subCategories![index].name}”'),
                          const SizedBox(height: 20),
                          _buildContentTable(widget
                              .categoriesList[i].subCategories![index].items!),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContentTable(List<Items> itemsList) {
    return Column(
      children: List.generate(
        itemsList.length,
        (index) {
          return Column(
            children: [
              ItemsTile(
                isTitleRowRequired: index == 0 ? true : false,
                descriptionTitle: itemsList[index].itemName!.toCapitalized(),
                trashCode: itemsList[index].type!,
                toolTipMsg: 'Atliekos kodas: ${itemsList[index].code}',
                code: itemsList[index].code!,
                firstStageBloc: widget.firstStageBloc,
                listOfCategories: widget.categoriesList,
                onPressed: () {
                  widget.firstStageBloc.add(
                    OpenSecondStageEvent(
                      trashCode: itemsList[index].code!,
                      title: itemsList[index].itemName!.toCapitalized(),
                      trashType: itemsList[index].type!,
                      listOfCategories: widget.categoriesList,
                      promptManagerCubit:
                          BlocProvider.of<PromptManagerCubit>(context),
                    ),
                  );
                  Future.delayed(const Duration(milliseconds: 250), () {
                    if (BlocProvider.of<PromptManagerCubit>(context).state
                        is! PromptState) {
                      Navigator.pop(context);
                    }
                  });
                },
              ),
              (itemsList.indexOf(itemsList.last) == index)
                  ? const SizedBox(height: 30)
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDescription(String content) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width > 768)
          ? MediaQuery.of(context).size.width * 0.75
          : MediaQuery.of(context).size.width,
      child: SelectableText(
        content,
        style: (MediaQuery.of(context).size.width > 768)
            ? _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.itemDescriptionStyle
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.itemDescriptionStyle
                    : TextStyles.itemDescriptionStyle
            : _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.mobileTypeStyle
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.mobileTypeStyle
                    : TextStyles.mobileTypeStyle,
      ),
    );
  }

  Widget _buildTitle({
    required String title,
    double? width,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 50),
          width: width ?? MediaQuery.of(context).size.width * 0.75,
          child: SelectableText.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Paieška ',
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.itemTitleStyle
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.itemTitleStyle
                          : TextStyles.itemTitleStyle,
                ),
                TextSpan(
                  text: "„$title”",
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.itemTitleStyleSecondary
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.itemTitleStyleSecondary
                          : TextStyles.itemTitleStyleSecondary,
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppStyle.greenBtnHoover,
          ),
          child: IconButton(
            onPressed: () {
              if (_promptManagerCubit.state is PromptState) {
                widget.firstStageBloc.add(OpenFirstStageEvent());
                _promptManagerCubit.backToInitial();
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
