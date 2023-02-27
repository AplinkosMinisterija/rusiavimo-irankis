import 'package:aplinkos_ministerija/bloc/how_to_use/how_to_use_bloc.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/model/category.dart';
import 'package:aplinkos_ministerija/ui/screens/bussines_first_stage.dart';
import 'package:aplinkos_ministerija/ui/screens/final_recomendations.dart';
import 'package:aplinkos_ministerija/ui/screens/recomendations.dart';
import 'package:aplinkos_ministerija/ui/screens/second_stage_screen.dart';
import 'package:aplinkos_ministerija/ui/screens/third_stage_screen.dart';
import 'package:aplinkos_ministerija/ui/widgets/mobile_small_nav_bar.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../bloc/nav_bar_bloc/nav_bar_bloc.dart';
import '../../bloc/route_controller/route_controller_bloc.dart';
import '../../bloc/stages_cotroller/first_stage_bloc.dart';
import '../../constants/app_colors.dart';
import '../../constants/routes.dart';
import '../../generated/locale_keys.g.dart';
import '../../utils/app_dialogs.dart';
import '../styles/text_styles.dart';
import '../widgets/mobile_extended_nav_bar.dart';
import '../widgets/mobile_nav_bar.dart';
import '../widgets/web_nav_bar.dart';

class BussinessScreen extends StatefulWidget {
  final RouteControllerBloc routeControllerBloc;

  const BussinessScreen({
    super.key,
    required this.routeControllerBloc,
  });

  @override
  State<BussinessScreen> createState() => _BussinessScreenState();
}

class _BussinessScreenState extends State<BussinessScreen> {
  late NavBarBloc _navBarBloc;
  late FirstStageBloc _firstStageBloc;
  late HowToUseBloc _howToUseBloc;
  List<Category> categoryList = [];
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
    _firstStageBloc = BlocProvider.of<FirstStageBloc>(context);
    _howToUseBloc = BlocProvider.of<HowToUseBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FirstStageBloc, FirstStageState>(
          listener: (context, state) {
            if (state is FirstStageOpenState) {
              categoryList = state.listCategories;
            } else if (state is SecondStageOpenState) {
              categoryList = state.listOfCategories;
            }
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
                listOfCategories: categoryList,
                firstStageBloc: _firstStageBloc,
                routeControllerBloc: widget.routeControllerBloc,
              );
            } else if (state is SecondStageLoadingState ||
                state is SecondStageOpenState) {
              return Column(
                children: [
                  MobileSmallNavBar(
                    routeControllerBloc: widget.routeControllerBloc,
                    firstStageBloc: _firstStageBloc,
                  ),
                  SecondStageScreen(
                    firstStageBloc: _firstStageBloc,
                    listOfCategories: categoryList,
                  ),
                ],
              );
            } else if (state is ThirdStageOpenState ||
                state is ThirdStageLoadingState) {
              return Column(
                children: [
                  MobileSmallNavBar(
                    routeControllerBloc: widget.routeControllerBloc,
                    firstStageBloc: _firstStageBloc,
                  ),
                  ThirdStageScreen(
                    firstStageBloc: _firstStageBloc,
                  ),
                ],
              );
            } else if (state is FoundCodeState) {
              return Column(
                children: [
                  MobileSmallNavBar(
                    routeControllerBloc: widget.routeControllerBloc,
                    firstStageBloc: _firstStageBloc,
                  ),
                  RecomendationScreen(
                    title: state.title,
                    trashCode: state.trashCode,
                    trashType: state.trashType,
                  ),
                ],
              );
            } else if (state is CodeFoundAfterThirdStageState) {
              return Column(
                children: [
                  MobileSmallNavBar(
                    routeControllerBloc: widget.routeControllerBloc,
                    firstStageBloc: _firstStageBloc,
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
                  children: [
                    MobileSmallNavBar(
                      routeControllerBloc: widget.routeControllerBloc,
                      firstStageBloc: _firstStageBloc,
                    ),
                    const CircularProgressIndicator(
                      color: AppColors.orange,
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  MobileSmallNavBar(
                    routeControllerBloc: widget.routeControllerBloc,
                    firstStageBloc: _firstStageBloc,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.04,
                    ),
                    child: const SelectableText(
                      'Lorem ipsum dolor sit amet consectetur. Sed aliquam porttitor nunc est ornare porta. Tellus faucibus commodo eleifend sed lectus neque elit. Volutpat ullamcorper quis amet pretium. Diam ultrices orci faucibus dolor proin odio neque turpis sodales.',
                      style: TextStyles.mobileContentDescription,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildInfoRow(MediaQuery.of(context).size.width * 0.35),
                  const SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.04,
                    ),
                    child: _buildHowToUseSection(),
                  ),
                  const SizedBox(height: 80),
                  _buildStartBtn(),
                  const SizedBox(height: 80),
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
                listOfCategories: categoryList,
                firstStageBloc: _firstStageBloc,
                routeControllerBloc: widget.routeControllerBloc,
              );
            } else if (state is SecondStageLoadingState ||
                state is SecondStageOpenState) {
              return SecondStageScreen(
                firstStageBloc: _firstStageBloc,
                listOfCategories: categoryList,
              );
            } else if (state is ThirdStageOpenState ||
                state is ThirdStageLoadingState) {
              return ThirdStageScreen(
                firstStageBloc: _firstStageBloc,
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
                    _buildInfoRow(MediaQuery.of(context).size.width * 0.35),
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
        (MediaQuery.of(context).size.width > 768)
            ? Text(
                text,
                style: TextStyles.howToUseTitleStyle,
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: Text(
                  text,
                  style: TextStyles.howToUseMobileStyle,
                ),
              ),
      ],
    );
  }

  Widget _buildInfoRow(double width) {
    return (MediaQuery.of(context).size.width > 768)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoLeftPart(),
              const SizedBox(),
              _buildInfoRightPart(width),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                ),
                child: _buildInfoLeftPart(),
              ),
              const SizedBox(height: 20),
              _buildInfoRightPart(MediaQuery.of(context).size.width),
            ],
          );
  }

  Widget _buildInfoRightPart(double width) {
    return SelectionArea(
      child: Container(
        width: width,
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
                (MediaQuery.of(context).size.width > 768)
                    ? TextStyles.bussinessEntityToolWorksTitle.copyWith(
                        color: AppColors.black,
                      )
                    : TextStyles.mobileMarkingStyle,
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
          width: (MediaQuery.of(context).size.width > 768)
              ? MediaQuery.of(context).size.width * 0.25
              : MediaQuery.of(context).size.width * 0.72,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              text,
              style: MediaQuery.of(context).size.width > 768
                  ? TextStyles.contentDescription
                  : TextStyles.mobileContentDescription,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoLeftPart() {
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
                  ? TextStyles.bussinessEntityToolWorksTitle
                  : TextStyles.mobileOrangeTitle,
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
      style: MediaQuery.of(context).size.width > 768
          ? TextStyles.selctorColor.copyWith(color: AppColors.black)
          : TextStyles.mobileContentDescription,
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
                    _buildInfoRow(MediaQuery.of(context).size.width * 0.35),
                    const SizedBox(height: 40),
                    _buildHowToUseSection(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        ),
      ).whenComplete(() => _howToUseBloc.add(CloseHowToUseEvent()));
}
