import 'package:flutter/material.dart';
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
  TextStyle stileTitolo = TextStyle(fontSize: 40);

  String category = "";

  List<String> paths = [
    "images/categories/any.png",
    "images/categories/generalKnowledge.png",
    "images/categories/books.png",
    "images/categories/computers.png",
    "images/categories/film.png",
    "images/categories/television.png",
    "images/categories/mathematics.png",
    "images/categories/scienceNature.png",
    "images/categories/geography.png"
  ];

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

  void goToSetupPage() {
    Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => SetupPage(key: UniqueKey(), title: 'Setup Page', category: category))
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

    List<RawMaterialButton> pulsantiCategoria = [];
    for(int i = 0; i < 9; i++){
      pulsantiCategoria.add(
          RawMaterialButton(
            onPressed: goToSetupPage,
            child: Image.asset(paths[i]),
          )
      );
    }

    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(p(20)),
                  child: Text(widget.title, style: stileTitolo),
                ),
                Padding(
                  padding: EdgeInsets.all(p(20)),
                  child: Table(
                    border: TableBorder.all(),
                    children: [
                      rigaTabella(pulsantiCategoria.sublist(0, 3), p(150)),
                      rigaTabella(pulsantiCategoria.sublist(3, 6), p(150)),
                      rigaTabella(pulsantiCategoria.sublist(6, 9), p(150)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

