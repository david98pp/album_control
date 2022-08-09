import 'package:album_control/model/album_data.dart';
import 'package:album_control/model/group_model.dart';
import 'package:album_control/model/sticker_model.dart';
import 'package:album_control/provider/groupExpansionProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(create: (_) => AlbumData(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de stickers mundial Qatar 2022',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChangeNotifierProvider(create: (_) => StickerModel(), child: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var providerAlbum = context.watch<AlbumData>();
    List<StickerModel> listSticker = providerAlbum.stickerList;
    List<GroupModel> listGroup = providerAlbum.groupList;
    var sum = -1;
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        drawer: SafeArea(
          child: Drawer(
            child: ListView(
              children: [
                /* const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('Drawer Header'),
                ),*/
                ListTile(
                  title: const Text('Estadísticas'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text('Control de stickers'),
          centerTitle: true,
          elevation: 2,
          bottom: providerAlbum.loading
              ? null
              : const TabBar(
                  labelStyle: TextStyle(fontSize: 12),
                  tabs: [
                    //  Tab(text: "Todos"),
                    Tab(text: "Equipos"),
                    Tab(text: "Faltantes"),
                    Tab(text: "Repetidos"),
                  ],
                ),
        ),
        body: providerAlbum.loading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        'Estamos cargando los stickers',
                        style: TextStyle(fontSize: 20, color: Colors.blue),
                      ),
                    ),
                    CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ],
                ),
              )
            : TabBarView(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ...listGroup
                                .map(
                                  (group) => ChangeNotifierProvider(
                                    create: (_) => GroupExpansionProvider(),
                                    child: Consumer<GroupExpansionProvider>(builder: (_, providerCountry, __) {
                                      return ExpansionPanelList(
                                        children: [
                                          ExpansionPanel(
                                            headerBuilder: (context, isExpanded) {
                                              return ListTile(title: Text(group.groupName));
                                            },
                                            canTapOnHeader: true,
                                            isExpanded: providerCountry.isExpanded,
                                            body: ListView.builder(
                                              shrinkWrap: true,
                                              primary: false,
                                              itemCount: group.countries.length,
                                              itemBuilder: (context, j) {
                                                sum = -1;
                                                return Column(
                                                  children: [
                                                    group.groupName != 'Especiales'
                                                        ? Text(
                                                            group.countries[j].name,
                                                            style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                                                          )
                                                        : Container(),
                                                    GridView.builder(
                                                      shrinkWrap: true,
                                                      primary: false,
                                                      itemCount: group.countries[j].to - group.countries[j].from + 1,
                                                      itemBuilder: (context, indexc) {
                                                        sum += 1;
                                                        int i = group.countries[j].from;
                                                        return Consumer<StickerModel>(
                                                          builder: (_, provider, __) {
                                                            return InkWell(
                                                              onLongPress: () {
                                                                StickerModel sticker = provider.getSticker(group.countries[j], listSticker, indexc);
                                                                showDialogUpdate(context, sticker);
                                                              },
                                                              onTap: () async => await provider.updateQuantityTeams(group.countries[j], listSticker, indexc),
                                                              child: Stack(
                                                                children: [
                                                                  Align(
                                                                      alignment: Alignment.center,
                                                                      child: Text(listSticker[i + sum].number.toString(), style: const TextStyle(fontSize: 15.0))),
                                                                  if (listSticker[i + sum].repeated > 0)
                                                                    Align(
                                                                      alignment: Alignment.bottomRight,
                                                                      child: Text(listSticker[i + sum].repeated.toString(), style: const TextStyle(fontSize: 12.0)),
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
                                      );
                                    }),
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      )),
                  /* Consumer<Sticker>(
              builder: (_, provider, __) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: GridView.builder(
                    itemCount: listSticker.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => provider.updateQuantity(listSticker[index]),
                      child: Stack(
                        children: [
                          Align(alignment: Alignment.center, child: Text(listSticker[index].number.toString())),
                          if (listSticker[index].repeated > 0)
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(listSticker[index].repeated.toString(), style: const TextStyle(fontSize: 12.0)),
                            )
                        ],
                      ),
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                  ),
                );
              },
            ), */
                  Consumer<StickerModel>(
                    builder: (_, provider, __) {
                      List<StickerModel> listMissing = [...listSticker];
                      listMissing.removeWhere((element) => element.repeated != 0);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                        child: GridView.builder(
                          itemCount: listMissing.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () async => await provider.updateQuantity(listSticker[index]),
                            onLongPress: () => showDialogUpdate(context, listSticker[index]),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(listMissing[index].number.toString()),
                            ),
                          ),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                        ),
                      );
                    },
                  ),
                  Consumer<StickerModel>(
                    builder: (_, provider, __) {
                      List<StickerModel> listRepeated = [...listSticker];
                      listRepeated.removeWhere((element) => element.repeated < 2);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                        child: GridView.builder(
                          itemCount: listRepeated.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () async => await provider.updateQuantity(listSticker[index]),
                            onLongPress: () => showDialogUpdate(context, listSticker[index]),
                            child: Stack(
                              children: [
                                Align(alignment: Alignment.center, child: Text(listRepeated[index].number.toString())),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(listRepeated[index].repeated.toString(), style: const TextStyle(fontSize: 12.0)),
                                )
                              ],
                            ),
                          ),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                        ),
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }

  void showDialogUpdate(BuildContext context, StickerModel sticker) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Modificar Sticker ${sticker.number.toString()}'),
        content: Text('Sticker ${sticker.number}', textAlign: TextAlign.center),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Grabar')),
        ],
      ),
    );
  }
}
