import 'package:aplinkos_ministerija/bloc/how_to_use/how_to_use_bloc.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/model/category.dart';
import 'package:aplinkos_ministerija/ui/screens/bussines_first_stage.dart';
import 'package:aplinkos_ministerija/ui/screens/recomendations.dart';
import 'package:aplinkos_ministerija/ui/screens/second_stage_screen.dart';
import 'package:aplinkos_ministerija/ui/screens/third_stage_screen.dart';
import 'package:aplinkos_ministerija/ui/widgets/back_btn.dart';
import 'package:aplinkos_ministerija/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../../bloc/nav_bar_bloc/nav_bar_bloc.dart';
import '../../bloc/route_controller/route_controller_bloc.dart';
import '../../bloc/stages_cotroller/first_stage_bloc.dart';
import '../../constants/app_colors.dart';
import '../../generated/locale_keys.g.dart';
import '../../model/items.dart';
import '../../model/second_stage_models/second_category.dart';
import '../../utils/app_dialogs.dart';
import '../styles/app_style.dart';
import '../styles/text_styles.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';
import '../widgets/mobile_small_nav_bar.dart';
import 'final_recomendations.dart';
import 'from_second_stage.dart';

class BussinessScreen extends StatefulWidget {
  final RouteControllerBloc routeControllerBloc;
  final FirstStageBloc firstStageBloc;

  const BussinessScreen({
    super.key,
    required this.routeControllerBloc,
    required this.firstStageBloc,
  });

  @override
  State<BussinessScreen> createState() => _BussinessScreenState();
}

class _BussinessScreenState extends State<BussinessScreen> {
  late NavBarBloc _navBarBloc;
  late HowToUseBloc _howToUseBloc;
  late AccessibilityControllerState _state;

  // List<Category> categoryList = [];
  // List<SecondCategory> secondCategoryList = [];
  List<Items> itemsList = [];
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _navBarBloc = BlocProvider.of<NavBarBloc>(context);
    _howToUseBloc = BlocProvider.of<HowToUseBloc>(context);
    _state = BlocProvider.of<AccessibilityControllerCubit>(context).state;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FirstStageBloc, FirstStageState>(
          listener: (context, state) {
            if (state is FoundCodeState) {
              // Navigator.pushReplacementNamed(context,
              //     "/recomendations/${state.title}/${state.trashCode}/${state.trashType}");
            } else if (state is CodeFoundAfterThirdStageState) {}
          },
        ),
        BlocListener<HowToUseBloc, HowToUseState>(
          listener: (context, state) {
            if (state is HowToUseOpenState) {
              howToUseDialog(context);
            }
          },
        ),
      ],
      child: MediaQuery.of(context).size.width > 768
          ? _buildContent()
          : _buildMobileContent(),
    );
  }

  Widget _buildMobileContent() {
    return Column(
      children: [
        BlocBuilder<FirstStageBloc, FirstStageState>(
          builder: (context, state) {
            if (state is FirstStageOpenState ||
                state is SelectedCategoryState) {
              return BussinessFirstStageScreen(
                // listOfCategories: (state as FirstStageOpenState).listCategories,
                firstStageBloc: widget.firstStageBloc,
                routeControllerBloc: widget.routeControllerBloc,
                howToUseBloc: _howToUseBloc,
              );
            } else if (state is SecondStageOpenState) {
              return Column(
                children: [
                  MobileSmallNavBar(
                    routeControllerBloc: widget.routeControllerBloc,
                    firstStageBloc: widget.firstStageBloc,
                  ),
                  SecondStageScreen(
                    firstStageBloc: widget.firstStageBloc,
                    listOfCategories: state.listOfCategories,
                    howToUseBloc: _howToUseBloc,
                    routeControllerBloc: widget.routeControllerBloc,
                  ),
                ],
              );
            } else if (state is ThirdStageOpenState) {
              return Column(
                children: [
                  MobileSmallNavBar(
                    routeControllerBloc: widget.routeControllerBloc,
                    firstStageBloc: widget.firstStageBloc,
                  ),
                  ThirdStageScreen(
                    firstStageBloc: widget.firstStageBloc,
                    howToUseBloc: _howToUseBloc,
                    routeControllerBloc: widget.routeControllerBloc,
                  ),
                ],
              );
            } else if (state is FoundCodeState) {
              return Column(
                children: [
                  MobileSmallNavBar(
                    routeControllerBloc: widget.routeControllerBloc,
                    firstStageBloc: widget.firstStageBloc,
                  ),
                  RecomendationScreen(
                    title: state.title,
                    trashCode: state.trashCode,
                    trashType: state.trashType,
                    // firstStageBloc: widget.firstStageBloc,
                    // routeControllerBloc: widget.routeControllerBloc,
                  ),
                ],
              );
            } else if (state is CodeFoundAfterThirdStageState) {
              return Column(
                children: [
                  MobileSmallNavBar(
                    routeControllerBloc: widget.routeControllerBloc,
                    firstStageBloc: widget.firstStageBloc,
                  ),
                  FinalRecomendationsScreen(
                    title: state.trashTitle,
                    trashType: state.trashType,
                  ),
                ],
              );
            } else if (state is FirstStageLoadingState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height - 270,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    // MobileSmallNavBar(
                    //   routeControllerBloc: widget.routeControllerBloc,
                    //   firstStageBloc: widget.firstStageBloc,
                    // ),
                    CircularProgressIndicator(
                      color: AppStyle.orange,
                    ),
                  ],
                ),
              );
            } else if (state is StartForSecondStageState ||
                state is StartFromSecondStageSelectedCategoryState) {
              return FromSecondScreen(
                firstStageBloc: widget.firstStageBloc,
                routeControllerBloc: widget.routeControllerBloc,
                listOfCategories:
                    (state as StartForSecondStageState).listOfCategories,
                howToUseBloc: _howToUseBloc,
                itemsList: itemsList,
              );
            } else if (state is SecondStageLoadingState ||
                state is ThirdStageLoadingState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    color: AppStyle.blue,
                  )
                ],
              );
            } else {
              return Column(
                children: [
                  MobileSmallNavBar(
                    routeControllerBloc: widget.routeControllerBloc,
                    firstStageBloc: widget.firstStageBloc,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: BackButtonWidget(
                        firstStageBloc: widget.firstStageBloc,
                        routeControllerBloc: widget.routeControllerBloc,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildInfoRow(MediaQuery.of(context).size.width * 0.35, true),
                  const SizedBox(height: 40),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     DefaultAccentButton(
                  //       title: 'Pradėti',
                  //       textStyle: TextStyles.footerBold
                  //           .copyWith(color: AppStyle.scaffoldColor),
                  //       paddingFromTop: 10,
                  //       onPressed: () {
                  //         widget.firstStageBloc.add(OpenFirstStageEvent());
                  //       },
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 20),
                ],
              );
            }
          },
        )
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        BlocBuilder<FirstStageBloc, FirstStageState>(
          builder: (context, state) {
            if (state is FirstStageOpenState ||
                state is SelectedCategoryState) {
              return BussinessFirstStageScreen(
                // listOfCategories: categoryList,
                firstStageBloc: widget.firstStageBloc,
                routeControllerBloc: widget.routeControllerBloc,
                howToUseBloc: _howToUseBloc,
              );
            } else if (state is SecondStageOpenState) {
              return SecondStageScreen(
                firstStageBloc: widget.firstStageBloc,
                listOfCategories: state.listOfCategories,
                howToUseBloc: _howToUseBloc,
                routeControllerBloc: widget.routeControllerBloc,
              );
            } else if (state is ThirdStageOpenState) {
              return ThirdStageScreen(
                firstStageBloc: widget.firstStageBloc,
                howToUseBloc: _howToUseBloc,
                routeControllerBloc: widget.routeControllerBloc,
              );
            } else if (state is FoundCodeState) {
              return RecomendationScreen(
                title: state.title,
                trashCode: state.trashCode,
                trashType: state.trashType,
              );
            } else if (state is CodeFoundAfterThirdStageState) {
              return FinalRecomendationsScreen(
                title: state.trashTitle,
                trashType: state.trashType,
              );
              // } else if (state is StartForSecondStageState ||
              //     state is StartFromSecondStageSelectedCategoryState) {
              //   return FromSecondScreen(
              //     firstStageBloc: widget.firstStageBloc,
              //     routeControllerBloc: widget.routeControllerBloc,
              //     listOfCategories: (state is StartForSecondStageState) ? state.listOfCategories : categoryList,
              //     howToUseBloc: _howToUseBloc,
              //     itemsList: itemsList,
              //   );
            } else if (state is FirstStageLoadingState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height - 270,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      color: AppStyle.orange,
                    ),
                  ],
                ),
              );
            } else if (state is SecondStageLoadingState ||
                state is ThirdStageLoadingState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    color: AppStyle.blue,
                  )
                ],
              );
            } else {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.02,
                      vertical: 10,
                    ),
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.04,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        _buildInfoRow(
                            MediaQuery.of(context).size.width * 0.35, true),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        )
      ],
    );
  }

  Widget _buildHowToUseSection(bool isStartBtnShown) {
    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHowToUseTitle('1', 'I etapas. Atliekos kodo parinkimas'),
          const SizedBox(height: 20),
          _buildHowToUseDescription(
            'Šis etapas taikomas kai nežinomas nei atliekos kodas, nei jo tipas (AN – absoliučiai nepavojingas, AP – absoliučiai pavojingas, VP – veidrodinis pavojingas, VN – veidrodinis nepavojingas). Pagal atliekai tinkamiausia apibūdinimą nustatoma ar jai tinkamai klasifikuoti reikia taikyti II ar III etapus.',
          ),
          const SizedBox(height: 20),
          // isStartBtnShown
          //     ? Align(
          //         alignment: Alignment.center,
          //         child: DefaultAccentButton(
          //           title: 'Pradėti',
          //           textStyle: _state.status ==
          //                   AccessibilityControllerStatus.big
          //               ? TextStylesBigger.footerBold
          //                   .copyWith(color: AppStyle.scaffoldColor)
          //               : _state.status == AccessibilityControllerStatus.biggest
          //                   ? TextStylesBiggest.footerBold
          //                       .copyWith(color: AppStyle.scaffoldColor)
          //                   : TextStyles.footerBold
          //                       .copyWith(color: AppStyle.scaffoldColor),
          //           textPadding: (MediaQuery.of(context).size.width > 762)
          //               ? null
          //               : _state.status == AccessibilityControllerStatus.normal
          //                   ? const EdgeInsets.only(top: 0)
          //                   : _state.status ==
          //                           AccessibilityControllerStatus.biggest
          //                       ? const EdgeInsets.only(top: 9)
          //                       : const EdgeInsets.only(top: 2),
          //           paddingFromTop: (_state.status ==
          //                       AccessibilityControllerStatus.biggest &&
          //                   MediaQuery.of(context).size.width < 762)
          //               ? 0
          //               : 4,
          //           onPressed: () {
          //             widget.firstStageBloc.add(OpenFirstStageEvent());
          //           },
          //         ),
          //       )
          //     : const SizedBox(),
          const SizedBox(height: 20),
          _buildHowToUseTitle(
              '2', 'II etapas. Tam tikrų atliekų identifikavimas'),
          const SizedBox(height: 20),
          _buildHowToUseDescription(
            'Jei klasifikuojamos atliekos priskiriamos vienai iš žemiau nurodytų kategorijų, jas galima klasifikuoti neatliekant I etapo ar pavojingųjų savybių vertinimo pagal III etapą:',
          ),
          _buildMarkingText(
              'pakuočių atliekos (išskyrus augalų apsaugos produktų pakuotes);'),
          _buildMarkingText('elektros ir elektroninės įrangos (EEĮ) atliekos;'),
          _buildMarkingText(
              'įvairiomis medžiagomis padengtos medienos atliekos;'),
          _buildMarkingText(
              'paviršių apdorojimui naudotų šlifavimo, poliravimo dalių ir šlifavimo medžiagų atliekos;'),
          _buildMarkingText(
              'absorbentų atliekų, filtrų medžiagų atliekų, pašluosčių ir apsauginių drabužių atliekos;'),
          _buildMarkingText('netinkamų naudoti gumos gaminių atliekos;'),
          _buildMarkingText(
              'stomatologijos (odontologijos) paslaugas teikiančiose įmonėse susidariusių atliekos;'),
          _buildMarkingText(
              'tvarkomos eksploatuoti netinkamas transporto priemonės (ENTP).'),
          const SizedBox(height: 20),
          _buildHowToUseTitle(
              '3', 'III etapas. Atliekų pavojingųjų savybių vertinimas'),
          const SizedBox(height: 20),
          _buildHowToUseDescription(
            'III etapas taikomas vertinant atliekų, kurioms suteikiamas VN ar VP atliekų kodo tipas ir jos nėra vertinamos pagal II etapą arba jo metu klasifikuojamų atliekų negalima identifikuoti konkrečiu atliekų kodu.',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMarkingText(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•',
          style: _state.status == AccessibilityControllerStatus.big
              ? TextStylesBigger.contentDescription
              : _state.status == AccessibilityControllerStatus.biggest
                  ? TextStylesBiggest.contentDescription
                  : TextStyles.contentDescription,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.contentDescription
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.contentDescription
                    : TextStyles.contentDescription,
          ),
        ),
      ],
    );
  }

  Widget _buildHowToUseDescription(String text) {
    return Text(
      text,
      style: _state.status == AccessibilityControllerStatus.big
          ? TextStylesBigger.contentDescription
          : _state.status == AccessibilityControllerStatus.biggest
              ? TextStylesBiggest.contentDescription
              : TextStyles.contentDescription,
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildHowToUseTitle(String number, String text) {
    return Row(
      children: [
        Container(
          width: (MediaQuery.of(context).size.width > 768) ? 100 : 70,
          height: (MediaQuery.of(context).size.width > 768) ? 100 : 70,
          decoration: const BoxDecoration(
            color: AppStyle.greenBtnUnHoover,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: _state.status == AccessibilityControllerStatus.normal
                ? const EdgeInsets.only(top: 13)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? const EdgeInsets.only(top: 7)
                    : const EdgeInsets.only(top: 10),
            child: Center(
              child: Text(
                number,
                style: _state.status == AccessibilityControllerStatus.big
                    ? TextStylesBigger.numberTextStyle
                    : _state.status == AccessibilityControllerStatus.biggest
                        ? TextStylesBiggest.numberTextStyle
                        : TextStyles.numberTextStyle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 40),
        (MediaQuery.of(context).size.width > 768)
            ? Expanded(
                child: Text(
                  text,
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.howToUseTitleStyle
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.howToUseTitleStyle
                          : TextStyles.howToUseTitleStyle,
                ),
              )
            : Expanded(
                child: Text(
                  text,
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.howToUseMobileStyle
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.howToUseMobileStyle
                          : TextStyles.howToUseMobileStyle,
                ),
              ),
      ],
    );
  }

  Widget _buildInfoRow(double width, bool isStartBtnShown) {
    if (MediaQuery.of(context).size.width > 1230) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoLeftPart(isStartBtnShown),
              const SizedBox(width: 10),
              _buildInfoRightPart(width),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: DefaultAccentButton(
              title: 'Pradėti',
              textStyle: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.footerBold
                      .copyWith(color: AppStyle.scaffoldColor)
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.footerBold
                          .copyWith(color: AppStyle.scaffoldColor)
                      : TextStyles.footerBold
                          .copyWith(color: AppStyle.scaffoldColor),
              textPadding: (MediaQuery.of(context).size.width > 762)
                  ? null
                  : _state.status == AccessibilityControllerStatus.normal
                      ? const EdgeInsets.only(top: 0)
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? const EdgeInsets.only(top: 9)
                          : const EdgeInsets.only(top: 2),
              paddingFromTop:
                  (_state.status == AccessibilityControllerStatus.biggest &&
                          MediaQuery.of(context).size.width < 762)
                      ? 0
                      : 4,
              onPressed: () {
                widget.firstStageBloc.add(OpenFirstStageEvent());
              },
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRightPart(MediaQuery.of(context).size.width),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04,
            ),
            child: _buildInfoLeftPart(isStartBtnShown),
          ),
          Align(
            alignment: Alignment.center,
            child: DefaultAccentButton(
              title: 'Pradėti',
              textStyle: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.footerBold
                      .copyWith(color: AppStyle.scaffoldColor)
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.footerBold
                          .copyWith(color: AppStyle.scaffoldColor)
                      : TextStyles.footerBold
                          .copyWith(color: AppStyle.scaffoldColor),
              textPadding: (MediaQuery.of(context).size.width > 762)
                  ? null
                  : _state.status == AccessibilityControllerStatus.normal
                      ? const EdgeInsets.only(top: 0)
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? const EdgeInsets.only(top: 9)
                          : const EdgeInsets.only(top: 2),
              paddingFromTop:
                  (_state.status == AccessibilityControllerStatus.biggest &&
                          MediaQuery.of(context).size.width < 762)
                      ? 0
                      : 4,
              onPressed: () {
                widget.firstStageBloc.add(OpenFirstStageEvent());
              },
            ),
          ),
        ],
      );
    }
  }

  Widget _buildInfoRightPart(double width) {
    return SelectionArea(
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppStyle.appBarWebColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildTitle(
                'Žymėjimai',
                (MediaQuery.of(context).size.width > 768)
                    ? _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.bussinessEntityToolWorksTitle
                            .copyWith(
                            color: AppStyle.black,
                          )
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.bussinessEntityToolWorksTitle
                                .copyWith(
                                color: AppStyle.black,
                              )
                            : TextStyles.bussinessEntityToolWorksTitle.copyWith(
                                color: AppStyle.black,
                              )
                    : _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.mobileMarkingStyle
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.mobileMarkingStyle
                            : TextStyles.mobileMarkingStyle,
              ),
              const SizedBox(height: 20),
              _buildMarkingRow(
                (_state.blindness == AccessibilityControllerBlindness.blind)
                    ? Strings.approved_mark_monochrome
                    : Strings.approved_mark,
                'AN - absoliučiai nepavojingos atliekos',
              ),
              const SizedBox(height: 20),
              _buildMarkingRow(
                (_state.blindness == AccessibilityControllerBlindness.blind)
                    ? Strings.red_exclemation_mark_monochrome
                    : Strings.red_exclemation_mark,
                'AP - absoliučiai pavojingos atliekos',
              ),
              const SizedBox(height: 20),
              _buildMarkingRow(
                (_state.blindness == AccessibilityControllerBlindness.blind)
                    ? Strings.question_mark_monochrome
                    : Strings.question_mark,
                'VP/VN - veidrodinės pavojingos arba veidrodinės nepavojingos atliekos',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarkingRow(String icon, String text) {
    return Row(
      children: [
        Image.asset(
          icon,
          width: 48,
          height: 48,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            width: (MediaQuery.of(context).size.width > 768)
                ? MediaQuery.of(context).size.width * 0.24
                : MediaQuery.of(context).size.width * 0.72,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                text,
                style: MediaQuery.of(context).size.width > 768
                    ? _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.contentDescription
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.contentDescription
                            : TextStyles.contentDescription
                    : _state.status == AccessibilityControllerStatus.big
                        ? TextStylesBigger.mobileContentDescription
                        : _state.status == AccessibilityControllerStatus.biggest
                            ? TextStylesBiggest.mobileContentDescription
                            : TextStyles.mobileContentDescription,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoLeftPart(bool isStartBtnShown) {
    return SelectionArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width > 768
            ? MediaQuery.of(context).size.width * 0.45
            : MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildTitle(
              LocaleKeys.how_tool_works.tr(),
              MediaQuery.of(context).size.width > 768
                  ? _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.bussinessEntityToolWorksTitle
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.bussinessEntityToolWorksTitle
                          : TextStyles.bussinessEntityToolWorksTitle
                  : _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.mobileOrangeTitle
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.mobileOrangeTitle
                          : TextStyles.mobileOrangeTitle,
            ),
            const SizedBox(height: 40),
            _buildHowToUseSection(isStartBtnShown),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title, TextStyle style) {
    return Text(
      title,
      style: style,
    );
  }

  void howToUseDialog(
    BuildContext context,
  ) =>
      AppDialogs.showAnimatedDialog(
        context,
        content: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
            _howToUseBloc.add(CloseHowToUseEvent());
          },
          child: Scrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const ScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Material(
                        elevation: 10,
                        color: AppStyle.greenBtnHoover,
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.close,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildInfoRow(
                        MediaQuery.of(context).size.width * 0.3, false),
                    const SizedBox(height: 40),
                    // _buildHowToUseSection(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ),
      ).whenComplete(() => _howToUseBloc.add(CloseHowToUseEvent()));
}
