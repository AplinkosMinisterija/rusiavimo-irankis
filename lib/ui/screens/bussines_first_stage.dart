import 'package:aplinkos_ministerija/bloc/how_to_use/how_to_use_bloc.dart';
import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:aplinkos_ministerija/model/category.dart';
import 'package:aplinkos_ministerija/model/sub_categories.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/ui/widgets/default_btn.dart';
import 'package:aplinkos_ministerija/ui/widgets/how_to_use_tool.dart';
import 'package:aplinkos_ministerija/utils/app_dialogs.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../../model/items.dart';
import '../styles/app_style.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';
import '../widgets/back_btn.dart';
import '../widgets/mobile_small_nav_bar.dart';
import '../widgets/search_popup.dart';
import 'popups/items_popup.dart';
import 'dart:html' as html;

class BussinessFirstStageScreen extends StatefulWidget {
  // final List<Category> listOfCategories;
  final FirstStageBloc firstStageBloc;
  final RouteControllerBloc routeControllerBloc;
  final HowToUseBloc howToUseBloc;

  const BussinessFirstStageScreen({
    super.key,
    // required this.listOfCategories,
    required this.firstStageBloc,
    required this.routeControllerBloc,
    required this.howToUseBloc,
  });

  @override
  State<BussinessFirstStageScreen> createState() =>
      _BussinessFirstStageScreenState();
}

class _BussinessFirstStageScreenState extends State<BussinessFirstStageScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController listViewController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  List<Category> listOfCategories = [];
  List<Category> searchCategoryList = [];
  List<Items> suggestionsList = [];
  late AccessibilityControllerState _state;

  //For Mobile
  String? selectedValue;
  String? selectedValue2;
  bool isSubCategorySelected = false;
  List<Items> listOfItems = [];
  String nameOfCategory = '';
  String nameOfSubCategory = '';
  bool isSearchSelected = false;
  bool isListActive = false;
  bool isListActive2 = false;
  bool isSearchOpen = false;

  //

  @override
  void initState() {
    super.initState();
    _state = BlocProvider.of<AccessibilityControllerCubit>(context).state;
    FirstStageState checker = BlocProvider.of<FirstStageBloc>(context).state;
    if (checker is FirstStageOpenState) {
      listOfCategories = checker.listCategories;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AccessibilityControllerCubit,
            AccessibilityControllerState>(
          listener: (context, state) {
            _state = state;
            setState(() {});
          },
        ),
      ],
      child: BlocBuilder<FirstStageBloc, FirstStageState>(
        builder: (context, state) {
          if (state is FirstStageOpenState) {
            if (isSearchSelected && MediaQuery.of(context).size.width < 768) {
              return SearchPopUp(
                title: searchController.text,
                firstStageBloc: widget.firstStageBloc,
                categoriesList: searchCategoryList,
                onBackToCategories: () {
                  isSearchSelected = false;
                  setState(() {});
                },
              );
            } else {
              return Column(
                children: [
                  (MediaQuery.of(context).size.width < 768)
                      ? MobileSmallNavBar(
                          routeControllerBloc: widget.routeControllerBloc,
                          firstStageBloc: widget.firstStageBloc,
                        )
                      : const SizedBox(),
                  _buildTitle(
                      'Naudokite paiešką arba pasirinkite atliekų grupę'),
                  const SizedBox(height: 10),
                  Column(
                    children: [
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
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.04),
                        child: Column(
                          children: [
                            _buildSearchSection(),
                            const SizedBox(height: 10),
                            _buildSelectionSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          } else if (state is SelectedCategoryState) {
            if (isSubCategorySelected &&
                MediaQuery.of(context).size.width < 768) {
              return Column(
                children: [
                  MobileSmallNavBar(
                    routeControllerBloc: widget.routeControllerBloc,
                    titleFirstPart: 'Pogrupis ',
                    titleSecondPart: ',,${nameOfSubCategory.toCapitalized()}’’',
                    firstStageBloc: widget.firstStageBloc,
                  ),
                  ItemsPopUp(
                    itemsList: listOfItems,
                    categoryName: nameOfCategory,
                    subCategoryName: nameOfSubCategory,
                    firstStageBloc: widget.firstStageBloc,
                    listOfCategories: listOfCategories,
                    routeControllerBloc: widget.routeControllerBloc,
                    mobileOnBackBtnPressed: () {
                      widget.firstStageBloc.add(OpenFirstStageEvent());
                      isSubCategorySelected = false;
                      selectedValue = null;
                      selectedValue2 = null;
                      listOfItems.clear();
                      nameOfCategory = '';
                      nameOfSubCategory = '';
                      setState(() {});
                    },
                  ),
                ],
              );
            } else if (isSearchSelected &&
                MediaQuery.of(context).size.width < 768) {
              return Column(
                children: [
                  MobileSmallNavBar(
                    routeControllerBloc: widget.routeControllerBloc,
                    titleFirstPart: 'Atliekos pavadinimas ',
                    titleSecondPart:
                        ',,${searchController.text.toCapitalized()}’’',
                    firstStageBloc: widget.firstStageBloc,
                  ),
                  SearchPopUp(
                    title: searchController.text,
                    firstStageBloc: widget.firstStageBloc,
                    categoriesList: searchCategoryList,
                    onBackToSubCategories: () {
                      isSearchSelected = false;
                      setState(() {});
                    },
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  (MediaQuery.of(context).size.width < 768)
                      ? MobileSmallNavBar(
                          routeControllerBloc: widget.routeControllerBloc,
                          firstStageBloc: widget.firstStageBloc,
                        )
                      : const SizedBox(),
                  _buildTitle(
                      'Naudokite paiešką arba pasirinkite atliekų pogrupį'),
                  const SizedBox(height: 10),
                  Column(
                    children: [
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
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.04),
                        child: Column(
                          children: [
                            _buildSearchSection(),
                            const SizedBox(height: 10),
                            _buildSelectionSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildSelectionSection() {
    return BlocBuilder<FirstStageBloc, FirstStageState>(
      builder: (context, state) {
        if (state is FirstStageOpenState) {
          if (MediaQuery.of(context).size.width > 768) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildText('pasirinkite atliekų grupę '),
                ),
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildText('pasirinkite atliekų grupę '),
                ),
                const SizedBox(height: 10),
                _buildDropDownForCategories(state),
                const SizedBox(height: 50),
              ],
            );
          }
        } else if (state is SelectedCategoryState) {
          if (MediaQuery.of(context).size.width > 768) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildText('pasirinkite atliekų pogrupį '),
                ),
                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildSubCategoryList(state.category),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildText('pasirinkite atliekų pogrupį '),
                ),
                const SizedBox(height: 10),
                _buildDropDownForSubCategories(state),
                const SizedBox(height: 50),
              ],
            );
          }
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildDropDownForSubCategories(SelectedCategoryState state) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              isListActive2 = !isListActive2;
              isSearchOpen = false;

              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }

              if (isListActive2) {
                html.window.parent!.postMessage({'searchTapped': true}, '*');
              } else {
                html.window.parent!.postMessage({'searchTapped': false}, '*');
              }
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              side: const BorderSide(),
              alignment: Alignment.center,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    'Pasirinkite pogrupį',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        isListActive2
            ? NotificationListener(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black12,
                  ),
                  child: ListView.builder(
                    itemCount: state.dropdownSubCategory
                        .map<String>((e) => e['value'])
                        .toList()
                        .length,
                    itemBuilder: (context, i) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          int index = state.dropdownSubCategory.indexWhere(
                              (el) =>
                                  el['value'] ==
                                  state.dropdownSubCategory[i]['value']);
                          listOfItems =
                              state.category.subCategories![index].items!;
                          nameOfCategory = state.category.categoryName!;
                          nameOfSubCategory =
                              state.category.subCategories![index].name!;
                          isSubCategorySelected = true;
                          isListActive2 = false;
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              state.dropdownSubCategory[i]['value'],
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                onNotification: (notify) {
                  if (notify is ScrollStartNotification) {
                    html.window.parent!
                        .postMessage({'searchScrolling': true}, '*');
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
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _buildDropDownForCategories(FirstStageOpenState state) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              isListActive = !isListActive;
              isSearchOpen = false;

              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }

              if (isListActive) {
                html.window.parent!.postMessage({'searchTapped': true}, '*');
              } else {
                html.window.parent!.postMessage({'searchTapped': false}, '*');
              }
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              side: const BorderSide(),
              alignment: Alignment.center,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    'Pasirinkite grupę',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        isListActive
            ? NotificationListener(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black12,
                  ),
                  child: ListView.builder(
                    itemCount: state.dropdownCategory
                        .map<String>((e) => e['value'])
                        .toList()
                        .length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () {
                          int ind = state.dropdownCategory.indexWhere((el) =>
                              el['value'] ==
                              state.dropdownCategory[index]['value']);
                          widget.firstStageBloc.add(
                            FirstStageSelectedCategoryEvent(
                              category: listOfCategories[ind],
                            ),
                          );
                          isListActive = false;
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              state.dropdownCategory[index]['value'],
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                onNotification: (notify) {
                  if (notify is ScrollStartNotification) {
                    html.window.parent!
                        .postMessage({'searchScrolling': true}, '*');
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
              )
            : const SizedBox(),
      ],
    );
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
                          'Pogrupio numeris: ${category.subCategories![index].codeId}',
                      btnText:
                          '${category.subCategories![index].codeId} ${category.subCategories![index].name!.toCapitalized()}',
                      isPressed: category.subCategories![index].isPressed,
                      hoverColor: AppStyle.greenBtnUnHoover,
                      btnTextStyle:
                          _state.status == AccessibilityControllerStatus.big
                              ? TextStylesBigger.contentDescription
                              : _state.status ==
                                      AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.contentDescription
                                  : TextStyles.contentDescription,
                      onPressed: () {
                        showSelectedSubCategoryItems(
                          context,
                          category.subCategories![index].items!,
                          category.categoryName!,
                          category.subCategories![index].name!,
                          listOfCategories,
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
            listOfCategories.length,
            (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DefaultButton(
                      btnText:
                          '${listOfCategories[index].categoryId} ${listOfCategories[index].categoryName!.toCapitalized()}',
                      btnTextStyle:
                          _state.status == AccessibilityControllerStatus.big
                              ? TextStylesBigger.contentDescription
                              : _state.status ==
                                      AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.contentDescription
                                  : TextStyles.contentDescription,
                      isPressed: listOfCategories[index].isPressed,
                      onPressed: () {
                        widget.firstStageBloc
                            .add(FirstStageSelectedCategoryEvent(
                          category: listOfCategories[index],
                        ));
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
            style: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.selectorDescriptionTitleStyle.copyWith(
                    color: AppStyle.orange,
                  )
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.selectorDescriptionTitleStyle.copyWith(
                        color: AppStyle.orange,
                      )
                    : TextStyles.selectorDescriptionTitleStyle.copyWith(
                        color: AppStyle.orange,
                      ),
          ),
          TextSpan(
            text: title,
            style: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.selectorDescriptionTitleStyle
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.selectorDescriptionTitleStyle
                    : TextStyles.selectorDescriptionTitleStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SelectableText.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Naudokite paiešką',
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.selectorDescriptionTitleStyle
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.selectorDescriptionTitleStyle
                          : TextStyles.selectorDescriptionTitleStyle,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        MediaQuery.of(context).size.width > 768
            ? _buildWebSearchBar()
            : _buildMobileSearchBar(),
      ],
    );
  }

  Widget _buildMobileSearchBar() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: searchController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textAlignVertical: TextAlignVertical.bottom,
              decoration: InputDecoration(
                hintText: 'Atliekos pavadinimas',
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppStyle.black.withOpacity(0.08)),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: AppStyle.whiteSecondaryColor,
                suffixIcon: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _searchInitial();
                    }
                  },
                  child: Container(
                    width: 46,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppStyle.greenBtnUnHoover,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: AppStyle.scaffoldColor,
                    ),
                  ),
                ),
              ),
              onChanged: (value) {
                suggestionsList.clear();
                String valueString = _searchWords(value.toLowerCase());
                if (value != '' && value.length > 2) {
                  for (var i = 0; i < listOfCategories.length; i++) {
                    for (var z = 0;
                        z < listOfCategories[i].subCategories!.length;
                        z++) {
                      for (var x = 0;
                          x <
                              listOfCategories[i]
                                  .subCategories![z]
                                  .items!
                                  .length;
                          x++) {
                        String gotString = _searchWords(listOfCategories[i]
                            .subCategories![z]
                            .items![x]
                            .itemName!
                            .toLowerCase());
                        if (gotString.contains(valueString)) {
                          suggestionsList.add(
                              listOfCategories[i].subCategories![z].items![x]);
                        }
                      }
                    }
                  }
                }
                setState(() {});
              },
              onTap: () {
                isSearchOpen = true;
                isListActive = false;
                isListActive2 = false;
                setState(() {});
                html.window.parent!.postMessage({'searchTapped': true}, '*');
              },
              onTapOutside: (e) {
                html.window.parent!.postMessage({'searchTapped': false}, '*');
              },
            ),
          ),
        ),
        (suggestionsList.isNotEmpty && isSearchOpen)
            ? NotificationListener(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration:
                      BoxDecoration(border: Border.all(color: AppStyle.black)),
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: listViewController,
                    child: ListView.builder(
                      controller: listViewController,
                      itemCount: suggestionsList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            TextButton(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: _state.status ==
                                          AccessibilityControllerStatus.normal
                                      ? const EdgeInsets.only(top: 5)
                                      : _state.status ==
                                              AccessibilityControllerStatus
                                                  .biggest
                                          ? const EdgeInsets.only(top: 7)
                                          : const EdgeInsets.only(top: 10),
                                  child: Text(
                                    suggestionsList[index].itemName!,
                                    style: _state.status ==
                                            AccessibilityControllerStatus.big
                                        ? TextStylesBigger.toolTipTextStyle
                                        : _state.status ==
                                                AccessibilityControllerStatus
                                                    .biggest
                                            ? TextStylesBiggest.toolTipTextStyle
                                            : TextStyles.toolTipTextStyle,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                searchController.text =
                                    suggestionsList[index].itemName!;
                                _searchInitial(
                                    text: suggestionsList[index].itemName!);
                                suggestionsList.clear();
                                setState(() {});
                              },
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                onNotification: (notify) {
                  if (notify is ScrollStartNotification) {
                    html.window.parent!
                        .postMessage({'searchScrolling': true}, '*');
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
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _buildWebSearchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          // height: 100,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: searchController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    hintText: 'Atliekos pavadinimas',
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppStyle.black.withOpacity(0.08)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    suggestionsList.clear();
                    String valueString = _searchWords(value.toLowerCase());
                    if (value != '' && value.length > 2) {
                      for (var i = 0; i < listOfCategories.length; i++) {
                        for (var z = 0;
                            z < listOfCategories[i].subCategories!.length;
                            z++) {
                          for (var x = 0;
                              x <
                                  listOfCategories[i]
                                      .subCategories![z]
                                      .items!
                                      .length;
                              x++) {
                            String gotString = _searchWords(listOfCategories[i]
                                .subCategories![z]
                                .items![x]
                                .itemName!
                                .toLowerCase());
                            if (gotString.contains(valueString)) {
                              suggestionsList.add(listOfCategories[i]
                                  .subCategories![z]
                                  .items![x]);
                            }
                          }
                        }
                      }
                    }
                    setState(() {});
                  },
                  onFieldSubmitted: (value) {
                    if (_formKey.currentState!.validate()) {
                      _searchInitial();
                    }
                  },
                  onTap: () {
                    html.window.parent!
                        .postMessage({'searchTapped': true}, '*');
                  },
                  onTapOutside: (e) {
                    html.window.parent!
                        .postMessage({'searchTapped': false}, '*');
                  },
                ),
                (suggestionsList.isNotEmpty)
                    ? NotificationListener(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 200,
                          decoration: BoxDecoration(
                              border: Border.all(color: AppStyle.black)),
                          child: Scrollbar(
                            thumbVisibility: true,
                            controller: listViewController,
                            child: ListView.builder(
                              controller: listViewController,
                              itemCount: suggestionsList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    TextButton(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: _state.status ==
                                                  AccessibilityControllerStatus
                                                      .normal
                                              ? const EdgeInsets.only(top: 5)
                                              : _state.status ==
                                                      AccessibilityControllerStatus
                                                          .biggest
                                                  ? const EdgeInsets.only(
                                                      top: 7)
                                                  : const EdgeInsets.only(
                                                      top: 10),
                                          child: Text(
                                            suggestionsList[index].itemName!,
                                            style: _state.status ==
                                                    AccessibilityControllerStatus
                                                        .big
                                                ? TextStylesBigger
                                                    .toolTipTextStyle
                                                : _state.status ==
                                                        AccessibilityControllerStatus
                                                            .biggest
                                                    ? TextStylesBiggest
                                                        .toolTipTextStyle
                                                    : TextStyles
                                                        .toolTipTextStyle,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        searchController.text =
                                            suggestionsList[index].itemName!;
                                        _searchInitial(
                                            text: suggestionsList[index]
                                                .itemName!);
                                        suggestionsList.clear();
                                        setState(() {});
                                      },
                                    ),
                                    const Divider(),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        onNotification: (notify) {
                          if (notify is ScrollStartNotification) {
                            html.window.parent!
                                .postMessage({'searchScrolling': true}, '*');
                          }
                          if (notify is ScrollEndNotification) {
                            Future.delayed(
                              const Duration(seconds: 5),
                              () {
                                html.window.parent!.postMessage(
                                    {'searchScrolling': false}, '*');
                              },
                            );
                          }
                          return true;
                        },
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          height: 50,
          width: 150,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.greenBtnUnHoover),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _searchInitial();
              }
            },
            child: Padding(
              padding: _state.status == AccessibilityControllerStatus.normal
                  ? const EdgeInsets.only(top: 6)
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? const EdgeInsets.only(top: 5)
                      : const EdgeInsets.only(top: 8),
              child: Text(
                'Ieškoti',
                style: _state.status == AccessibilityControllerStatus.big
                    ? TextStylesBigger.searchBtnStyle
                    : _state.status == AccessibilityControllerStatus.biggest
                        ? TextStylesBiggest.searchBtnStyle
                        : TextStyles.searchBtnStyle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppStyle.greenBtnUnHoover,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
          vertical: 20,
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              // height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppStyle.scaffoldColor,
              ),
              child: Center(
                child: Padding(
                  padding: _state.status == AccessibilityControllerStatus.normal
                      ? const EdgeInsets.only(top: 15)
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? const EdgeInsets.only(top: 20)
                          : const EdgeInsets.only(top: 20),
                  child: Text(
                    '1',
                    style: _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.numberTextStyle
                            .copyWith(color: AppStyle.greenBtnUnHoover)
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.numberTextStyle
                                .copyWith(color: AppStyle.greenBtnUnHoover)
                            : TextStyles.numberTextStyle
                                .copyWith(color: AppStyle.greenBtnUnHoover),
                  ),
                ),
              ),
            ),
            (MediaQuery.of(context).size.width > 768)
                ? const SizedBox(width: 50)
                : const SizedBox(width: 20),
            (MediaQuery.of(context).size.width > 768)
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: SelectableText(
                        title,
                        style: (MediaQuery.of(context).size.width > 768)
                            ? _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.howToUseTitleStyle
                                    .copyWith(color: AppStyle.scaffoldColor)
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.howToUseTitleStyle
                                        .copyWith(color: AppStyle.scaffoldColor)
                                    : TextStyles.howToUseTitleStyle
                                        .copyWith(color: AppStyle.scaffoldColor)
                            : _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.greenSectionMobileStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.greenSectionMobileStyle
                                    : TextStyles.greenSectionMobileStyle,
                      ),
                    ),
                  )
                : Expanded(
                    child: SelectableText(
                      title,
                      style: (MediaQuery.of(context).size.width > 768)
                          ? _state.status == AccessibilityControllerStatus.big
                              ? TextStylesBigger.howToUseTitleStyle
                                  .copyWith(color: AppStyle.scaffoldColor)
                              : _state.status ==
                                      AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.howToUseTitleStyle
                                      .copyWith(color: AppStyle.scaffoldColor)
                                  : TextStyles.howToUseTitleStyle
                                      .copyWith(color: AppStyle.scaffoldColor)
                          : _state.status == AccessibilityControllerStatus.big
                              ? TextStylesBigger.greenSectionMobileStyle
                              : _state.status ==
                                      AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.greenSectionMobileStyle
                                  : TextStyles.greenSectionMobileStyle,
                    ),
                  ),
            (MediaQuery.of(context).size.width < 768)
                ? const SizedBox()
                : HowToUseTool(howToUseBloc: widget.howToUseBloc),
          ],
        ),
      ),
    );
  }

  void _searchInitial({String? text}) {
    String searchText = '';
    if (text != null) {
      searchText = text.toLowerCase();
    } else {
      searchText = searchController.text.toLowerCase();
    }
    searchCategoryList = [];
    List<Items> itemsList = [];
    List<SubCategories> subCategoriesList = [];
    for (var i = 0; i < listOfCategories.length; i++) {
      subCategoriesList = [];
      for (var z = 0; z < listOfCategories[i].subCategories!.length; z++) {
        itemsList = [];
        for (var x = 0;
            x < listOfCategories[i].subCategories![z].items!.length;
            x++) {
          if (listOfCategories[i]
              .subCategories![z]
              .items![x]
              .itemName!
              .toLowerCase()
              .contains(searchText)) {
            itemsList.add(listOfCategories[i].subCategories![z].items![x]);
          }
        }
        if (itemsList.isNotEmpty) {
          subCategoriesList.add(
            SubCategories(
              codeId: listOfCategories[i].subCategories![z].codeId,
              items: itemsList,
              name: listOfCategories[i].subCategories![z].name,
            ),
          );
        }
      }
      if (subCategoriesList.isNotEmpty) {
        searchCategoryList.add(
          Category(
            categoryName: listOfCategories[i].categoryName,
            categoryId: listOfCategories[i].categoryId,
            subCategories: subCategoriesList,
          ),
        );
      }
    }
    if (MediaQuery.of(context).size.width > 768) {
      showSearchItems(
        context,
        searchController.text,
        searchCategoryList,
      );
    } else {
      isSearchSelected = true;
      setState(() {});
    }
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
          routeControllerBloc: widget.routeControllerBloc,
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

  String _searchWords(String text) {
    if (text.contains('ą') ||
        text.contains('č') ||
        text.contains('ę') ||
        text.contains('ė') ||
        text.contains('į') ||
        text.contains('š') ||
        text.contains('ų') ||
        text.contains('ū') ||
        text.contains('ž')) {
      text = text.replaceAll('ą', 'a');
      text = text.replaceAll('č', 'c');
      text = text.replaceAll('ę', 'e');
      text = text.replaceAll('ė', 'e');
      text = text.replaceAll('į', 'i');
      text = text.replaceAll('š', 's');
      text = text.replaceAll('ų', 'u');
      text = text.replaceAll('ū', 'u');
      text = text.replaceAll('ž', 'z');
      return text;
    } else {
      return text;
    }
  }
}
