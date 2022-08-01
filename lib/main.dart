import 'package:album_control/model/album_data.dart';
import 'package:album_control/model/group_model.dart';
import 'package:album_control/model/sticker_model.dart';
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
      title: 'Control de stickers mundial 2022',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
                  onTap: () {
                    Navigator.pop(context);
                  },
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
                    Tab(text: "Faltantes"),
                    Tab(text: "Repetidos"),
                    Tab(text: "Equipos"),
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
                  Consumer<StickerModel>(
                    builder: (_, provider, __) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            primary: true,
                            itemCount: listGroup.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Column(
                                  children: [
                                    index != 0 ? Text(listGroup[index].groupName) : Container(),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      itemCount: listGroup[index].countries.length,
                                      itemBuilder: (context, j) {
                                        sum = -1;
                                        return Column(
                                          children: [
                                            Text(listGroup[index].countries[j].name),
                                            GridView.builder(
                                              shrinkWrap: true,
                                              primary: false,
                                              itemCount: listGroup[index].countries[j].to - listGroup[index].countries[j].from + 1,
                                              itemBuilder: (context, indexc) {
                                                sum += 1;
                                                int i = listGroup[index].countries[j].from;
                                                return InkWell(
                                                  onTap: () async => await provider.updateQuantityTeams(listGroup[index].countries[j], listSticker, indexc),
                                                  child: Stack(
                                                    children: [
                                                      Align(alignment: Alignment.center, child: Text(listSticker[i + sum].number.toString())),
                                                      if (listSticker[i + sum].repeated > 0)
                                                        Align(
                                                          alignment: Alignment.bottomRight,
                                                          child: Text(listSticker[i + sum].repeated.toString(), style: const TextStyle(fontSize: 12.0)),
                                                        )
                                                    ],
                                                  ),
                                                );
                                              },
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );
                    },
                  ),
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
}
