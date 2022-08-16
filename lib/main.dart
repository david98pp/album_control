import 'package:album_control/data/album_data.dart';
import 'package:album_control/model/group_model.dart';
import 'package:album_control/model/sticker_model.dart';
import 'package:album_control/provider/groupExpansionProvider.dart';
import 'package:album_control/provider/stickerProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      title: 'Control de stickers Qatar 2022',
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
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('Drawer Header'),
                ),
                ListTile(
                  title: const Text('Estadísticas'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: const Text('Control de stickers Qatar 2022'),
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
                                                      return Consumer<StickerProvider>(
                                                        builder: (_, provider, __) {
                                                          return InkWell(
                                                            onLongPress: () {
                                                              Sticker sticker = provider.getSticker(group.countries[j], listSticker, indexc);
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
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                        child: GridView.builder(
                          itemCount: listMissing.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () async => await provider.updateQuantity(listMissing[index]),
                            onLongPress: () => showDialogUpdate(context, listMissing[index]),
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
                            onLongPress: () => showDialogUpdate(context, listRepeated[index]),
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

  void showDialogUpdate(BuildContext context, Sticker sticker) {
    TextEditingController controller = TextEditingController(text: sticker.repeated.toString());

    String? numberValidator(String? value) {
      if (value == null) {
        return null;
      }
      final n = int.tryParse(value);
      if (n == null || n < 0) {
        return '"$value" no es número válido';
      }
      return null;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Modificar Sticker ${sticker.number.toString()}'),
        content: Form(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => controller.text = ((int.tryParse(controller.text) ?? 0) > 0 ? (int.tryParse(controller.text) ?? 1) - 1 : 0).toString(),
                icon: const Icon(Icons.minimize_sharp),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  validator: (s) => numberValidator(s),
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              IconButton(
                onPressed: () => controller.text = ((int.tryParse(controller.text) ?? 0) + 1).toString(),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
          TextButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await _providerSticker.updateQuantityModal(sticker, int.tryParse(controller.text) ?? sticker.repeated);
                navigator.pop();
              },
              child: const Text('Grabar')),
        ],
      ),
    );
  }
}
