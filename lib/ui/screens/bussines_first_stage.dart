import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/model/category.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/ui/widgets/default_btn.dart';
import 'package:aplinkos_ministerija/utils/app_dialogs.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/items.dart';
import 'popups/items_popup.dart';

class BussinessFirstStageScreen extends StatefulWidget {
  final List<Category> listOfCategories;
  final FirstStageBloc firstStageBloc;
  const BussinessFirstStageScreen({
    super.key,
    required this.listOfCategories,
    required this.firstStageBloc,
  });

  @override
  State<BussinessFirstStageScreen> createState() =>
      _BussinessFirstStageScreenState();
}

class _BussinessFirstStageScreenState extends State<BussinessFirstStageScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirstStageBloc, FirstStageState>(
      builder: (context, state) {
        if (state is FirstStageOpenState) {
          return Column(
            children: [
              _buildTitle(
                  'Naudokite paiešką arba pasirinkite atliekų kategoriją'),
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
        } else if (state is SelectedCategoryState) {
          return Column(
            children: [
              _buildTitle(
                  'Naudokite paiešką arba pasirinkite atliekų subkategoriją'),
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
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildSelectionSection() {
    return BlocBuilder<FirstStageBloc, FirstStageState>(
      builder: (context, state) {
        if (state is FirstStageOpenState) {
          return Column(
            children: [
              _buildText('pasirinkite atliekų kategoriją '),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCategoryList()),
                ],
              ),
            ],
          );
        } else if (state is SelectedCategoryState) {
          return Column(
            children: [
              _buildText('pasirinkite atliekų subkategoriją '),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildSubCategoryList(state.category)),
                ],
              ),
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  // Widget _buildBottomPart() {
  //   if (itemsList != null) {
  //     return Column(
  //       children: [
  //         ListView(
  //           shrinkWrap: true,
  //           children: List.generate(
  //             itemsList!.length,
  //             (index) {
  //               return Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   SizedBox(
  //                     width: MediaQuery.of(context).size.width,
  //                     child: DefaultButton(
  //                       toolTipMsg:
  //                           'Atliekos numeris: ${itemsList![index].code}',
  //                       btnText: itemsList![index].itemName!.toCapitalized(),
  //                       isPressed: itemsList![index].isPressed,
  //                       hoverColor: AppColors.greenBtnUnHoover,
  //                       onPressed: () {},
  //                     ),
  //                   ),
  //                   const SizedBox(height: 10),
  //                 ],
  //               );
  //             },
  //           ),
  //         ),
  //         const SizedBox(height: 30),
  //       ],
  //     );
  //   } else {
  //     return const SizedBox();
  //   }
  // }

  Widget _buildSubCategoryList(Category category) {
    return Column(
      children: [
        ListView(
          shrinkWrap: true,
          children: List.generate(
            category.subCategories!.length,
            (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DefaultButton(
                      toolTipMsg:
                          'Sub kategorijos numeris: ${category.subCategories![index].codeId}',
                      btnText:
                          category.subCategories![index].name!.toCapitalized(),
                      isPressed: category.subCategories![index].isPressed,
                      hoverColor: AppColors.greenBtnUnHoover,
                      onPressed: () {
                        showSelectedSubCategoryItems(
                          context,
                          category.subCategories![index].items!,
                          category.categoryName!,
                          category.subCategories![index].name!,
                        );
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

  Widget _buildCategoryList() {
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
                    width: MediaQuery.of(context).size.width,
                    child: DefaultButton(
                      toolTipMsg:
                          'Kategorijos numeris: ${widget.listOfCategories[index].categoryId!}',
                      btnText: widget.listOfCategories[index].categoryName!
                          .toCapitalized(),
                      isPressed: widget.listOfCategories[index].isPressed,
                      onPressed: () {
                        widget.firstStageBloc.add(
                            FirstStageSelectedCategoryEvent(
                                category: widget.listOfCategories[index]));
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

  Widget _buildText(String title) {
    return SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'arba ',
            style: TextStyles.selectorDescriptionTitleStyle.copyWith(
              color: AppColors.orange,
            ),
          ),
          TextSpan(
            text: title,
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
                    '1',
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

  void showSelectedSubCategoryItems(
    BuildContext context,
    List<Items> itemsList,
    String categoryName,
    String subCategoryName,
  ) =>
      AppDialogs.showAnimatedDialog(
        context,
        content: ItemsPopUp(
          itemsList: itemsList,
          categoryName: categoryName,
          subCategoryName: subCategoryName,
          firstStageBloc: widget.firstStageBloc,
        ),
      );
}
