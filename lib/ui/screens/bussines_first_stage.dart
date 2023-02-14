import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/model/category.dart';
import 'package:aplinkos_ministerija/model/items.dart';
import 'package:aplinkos_ministerija/model/sub_categories.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/ui/widgets/default_btn.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:flutter/material.dart';

class BussinessFirstStageScreen extends StatefulWidget {
  final List<Category> listOfCategories;
  final ScrollController scrollController;
  const BussinessFirstStageScreen({
    super.key,
    required this.listOfCategories,
    required this.scrollController,
  });

  @override
  State<BussinessFirstStageScreen> createState() =>
      _BussinessFirstStageScreenState();
}

class _BussinessFirstStageScreenState extends State<BussinessFirstStageScreen> {
  final TextEditingController searchController = TextEditingController();
  List<SubCategories>? showSubCategory;
  List<Items>? itemsList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        const SizedBox(height: 40),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04),
          child: Column(
            children: [
              _buildSearchSection(),
              const SizedBox(height: 80),
              _buildSelectionSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionSection() {
    return Column(
      children: [
        _buildText(),
        const SizedBox(height: 30),
        _buildSelection(),
      ],
    );
  }

  Widget _buildSelection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildLeftPart()),
            Expanded(child: _buildRightPart())
          ],
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(child: _buildBottomPart()),
          ],
        )
      ],
    );
  }

  Widget _buildBottomPart() {
    if (itemsList != null) {
      return Column(
        children: [
          ListView(
            shrinkWrap: true,
            children: List.generate(
              itemsList!.length,
              (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DefaultButton(
                        toolTipMsg:
                            'Atliekos numeris: ${itemsList![index].code}',
                        btnText: itemsList![index].itemName!.toCapitalized(),
                        isPressed: itemsList![index].isPressed,
                        hoverColor: AppColors.greenBtnUnHoover,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildRightPart() {
    if (showSubCategory != null) {
      return Column(
        children: [
          ListView(
            shrinkWrap: true,
            children: List.generate(
              showSubCategory!.length,
              (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: DefaultButton(
                        toolTipMsg:
                            'Sub kategorijos numeris: ${showSubCategory![index].codeId}',
                        btnText: showSubCategory![index].name!.toCapitalized(),
                        isPressed: showSubCategory![index].isPressed,
                        hoverColor: AppColors.greenBtnUnHoover,
                        onPressed: () {
                          _manageSubCategory(index);
                          _scrollToBottom();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildLeftPart() {
    return Column(
      children: [
        ListView(
          shrinkWrap: true,
          children: List.generate(
            widget.listOfCategories.length,
            (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: DefaultButton(
                      toolTipMsg:
                          'Kategorijos numeris: ${widget.listOfCategories[index].categoryId!}',
                      btnText: widget.listOfCategories[index].categoryName!
                          .toCapitalized(),
                      isPressed: widget.listOfCategories[index].isPressed,
                      onPressed: () {
                        _manageCategory(index);
                        if (widget.listOfCategories[index].isPressed!) {
                          _scrollToTop();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildText() {
    return SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'arba ',
            style: TextStyles.selectorDescriptionTitleStyle.copyWith(
              color: AppColors.orange,
            ),
          ),
          const TextSpan(
            text: 'pasirinkite atliekų kategoriją ',
            style: TextStyles.selectorDescriptionTitleStyle,
          ),
          const TextSpan(
            text:
                'Lorem ipsum dolor sit amet consectetur. Vulputate elementum viverra fusce ut faucibus ut tortor. Arcu facilisi nascetur feugiat ut et gravida nulla eget eros. Lobortis nec amet placerat cras porttitor.',
            style: TextStyles.descriptionNormal,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Column(
      children: [
        const SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Naudokite paiešką',
                style: TextStyles.selectorDescriptionTitleStyle,
              ),
              TextSpan(
                text:
                    'Lorem ipsum dolor sit amet consectetur. Vulputate elementum viverra fusce ut faucibus ut tortor. Arcu facilisi nascetur feugiat ut et gravida nulla eget eros. Lobortis nec amet placerat cras porttitor.',
                style: TextStyles.descriptionNormal,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              height: 50,
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Paieška',
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.black.withOpacity(0.08)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppColors.whiteSecondaryColor,
                ),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenBtnUnHoover),
                onPressed: () {},
                child: const Text(
                  'Ieškoti',
                  style: TextStyles.searchBtnStyle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitle() {
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
                    '1',
                    style: TextStyles.numberTextStyle
                        .copyWith(color: AppColors.greenBtnUnHoover),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 50),
            SelectableText(
              'Naudokite paiešką arba pasirinkite atliekų kategoriją',
              style: TextStyles.howToUseTitleStyle
                  .copyWith(color: AppColors.scaffoldColor),
            ),
          ],
        ),
      ),
    );
  }

  void _manageCategory(int index) {
    if (widget.listOfCategories[index].isPressed == false) {
      if (widget.listOfCategories.any((el) => el.isPressed == true)) {
        int indexOfBoolTrue =
            widget.listOfCategories.indexWhere((el) => el.isPressed == true);
        widget.listOfCategories[indexOfBoolTrue].isPressed = false;
      }
      widget.listOfCategories[index].isPressed = true;
      if (showSubCategory != null &&
          showSubCategory!.any((element) => element.isPressed == true)) {
        int indexOfPressed =
            showSubCategory!.indexWhere((el) => el.isPressed == true);
        showSubCategory![indexOfPressed].isPressed = false;
      }
      showSubCategory = widget.listOfCategories[index].subCategories;
      if (itemsList != null && itemsList!.any((el) => el.isPressed == true)) {
        int indexOfPressed = itemsList!.indexWhere((e) => e.isPressed == true);
        itemsList![indexOfPressed].isPressed = false;
      }
      itemsList = null;
    } else {
      widget.listOfCategories[index].isPressed = false;
      if (showSubCategory != null &&
          showSubCategory!.any((element) => element.isPressed == true)) {
        int indexOfPressed =
            showSubCategory!.indexWhere((el) => el.isPressed == true);
        showSubCategory![indexOfPressed].isPressed = false;
      }
      showSubCategory = null;
      if (itemsList != null && itemsList!.any((el) => el.isPressed == true)) {
        int indexOfPressed = itemsList!.indexWhere((e) => e.isPressed == true);
        itemsList![indexOfPressed].isPressed = false;
      }
      itemsList = null;
    }
    setState(() {});
  }

  void _manageSubCategory(int index) {
    if (showSubCategory![index].isPressed == false) {
      if (showSubCategory!.any((el) => el.isPressed == true)) {
        int indexOfBoolTrue =
            showSubCategory!.indexWhere((el) => el.isPressed == true);
        showSubCategory![indexOfBoolTrue].isPressed = false;
      }
      showSubCategory![index].isPressed = true;
      if (itemsList != null && itemsList!.any((el) => el.isPressed == true)) {
        int indexOfPressed = itemsList!.indexWhere((e) => e.isPressed == true);
        itemsList![indexOfPressed].isPressed = false;
      }
      itemsList = showSubCategory![index].items;
    } else {
      showSubCategory![index].isPressed = false;
      if (itemsList != null && itemsList!.any((el) => el.isPressed == true)) {
        int indexOfPressed = itemsList!.indexWhere((e) => e.isPressed == true);
        itemsList![indexOfPressed].isPressed = false;
      }
      itemsList = null;
    }
    setState(() {});
  }

  void _scrollToTop() {
    widget.scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  void _scrollToBottom() {
    widget.scrollController.animateTo(
      widget.scrollController.position.maxScrollExtent + 1000,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }
}
