import 'package:album_control/data/album_data.dart';
import 'package:album_control/diff_in_days.dart';
import 'package:album_control/model/group_model.dart';
import 'package:album_control/model/sticker_model.dart';
import 'package:album_control/provider/group_expansion_provider.dart';
import 'package:album_control/provider/sticker_provider.dart';
import 'package:album_control/ui/modals/dialog_update.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

late StickerProvider _providerSticker;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(create: (_) => AlbumData(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static Color getShade(Color color, {bool darker = false, double value = .1}) {
    assert(value >= 0 && value <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((darker ? (hsl.lightness - value) : (hsl.lightness + value)).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static MaterialColor getMaterialColorFromColor(Color color) {
    Map<int, Color> colorShades = {
      50: getShade(color, value: 0.5),
      100: getShade(color, value: 0.4),
      200: getShade(color, value: 0.3),
      300: getShade(color, value: 0.2),
      400: getShade(color, value: 0.1),
      500: color,
      600: getShade(color, value: 0.1, darker: true),
      700: getShade(color, value: 0.15, darker: true),
      800: getShade(color, value: 0.2, darker: true),
      900: getShade(color, value: 0.25, darker: true),
    };
    return MaterialColor(color.value, colorShades);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de stickers Mundial Qatar 2022',
      theme: ThemeData(primarySwatch: getMaterialColorFromColor(const Color.fromARGB(255, 110, 18, 52))),
      home: ChangeNotifierProvider(create: (_) => StickerProvider(), child: const MyHomePage()),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var providerAlbum = context.watch<AlbumData>();
    _providerSticker = context.watch<StickerProvider>();
    List<Sticker> listSticker = providerAlbum.stickerList;
    List<Group> listGroup = providerAlbum.groupList;
    var sum = -1;
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        drawer: SafeArea(
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Color.fromARGB(255, 110, 18, 52)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: Image.asset("assets/images/header.jpeg", fit: BoxFit.contain)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(diffInDays(), style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.data_saver_off_rounded),
                  title: const Text('Estadísticas'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('Acerca de'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.close),
                  title: const Text('Cerrar'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text('Control de stickers Mundial Qatar 2022', style: TextStyle(fontSize: 17)),
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
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    CircularProgressIndicator(),
                  ],
                ),
              )
            : TabBarView(
                children: <Widget>[
                  Container(
                    color: const Color.fromARGB(255, 110, 18, 52),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            ...listGroup
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
                                                  sum = -1;
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
                                                        itemCount: group.countries[j].to - group.countries[j].from + 1,
                                                        itemBuilder: (context, indexc) {
                                                          sum += 1;
                                                          int i = group.countries[j].from;
                                                          return Consumer<StickerProvider>(
                                                            builder: (_, provider, __) {
                                                              return InkWell(
                                                                onLongPress: () {
                                                                  Sticker sticker = provider.getSticker(group.countries[j], listSticker, indexc);
                                                                  showDialogUpdate(context, sticker, _providerSticker);
                                                                },
                                                                onTap: () async => await provider.updateQuantityTeams(group.countries[j], listSticker, indexc),
                                                                child: Stack(
                                                                  children: [
                                                                    Align(
                                                                      child: Text(
                                                                        listSticker[i + sum].number.toString(),
                                                                        style: const TextStyle(fontSize: 18.0, color: Color.fromARGB(255, 110, 18, 52)),
                                                                      ),
                                                                    ),
                                                                    if (listSticker[i + sum].repeated > 0)
                                                                      Align(
                                                                        alignment: Alignment.bottomRight,
                                                                        child: Text(
                                                                          listSticker[i + sum].repeated.toString(),
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
                  Consumer<StickerProvider>(
                    builder: (_, provider, __) {
                      List<Sticker> listMissing = [...listSticker];
                      listMissing.removeWhere((element) => element.repeated != 0);
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
                        itemCount: listMissing.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            radius: 100,
                            onTap: () async => await provider.updateQuantity(listMissing[index]),
                            onLongPress: () => showDialogUpdate(context, listMissing[index], _providerSticker),
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 154, 16, 66),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  listMissing[index].number.toString(),
                                  style: const TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Consumer<StickerProvider>(
                    builder: (_, provider, __) {
                      List<Sticker> listRepeated = [...listSticker];
                      listRepeated.removeWhere((element) => element.repeated < 2);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                        child: GridView.builder(
                          itemCount: listRepeated.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () async => await provider.updateQuantity(listRepeated[index]),
                            onLongPress: () => showDialogUpdate(context, listRepeated[index], _providerSticker),
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
