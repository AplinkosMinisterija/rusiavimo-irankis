import 'package:aplinkos_ministerija/bloc/prompt/prompt_manager_cubit.dart';
import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:aplinkos_ministerija/model/items.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/ui/widgets/items_tile.dart';
import 'package:aplinkos_ministerija/ui/widgets/mobile_items_tile.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../../../constants/app_colors.dart';
import '../../../model/category.dart';
import '../../styles/app_style.dart';
import '../../styles/text_styles_bigger.dart';
import '../../styles/text_styles_biggest.dart';
import '../../widgets/back_btn.dart';
import 'dart:html' as html;

class ItemsPopUp extends StatefulWidget {
  final List<Items> itemsList;
  final String categoryName;
  final String subCategoryName;
  final FirstStageBloc firstStageBloc;
  final List<Category> listOfCategories;
  final RouteControllerBloc routeControllerBloc;
  final Category category;
  Function()? mobileOnBackBtnPressed;

  ItemsPopUp({
    super.key,
    required this.itemsList,
    required this.categoryName,
    required this.subCategoryName,
    required this.firstStageBloc,
    required this.listOfCategories,
    required this.routeControllerBloc,
    required this.category,
    this.mobileOnBackBtnPressed,
  });

  @override
  State<ItemsPopUp> createState() => _ItemsPopUpState();
}

class _ItemsPopUpState extends State<ItemsPopUp> {
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
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (MediaQuery.of(context).size.width > 768) ? 50 : 10,
              ),
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
                isDesNeeded: false,
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
                    onPressed: widget.mobileOnBackBtnPressed,
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
                            text: 'Ar norite praleisti 2 etapą?'.toCapitalized(),
                            style:
                            _state.status == AccessibilityControllerStatus.big
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

  Widget _buildMainSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (MediaQuery.of(context).size.width > 768)
            ? _buildTitle(title: widget.categoryName)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyle.greenBtnHoover,
                      shape: const CircleBorder(),
                    ),
                    onPressed: widget.mobileOnBackBtnPressed,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal:
                              MediaQuery.of(context).size.width > 768 ? 20 : 0),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
        _buildDescription(
            'Rezultatai grupėje „${widget.categoryName.toCapitalized()}”'),
        _buildDescription(
            'Rezultatai pogrupyje „${widget.subCategoryName.toCapitalized()}”'),
        const SizedBox(height: 10),
        (MediaQuery.of(context).size.width > 768)
            ? _buildContentTable()
            : _buildMobileContentTable(),
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

  Widget _buildMobileContentTable() {
    return Column(
      children: List.generate(
        widget.itemsList.length,
        (index) {
          return Column(
            children: [
              MobileItemsTile(
                code: widget.itemsList[index].code!,
                trashType: widget.itemsList[index].type!,
                itemName: widget.itemsList[index].itemName!,
                firstStageBloc: widget.firstStageBloc,
                listOfCategories: widget.listOfCategories,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContentTable() {
    return Column(
      children: List.generate(
        widget.itemsList.length,
        (index) {
          return Column(
            children: [
              ItemsTile(
                isTitleRowRequired: index == 0 ? true : false,
                descriptionTitle:
                    widget.itemsList[index].itemName!.toCapitalized(),
                trashCode: widget.itemsList[index].type!,
                toolTipMsg: 'Atliekos kodas: ${widget.itemsList[index].code}',
                code: widget.itemsList[index].code!,
                firstStageBloc: widget.firstStageBloc,
                listOfCategories: widget.listOfCategories,
              ),
              (widget.itemsList.indexOf(widget.itemsList.last) == index)
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
                ? TextStylesBigger.mobileContentDescription
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.mobileContentDescription
                    : TextStyles.mobileContentDescription,
      ),
    );
  }

  Widget _buildTitle({
    required String title,
    bool? isDesNeeded = true,
    double? width,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 80, 0, 50),
          width: width ?? MediaQuery.of(context).size.width * 0.75,
          child: SelectableText.rich(
            TextSpan(
              children: [
                isDesNeeded!
                    ? TextSpan(
                        text: 'Pogrupis ',
                        style:
                            _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.itemTitleStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.itemTitleStyle
                                    : TextStyles.itemTitleStyle,
                      )
                    : const TextSpan(),
                isDesNeeded
                    ? TextSpan(
                        text: "„${title.toCapitalized()}”",
                        style:
                            _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.itemTitleStyleSecondary
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.itemTitleStyleSecondary
                                    : TextStyles.itemTitleStyleSecondary,
                      )
                    : TextSpan(
                        text: title.toCapitalized(),
                        style:
                            _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.itemTitleStyleSecondary
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
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
                _promptManagerCubit.backToInitial();
                widget.firstStageBloc.add(
                    FirstStageSelectedCategoryEvent(category: widget.category));
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
