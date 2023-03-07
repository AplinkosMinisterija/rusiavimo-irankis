import 'package:aplinkos_ministerija/bloc/how_to_use/how_to_use_bloc.dart';
import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/generated/locale_keys.g.dart';
import 'package:aplinkos_ministerija/ui/screens/bussiness.dart';
import 'package:aplinkos_ministerija/ui/screens/residents.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/ui/widgets/mobile_extended_nav_bar.dart';
import 'package:aplinkos_ministerija/ui/widgets/mobile_nav_bar.dart';
import 'package:aplinkos_ministerija/ui/widgets/web_nav_bar.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/nav_bar_bloc/nav_bar_bloc.dart';
import '../../constants/routes.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late NavBarBloc _navBarBloc;
  late RouteControllerBloc _routeControllerBloc;
  late HowToUseBloc _howToUseBloc;
  late FirstStageBloc _firstStageBloc;
  bool residentsBool = false;
  bool bussinessBool = false;

  @override
  void initState() {
    super.initState();
    _navBarBloc = BlocProvider.of<NavBarBloc>(context);
    _routeControllerBloc = BlocProvider.of<RouteControllerBloc>(context);
    _howToUseBloc = BlocProvider.of<HowToUseBloc>(context);
    _firstStageBloc = BlocProvider.of<FirstStageBloc>(context);
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
              ExtendedMobileNavBar(
                navBarBloc: _navBarBloc,
                firstStageBloc: _firstStageBloc,
              ),
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
    );
  }

  Widget _buildWebAppBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 270,
      child: WebNavBar(howToUseBloc: _howToUseBloc),
    );
  }

  Widget _buildMobileContent() {
    return BlocBuilder<RouteControllerBloc, RouteControllerState>(
      builder: (context, state) {
        if (state is ResidentsState) {
          return ResidentsScreen(routeControllerBloc: _routeControllerBloc);
        } else if (state is BussinessState) {
          return BussinessScreen(routeControllerBloc: _routeControllerBloc);
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                const SizedBox(height: 20),
                _buildContentDescription(),
                const SizedBox(height: 20),
                _buildMobileButtons(),
                const SizedBox(height: 20),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildMobileButtons() {
    return Column(
      children: [
        _buildMobileBtn(
          image: Strings.residents,
          title: LocaleKeys.residents.tr().toTitleCase(),
          onEnter: (event) {
            setState(() {
              residentsBool = true;
            });
          },
          onExit: (event) {
            setState(() {
              residentsBool = false;
            });
          },
          isChanged: residentsBool,
          onPress: () {
            _routeControllerBloc.add(OpenResidentsScreenEvent());
          },
        ),
        const SizedBox(height: 20),
        _buildMobileBtn(
          image: Strings.bussiness,
          title: LocaleKeys.economic_entities.tr().toTitleCase(),
          onEnter: (event) {
            setState(() {
              bussinessBool = true;
            });
          },
          onExit: (event) {
            setState(() {
              bussinessBool = false;
            });
          },
          isChanged: bussinessBool,
          onPress: () {
            _routeControllerBloc.add(OpenBussinessScreenEvent());
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildWebAppBar(),
        BlocBuilder<RouteControllerBloc, RouteControllerState>(
          builder: (context, state) {
            if (state is ResidentsState) {
              return ResidentsScreen(routeControllerBloc: _routeControllerBloc);
            } else if (state is BussinessState) {
              return BussinessScreen(routeControllerBloc: _routeControllerBloc);
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildContentDescription(),
                    const SizedBox(height: 20),
                    _buildButtons(),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        _buildBtn(
          image: Strings.residents,
          title: LocaleKeys.residents.tr().toTitleCase(),
          onEnter: (event) {
            setState(() {
              residentsBool = true;
            });
          },
          onExit: (event) {
            setState(() {
              residentsBool = false;
            });
          },
          isChanged: residentsBool,
          onPress: () {
            _routeControllerBloc.add(OpenResidentsScreenEvent());
          },
        ),
        const SizedBox(width: 20),
        _buildBtn(
          image: Strings.bussiness,
          title: LocaleKeys.economic_entities.tr().toTitleCase(),
          onEnter: (event) {
            setState(() {
              bussinessBool = true;
            });
          },
          onExit: (event) {
            setState(() {
              bussinessBool = false;
            });
          },
          isChanged: bussinessBool,
          onPress: () {
            _routeControllerBloc.add(OpenBussinessScreenEvent());
          },
        ),
      ],
    );
  }

  Widget _buildMobileBtn({
    required String image,
    required String title,
    required Function(PointerEnterEvent) onEnter,
    required Function(PointerExitEvent) onExit,
    required bool isChanged,
    required Function() onPress,
  }) {
    return GestureDetector(
      onTap: onPress,
      child: MouseRegion(
        onEnter: onEnter,
        onExit: onExit,
        child: Transform.scale(
          scale: isChanged ? 1.02 : 1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 125,
            decoration: BoxDecoration(
              color: isChanged
                  ? AppColors.greenBtnHoover
                  : AppColors.greenBtnUnHoover,
              borderRadius: BorderRadius.circular(20),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 190,
                      child: Text(
                        title,
                        style: TextStyles.btnMobileText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Image.asset(
                      image,
                      width: 65,
                      height: 65,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
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
    required Function() onPress,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onPress,
        child: MouseRegion(
          onEnter: onEnter,
          onExit: onExit,
          child: Transform.scale(
            scale: isChanged ? 1.02 : 1,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                color: isChanged
                    ? AppColors.greenBtnHoover
                    : AppColors.greenBtnUnHoover,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      image,
                      width: 135,
                      height: 135,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      title,
                      style: TextStyles.btnText,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentDescription() {
    if (MediaQuery.of(context).size.width > 768) {
      return const SelectableText(
        'Pavojingųjų atliekų identifikavimo ir klasifikavimo įrankiai parengti Aplinkos ministerijos įgyvendinamo 2014–2021 m. Norvegijos finansinio mechanizmo projekto „HAZ-IDENT“ metu sukurtos vieningos pavojingųjų atliekų identifikavimo metodikos pagrindu. Šios metodikos tikslas valstybės, savivaldos institucijoms ir įstaigoms, ūkio subjektams sudaryti sąlygas teisingai ir vieningai taikyti nacionalinius ir Europos Sąjungos teisės aktus dėl atliekų klasifikavimo. Taip siekiama užtikrinti tinkamą ir efektyvų pavojingųjų atliekų identifikavimą ir klasifikavimą, pavojingųjų atliekų saugų ir efektyvų surinkimą ir tvarkymą.',
        style: TextStyles.contentDescription,
        textAlign: TextAlign.justify,
      );
    } else {
      return const SelectableText(
        'Pavojingųjų atliekų identifikavimo ir klasifikavimo įrankiai parengti Aplinkos ministerijos įgyvendinamo 2014–2021 m. Norvegijos finansinio mechanizmo projekto „HAZ-IDENT“ metu sukurtos vieningos pavojingųjų atliekų identifikavimo metodikos pagrindu. Šios metodikos tikslas valstybės, savivaldos institucijoms ir įstaigoms, ūkio subjektams sudaryti sąlygas teisingai ir vieningai taikyti nacionalinius ir Europos Sąjungos teisės aktus dėl atliekų klasifikavimo. Taip siekiama užtikrinti tinkamą ir efektyvų pavojingųjų atliekų identifikavimą ir klasifikavimą, pavojingųjų atliekų saugų ir efektyvų surinkimą ir tvarkymą.',
        style: TextStyles.mobileContentDescription,
        textAlign: TextAlign.justify,
      );
    }
  }

  PreferredSizeWidget _buildMobileAppBar() {
    return PreferredSize(
      preferredSize: Size(
        MediaQuery.of(context).size.width,
        71,
      ),
      child: MobileNavBar(navBarBloc: _navBarBloc),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.nav_description_first.tr(),
          style: TextStyles.navigationDescriptionMobileStyle,
        ),
        Text(
          LocaleKeys.nav_description_second.tr(),
          style: TextStyles.navigationSecondDescriptionMobileStyle,
        ),
      ],
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
