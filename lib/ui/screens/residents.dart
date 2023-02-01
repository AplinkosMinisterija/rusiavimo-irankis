import 'package:aplinkos_ministerija/bloc/bloc/nav_bar_bloc.dart';
import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/generated/locale_keys.g.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/ui/widgets/mobile_extended_nav_bar.dart';
import 'package:aplinkos_ministerija/ui/widgets/mobile_nav_bar.dart';
import 'package:aplinkos_ministerija/ui/widgets/selector_description.dart';
import 'package:aplinkos_ministerija/ui/widgets/selector_tile.dart';
import 'package:aplinkos_ministerija/ui/widgets/web_nav_bar.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResidentsScreen extends StatefulWidget {
  const ResidentsScreen({super.key});

  @override
  State<ResidentsScreen> createState() => _ResidentsScreenState();
}

class _ResidentsScreenState extends State<ResidentsScreen> {
  late NavBarBloc _navBarBloc;
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

  @override
  void initState() {
    super.initState();
    _navBarBloc = BlocProvider.of<NavBarBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarBloc, NavBarState>(
      builder: (context, state) {
        if (state is NavBarOpenState) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.scaffoldColor,
                appBar: MediaQuery.of(context).size.width > 768
                    ? _buildWebAppBar()
                    : _buildMobileAppBar(),
                body: SingleChildScrollView(
                  child: MediaQuery.of(context).size.width > 768
                      ? _buildContent()
                      : _buildMobileContent(),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _navBarBloc.add(CloseNavBarEvent());
                },
                child: _buildBg(),
              ),
              ExtendedMobileNavBar(navBarBloc: _navBarBloc),
            ],
          );
        } else {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            appBar: MediaQuery.of(context).size.width > 768
                ? _buildWebAppBar()
                : _buildMobileAppBar(),
            body: SingleChildScrollView(
              child: MediaQuery.of(context).size.width > 768
                  ? _buildContent()
                  : _buildMobileContent(),
            ),
          );
        }
      },
    );
  }

  PreferredSizeWidget _buildWebAppBar() {
    return PreferredSize(
      preferredSize: Size(
        MediaQuery.of(context).size.width,
        270,
      ),
      child: const WebNavBar(),
    );
  }

  Widget _buildMobileContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildMobileButtons(),
          const SizedBox(height: 20),
        ],
      ),
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
        first_clicked ? _buildFirstSelectorList() : const SizedBox(),
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
        second_clicked ? _buildSecondSelectorList() : const SizedBox(),
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
        third_clicked ? _buildThirdSelectorList() : const SizedBox(),
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
        fourth_clicked ? _buildFourthSelectorList() : const SizedBox(),
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
        fifth_clicked ? const SelectorDescription() : const SizedBox(),
        const SizedBox(height: 20),
        _buildMobileBtn(
          image: Strings.others,
          title: LocaleKeys.other_wastes.tr(),
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
        sixt_clicked ? const SelectorDescription() : const SizedBox(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildButtons(),
          const SizedBox(height: 100),
          _buildSelector(),
          _buildFooter(),
          const SizedBox(height: 20),
        ],
      ),
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
      return const SelectorDescription();
    } else if (sixt_clicked) {
      return const SelectorDescription();
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
          infoWidget: const SelectorDescription(),
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
          infoWidget: const SelectorDescription(),
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
          infoWidget: const SelectorDescription(),
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
          infoWidget: const SelectorDescription(),
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
          infoWidget: const SelectorDescription(),
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
          infoWidget: const SelectorDescription(),
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
          infoWidget: const SelectorDescription(),
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
          infoWidget: const SelectorDescription(),
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
          infoWidget: const SelectorDescription(),
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
          infoWidget: const SelectorDescription(),
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
          infoWidget: const SelectorDescription(),
        ),
        const SizedBox(height: 10),
        SelectorTile(
          title: LocaleKeys.house_hold_five.tr(),
          onTap: () {
            setState(() {
              setHouseHold(5);
            });
          },
          clicked: _five_house_hold_clicked,
          infoWidget: const SelectorDescription(),
        ),
        const SizedBox(height: 10),
        SelectorTile(
          title: LocaleKeys.house_hold_six.tr(),
          onTap: () {
            setState(() {
              setHouseHold(6);
            });
          },
          clicked: _six_house_hold_clicked,
          infoWidget: const SelectorDescription(),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _buildInfoText() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Wrap(
        children: [
          Text(
            LocaleKeys.footer_first_desc.tr(),
            style: TextStyles.footerBold.copyWith(
              color: AppColors.black,
            ),
          ),
          Text(
            LocaleKeys.footer_second_desc.tr(),
            style: TextStyles.footerNormal.copyWith(
              color: AppColors.black,
            ),
          ),
          Text(
            LocaleKeys.footer_third_desc.tr(),
            style: TextStyles.footerBold.copyWith(
              color: AppColors.orange,
            ),
          ),
          Text(
            LocaleKeys.footer_four_desc.tr(),
            style: TextStyles.footerNormal.copyWith(
              color: AppColors.black,
            ),
          ),
          Text(
            LocaleKeys.footer_five_desc.tr(),
            style: TextStyles.footerBold.copyWith(
              color: AppColors.selectedBtnColor,
            ),
          ),
          Text(
            LocaleKeys.footer_six_desc.tr(),
            style: TextStyles.footerNormal.copyWith(
              color: AppColors.black,
            ),
          ),
          Text(
            LocaleKeys.footer_seven_desc.tr(),
            style: TextStyles.footerBold.copyWith(
              color: AppColors.greenBtnHoover,
            ),
          ),
        ],
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
          image: Strings.others,
          title: LocaleKeys.other_wastes.tr(),
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
                  ? AppColors.greenBtnHoover
                  : AppColors.greenBtnUnHoover,
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
                    child: AutoSizeText(
                      title,
                      style: TextStyles.selectorMobileBtnText,
                      textAlign: TextAlign.center,
                      maxFontSize: 15,
                      minFontSize: 8,
                    ),
                  ),
                  Image.asset(
                    image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
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
            scale: isChanged ? 1.12 : 1,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Container(
                height: 125,
                decoration: BoxDecoration(
                  color: isChanged
                      ? AppColors.greenBtnHoover
                      : AppColors.greenBtnUnHoover,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        image,
                        width: 45,
                        height: 45,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 150,
                        child: AutoSizeText(
                          title,
                          style: TextStyles.btnSecondaryText,
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

  PreferredSizeWidget _buildMobileAppBar() {
    return PreferredSize(
      preferredSize: Size(
        MediaQuery.of(context).size.width,
        100,
      ),
      child: MobileNavBar(navBarBloc: _navBarBloc),
    );
  }

  Container _buildBg() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: AppColors.blackBgWithOpacity,
    );
  }

  void disableHouseHold() {
    _first_house_hold_clicked = false;
    _second_house_hold_clicked = false;
    _third_house_hold_clicked = false;
    _four_house_hold_clicked = false;
    _five_house_hold_clicked = false;
    _six_house_hold_clicked = false;
  }

  void setCategory(int position) {
    first_clicked = position == 1 ? true : false;
    second_clicked = position == 2 ? true : false;
    third_clicked = position == 3 ? true : false;
    fourth_clicked = position == 4 ? true : false;
    fifth_clicked = position == 5 ? true : false;
    sixt_clicked = position == 6 ? true : false;
  }

  void setHouseHold(int position) {
    _first_house_hold_clicked = position == 1 ? true : false;
    _second_house_hold_clicked = position == 2 ? true : false;
    _third_house_hold_clicked = position == 3 ? true : false;
    _four_house_hold_clicked = position == 4 ? true : false;
    _five_house_hold_clicked = position == 5 ? true : false;
    _six_house_hold_clicked = position == 6 ? true : false;
  }
}
