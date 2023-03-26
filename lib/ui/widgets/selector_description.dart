import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/generated/locale_keys.g.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:js' as js;

class SelectorDescription extends StatefulWidget {
  final String? sortDescription;
  final String? moreInfoDescription;
  final String? whereToGiveAway;
  final String? whereToGiveAway2;
  final bool isDangerous;

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
  });

  @override
  State<SelectorDescription> createState() => _SelectorDescriptionState();
}

class _SelectorDescriptionState extends State<SelectorDescription> {
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 768) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(),
            _buildRightPart(),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildSection(),
            _buildRightPart(),
          ],
        ),
      );
    }
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
                  style: TextStyles.searchTitleStyle,
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
                        titleStyle: TextStyles.searchDescStyle,
                        content: '',
                        contentStyle: const TextStyle(),
                      ),
                      (widget.whereToGiveAway2 != null)
                          ? _buildDescription(
                              title: widget.whereToGiveAway2!,
                              titleStyle: TextStyles.searchDescStyle,
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
          //             BorderSide(color: AppColors.black.withOpacity(0.08)),
          //         borderRadius: BorderRadius.circular(8),
          //       ),
          //       filled: true,
          //       fillColor: AppColors.whiteSecondaryColor,
          //     ),
          //     dropdownColor: AppColors.whiteSecondaryColor,
          //     items: menuItems,
          //     value: null,
          //     onChanged: null,
          //     disabledHint: Text(selectedValue),
          //   ),
          // ),
          // const SizedBox(height: 20),
          Container(
            width: (MediaQuery.of(context).size.width > 768)
                ? MediaQuery.of(context).size.width * 0.2
                : MediaQuery.of(context).size.width,
            padding: (MediaQuery.of(context).size.width > 768)
                ? null
                : const EdgeInsets.symmetric(horizontal: 40),
            height: 62,
            child: ElevatedButton(
              onPressed: () {
                js.context.callMethod('open', [
                  'https://www.atliekukultura.lt/atlieku-kulturos-zemelapis/'
                ]);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenBtnHoover,
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Kur tvarkyti?',
                  style: TextStyles.searchBtnStyle,
                  textAlign: TextAlign.center,
                ),
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
            contentStyle:
                TextStyles.descriptionNormal.copyWith(color: AppColors.black),
            title: LocaleKeys.selector_how_recycle.tr(),
            titleStyle:
                TextStyles.descriptionBold.copyWith(color: AppColors.orange),
          ),
          const SizedBox(height: 20),
          _buildDescription(
            content: widget.moreInfoDescription!,
            contentStyle:
                TextStyles.descriptionNormal.copyWith(color: AppColors.black),
            title: LocaleKeys.selector_extra_info.tr(),
            titleStyle:
                TextStyles.descriptionBold.copyWith(color: AppColors.blueText),
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
            contentStyle:
                TextStyles.descriptionNormal.copyWith(color: AppColors.black),
            title: LocaleKeys.selector_how_recycle.tr(),
            titleStyle:
                TextStyles.descriptionBold.copyWith(color: AppColors.orange),
          ),
          const SizedBox(height: 20),
          _buildDescription(
            content: widget.moreInfoDescription!,
            contentStyle:
                TextStyles.descriptionNormal.copyWith(color: AppColors.black),
            title: LocaleKeys.selector_extra_info.tr(),
            titleStyle:
                TextStyles.descriptionBold.copyWith(color: AppColors.blueText),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      LocaleKeys.selector_title.tr(),
      style: TextStyles.selectorDescriptionTitleStyle,
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
          child: AutoSizeText(
            text,
            style: TextStyles.selectorImprtantTitleStyle,
            maxFontSize: 15,
            minFontSize: 8,
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
