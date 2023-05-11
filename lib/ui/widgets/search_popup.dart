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
import '../../constants/app_colors.dart';
import '../../model/category.dart';
import '../styles/app_style.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';

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
      child: SingleChildScrollView(
        child: Column(
          children: [
            (MediaQuery.of(context).size.width > 768)
                ? _buildTitle(widget.title)
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
                            textStyle: _state.status ==
                                    AccessibilityControllerStatus.big
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
                            textStyle: _state.status ==
                                    AccessibilityControllerStatus.big
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
        ),
      ),
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

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 80, 0, 50),
            width: MediaQuery.of(context).size.width * 0.75,
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
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
