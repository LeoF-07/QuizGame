import 'package:flutter/material.dart';
import 'package:quiz_game/path_databases.dart';
import 'package:quiz_game/setup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Quiz Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextStyle stileTitolo;
  late TextStyle stileTesto;

  TableRow rigaTabella(List<RawMaterialButton> buttons, double height){
    List<SizedBox> children = [];

    for(RawMaterialButton button in buttons){
      children.add(
          SizedBox(
              height: height,
              child: button
          )
      );
    }

    return TableRow(children: children);
  }

  void goToSetupPage(int i) {
    if(i != 0){
      i += 8;
    }
    Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => SetupPage(key: UniqueKey(), title: 'Setup Page', category: i))
    );
  }

  @override
  Widget build(BuildContext context) {
    const double baseWidth = 412;
    const double baseHeight = 915;

    final size = MediaQuery.of(context).size;
    final scaleW = size.width / baseWidth;
    final scaleH = size.height / baseHeight;
    final scale = scaleW <= scaleH ? scaleW : scaleH;

    double p(double value) => value * scale;

    stileTitolo = TextStyle(fontSize: p(40));
    stileTesto = TextStyle(fontSize: p(22));

    List<RawMaterialButton> pulsantiCategoria = [];
    for(int i = 0; i < 25; i++){
      pulsantiCategoria.add(
          RawMaterialButton(
            onPressed: () => goToSetupPage(i),
            child: Image.asset(PathDatabases.categoriesPaths[i]),
          )
      );
    }
    pulsantiCategoria.add(RawMaterialButton(onPressed: () {}));
    pulsantiCategoria.add(RawMaterialButton(onPressed: () {}));

    return Scaffold(
        body: SafeArea(
          child: Column(
            spacing: p(20),
            children: [
              SizedBox(height: 10),
              Text(widget.title, style: stileTitolo),
              SizedBox(height: 10),
              Text("Choose a category", style: stileTesto),
              Container(
                  margin: EdgeInsets.all(p(20)),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: p(2)),
                  ),
                  child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: p(520)),
                      child: SingleChildScrollView(
                        child: Table(
                            border: TableBorder.all(),
                            children: [
                              rigaTabella(pulsantiCategoria.sublist(0, 3), p(150)),
                              rigaTabella(pulsantiCategoria.sublist(3, 6), p(150)),
                              rigaTabella(pulsantiCategoria.sublist(6, 9), p(150)),
                              rigaTabella(pulsantiCategoria.sublist(9, 12), p(150)),
                              rigaTabella(pulsantiCategoria.sublist(12, 15), p(150)),
                              rigaTabella(pulsantiCategoria.sublist(15, 18), p(150)),
                              rigaTabella(pulsantiCategoria.sublist(18, 21), p(150)),
                              rigaTabella(pulsantiCategoria.sublist(21, 24), p(150)),
                              rigaTabella(pulsantiCategoria.sublist(24, 27), p(150))
                            ],
                        ),
                      )
                  )
              ),
            ],
          ),
        )
    );
  }
}

