import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/routes.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/generated/locale_keys.g.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool residentsBool = false;
  bool bussinessBool = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: _buildContent(),
      ),
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
          _buildContentDescription(),
          const SizedBox(height: 20),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      children: [
        _buildBtn(
          image: Strings.residents,
          title: LocaleKeys.residents.tr().toTitleCase(),
          eventBool: residentsBool,
        ),
        const SizedBox(width: 20),
        _buildBtn(
          image: Strings.bussiness,
          title: LocaleKeys.economic_entities.tr().toTitleCase(),
          eventBool: bussinessBool,
        ),
      ],
    );
  }

  Widget _buildBtn({
    required String image,
    required String title,
    required bool eventBool,
  }) {
    return Expanded(
      child: MouseRegion(
        onEnter: (event) {
          eventBool = true;
          setState(() {});
          print(eventBool);
        },
        onExit: (event) {
          eventBool = false;
          setState(() {});
          print(eventBool);
        },
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            color: eventBool ? AppColors.greenBtnHoover : Colors.red,
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
    );
  }

  Widget _buildContentDescription() {
    return const Text(
      'Lorem ipsum dolor sit amet consectetur. Sed aliquam porttitor nunc est ornare porta. Tellus faucibus commodo eleifend sed lectus neque elit. Volutpat ullamcorper quis amet pretium. Diam ultrices orci faucibus dolor proin odio neque turpis sodales.',
      style: TextStyles.contentDescription,
      textAlign: TextAlign.justify,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size(
        MediaQuery.of(context).size.width,
        270,
      ),
      child: _appBar(),
    );
  }

  Widget _appBar() {
    return Stack(
      children: [
        _buildBg(),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
          ),
          child: Column(
            children: [
              _buildNavigationBar(),
              _buildTitle(),
              _buildRouteTracker(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRouteTracker() {
    return Row(
      children: [
        Text(
          LocaleKeys.home.tr().toTitleCase(),
          style: TextStyles.routeTracker,
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Text(
          LocaleKeys.nav_description_first.tr(),
          style: TextStyles.navigationDescriptionStyle,
        ),
        Text(
          LocaleKeys.nav_description_second.tr(),
          style: TextStyles.navigationSecondDescriptionStyle,
        ),
      ],
    );
  }

  Widget _buildNavigationBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.03,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            Strings.logo,
            width: MediaQuery.of(context).size.width * 0.1,
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNav(),
              const SizedBox(height: 10),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width * 0.8,
                color: AppColors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 30),
        TextButton(
          onPressed: () {},
          child: Text(
            LocaleKeys.home.tr().toUpperCase(),
            style:
                (ModalRoute.of(context)!.settings.name == RouteName.main_route)
                    ? TextStyles.navigationBtnSelectedStyle
                    : TextStyles.navigationBtnUnSelectedStyle,
          ),
        ),
        const SizedBox(width: 40),
        TextButton(
          onPressed: () {},
          child: Text(
            LocaleKeys.residents.tr().toUpperCase(),
            style: TextStyles.navigationBtnUnSelectedStyle,
          ),
        ),
        const SizedBox(width: 40),
        TextButton(
          onPressed: () {},
          child: Text(
            LocaleKeys.economic_entities.tr().toUpperCase(),
            style: TextStyles.navigationBtnUnSelectedStyle,
          ),
        ),
      ],
    );
  }

  Widget _buildBg() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: AppColors.appBarWebColor,
    );
  }
}
