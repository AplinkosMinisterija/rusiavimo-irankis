import 'package:aplinkos_ministerija/bloc/accessibility_controller/accessibility_controller_cubit.dart';
import 'package:aplinkos_ministerija/bloc/how_to_use/how_to_use_bloc.dart';
import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/model/category.dart';
import 'package:aplinkos_ministerija/ui/screens/popups/items_popup.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/ui/widgets/default_btn.dart';
import 'package:aplinkos_ministerija/utils/app_dialogs.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:html' as html;

import '../../model/items.dart';
import '../../model/second_stage_models/second_category.dart';
import '../styles/app_style.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';
import '../widgets/back_btn.dart';
import '../widgets/mobile_small_nav_bar.dart';
import '../widgets/search_popup.dart';

class FromSecondScreen extends StatefulWidget {
  final List<SecondCategory> listOfCategories;
  final FirstStageBloc firstStageBloc;
  final RouteControllerBloc routeControllerBloc;
  final HowToUseBloc howToUseBloc;
  final List<Items> itemsList;
  final List<Category> categoryList;

  const FromSecondScreen({
    super.key,
    required this.listOfCategories,
    required this.firstStageBloc,
    required this.routeControllerBloc,
    required this.howToUseBloc,
    required this.itemsList,
    required this.categoryList,
  });

  @override
  State<FromSecondScreen> createState() => _FromSecondScreenState();
}

class _FromSecondScreenState extends State<FromSecondScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _categoryController = ScrollController();
  final ScrollController _subCategoryController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  List<Category> searchCategoryList = [];
  List<Category> categoryList = [];
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
      child: BlocBuilder<FirstStageBloc, FirstStageState>(
        builder: (context, state) {
          if (state is StartForSecondStageState) {
            if (isSearchSelected && MediaQuery.of(context).size.width < 768) {
              return Column(
                children: [
                  SearchPopUp(
                    title: searchController.text,
                    firstStageBloc: widget.firstStageBloc,
                    categoriesList: searchCategoryList,
                    onBackToCategories: () {
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
                            const SizedBox(height: 40),
                            _buildSelectionSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          } else if (state is StartFromSecondStageSelectedCategoryState) {
            if (isSearchSelected && MediaQuery.of(context).size.width < 768) {
              return Column(
                children: [
                  MobileSmallNavBar(
                    routeControllerBloc: widget.routeControllerBloc,
                    titleFirstPart: 'Paieška ',
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
                  _buildTitle('Naudokite paiešką arba pasirinkite atlieką'),
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
                            const SizedBox(height: 40),
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
        if (state is StartForSecondStageState) {
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
                  child: _buildText('pasirinkite atlieką '),
                ),
                const SizedBox(height: 30),
                _buildDropDownForCategories(state),
                const SizedBox(height: 50),
              ],
            );
          }
        } else if (state is StartFromSecondStageSelectedCategoryState) {
          if (MediaQuery.of(context).size.width > 768) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildText('pasirinkite atlieką '),
                ),
                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildSubCategoryList(state.listOfSortedItems),
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
                  child: _buildText('pasirinkite atlieką '),
                ),
                const SizedBox(height: 30),
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

  Widget _buildDropDownForSubCategories(
      StartFromSecondStageSelectedCategoryState state) {
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
                    'Pasirinkite atlieką',
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: _subCategoryController,
                      child: ListView.builder(
                        controller: _subCategoryController,
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
                              Items item =
                                  state.dropdownSubCategory[index]['data'];
                              isListActive2 = false;
                              isListActive = false;
                              widget.firstStageBloc.add(
                                OpenSecondStageEvent(
                                  trashCode: item.code!,
                                  trashType: item.type!,
                                  title: item.itemName!,
                                  listOfCategories: widget.categoryList,
                                  fromEntryPoint: true,
                                  context: context,
                                ),
                              );
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

  Widget _buildDropDownForCategories(StartForSecondStageState state) {
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Scrollbar(
                      controller: _categoryController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: _categoryController,
                        itemCount: state.dropdownSubCategory
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
                              int ind = state.dropdownSubCategory.indexWhere(
                                  (e) =>
                                      e['value'] ==
                                      state.dropdownSubCategory[index]
                                          ['value']);
                              widget.firstStageBloc.add(
                                  StartFromSecondStageSelectedCategoryEvent(
                                secondCategory: widget.listOfCategories[ind],
                              ));
                              isListActive = false;
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  state.dropdownSubCategory[index]['value'],
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

  Widget _buildSubCategoryList(List<Items> itemsList) {
    return Column(
      children: [
        ListView(
          shrinkWrap: true,
          children: List.generate(
            itemsList.length,
            (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DefaultButton(
                      toolTipMsg: 'Atliekos numeris: ${itemsList[index].code}',
                      btnText:
                          '${itemsList[index].code} ${itemsList[index].itemName!.toCapitalized()}',
                      hoverColor: AppStyle.greenBtnUnHoover,
                      btnTextStyle:
                          _state.status == AccessibilityControllerStatus.big
                              ? TextStylesBigger.contentDescription
                              : _state.status ==
                                      AccessibilityControllerStatus.biggest
                                  ? TextStylesBiggest.contentDescription
                                  : TextStyles.contentDescription,
                      onPressed: () => widget.firstStageBloc.add(
                        OpenSecondStageEvent(
                          trashCode: itemsList[index].code!,
                          trashType: itemsList[index].type!,
                          title: itemsList[index].itemName!,
                          listOfCategories: widget.categoryList,
                          fromEntryPoint: true,
                          context: context,
                        ),
                      ),
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
                      toolTipMsg: '${widget.listOfCategories[index].title}',
                      btnText: '${widget.listOfCategories[index].title}',
                      btnTextStyle: TextStyles.contentDescription,
                      onPressed: () {
                        widget.firstStageBloc.add(
                          StartFromSecondStageSelectedCategoryEvent(
                            secondCategory: widget.listOfCategories[index],
                          ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText.rich(
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
          textAlignVertical: TextAlignVertical.bottom,
          decoration: InputDecoration(
            hintText: 'Atliekos pavadinimas',
            helperText: "",
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.black.withOpacity(0.08)),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: AppColors.whiteSecondaryColor,
            suffixIcon: GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  // _searchInitial();
                }
              },
              child: Container(
                width: 46,
                height: 50,
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
                          BorderSide(color: AppColors.black.withOpacity(0.08)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {},
                  onFieldSubmitted: (value) {},
                  onTap: () {
                    html.window.parent!
                        .postMessage({'searchTapped': true}, '*');
                  },
                  onTapOutside: (e) {
                    html.window.parent!
                        .postMessage({'searchTapped': false}, '*');
                  },
                ),
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
                // _searchInitial();
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
      height: 150,
      color: AppStyle.greenBtnUnHoover,
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
                    '2',
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
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
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
            // HowToUseTool(howToUseBloc: widget.howToUseBloc),
          ],
        ),
      ),
    );
  }

// void _searchInitial() {
//   String searchText = searchController.text.toLowerCase();
//   searchCategoryList = [];
//   List<Items> itemsList = [];
//   List<SubCategories> subCategoriesList = [];
//   for (var i = 0; i < widget.listOfCategories.length; i++) {
//     subCategoriesList = [];
//     for (var z = 0;
//     z < widget.listOfCategories[i].subCategories!.length;
//     z++) {
//       itemsList = [];
//       for (var x = 0;
//       x < widget.listOfCategories[i].subCategories![z].items!.length;
//       x++) {
//         if (widget.listOfCategories[i].subCategories![z].items![x].itemName!
//             .toLowerCase()
//             .contains(searchText)) {
//           itemsList
//               .add(widget.listOfCategories[i].subCategories![z].items![x]);
//         }
//       }
//       if (itemsList.isNotEmpty) {
//         subCategoriesList.add(
//           SubCategories(
//             codeId: widget.listOfCategories[i].subCategories![z].codeId,
//             items: itemsList,
//             name: widget.listOfCategories[i].subCategories![z].name,
//           ),
//         );
//       }
//     }
//     if (subCategoriesList.isNotEmpty) {
//       searchCategoryList.add(
//         Category(
//           categoryName: widget.listOfCategories[i].categoryName,
//           categoryId: widget.listOfCategories[i].categoryId,
//           subCategories: subCategoriesList,
//         ),
//       );
//     }
//   }
//   if (MediaQuery.of(context).size.width > 768) {
//     showSearchItems(
//       context,
//       searchController.text,
//       searchCategoryList,
//     );
//   } else {
//     isSearchSelected = true;
//     setState(() {});
//   }
// }

// void showSelectedSubCategoryItems(
//     BuildContext context,
//     List<Items> itemsList,
//     String categoryName,
//     String subCategoryName,
//     List<Category> listOfCategories,
//     ) =>
//     AppDialogs.showAnimatedDialog(
//       context,
//       content: ItemsPopUp(
//         itemsList: itemsList,
//         categoryName: categoryName,
//         subCategoryName: subCategoryName,
//         firstStageBloc: widget.firstStageBloc,
//         listOfCategories: listOfCategories,
//       ),
//     );
//
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
