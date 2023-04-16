import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/generated/locale_keys.g.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:js' as js;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/accessibility_controller/accessibility_controller_cubit.dart';
import '../../bloc/share/share_manager_cubit.dart';
import '../styles/app_style.dart';
import '../styles/text_styles_bigger.dart';
import '../styles/text_styles_biggest.dart';

class SelectorDescription extends StatefulWidget {
  final String? sortDescription;
  final String? moreInfoDescription;
  final String? whereToGiveAway;
  final String? whereToGiveAway2;
  final bool isDangerous;
  final bool? isBtnShown;
  final String title;

  const SelectorDescription({
    super.key,
    required this.isDangerous,
    this.whereToGiveAway2,
    this.moreInfoDescription =
        'Papildoma informacija: It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchange.',
    this.sortDescription =
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
    this.whereToGiveAway =
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
    this.isBtnShown = true,
    required this.title,
  });

  @override
  State<SelectorDescription> createState() => _SelectorDescriptionState();
}

class _SelectorDescriptionState extends State<SelectorDescription> {
  late AccessibilityControllerState _state;
  late ShareManagerCubit _shareManagerCubit;

  @override
  void initState() {
    super.initState();
    _state = BlocProvider.of<AccessibilityControllerCubit>(context).state;
    _shareManagerCubit = BlocProvider.of<ShareManagerCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccessibilityControllerCubit,
        AccessibilityControllerState>(
      listener: (context, state) {
        _state = state;
        setState(() {});
      },
      child: (MediaQuery.of(context).size.width > 768)
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(),
                  _buildRightPart(),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildSection(),
                  _buildRightPart(),
                ],
              ),
            ),
    );
  }

  Padding _buildRightPart() {
    return Padding(
      padding: EdgeInsets.only(
          right: (MediaQuery.of(context).size.width > 768) ? 20 : 0,
          left: (MediaQuery.of(context).size.width > 768) ? 0 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectionArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.selector_where_to_give.tr(),
                  style: _state.status == AccessibilityControllerStatus.big
                      ? TextStylesBigger.searchTitleStyle
                      : _state.status == AccessibilityControllerStatus.biggest
                          ? TextStylesBiggest.searchTitleStyle
                          : TextStyles.searchTitleStyle,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: (MediaQuery.of(context).size.width > 768)
                      ? MediaQuery.of(context).size.width * 0.25
                      : MediaQuery.of(context).size.width,
                  child: Wrap(
                    children: [
                      _buildDescription(
                        title: widget.whereToGiveAway!,
                        titleStyle:
                            _state.status == AccessibilityControllerStatus.big
                                ? TextStylesBigger.searchDescStyle
                                : _state.status ==
                                        AccessibilityControllerStatus.biggest
                                    ? TextStylesBiggest.searchDescStyle
                                    : TextStyles.searchDescStyle,
                        content: '',
                        contentStyle: const TextStyle(),
                      ),
                      (widget.whereToGiveAway2 != null)
                          ? _buildDescription(
                              title: widget.whereToGiveAway2!,
                              titleStyle: _state.status ==
                                      AccessibilityControllerStatus.big
                                  ? TextStylesBigger.searchDescStyle
                                  : _state.status ==
                                          AccessibilityControllerStatus.biggest
                                      ? TextStylesBiggest.searchDescStyle
                                      : TextStyles.searchDescStyle,
                              content: '',
                              contentStyle: const TextStyle(),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // SizedBox(
          //   width: (MediaQuery.of(context).size.width > 768)
          //       ? MediaQuery.of(context).size.width * 0.25
          //       : MediaQuery.of(context).size.width,
          //   child: DropdownButtonFormField(
          //     decoration: InputDecoration(
          //       border: OutlineInputBorder(
          //         borderSide:
          //             BorderSide(color: AppStyle.black.withOpacity(0.08)),
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //       filled: true,
          //       fillColor: AppStyle.whiteSecondaryColor,
          //     ),
          //     dropdownColor: AppStyle.whiteSecondaryColor,
          //     items: menuItems,
          //     value: null,
          //     onChanged: null,
          //     disabledHint: Text(selectedValue),
          //   ),
          // ),
          // const SizedBox(height: 20),
          widget.isBtnShown!
              ? Container(
                  width: (MediaQuery.of(context).size.width > 768)
                      ? MediaQuery.of(context).size.width * 0.2
                      : MediaQuery.of(context).size.width,
                  padding: (MediaQuery.of(context).size.width > 768)
                      ? const EdgeInsets.symmetric(horizontal: 20)
                      : const EdgeInsets.symmetric(horizontal: 40),
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      js.context.callMethod('open', [
                        'https://www.atliekukultura.lt/atlieku-kulturos-zemelapis/'
                      ]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyle.greenBtnHoover,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: _state.status ==
                                AccessibilityControllerStatus.normal
                            ? const EdgeInsets.only(top: 2)
                            : _state.status ==
                                    AccessibilityControllerStatus.biggest
                                ? const EdgeInsets.only(top: 4)
                                : const EdgeInsets.only(top: 5),
                        child: Text(
                          'Kur tvarkyti?',
                          style:
                              _state.status == AccessibilityControllerStatus.big
                                  ? TextStylesBigger.searchBtnStyle
                                  : _state.status ==
                                          AccessibilityControllerStatus.biggest
                                      ? TextStylesBiggest.searchBtnStyle
                                      : TextStyles.searchBtnStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          const SizedBox(height: 10),
          CircleAvatar(
            radius: 30,
            backgroundColor: AppStyle.greenBtnUnHoover,
            child: IconButton(
              onPressed: () {
                List<String> stringsList = [];
                stringsList.clear();
                if (widget.whereToGiveAway != null) {
                  stringsList.add(widget.whereToGiveAway!);
                }
                if (widget.whereToGiveAway2 != null) {
                  stringsList.add(widget.whereToGiveAway2!);
                }
                _shareManagerCubit.saveResident(
                  howToRecycle: widget.sortDescription!,
                  info: widget.moreInfoDescription!,
                  giveAway: stringsList,
                  title: widget.title,
                  isDangerous: widget.isDangerous,
                );
              },
              icon: const Icon(
                Icons.save_alt,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection() {
    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.isDangerous ? _buildFirstSection() : _buildSecondSection(),
        ],
      ),
    );
  }

  Padding _buildSecondSection() {
    return Padding(
      padding: EdgeInsets.only(
        left: (MediaQuery.of(context).size.width > 768) ? 20 : 0,
        top: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: 15),
          _buildInformation(
            Strings.approved_mark,
            LocaleKeys.selector_wastes_title.tr(),
          ),
          const SizedBox(height: 20),
          _buildDescription(
            content: widget.sortDescription!,
            contentStyle: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.descriptionNormal
                    .copyWith(color: AppStyle.black)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.descriptionNormal
                        .copyWith(color: AppStyle.black)
                    : TextStyles.descriptionNormal
                        .copyWith(color: AppStyle.black),
            title: LocaleKeys.selector_how_recycle.tr(),
            titleStyle: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.descriptionBold
                    .copyWith(color: AppStyle.orange)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.descriptionBold
                        .copyWith(color: AppStyle.orange)
                    : TextStyles.descriptionBold
                        .copyWith(color: AppStyle.orange),
          ),
          const SizedBox(height: 20),
          _buildDescription(
            content: widget.moreInfoDescription!,
            contentStyle: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.descriptionNormal
                    .copyWith(color: AppStyle.black)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.descriptionNormal
                        .copyWith(color: AppStyle.black)
                    : TextStyles.descriptionNormal
                        .copyWith(color: AppStyle.black),
            title: LocaleKeys.selector_extra_info.tr(),
            titleStyle: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.descriptionBold
                    .copyWith(color: AppStyle.blueText)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.descriptionBold
                        .copyWith(color: AppStyle.blueText)
                    : TextStyles.descriptionBold
                        .copyWith(color: AppStyle.blueText),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Padding _buildFirstSection() {
    return Padding(
      padding: EdgeInsets.only(
        left: (MediaQuery.of(context).size.width > 768) ? 20 : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: 15),
          _buildInformation(
            Strings.red_exclemation_mark,
            LocaleKeys.selector_dangerous_waste_title.tr(),
          ),
          const SizedBox(height: 20),
          _buildDescription(
            content: widget.sortDescription!,
            contentStyle: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.descriptionNormal
                    .copyWith(color: AppStyle.black)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.descriptionNormal
                        .copyWith(color: AppStyle.black)
                    : TextStyles.descriptionNormal
                        .copyWith(color: AppStyle.black),
            title: LocaleKeys.selector_how_recycle.tr(),
            titleStyle: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.descriptionBold
                    .copyWith(color: AppStyle.orange)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.descriptionBold
                        .copyWith(color: AppStyle.orange)
                    : TextStyles.descriptionBold
                        .copyWith(color: AppStyle.orange),
          ),
          const SizedBox(height: 20),
          _buildDescription(
            content: widget.moreInfoDescription!,
            contentStyle: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.descriptionNormal
                    .copyWith(color: AppStyle.black)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.descriptionNormal
                        .copyWith(color: AppStyle.black)
                    : TextStyles.descriptionNormal
                        .copyWith(color: AppStyle.black),
            title: LocaleKeys.selector_extra_info.tr(),
            titleStyle: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.descriptionBold
                    .copyWith(color: AppStyle.blueText)
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.descriptionBold
                        .copyWith(color: AppStyle.blueText)
                    : TextStyles.descriptionBold
                        .copyWith(color: AppStyle.blueText),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      LocaleKeys.selector_title.tr(),
      style: _state.status == AccessibilityControllerStatus.big
          ? TextStylesBigger.selectorDescriptionTitleStyle
          : _state.status == AccessibilityControllerStatus.biggest
              ? TextStylesBiggest.selectorDescriptionTitleStyle
              : TextStyles.selectorDescriptionTitleStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildInformation(String image, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          image,
          width: 25,
          fit: BoxFit.fitWidth,
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(
            text,
            style: _state.status == AccessibilityControllerStatus.big
                ? TextStylesBigger.selectorImprtantTitleStyle
                : _state.status == AccessibilityControllerStatus.biggest
                    ? TextStylesBiggest.selectorImprtantTitleStyle
                    : TextStyles.selectorImprtantTitleStyle,
          ),
        ),
      ],
    );
  }

  SizedBox _buildDescription({
    required String title,
    required TextStyle titleStyle,
    required String content,
    required TextStyle contentStyle,
  }) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width > 768)
          ? MediaQuery.of(context).size.width * 0.55
          : MediaQuery.of(context).size.width,
      child: Wrap(
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Text(
            content,
            style: contentStyle,
          )
        ],
      ),
    );
  }
}
