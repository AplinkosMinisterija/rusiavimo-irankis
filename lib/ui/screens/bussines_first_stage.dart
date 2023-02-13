import 'package:aplinkos_ministerija/constants/app_colors.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/ui/widgets/default_btn.dart';
import 'package:flutter/material.dart';

class BussinessFirstStageScreen extends StatefulWidget {
  const BussinessFirstStageScreen({super.key});

  @override
  State<BussinessFirstStageScreen> createState() =>
      _BussinessFirstStageScreenState();
}

class _BussinessFirstStageScreenState extends State<BussinessFirstStageScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<bool> boolsList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  final List<bool> anotherBoolsList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        const SizedBox(height: 40),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04),
          child: Column(
            children: [
              _buildSearchSection(),
              const SizedBox(height: 80),
              _buildSelectionSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionSection() {
    return Column(
      children: [
        _buildText(),
        const SizedBox(height: 30),
        _buildSelection(),
      ],
    );
  }

  Widget _buildSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildLeftPart()),
        Expanded(child: _buildRightPart())
      ],
    );
  }

  Widget _buildRightPart() {
    return Column(
      children: [
        ListView(
          shrinkWrap: true,
          children: List.generate(
            8,
            (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: DefaultButton(
                      toolTipMsg: 'Lorem ipsum dolor sit amet consectetur.',
                      btnText: 'Gamybos procesų sektorius',
                      isPressed: boolsList[index],
                      hoverColor: AppColors.greenBtnUnHoover,
                      onPressed: () {
                        if (anotherBoolsList.contains(true)) {
                          if (boolsList[index] == false) {
                            if (boolsList.contains(true)) {
                              int boolTrueIndex = boolsList.indexOf(true);
                              boolsList[boolTrueIndex] = false;
                            }
                            boolsList[index] = true;
                          } else {
                            boolsList[index] = false;
                          }
                          setState(() {});
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLeftPart() {
    return Column(
      children: [
        ListView(
          shrinkWrap: true,
          children: List.generate(
            8,
            (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: DefaultButton(
                      toolTipMsg: 'Lorem ipsum dolor sit amet consectetur.',
                      btnText: 'Gamybos procesų sektorius',
                      isPressed: anotherBoolsList[index],
                      onPressed: () {
                        if (anotherBoolsList[index] == false) {
                          if (anotherBoolsList.contains(true)) {
                            int boolTrueIndex = anotherBoolsList.indexOf(true);
                            anotherBoolsList[boolTrueIndex] = false;
                            if (boolsList.contains(true)) {
                              int boolIndex = boolsList.indexOf(true);
                              boolsList[boolIndex] = false;
                            }
                          }
                          anotherBoolsList[index] = true;
                        } else {
                          anotherBoolsList[index] = false;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildText() {
    return SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'arba ',
            style: TextStyles.selectorDescriptionTitleStyle.copyWith(
              color: AppColors.orange,
            ),
          ),
          const TextSpan(
            text: 'pasirinkite atliekų kategoriją ',
            style: TextStyles.selectorDescriptionTitleStyle,
          ),
          const TextSpan(
            text:
                'Lorem ipsum dolor sit amet consectetur. Vulputate elementum viverra fusce ut faucibus ut tortor. Arcu facilisi nascetur feugiat ut et gravida nulla eget eros. Lobortis nec amet placerat cras porttitor.',
            style: TextStyles.descriptionNormal,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Column(
      children: [
        const SelectableText.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Naudokite paiešką',
                style: TextStyles.selectorDescriptionTitleStyle,
              ),
              TextSpan(
                text:
                    'Lorem ipsum dolor sit amet consectetur. Vulputate elementum viverra fusce ut faucibus ut tortor. Arcu facilisi nascetur feugiat ut et gravida nulla eget eros. Lobortis nec amet placerat cras porttitor.',
                style: TextStyles.descriptionNormal,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              height: 50,
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Paieška',
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.black.withOpacity(0.08)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppColors.whiteSecondaryColor,
                ),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenBtnUnHoover),
                onPressed: () {},
                child: const Text(
                  'Ieškoti',
                  style: TextStyles.searchBtnStyle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      color: AppColors.greenBtnUnHoover,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.scaffoldColor,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    '1',
                    style: TextStyles.numberTextStyle
                        .copyWith(color: AppColors.greenBtnUnHoover),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 50),
            SelectableText(
              'Naudokite paiešką arba pasirinkite atliekų kategoriją',
              style: TextStyles.howToUseTitleStyle
                  .copyWith(color: AppColors.scaffoldColor),
            ),
          ],
        ),
      ),
    );
  }
}
