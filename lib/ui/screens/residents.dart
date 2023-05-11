import 'package:aplinkos_ministerija/bloc/nav_bar_bloc/nav_bar_bloc.dart';
import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:aplinkos_ministerija/constants/residents_content.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/constants/words.dart';
import 'package:aplinkos_ministerija/generated/locale_keys.g.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/ui/widgets/back_btn.dart';
import 'package:aplinkos_ministerija/ui/widgets/mobile_small_nav_bar.dart';
import 'package:aplinkos_ministerija/ui/widgets/selector_description.dart';
import 'package:aplinkos_ministerija/ui/widgets/selector_tile.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../styles/app_style.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';

class ResidentsScreen extends StatefulWidget {
  final RouteControllerBloc routeControllerBloc;
  final FirstStageBloc firstStageBloc;

  const ResidentsScreen({
    super.key,
    required this.firstStageBloc,
    required this.routeControllerBloc,
  });

  @override
  State<ResidentsScreen> createState() => _ResidentsScreenState();
}

class _ResidentsScreenState extends State<ResidentsScreen> {
  final ScrollController _scrollController = ScrollController();
  late NavBarBloc _navBarBloc;
  late FirstStageBloc _firstStageBloc;
  late AccessibilityControllerState _state;

  bool first = false;
  bool second = false;
  bool third = false;
  bool fourth = false;
  bool fifth = false;
  bool sixt = false;

  //clicked
  bool first_clicked = false;
  bool second_clicked = false;
  bool third_clicked = false;
  bool fourth_clicked = false;
  bool fifth_clicked = false;
  bool sixt_clicked = false;

  //Selections
  bool _first_house_hold_clicked = false;
  bool _second_house_hold_clicked = false;
  bool _third_house_hold_clicked = false;
  bool _four_house_hold_clicked = false;
  bool _five_house_hold_clicked = false;
  bool _six_house_hold_clicked = false;
  bool _seven_house_hold_clicked = false;

  @override
  void initState() {
    super.initState();
    _navBarBloc = BlocProvider.of<NavBarBloc>(context);
    _firstStageBloc = BlocProvider.of<FirstStageBloc>(context);
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
      child: MediaQuery.of(context).size.width > 768
          ? _buildContent()
          : _buildMobileContent(),
    );
  }

  Widget _buildMobileContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MobileSmallNavBar(
          routeControllerBloc: widget.routeControllerBloc,
          firstStageBloc: _firstStageBloc,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: BackButtonWidget(
                  firstStageBloc: widget.firstStageBloc,
                  routeControllerBloc: widget.routeControllerBloc,
                ),
              ),
              _buildPreFooter(),
              const SizedBox(height: 20),
              _buildMobileButtons(),
              const SizedBox(height: 20),
              _buildFooter(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileButtons() {
    return Column(
      children: [
        _buildMobileBtn(
          image: Strings.household_waste,
          title: LocaleKeys.house_hold_wastes.tr(),
          onEnter: (event) {
            setState(() {
              first = true;
            });
          },
          onExit: (event) {
            setState(() {
              first = false;
            });
          },
          isChanged: first || first_clicked,
          onClick: () {
            setState(() {
              setCategory(1);
              disableHouseHold();
            });
          },
        ),
        const SizedBox(height: 20),
        first_clicked
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _buildFirstSelectorList(),
              )
            : const SizedBox(),
        const SizedBox(height: 20),
        _buildMobileBtn(
          image: Strings.pills,
          title: LocaleKeys.pills_wastes.tr(),
          onEnter: (event) {
            setState(() {
              second = true;
            });
          },
          onExit: (event) {
            setState(() {
              second = false;
            });
          },
          isChanged: second || second_clicked,
          onClick: () {
            setState(() {
              setCategory(2);
              disableHouseHold();
            });
          },
        ),
        const SizedBox(height: 20),
        second_clicked
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _buildSecondSelectorList(),
              )
            : const SizedBox(),
        const SizedBox(height: 20),
        _buildMobileBtn(
          image: Strings.construction,
          title: LocaleKeys.construction_wastes.tr(),
          onEnter: (event) {
            setState(() {
              third = true;
            });
          },
          onExit: (event) {
            setState(() {
              third = false;
            });
          },
          isChanged: third || third_clicked,
          onClick: () {
            setState(() {
              setCategory(3);
              disableHouseHold();
            });
          },
        ),
        const SizedBox(height: 20),
        third_clicked
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _buildThirdSelectorList(),
              )
            : const SizedBox(),
        const SizedBox(height: 20),
        _buildMobileBtn(
          image: Strings.automotive,
          title: LocaleKeys.automotive_wastes.tr(),
          onEnter: (event) {
            setState(() {
              fourth = true;
            });
          },
          onExit: (event) {
            setState(() {
              fourth = false;
            });
          },
          isChanged: fourth || fourth_clicked,
          onClick: () {
            setState(() {
              setCategory(4);
              disableHouseHold();
            });
          },
        ),
        const SizedBox(height: 20),
        fourth_clicked
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _buildFourthSelectorList(),
              )
            : const SizedBox(),
        const SizedBox(height: 20),
        _buildMobileBtn(
          image: Strings.health_care,
          title: LocaleKeys.health_care_wastes.tr(),
          onEnter: (event) {
            setState(() {
              fifth = true;
            });
          },
          onExit: (event) {
            setState(() {
              fifth = false;
            });
          },
          isChanged: fifth || fifth_clicked,
          onClick: () {
            setState(() {
              setCategory(5);
              disableHouseHold();
            });
          },
        ),
        const SizedBox(height: 20),
        fifth_clicked
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SelectorDescription(
                  isDangerous: true,
                  moreInfoDescription: ResidentsContent.mercury,
                  sortDescription: ResidentsContent.mercurySort,
                  whereToGiveAway: ResidentsContent.mercuryGiveaway,
                  title: 'Atliekos kuriose yra gyvsidabrio',
                ),
              )
            : const SizedBox(),
        const SizedBox(height: 20),
        _buildMobileBtn(
          image: Strings.battery,
          title: 'Elektros ir elektroninės įrangos (EEĮ) atliekos',
          onEnter: (event) {
            setState(() {
              sixt = true;
            });
          },
          onExit: (event) {
            setState(() {
              sixt = false;
            });
          },
          isChanged: sixt || sixt_clicked,
          onClick: () {
            setState(() {
              setCategory(6);
              disableHouseHold();
            });
          },
        ),
        const SizedBox(height: 20),
        sixt_clicked
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SelectorDescription(
                  isDangerous: true,
                  moreInfoDescription: ResidentsContent.eei,
                  sortDescription: ResidentsContent.eeiSort,
                  whereToGiveAway: ResidentsContent.eeiGiveaway,
                  title: 'Elektros ir elektroninės įrangos (EEĮ) atliekos',
                ),
              )
            : const SizedBox(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
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
              _buildPreFooter(),
              const SizedBox(height: 20),
              _buildButtons(),
              const SizedBox(height: 20),
              _buildSelector(),
              const SizedBox(height: 20),
              _buildFooter(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelector() {
    if (first_clicked) {
      return _buildFirstSelectorList();
    } else if (second_clicked) {
      return _buildSecondSelectorList();
    } else if (third_clicked) {
      return _buildThirdSelectorList();
    } else if (fourth_clicked) {
      return _buildFourthSelectorList();
    } else if (fifth_clicked) {
      return const SelectorDescription(
        isDangerous: true,
        moreInfoDescription: ResidentsContent.mercury,
        sortDescription: ResidentsContent.mercurySort,
        title: 'Atliekos, kuriose yra gyvsidabrio',
        whereToGiveAway: ResidentsContent.mercuryGiveaway,
      );
    } else if (sixt_clicked) {
      return const SelectorDescription(
        isDangerous: true,
        title: 'Elektros ir elektroninės įrangos (EEĮ) atliekos',
        moreInfoDescription: ResidentsContent.eei,
        sortDescription: ResidentsContent.eeiSort,
        whereToGiveAway: ResidentsContent.eeiGiveaway,
      );
    } else {
      return const SizedBox();
    }
  }

  Column _buildFourthSelectorList() {
    return Column(
      children: [
        SelectorTile(
          title: LocaleKeys.automotive_first.tr(),
          onTap: () {
            setState(() {
              setHouseHold(1);
            });
          },
          clicked: _first_house_hold_clicked,
          infoWidget: SelectorDescription(
            isDangerous: true,
            moreInfoDescription: ResidentsContent.automotiveFirst,
            sortDescription: ResidentsContent.automotiveFirstSort,
            title: LocaleKeys.automotive_first.tr(),
            whereToGiveAway: ResidentsContent.automotiveFirstGiveaway,
          ),
        ),
        const SizedBox(height: 10),
        SelectorTile(
          title: LocaleKeys.automotive_second.tr(),
          onTap: () {
            setState(() {
              setHouseHold(2);
            });
          },
          clicked: _second_house_hold_clicked,
          infoWidget: SelectorDescription(
            isDangerous: true,
            moreInfoDescription: ResidentsContent.automotiveSecond,
            sortDescription: ResidentsContent.automotiveSecondSort,
            title: LocaleKeys.automotive_second.tr(),
            whereToGiveAway: ResidentsContent.automotiveSecondGiveaway,
          ),
        ),
      ],
    );
  }

  Column _buildThirdSelectorList() {
    return Column(
      children: [
        SelectorTile(
          title: LocaleKeys.construction_first.tr(),
          onTap: () {
            setState(() {
              setHouseHold(1);
            });
          },
          clicked: _first_house_hold_clicked,
          infoWidget: SelectorDescription(
            isDangerous: true,
            title: LocaleKeys.construction_first.tr(),
            moreInfoDescription: ResidentsContent.constructionFirst,
            sortDescription: ResidentsContent.constructionFirstSort,
            whereToGiveAway: ResidentsContent.constructionFirstGiveaway,
          ),
        ),
        const SizedBox(height: 10),
        SelectorTile(
          title: LocaleKeys.construction_second.tr(),
          onTap: () {
            setState(() {
              setHouseHold(2);
            });
          },
          clicked: _second_house_hold_clicked,
          infoWidget: SelectorDescription(
            isDangerous: true,
            title: LocaleKeys.construction_second.tr(),
            moreInfoDescription: ResidentsContent.constructionSecond,
            sortDescription: ResidentsContent.constructionSecondSort,
            whereToGiveAway: ResidentsContent.constructionSecondGiveaway,
          ),
        ),
        const SizedBox(height: 10),
        SelectorTile(
          title: LocaleKeys.construction_third.tr(),
          onTap: () {
            setState(() {
              setHouseHold(3);
            });
          },
          clicked: _third_house_hold_clicked,
          infoWidget: SelectorDescription(
            isDangerous: true,
            title: LocaleKeys.construction_third.tr(),
            moreInfoDescription: ResidentsContent.constructionThird,
            sortDescription: ResidentsContent.constructionThirdSort,
            whereToGiveAway: ResidentsContent.constructionThirdGiveaway,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Column _buildSecondSelectorList() {
    return Column(
      children: [
        SelectorTile(
          title: LocaleKeys.pills_first.tr(),
          onTap: () {
            setState(() {
              setHouseHold(1);
            });
          },
          clicked: _first_house_hold_clicked,
          infoWidget: SelectorDescription(
            isDangerous: true,
            title: LocaleKeys.pills_first.tr(),
            moreInfoDescription: ResidentsContent.healthCareFirst,
            sortDescription: ResidentsContent.healthCareFirstSort,
            whereToGiveAway: ResidentsContent.healthCareFirstGiveaway,
            isBtnShown: false,
          ),
        ),
        const SizedBox(height: 10),
        SelectorTile(
          title: LocaleKeys.pills_second.tr(),
          onTap: () {
            setState(() {
              setHouseHold(2);
            });
          },
          clicked: _second_house_hold_clicked,
          infoWidget: SelectorDescription(
            isDangerous: false,
            title: LocaleKeys.pills_second.tr(),
            moreInfoDescription: ResidentsContent.healthCareSecond,
            sortDescription: ResidentsContent.healthCareSecondSort,
            whereToGiveAway: ResidentsContent.healthCareSecondGiveaway,
          ),
        ),
      ],
    );
  }

  Column _buildFirstSelectorList() {
    return Column(
      children: [
        SelectorTile(
          title: LocaleKeys.house_hold_first.tr(),
          onTap: () {
            setState(() {
              setHouseHold(1);
            });
          },
          clicked: _first_house_hold_clicked,
          infoWidget: SelectorDescription(
            isDangerous: true,
            title: LocaleKeys.house_hold_first.tr(),
            moreInfoDescription: ResidentsContent.houseHoldFirst,
            sortDescription: [Words.howToSort],
            whereToGiveAway: ResidentsContent.houseHoldFirstGiveaway,
          ),
        ),
        const SizedBox(height: 10),
        SelectorTile(
          title: LocaleKeys.house_hold_second.tr(),
          onTap: () {
            setState(() {
              setHouseHold(2);
            });
          },
          clicked: _second_house_hold_clicked,
          infoWidget: SelectorDescription(
            isDangerous: true,
            title: LocaleKeys.house_hold_second.tr(),
            moreInfoDescription: ResidentsContent.houseHoldSecond,
            sortDescription: ResidentsContent.houseHoldSecondSort,
            whereToGiveAway: ResidentsContent.houseHoldSecondGiveaway,
          ),
        ),
        const SizedBox(height: 10),
        SelectorTile(
          title: LocaleKeys.house_hold_third.tr(),
          onTap: () {
            setState(() {
              setHouseHold(3);
            });
          },
          clicked: _third_house_hold_clicked,
          infoWidget: SelectorDescription(
            isDangerous: true,
            title: LocaleKeys.house_hold_third.tr(),
            moreInfoDescription: ResidentsContent.houseHoldThird,
            sortDescription: [Words.howToSort4],
            whereToGiveAway: ResidentsContent.houseHoldThirdGiveaway,
          ),
        ),
        const SizedBox(height: 10),
        SelectorTile(
          title: LocaleKeys.house_hold_four.tr(),
          onTap: () {
            setState(() {
              setHouseHold(4);
            });
          },
          clicked: _four_house_hold_clicked,
          infoWidget: SelectorDescription(
            isDangerous: true,
            title: LocaleKeys.house_hold_four.tr(),
            moreInfoDescription: ResidentsContent.houseHoldFourth,
            sortDescription: ResidentsContent.houseHoldFourthSort,
            whereToGiveAway: ResidentsContent.houseHoldFourthGiveaway,
          ),
        ),
        const SizedBox(height: 10),
        SelectorTile(
          title: 'Pavojingomis medžiagomis užterštos pakuotės',
          onTap: () {
            setState(() {
              setHouseHold(5);
            });
          },
          clicked: _five_house_hold_clicked,
          infoWidget: const SelectorDescription(
            isDangerous: true,
            title: 'Pavojingomis medžiagomis užterštos pakuotės',
            moreInfoDescription: ResidentsContent.houseHoldFifth,
            sortDescription: ResidentsContent.houseHoldFifthSort,
            whereToGiveAway: ResidentsContent.houseHoldFifthGiveaway,
          ),
        ),
        const SizedBox(height: 10),
        SelectorTile(
          title: 'Aerozolių balionėliai',
          onTap: () {
            setState(() {
              setHouseHold(7);
            });
          },
          clicked: _seven_house_hold_clicked,
          infoWidget: const SelectorDescription(
            isDangerous: true,
            title: 'Aerozolių balionėliai',
            moreInfoDescription: ResidentsContent.houseHoldSixth,
            sortDescription: ResidentsContent.houseHoldSixthSort,
            whereToGiveAway: ResidentsContent.houseHoldSixthGiveaway,
          ),
        ),
        // const SizedBox(height: 10),
        // SelectorTile(
        //   title: LocaleKeys.house_hold_six.tr(),
        //   onTap: () {
        //     setState(() {
        //       setHouseHold(6);
        //     });
        //   },
        //   clicked: _six_house_hold_clicked,
        //   infoWidget: const SelectorDescription(
        //     isDangerous: true,
        //     moreInfoDescription: '',
        //     sortDescription: '',
        //     whereToGiveAway: '* Pristatoma į DGASA.',
        //     whereToGiveAway2:
        //         '* Į savivaldybės nurodytas vietas, kai yra vykdomas pavojingųjų atliekų surinkimas apvažiavimo būdu.',
        //   ),
        // ),
      ],
    );
  }

  Widget _buildFooter() {
    if (MediaQuery.of(context).size.width > 768) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildInfoText(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.15,
            child: Image.asset(
              Strings.waste_sorting,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildInfoText(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Image.asset(
              Strings.waste_sorting,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildPreFooter() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SelectableText.rich(
        textAlign: TextAlign.center,
        TextSpan(
          style: _state.status == AccessibilityControllerStatus.big
              ? TextStylesBigger.footerNormal.copyWith(color: AppStyle.black)
              : _state.status == AccessibilityControllerStatus.biggest
                  ? TextStylesBiggest.footerNormal
                      .copyWith(color: AppStyle.black)
                  : TextStyles.footerNormal.copyWith(color: AppStyle.black),
          children: <TextSpan>[
            TextSpan(
              text: LocaleKeys.footer_first_desc.tr(),
              style: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.footerBold.copyWith(
                      color: AppStyle.black,
                    )
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.footerBold.copyWith(
                          color: AppStyle.black,
                        )
                      : TextStyles.footerBold.copyWith(
                          color: AppStyle.black,
                        ),
            ),
            TextSpan(
              text: LocaleKeys.footer_second_desc.tr(),
              style: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.footerNormal.copyWith(
                      color: AppStyle.black,
                    )
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.footerNormal.copyWith(
                          color: AppStyle.black,
                        )
                      : TextStyles.footerNormal.copyWith(
                          color: AppStyle.black,
                        ),
            ),
            TextSpan(
              text: LocaleKeys.footer_third_desc.tr(),
              style: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.footerBold.copyWith(
                      color: AppStyle.orange,
                    )
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.footerBold.copyWith(
                          color: AppStyle.orange,
                        )
                      : TextStyles.footerBold.copyWith(
                          color: AppStyle.orange,
                        ),
            ),
            TextSpan(
              text: LocaleKeys.footer_four_desc.tr(),
              style: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.footerNormal.copyWith(
                      color: AppStyle.black,
                    )
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.footerNormal.copyWith(
                          color: AppStyle.black,
                        )
                      : TextStyles.footerNormal.copyWith(
                          color: AppStyle.black,
                        ),
            ),
            TextSpan(
              text: LocaleKeys.footer_five_desc.tr(),
              style: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.footerBold.copyWith(
                      color: AppStyle.selectedBtnColor,
                    )
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.footerBold.copyWith(
                          color: AppStyle.selectedBtnColor,
                        )
                      : TextStyles.footerBold.copyWith(
                          color: AppStyle.selectedBtnColor,
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoText() {
    return SizedBox(
      width: (MediaQuery.of(context).size.width > 768)
          ? MediaQuery.of(context).size.width * 0.6
          : MediaQuery.of(context).size.width * 0.9,
      child: SelectableText.rich(
        textAlign: (MediaQuery.of(context).size.width > 768)
            ? TextAlign.start
            : TextAlign.center,
        TextSpan(
          style: _state.status == AccessibilityControllerStatus.big
              ? TextStylesBigger.footerNormal.copyWith(color: AppStyle.black)
              : _state.status == AccessibilityControllerStatus.biggest
                  ? TextStylesBiggest.footerNormal
                      .copyWith(color: AppStyle.black)
                  : TextStyles.footerNormal.copyWith(color: AppStyle.black),
          children: <TextSpan>[
            TextSpan(
              text: LocaleKeys.footer_first_desc.tr(),
              style: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.footerBold.copyWith(
                      color: AppStyle.black,
                    )
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.footerBold.copyWith(
                          color: AppStyle.black,
                        )
                      : TextStyles.footerBold.copyWith(
                          color: AppStyle.black,
                        ),
            ),
            TextSpan(
              text: LocaleKeys.footer_second_desc.tr(),
              style: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.footerNormal.copyWith(
                      color: AppStyle.black,
                    )
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.footerNormal.copyWith(
                          color: AppStyle.black,
                        )
                      : TextStyles.footerNormal.copyWith(
                          color: AppStyle.black,
                        ),
            ),
            TextSpan(
              text: LocaleKeys.footer_third_desc.tr(),
              style: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.footerBold.copyWith(
                      color: AppStyle.orange,
                    )
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.footerBold.copyWith(
                          color: AppStyle.orange,
                        )
                      : TextStyles.footerBold.copyWith(
                          color: AppStyle.orange,
                        ),
            ),
            TextSpan(
              text: LocaleKeys.footer_four_desc.tr(),
              style: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.footerNormal.copyWith(
                      color: AppStyle.black,
                    )
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.footerNormal.copyWith(
                          color: AppStyle.black,
                        )
                      : TextStyles.footerNormal.copyWith(
                          color: AppStyle.black,
                        ),
            ),
            TextSpan(
              text: LocaleKeys.footer_five_desc.tr(),
              style: _state.status == AccessibilityControllerStatus.big
                  ? TextStylesBigger.footerBold.copyWith(
                      color: AppStyle.selectedBtnColor,
                    )
                  : _state.status == AccessibilityControllerStatus.biggest
                      ? TextStylesBiggest.footerBold.copyWith(
                          color: AppStyle.selectedBtnColor,
                        )
                      : TextStyles.footerBold.copyWith(
                          color: AppStyle.selectedBtnColor,
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        _buildBtn(
          image: Strings.household_waste,
          title: LocaleKeys.house_hold_wastes.tr(),
          onEnter: (event) {
            setState(() {
              first = true;
            });
          },
          onExit: (event) {
            setState(() {
              first = false;
            });
          },
          isChanged: first || first_clicked,
          onClick: () {
            setState(() {
              setCategory(1);
              disableHouseHold();
            });
          },
        ),
        const SizedBox(width: 20),
        _buildBtn(
          image: Strings.pills,
          title: LocaleKeys.pills_wastes.tr(),
          onEnter: (event) {
            setState(() {
              second = true;
            });
          },
          onExit: (event) {
            setState(() {
              second = false;
            });
          },
          isChanged: second || second_clicked,
          onClick: () {
            setState(() {
              setCategory(2);
              disableHouseHold();
            });
          },
        ),
        const SizedBox(width: 20),
        _buildBtn(
          image: Strings.construction,
          title: LocaleKeys.construction_wastes.tr(),
          onEnter: (event) {
            setState(() {
              third = true;
            });
          },
          onExit: (event) {
            setState(() {
              third = false;
            });
          },
          isChanged: third || third_clicked,
          onClick: () {
            setState(() {
              setCategory(3);
              disableHouseHold();
            });
          },
        ),
        const SizedBox(width: 20),
        _buildBtn(
          image: Strings.automotive,
          title: LocaleKeys.automotive_wastes.tr(),
          onEnter: (event) {
            setState(() {
              fourth = true;
            });
          },
          onExit: (event) {
            setState(() {
              fourth = false;
            });
          },
          isChanged: fourth || fourth_clicked,
          onClick: () {
            setState(() {
              setCategory(4);
              disableHouseHold();
            });
          },
        ),
        const SizedBox(width: 20),
        _buildBtn(
          image: Strings.health_care,
          title: LocaleKeys.health_care_wastes.tr(),
          onEnter: (event) {
            setState(() {
              fifth = true;
            });
          },
          onExit: (event) {
            setState(() {
              fifth = false;
            });
          },
          isChanged: fifth || fifth_clicked,
          onClick: () {
            setState(() {
              setCategory(5);
              disableHouseHold();
            });
          },
        ),
        const SizedBox(width: 20),
        _buildBtn(
          image: Strings.battery,
          title: 'Elektros ir elektroninės įrangos (EEĮ) atliekos',
          onEnter: (event) {
            setState(() {
              sixt = true;
            });
          },
          onExit: (event) {
            setState(() {
              sixt = false;
            });
          },
          isChanged: sixt || sixt_clicked,
          onClick: () {
            setState(() {
              setCategory(6);
              disableHouseHold();
            });
          },
        ),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildMobileBtn({
    required String image,
    required String title,
    required Function(PointerEnterEvent) onEnter,
    required Function(PointerExitEvent) onExit,
    required bool isChanged,
    required Function() onClick,
  }) {
    return GestureDetector(
      onTap: onClick,
      child: MouseRegion(
        onEnter: onEnter,
        onExit: onExit,
        child: Transform.scale(
          scale: isChanged ? 1.02 : 1,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: isChanged
                  ? AppStyle.greenBtnHoover
                  : AppStyle.greenBtnUnHoover,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Text(
                      title,
                      style: _state.status == AccessibilityControllerStatus.big
                          ? TextStylesBigger.selectorMobileBtnText
                          : _state.status ==
                                  AccessibilityControllerStatus.biggest
                              ? TextStylesBiggest.selectorMobileBtnText
                              : TextStyles.selectorMobileBtnText,
                      textAlign: TextAlign.center,
                      // maxFontSize: 15,
                      // minFontSize: 8,
                    ),
                  ),
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                      cacheHeight: 25,
                      cacheWidth: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBtn({
    required String image,
    required String title,
    required Function(PointerEnterEvent) onEnter,
    required Function(PointerExitEvent) onExit,
    required bool isChanged,
    required Function() onClick,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onClick,
        child: MouseRegion(
          onEnter: onEnter,
          onExit: onExit,
          child: Transform.scale(
            scale: isChanged ? 1.01 : 1,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Container(
                height: 125,
                decoration: BoxDecoration(
                  color: isChanged
                      ? AppStyle.greenBtnHoover
                      : AppStyle.greenBtnUnHoover,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          image,
                          width: 45,
                          height: 45,
                          fit: BoxFit.contain,
                          cacheHeight: 25,
                          cacheWidth: 25,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 150,
                        child: AutoSizeText(
                          title,
                          style:
                              _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.btnSecondaryText
                                  : _state.status ==
                                          AccessibilityControllerStatus.biggest
                                      ? TextStylesBiggest.btnSecondaryText
                                      : TextStyles.btnSecondaryText,
                          textAlign: TextAlign.center,
                          maxFontSize: 12,
                          minFontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void disableHouseHold() {
    _first_house_hold_clicked = false;
    _second_house_hold_clicked = false;
    _third_house_hold_clicked = false;
    _four_house_hold_clicked = false;
    _five_house_hold_clicked = false;
    _six_house_hold_clicked = false;
    _seven_house_hold_clicked = false;
  }

  void setCategory(int position) {
    first_clicked = position == 1
        ? first_clicked
            ? false
            : true
        : false;
    second_clicked = position == 2
        ? second_clicked
            ? false
            : true
        : false;
    third_clicked = position == 3
        ? third_clicked
            ? false
            : true
        : false;
    fourth_clicked = position == 4
        ? fourth_clicked
            ? false
            : true
        : false;
    fifth_clicked = position == 5
        ? fifth_clicked
            ? false
            : true
        : false;
    sixt_clicked = position == 6
        ? sixt_clicked
            ? false
            : true
        : false;
  }

  void setHouseHold(int position) {
    _first_house_hold_clicked = position == 1
        ? _first_house_hold_clicked
            ? false
            : true
        : false;
    _second_house_hold_clicked = position == 2
        ? _second_house_hold_clicked
            ? false
            : true
        : false;
    _third_house_hold_clicked = position == 3
        ? _third_house_hold_clicked
            ? false
            : true
        : false;
    _four_house_hold_clicked = position == 4
        ? _four_house_hold_clicked
            ? false
            : true
        : false;
    _five_house_hold_clicked = position == 5
        ? _five_house_hold_clicked
            ? false
            : true
        : false;
    _six_house_hold_clicked = position == 6
        ? _six_house_hold_clicked
            ? false
            : true
        : false;
    _seven_house_hold_clicked = position == 7
        ? _seven_house_hold_clicked
            ? false
            : true
        : false;
  }
}
