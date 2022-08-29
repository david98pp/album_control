import 'package:album_control/data/album_data.dart';
import 'package:album_control/model/group_model.dart';
import 'package:album_control/model/sticker_model.dart';
import 'package:album_control/provider/group_expansion_provider.dart';
import 'package:album_control/provider/sticker_provider.dart';
import 'package:album_control/ui/modals/dialog_about.dart';
import 'package:album_control/ui/modals/dialog_instructions.dart';
import 'package:album_control/ui/modals/dialog_statistics.dart';
import 'package:album_control/ui/modals/dialog_update.dart';
import 'package:album_control/ui/widgets/banner_ad_widget.dart';
import 'package:album_control/utils/diff_in_days.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

late StickerProvider _providerSticker;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(ChangeNotifierProvider(create: (_) => AlbumData(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de stickers Mundial Qatar 2022',
      theme: ThemeData(primarySwatch: getMaterialColorFromColor(const Color.fromARGB(255, 110, 18, 52))),
      home: ChangeNotifierProvider(create: (_) => StickerProvider(), child: MyHomePage()),
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
    List<Sticker> listStickerMissing = providerAlbum.stickerMissingList;
    List<Group> listGroupMissing = providerAlbum.groupMissingList;
    List<Sticker> listStickerRepeated = providerAlbum.stickerRepeatedList;
    List<Group> listGroupRepeated = providerAlbum.groupRepeatedList;
    var sum = -1;

    if (!providerAlbum.loading) {
      showDialogInstructions(context);
    }

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
                        child: Text(diffInDays(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.data_saver_off_rounded),
                  title: const Text('Estadísticas'),
                  onTap: () => showDialogStatistics(context, listSticker),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('Acerca de'),
                  onTap: () => showDialogAbout(context),
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
                    Tab(text: "Todos"),
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
                      child: Column(
                        children: [
                          Expanded(
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
                                                        sum = group.groupName != 'Especiales' ? 0 : -1;
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
                                                              itemCount: group.countries[j].to - group.countries[j].from + (group.groupName != 'Especiales' ? 0 : 1),
                                                              itemBuilder: (context, indexc) {
                                                                sum += 1;
                                                                int i = group.countries[j].from;
                                                                return Consumer<StickerProvider>(
                                                                  builder: (_, provider, __) {
                                                                    return InkWell(
                                                                      onLongPress: () {
                                                                        Sticker sticker = provider.getSticker(
                                                                            group.countries[j], listSticker, group.groupName != 'Especiales' ? indexc + 1 : indexc);
                                                                        showDialogUpdate(
                                                                            context, group.groupName != 'Especiales' ? indexc + 1 : indexc, sticker, _providerSticker);
                                                                      },
                                                                      onTap: () async => await provider.updateQuantityTeams(
                                                                          group.countries[j], listSticker, group.groupName != 'Especiales' ? indexc + 1 : indexc),
                                                                      child: Stack(
                                                                        children: [
                                                                          Align(
                                                                            child: Text(
                                                                              sum.toString(),
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
                          const BannerAdWidget(),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 110, 18, 52),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  ...listGroupMissing
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
                                                        sum = group.groupName != 'Especiales' ? 0 : -1;
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
                                                              itemCount: group.countries[j].to - group.countries[j].from + (group.groupName != 'Especiales' ? 0 : 1),
                                                              itemBuilder: (context, indexc) {
                                                                sum += 1;
                                                                int i = group.countries[j].from;
                                                                return Consumer<StickerProvider>(
                                                                  builder: (_, provider, __) {
                                                                    ;
                                                                    return InkWell(
                                                                      onLongPress: () {
                                                                        Sticker sticker = provider.getSticker(
                                                                            group.countries[j], listStickerMissing, group.groupName != 'Especiales' ? indexc + 1 : indexc);
                                                                        showDialogUpdate(
                                                                            context, group.groupName != 'Especiales' ? indexc + 1 : indexc, sticker, _providerSticker);
                                                                      },
                                                                      onTap: () async => await provider.updateQuantityTeams(
                                                                          group.countries[j], listStickerMissing, group.groupName != 'Especiales' ? indexc + 1 : indexc),
                                                                      child: Align(
                                                                        child: Text(
                                                                          sum.toString(),
                                                                          style: const TextStyle(fontSize: 18.0, color: Color.fromARGB(255, 110, 18, 52)),
                                                                        ),
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
                      ),
                    ),
                  ),
                  Container(
                    color: const Color.fromARGB(255, 110, 18, 52),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  ...listGroupRepeated
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
                                                        sum = group.groupName != 'Especiales' ? 0 : -1;
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
                                                              //      itemCount: group.countries[j].to - group.countries[j].from + (group.groupName != 'Especiales' ? 0 : 1),
                                                              itemBuilder: (context, indexc) {
                                                                sum += 1;
                                                                int i = group.countries[j].from;
                                                                return Consumer<StickerProvider>(
                                                                  builder: (_, provider, __) {
                                                                    return InkWell(
                                                                      onLongPress: () {
                                                                        Sticker sticker = provider.getSticker(
                                                                            group.countries[j], listStickerRepeated, group.groupName != 'Especiales' ? indexc + 1 : indexc);
                                                                        showDialogUpdate(
                                                                            context, group.groupName != 'Especiales' ? indexc + 1 : indexc, sticker, _providerSticker);
                                                                      },
                                                                      onTap: () async => await provider.updateQuantityTeams(
                                                                          group.countries[j], listStickerRepeated, group.groupName != 'Especiales' ? indexc + 1 : indexc),
                                                                      child: Stack(
                                                                        children: [
                                                                          Align(
                                                                            child: Text(
                                                                              sum.toString(),
                                                                              style: const TextStyle(fontSize: 18.0, color: Color.fromARGB(255, 110, 18, 52)),
                                                                            ),
                                                                          ),
                                                                          if (listStickerRepeated[i + sum].repeated > 0)
                                                                            Align(
                                                                              alignment: Alignment.bottomRight,
                                                                              child: Text(
                                                                                listStickerRepeated[i + sum].repeated.toString(),
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
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

Color getShade(Color color, {bool darker = false, double value = .1}) {
  assert(value >= 0 && value <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((darker ? (hsl.lightness - value) : (hsl.lightness + value)).clamp(0.0, 1.0));

  return hslDark.toColor();
}

MaterialColor getMaterialColorFromColor(Color color) {
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
