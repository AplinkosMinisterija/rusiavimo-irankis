import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/model/category.dart';
import 'package:aplinkos_ministerija/model/second_stage_models/second_category.dart';
import 'package:aplinkos_ministerija/ui/screens/bussines_first_stage.dart';
import 'package:aplinkos_ministerija/ui/screens/recomendations.dart';
import 'package:aplinkos_ministerija/ui/screens/second_stage_screen.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../bloc/nav_bar_bloc/nav_bar_bloc.dart';
import '../../bloc/stages_cotroller/first_stage_bloc.dart';
import '../../constants/app_colors.dart';
import '../../constants/routes.dart';
import '../../generated/locale_keys.g.dart';
import '../styles/text_styles.dart';
import '../widgets/mobile_extended_nav_bar.dart';
import '../widgets/mobile_nav_bar.dart';
import '../widgets/web_nav_bar.dart';

class BussinessScreen extends StatefulWidget {
  const BussinessScreen({super.key});

  @override
  State<BussinessScreen> createState() => _BussinessScreenState();
}

class _BussinessScreenState extends State<BussinessScreen> {
  late NavBarBloc _navBarBloc;
  late FirstStageBloc _firstStageBloc;
  List<Category> categoryList = [];

  @override
  void initState() {
    super.initState();
    _navBarBloc = BlocProvider.of<NavBarBloc>(context);
    _firstStageBloc = BlocProvider.of<FirstStageBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FirstStageBloc, FirstStageState>(
      listener: (context, state) {
        if (state is FirstStageOpenState) {
          categoryList = state.listCategories;
        }
      },
      child: BlocBuilder<NavBarBloc, NavBarState>(
        builder: (context, state) {
          if (state is NavBarOpenState) {
            return Stack(
              children: [
                Scaffold(
                  backgroundColor: AppColors.scaffoldColor,
                  appBar: MediaQuery.of(context).size.width > 768
                      // ? _buildWebAppBar()
                      ? null
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
                  // ? _buildWebAppBar()
                  ? null
                  : _buildMobileAppBar(),
              body: SingleChildScrollView(
                child: MediaQuery.of(context).size.width > 768
                    ? _buildContent()
                    : _buildMobileContent(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildMobileContent() {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSmallNavigation(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallNavigation() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          _buildSmallNavBtn(
            title: LocaleKeys.residents.tr().toTitleCase(),
            routeString: RouteName.residents_route,
            onClick: () {
              Navigator.of(context).pushNamed(RouteName.residents_route);
            },
          ),
          _buildSmallNavBtn(
            title: LocaleKeys.economic_entities.tr().toCapitalized(),
            routeString: RouteName.bussiness_route,
            onClick: () {
              Navigator.of(context).pushNamed(RouteName.bussiness_route);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSmallNavBtn({
    required String title,
    required Function() onClick,
    required String routeString,
  }) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: ModalRoute.of(context)!.settings.name == routeString
              ? AppColors.scaffoldColor
              : AppColors.appBarWebColor,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                title,
                style: ModalRoute.of(context)!.settings.name == routeString
                    ? TextStyles.smallNavBarStyle
                    : TextStyles.smallNavBarStyle
                        .copyWith(color: AppColors.black.withOpacity(0.1)),
                textAlign: TextAlign.center,
                maxFontSize: 15,
                minFontSize: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildWebAppBar(),
        BlocBuilder<FirstStageBloc, FirstStageState>(
          builder: (context, state) {
            if (state is FirstStageOpenState ||
                state is SelectedCategoryState) {
              return BussinessFirstStageScreen(
                listOfCategories: categoryList,
                firstStageBloc: _firstStageBloc,
              );
            } else if (state is SecondStageLoadingState ||
                state is SecondStageOpenState) {
              return SecondStageScreen(
                firstStageBloc: _firstStageBloc,
              );
            } else if (state is FoundCodeState) {
              return RecomendationScreen(
                title: state.title,
                trashCode: state.trashCode,
                trashType: state.trashType,
              );
            } else if (state is FirstStageLoadingState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height - 270,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      color: AppColors.orange,
                    ),
                  ],
                ),
              );
              // return const Center(
              // child: CircularProgressIndicator(
              //   color: AppColors.orange,
              // ),
              // );
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const SelectableText(
                      'Lorem ipsum dolor sit amet consectetur. Sed aliquam porttitor nunc est ornare porta. Tellus faucibus commodo eleifend sed lectus neque elit. Volutpat ullamcorper quis amet pretium. Diam ultrices orci faucibus dolor proin odio neque turpis sodales.',
                      style: TextStyles.contentDescription,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 40),
                    _buildInfoRow(),
                    const SizedBox(height: 40),
                    _buildHowToUseSection(),
                    const SizedBox(height: 80),
                    _buildStartBtn(),
                    const SizedBox(height: 80),
                  ],
                ),
              );
            }
          },
        )
      ],
    );
  }

  Widget _buildStartBtn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greenBtnHoover),
          onPressed: () {
            _firstStageBloc.add(OpenFirstStageEvent());
          },
          child: SizedBox(
            width: 180,
            height: 50,
            child: Center(
              child: Text(
                'Pradėti',
                style: TextStyles.footerBold
                    .copyWith(color: AppColors.scaffoldColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHowToUseSection() {
    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHowToUseTitle('1', 'Atliekos kodo parinkimas'),
          const SizedBox(height: 20),
          _buildHowToUseDescription(
            'Lorem ipsum dolor sit amet consectetur. Sed aliquam porttitor nunc est ornare porta. Tellus faucibus commodo eleifend sed lectus neque elit. Volutpat ullamcorper quis amet pretium. Diam ultrices orci faucibus dolor proin odio neque turpis sodales.',
          ),
          const SizedBox(height: 20),
          _buildHowToUseTitle(
              '2', 'Atliekų, esančių specifinėse kategorijose įvertinimas'),
          const SizedBox(height: 20),
          _buildHowToUseDescription(
            'Lorem ipsum dolor sit amet consectetur. Sed aliquam porttitor nunc est ornare porta. Tellus faucibus commodo eleifend sed lectus neque elit. Volutpat ullamcorper quis amet pretium. Diam ultrices orci faucibus dolor proin odio neque turpis sodales.',
          ),
          const SizedBox(height: 20),
          _buildHowToUseTitle('3', 'Atliekų pavojingumo įvertinimas'),
          const SizedBox(height: 20),
          _buildHowToUseDescription(
            'Lorem ipsum dolor sit amet consectetur. Sed aliquam porttitor nunc est ornare porta. Tellus faucibus commodo eleifend sed lectus neque elit. Volutpat ullamcorper quis amet pretium. Diam ultrices orci faucibus dolor proin odio neque turpis sodales.',
          ),
        ],
      ),
    );
  }

  Widget _buildHowToUseDescription(String text) {
    return Text(
      text,
      style: TextStyles.contentDescription,
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildHowToUseTitle(String number, String text) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: AppColors.greenBtnUnHoover,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Text(
                number,
                style: TextStyles.numberTextStyle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 40),
        Text(
          text,
          style: TextStyles.howToUseTitleStyle,
        ),
      ],
    );
  }

  Widget _buildInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoLeftPart(),
        const SizedBox(),
        _buildInfoRightPart(),
      ],
    );
  }

  Widget _buildInfoRightPart() {
    return SelectionArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
          color: AppColors.appBarWebColor,
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
                TextStyles.bussinessEntityToolWorksTitle.copyWith(
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 20),
              _buildMarkingRow(
                Strings.approved_mark,
                'AN - absoliučiai nepavojingos atliekos',
              ),
              const SizedBox(height: 20),
              _buildMarkingRow(
                Strings.red_exclemation_mark,
                'AP - absoliučiai pavojingos atliekos',
              ),
              const SizedBox(height: 20),
              _buildMarkingRow(
                Strings.question_mark,
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
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              text,
              style: TextStyles.contentDescription,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoLeftPart() {
    return SelectionArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildTitle(
              LocaleKeys.how_tool_works.tr(),
              TextStyles.bussinessEntityToolWorksTitle,
            ),
            const SizedBox(height: 20),
            _buildDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
      style: TextStyles.selctorColor.copyWith(color: AppColors.black),
    );
  }

  Widget _buildTitle(String title, TextStyle style) {
    return Text(
      title,
      style: style,
    );
  }

  Widget _buildWebAppBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 270,
      child: const WebNavBar(),
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
}
