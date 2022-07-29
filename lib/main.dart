import 'package:album_control/model/album_data.dart';
import 'package:album_control/model/sticker_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<StickerModel> listSticker = List<StickerModel>.generate(801, (int index) => StickerModel.params(index, '', 'A', 0));

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(create: (_) => AlbumData(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 12),
            tabs: [
              //  Tab(text: "Todos"),
              Tab(text: "Faltantes"),
              Tab(text: "Repetidos"),
              Tab(text: "Equipos"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
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
                      onTap: () => provider.updateQuantity(listSticker[index]),
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
                      onTap: () => provider.updateQuantity(listSticker[index]),
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
            Consumer<StickerModel>(
              builder: (_, provider, __) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: Column(
                    children: [
                      GridView.builder(
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
                    ],
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
