import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/model/category.dart';
import 'package:aplinkos_ministerija/model/sub_categories.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/ui/widgets/default_btn.dart';
import 'package:aplinkos_ministerija/utils/app_dialogs.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/items.dart';
import '../widgets/search_popup.dart';
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
  final _formKey = GlobalKey<FormState>();
  List<Category> searchCategoryList = [];

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
                    const SizedBox(height: 40),
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
          if (MediaQuery.of(context).size.width > 768) {
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
          } else {
            return Column(
              children: [
                _buildText('pasirinkite atliekų kategoriją '),
                const SizedBox(height: 30),
                _buildDropDown(state),
                const SizedBox(height: 50),
              ],
            );
          }
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

  Widget _buildDropDown(FirstStageOpenState state) {
    return CustomDropdownButton2(
      hint: 'Test',
      buttonWidth: MediaQuery.of(context).size.width,
      dropdownWidth: MediaQuery.of(context).size.width,
      value: state.dropdownCategory.first['value'],
      dropdownItems:
          state.dropdownCategory.map<String>((e) => e['value']).toList(),
      onChanged: (value) {},
    );

    // return Container(
    //   width: MediaQuery.of(context).size.width,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(8),
    //     border: Border.all(color: AppColors.greyOpacity),
    //     color: AppColors.whiteSecondaryColor,
    //   ),
    //   child: DropdownButton<String>(
    //     underline: const SizedBox(),
    //     value: state.dropdownCategory.first['value'],
    //     items: state.dropdownCategory.map<DropdownMenuItem<String>>(
    //       (e) {
    //         return DropdownMenuItem<String>(
    //           value: e['value'],
    //           child: Container(
    //             padding: const EdgeInsets.only(left: 8),
    //             width: MediaQuery.of(context).size.width * 0.85,
    //             child: Text(
    //               e['value'],
    //             ),
    //           ),
    //         );
    //       },
    //     ).toList(),
    //     onChanged: (String? e) {
    //       int index =
    //           state.dropdownCategory.indexWhere((el) => el['value'] == e);
    //       widget.firstStageBloc.add(
    //         FirstStageSelectedCategoryEvent(
    //           category: widget.listOfCategories[index],
    //         ),
    //       );
    //     },
    //   ),
    // );
  }

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
                          widget.listOfCategories,
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
        MediaQuery.of(context).size.width > 768
            ? _buildWebSearchBar()
            : _buildMobileSearchBar(),
      ],
    );
  }

  Widget _buildMobileSearchBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: searchController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: 'Paieška',
            helperText: "",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.black.withOpacity(0.08)),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: AppColors.whiteSecondaryColor,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _searchInitial();
                  }
                },
                child: Container(
                  width: 40,
                  height: 30,
                  decoration: BoxDecoration(
                    color: AppColors.greenBtnUnHoover,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: AppColors.scaffoldColor,
                  ),
                ),
              ),
            ),
            // IconButton(
            //   icon: Icon(
            //     Icons.search,
            //     color: Colors.red,
            //   ),
            //   onPressed: () {},
            // ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Nieko neįrašėte';
            } else if (value.length < 3) {
              return 'Mažiausiai 3 simboliai';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildWebSearchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          height: 100,
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: searchController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                hintText: 'Paieška',
                helperText: "",
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.black.withOpacity(0.08)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nieko neįrašėte';
                } else if (value.length < 3) {
                  return 'Mažiausiai 3 simboliai';
                }
                return null;
              },
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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _searchInitial();
              }
            },
            child: const Text(
              'Ieškoti',
              style: TextStyles.searchBtnStyle,
            ),
          ),
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
            (MediaQuery.of(context).size.width > 768)
                ? const SizedBox(width: 50)
                : const SizedBox(width: 20),
            (MediaQuery.of(context).size.width > 768)
                ? SelectableText(
                    title,
                    style: (MediaQuery.of(context).size.width > 768)
                        ? TextStyles.howToUseTitleStyle
                            .copyWith(color: AppColors.scaffoldColor)
                        : TextStyles.greenSectionMobileStyle,
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: SelectableText(
                      title,
                      style: (MediaQuery.of(context).size.width > 768)
                          ? TextStyles.howToUseTitleStyle
                              .copyWith(color: AppColors.scaffoldColor)
                          : TextStyles.greenSectionMobileStyle,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  void _searchInitial() {
    String searchText = searchController.text.toLowerCase();
    searchCategoryList = [];
    List<Items> itemsList = [];
    List<SubCategories> subCategoriesList = [];
    for (var i = 0; i < widget.listOfCategories.length; i++) {
      subCategoriesList = [];
      for (var z = 0;
          z < widget.listOfCategories[i].subCategories!.length;
          z++) {
        itemsList = [];
        for (var x = 0;
            x < widget.listOfCategories[i].subCategories![z].items!.length;
            x++) {
          if (widget.listOfCategories[i].subCategories![z].items![x].itemName!
              .toLowerCase()
              .contains(searchText)) {
            itemsList
                .add(widget.listOfCategories[i].subCategories![z].items![x]);
          }
        }
        if (itemsList.isNotEmpty) {
          subCategoriesList.add(
            SubCategories(
              codeId: widget.listOfCategories[i].subCategories![z].codeId,
              items: itemsList,
              name: widget.listOfCategories[i].subCategories![z].name,
            ),
          );
        }
      }
      if (subCategoriesList.isNotEmpty) {
        searchCategoryList.add(
          Category(
            categoryName: widget.listOfCategories[i].categoryName,
            categoryId: widget.listOfCategories[i].categoryId,
            subCategories: subCategoriesList,
          ),
        );
      }
    }
    showSearchItems(
      context,
      searchController.text,
      searchCategoryList,
    );
  }

  void showSelectedSubCategoryItems(
    BuildContext context,
    List<Items> itemsList,
    String categoryName,
    String subCategoryName,
    List<Category> listOfCategories,
  ) =>
      AppDialogs.showAnimatedDialog(
        context,
        content: ItemsPopUp(
          itemsList: itemsList,
          categoryName: categoryName,
          subCategoryName: subCategoryName,
          firstStageBloc: widget.firstStageBloc,
          listOfCategories: listOfCategories,
        ),
      );

  void showSearchItems(
    BuildContext context,
    String searchString,
    List<Category> listOfCategories,
  ) =>
      AppDialogs.showAnimatedDialog(
        context,
        content: SearchPopUp(
          title: searchString,
          firstStageBloc: widget.firstStageBloc,
          categoriesList: listOfCategories,
        ),
      );
}
