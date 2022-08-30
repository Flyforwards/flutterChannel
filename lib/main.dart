import 'package:channel/pages/basic_message.dart';
import 'package:channel/pages/event_channel_page.dart';
import 'package:channel/pages/home_index.dart';
import 'package:channel/pages/unknown_page.dart';
import 'package:channel/utils/channel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        HomeIndex.routeName: (ctx) => const HomeIndex(),
        UnknownPage.routeName: (ctx) => const UnknownPage(),
        BasicMessage.routeName: (ctx) => const BasicMessage(),
        EventChannelPage.routeName: (ctx) => const EventChannelPage()
      },
      onGenerateRoute: (settings) {
        if (kDebugMode) {
          print(settings.name);
        }
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) {
          return const UnknownPage();
        });
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {}

  @override
  void initState() {
    super.initState();
    Channel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
                child: const Text(
                  "methodChannel通信",
                ),
                onPressed: () async {
                  Navigator.of(context).pushNamed(HomeIndex.routeName);
                }),
            OutlinedButton(
                child: const Text(
                  "BasicMessageChannel",
                ),
                onPressed: () async {
                  Navigator.of(context).pushNamed(BasicMessage.routeName);
                }),
            OutlinedButton(
                child: const Text(
                  "EventChannel",
                ),
                onPressed: () async {
                  Navigator.of(context).pushNamed(EventChannelPage.routeName);
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
