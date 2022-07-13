import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            // padding: EdgeInsets.zero,
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
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('Control de stickers'),
          centerTitle: true,
          elevation: 2,
          bottom: const TabBar(
            unselectedLabelColor: Color(0xFF8EC552),
            indicatorColor: Color(0xFF8EC552),
            labelColor: Color(0xFF8EC552),
            labelStyle: TextStyle(fontSize: 11.5),
            tabs: [
              Tab(text: "Todos"),
              Tab(text: "Faltantes"),
              Tab(text: "Repetidos"),
              Tab(text: "Equipos"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              //TODO ListView to GridView
              child: ListView.builder(
                itemCount: 256,
                itemBuilder: (context, index) {
                  return Container();
                },
              ),
            ),
            const Center(
              child: Text('Faltantes'),
            ),
            const Center(
              child: Text('Repetidos'),
            ),
            const Center(
              child: Text('Equipos'),
            ),
          ],
        ),
      ),
    );
  }
}
