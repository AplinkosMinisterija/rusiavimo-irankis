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

class ItemsPopUp extends StatefulWidget {
  final List<Items> itemsList;
  final String categoryName;
  final String subCategoryName;
  final FirstStageBloc firstStageBloc;
  final List<Category> listOfCategories;
  final RouteControllerBloc routeControllerBloc;
  Function()? mobileOnBackBtnPressed;

  ItemsPopUp({
    super.key,
    required this.itemsList,
    required this.categoryName,
    required this.subCategoryName,
    required this.firstStageBloc,
    required this.listOfCategories,
    required this.routeControllerBloc,
    this.mobileOnBackBtnPressed,
  });

  @override
  State<ItemsPopUp> createState() => _ItemsPopUpState();
}

class _ItemsPopUpState extends State<ItemsPopUp> {
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
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (MediaQuery.of(context).size.width > 768) ? 50 : 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (MediaQuery.of(context).size.width > 768)
                    ? _buildTitle(widget.categoryName)
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
                                      MediaQuery.of(context).size.width > 768
                                          ? 20
                                          : 0),
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

  Widget _buildTitle(String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0, 80, 0, 50),
          width: MediaQuery.of(context).size.width * 0.75,
          child: SelectableText.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Pogrupis ',
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.itemTitleStyle
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.itemTitleStyle
                          : TextStyles.itemTitleStyle,
                ),
                TextSpan(
                  text: "„${title.toCapitalized()}”",
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
    );
  }
}
