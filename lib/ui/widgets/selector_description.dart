import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/constants/strings.dart';
import 'package:aplinkos_ministerija/generated/locale_keys.g.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SelectorDescription extends StatefulWidget {
  const SelectorDescription({super.key});

  @override
  State<SelectorDescription> createState() => _SelectorDescriptionState();
}

class _SelectorDescriptionState extends State<SelectorDescription> {
  String selectedValue = LocaleKeys.selector_city.tr();
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(
        value: LocaleKeys.selector_city.tr(),
        child: Text(LocaleKeys.selector_city.tr())),
  ];
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
          right: 20, left: (MediaQuery.of(context).size.width > 768) ? 0 : 20),
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
                  title:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                  titleStyle: TextStyles.searchDescStyle,
                  content: '',
                  contentStyle: const TextStyle(),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: (MediaQuery.of(context).size.width > 768)
                ? MediaQuery.of(context).size.width * 0.25
                : MediaQuery.of(context).size.width,
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.black.withOpacity(0.08)),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: AppColors.whiteSecondaryColor,
              ),
              dropdownColor: AppColors.whiteSecondaryColor,
              items: menuItems,
              value: null,
              onChanged: null,
              disabledHint: Text(selectedValue),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: (MediaQuery.of(context).size.width > 768)
                ? MediaQuery.of(context).size.width * 0.2
                : MediaQuery.of(context).size.width,
            height: 62,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenBtnHoover,
              ),
              child: Text(
                LocaleKeys.selector_more_info.tr(),
                style: TextStyles.searchBtnStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFirstSection(),
        Container(
          height: 1,
          width: (MediaQuery.of(context).size.width > 768)
              ? MediaQuery.of(context).size.width * 0.6
              : MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppColors.black.withOpacity(0.28),
          ),
        ),
        _buildSecondSection(),
      ],
    );
  }

  Padding _buildSecondSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 30),
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
            content:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
            contentStyle:
                TextStyles.descriptionNormal.copyWith(color: AppColors.black),
            title: LocaleKeys.selector_how_recycle.tr(),
            titleStyle:
                TextStyles.descriptionBold.copyWith(color: AppColors.orange),
          ),
          const SizedBox(height: 20),
          _buildDescription(
            content:
                'It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchange.',
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
      padding: const EdgeInsets.only(left: 20),
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
            content:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
            contentStyle:
                TextStyles.descriptionNormal.copyWith(color: AppColors.black),
            title: LocaleKeys.selector_how_recycle.tr(),
            titleStyle:
                TextStyles.descriptionBold.copyWith(color: AppColors.orange),
          ),
          const SizedBox(height: 20),
          _buildDescription(
            content:
                'It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchange.',
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

  Row _buildInformation(String image, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          image,
          width: 25,
          fit: BoxFit.fitWidth,
        ),
        const SizedBox(width: 10),
        Text(text),
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
