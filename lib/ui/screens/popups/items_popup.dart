import 'package:aplinkos_ministerija/bloc/stages_cotroller/first_stage_bloc.dart';
import 'package:aplinkos_ministerija/model/items.dart';
import 'package:aplinkos_ministerija/ui/styles/text_styles.dart';
import 'package:aplinkos_ministerija/ui/widgets/items_tile.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:flutter/material.dart';

class ItemsPopUp extends StatefulWidget {
  final List<Items> itemsList;
  final String categoryName;
  final String subCategoryName;
  final FirstStageBloc firstStageBloc;
  const ItemsPopUp({
    super.key,
    required this.itemsList,
    required this.categoryName,
    required this.subCategoryName,
    required this.firstStageBloc,
  });

  @override
  State<ItemsPopUp> createState() => _ItemsPopUpState();
}

class _ItemsPopUpState extends State<ItemsPopUp> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(widget.categoryName),
              _buildDescription(
                  'Rezultatai kategorijoje „${widget.categoryName.toCapitalized()}”'),
              _buildDescription(
                  'Rezultatai subkategorijoje „${widget.subCategoryName.toCapitalized()}”'),
              const SizedBox(height: 50),
              _buildContentTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentTable() {
    return Column(
      children: List.generate(
        widget.itemsList.length,
        (index) {
          return Column(
            children: [
              ItemsTile(
                isTitleRowRequired: index == 0 ? true : false,
                descriptionTitle:
                    widget.itemsList[index].itemName!.toCapitalized(),
                trashCode: widget.itemsList[index].type!,
                toolTipMsg: 'Atliekos kodas: ${widget.itemsList[index].code}',
                code: widget.itemsList[index].code!,
                firstStageBloc: widget.firstStageBloc,
              ),
              (widget.itemsList.indexOf(widget.itemsList.last) == index)
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
      width: MediaQuery.of(context).size.width * 0.75,
      child: SelectableText(
        content,
        style: TextStyles.itemDescriptionStyle,
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
              text: 'Subkategorija ',
              style: TextStyles.itemTitleStyle,
            ),
            TextSpan(
              text: "„${title.toCapitalized()}”",
              style: TextStyles.itemTitleStyleSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
