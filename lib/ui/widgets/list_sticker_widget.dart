import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/album_data.dart';
import '../../model/group_model.dart';
import '../../model/sticker_model.dart';
import '../../provider/group_expansion_provider.dart';
import '../../provider/sticker_provider.dart';
import '../modals/dialog_update.dart';
import 'banner_ad_widget.dart';

Widget listStickerWidget(List<Group> list, AlbumData providerAlbum, StickerProvider providerSticker, int page) {
  return Container(
    color: const Color.fromARGB(255, 110, 18, 52),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: list.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        ...list
                            .map(
                              (group) => ChangeNotifierProvider(
                                create: (_) => GroupExpansionProvider(),
                                child: Consumer<GroupExpansionProvider>(builder: (_, providerCountry, __) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ExpansionPanelList(
                                      children: [
                                        ExpansionPanel(
                                          headerBuilder: (context, isExpanded) {
                                            return ListTile(title: Text(group.groupName, style: const TextStyle(fontSize: 20)));
                                          },
                                          canTapOnHeader: true,
                                          isExpanded: providerCountry.isExpanded,
                                          body: ListView.builder(
                                            shrinkWrap: true,
                                            primary: false,
                                            itemCount: group.countries.length,
                                            itemBuilder: (context, j) {
                                              return Column(
                                                children: [
                                                  group.groupName != 'Especiales'
                                                      ? Text(
                                                          group.countries[j].name,
                                                          style: const TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
                                                        )
                                                      : Container(),
                                                  GridView.builder(
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    itemCount: group.countries[j].stickerList.length - (group.groupName != 'Especiales' ? (page == 2 ? 0 : 1) : 0),
                                                    itemBuilder: (context, index) {
                                                      Sticker sticker = group.countries[j].stickerList[index];
                                                      return Consumer<StickerProvider>(
                                                        builder: (_, provider, __) {
                                                          return InkWell(
                                                            onLongPress: () => showDialogUpdate(context, group.countries[j], sticker, providerSticker, providerAlbum),
                                                            onTap: () async => await provider.updateQuantity(group.countries[j], group.countries[j].stickerList[index], providerAlbum),
                                                            child: Stack(
                                                              children: [
                                                                Align(
                                                                  child: Text(
                                                                    sticker.text,
                                                                    style: const TextStyle(fontSize: 18.0, color: Color.fromARGB(255, 110, 18, 52)),
                                                                  ),
                                                                ),
                                                                if (sticker.repeated > 0)
                                                                  Align(
                                                                    alignment: Alignment.bottomRight,
                                                                    child: Text(
                                                                      (sticker.repeated-(page==2?1:0)).toString(),
                                                                      style: const TextStyle(fontSize: 13.0, color: Color.fromARGB(255, 110, 18, 52)),
                                                                    ),
                                                                  )
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                      expansionCallback: (panelIndex, isExpanded) {
                                        providerCountry.isExpanded = !isExpanded;
                                      },
                                    ),
                                  );
                                }),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ),
                const BannerAdWidget(),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: const [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text('No tienes stickers aquí', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400), textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const BannerAdWidget(),
              ],
            ),
    ),
  );
}
