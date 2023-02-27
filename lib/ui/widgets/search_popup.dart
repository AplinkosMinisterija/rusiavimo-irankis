import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:aplinkos_ministerija/model/items.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/ui/widgets/items_tile.dart';
import 'package:aplinkos_ministerija/ui/widgets/mobile_items_tile.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:flutter/material.dart';

import '../../model/category.dart';

class SearchPopUp extends StatefulWidget {
  final String title;
  final List<Category> categoriesList;
  final FirstStageBloc firstStageBloc;

  const SearchPopUp({
    super.key,
    required this.title,
    required this.firstStageBloc,
    required this.categoriesList,
  });

  @override
  State<SearchPopUp> createState() => _SearchPopUpState();
}

class _SearchPopUpState extends State<SearchPopUp> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: (MediaQuery.of(context).size.width > 768) ? 50 : 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (MediaQuery.of(context).size.width > 768)
                  ? _buildTitle(widget.title)
                  : const SizedBox(),
              (MediaQuery.of(context).size.width > 768)
                  ? _buildContentList()
                  : _buildMobileContent(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileContent() {
    return Column(
      children: List.generate(
        widget.categoriesList.length,
        (i) {
          return Column(
            children: [
              _buildDescription(
                  'Rezultatai kategorijoje „${widget.categoriesList[i].categoryName!.toCapitalized()}”'),
              Column(
                children: List.generate(
                  widget.categoriesList[i].subCategories!.length,
                  (index) {
                    return Column(
                      children: [
                        _buildDescription(
                            'Rezultatai subkategorijoje „${widget.categoriesList[i].subCategories![index].name}”'),
                        const SizedBox(height: 20),
                        _buildMobileContentList(widget.categoriesList[i].subCategories![index].items!),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMobileContentList(List<Items> itemsList) {
    return Column(
      children: List.generate(
        itemsList.length,
        (index) {
          return Column(
            children: [
              MobileItemsTile(
                code: itemsList[index].code!,
                trashType: itemsList[index].type!,
                itemName: itemsList[index].itemName!,
                firstStageBloc: widget.firstStageBloc,
                listOfCategories: widget.categoriesList,
              ),
              (itemsList.indexOf(itemsList.last) == index)
                  ? const SizedBox(height: 30)
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContentList() {
    return Column(
      children: List.generate(
        widget.categoriesList.length,
        (i) {
          return Column(
            children: [
              _buildDescription(
                  'Rezultatai kategorijoje „${widget.categoriesList[i].categoryName!.toCapitalized()}”'),
              Column(
                children: List.generate(
                  widget.categoriesList[i].subCategories!.length,
                  (index) {
                    return Column(
                      children: [
                        _buildDescription(
                            'Rezultatai subkategorijoje „${widget.categoriesList[i].subCategories![index].name}”'),
                        const SizedBox(height: 20),
                        _buildContentTable(widget
                            .categoriesList[i].subCategories![index].items!),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContentTable(List<Items> itemsList) {
    return Column(
      children: List.generate(
        itemsList.length,
        (index) {
          return Column(
            children: [
              ItemsTile(
                isTitleRowRequired: index == 0 ? true : false,
                descriptionTitle: itemsList[index].itemName!.toCapitalized(),
                trashCode: itemsList[index].type!,
                toolTipMsg: 'Atliekos kodas: ${itemsList[index].code}',
                code: itemsList[index].code!,
                firstStageBloc: widget.firstStageBloc,
                listOfCategories: widget.categoriesList,
              ),
              (itemsList.indexOf(itemsList.last) == index)
                  ? const SizedBox(height: 30)
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDescription(String content) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width > 768)
          ? MediaQuery.of(context).size.width * 0.75
          : MediaQuery.of(context).size.width,
      child: SelectableText(
        content,
        style: (MediaQuery.of(context).size.width > 768)
            ? TextStyles.itemDescriptionStyle
            : TextStyles.mobileTypeStyle,
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 80, 0, 50),
      width: MediaQuery.of(context).size.width * 0.75,
      child: SelectableText.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: 'Paieška ',
              style: TextStyles.itemTitleStyle,
            ),
            TextSpan(
              text: "„$title”",
              style: TextStyles.itemTitleStyleSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
