import 'dart:async';
import 'dart:convert';
import 'dart:js' as js;
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_daum_post_api/messageHandler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const MyHomePage(title: '다음 주소 API Demo'),
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
  final TextEditingController _addressZoneCodeController = TextEditingController();
  final TextEditingController _addressBasicController = TextEditingController();
  final TextEditingController _addressDetailThreeController = TextEditingController();

  void _searchAddress() async {
    if (kIsWeb) {
      print("📗, Platform is web");

      //[로컬 html 파일 이용 방법]
      // String htmlFilePath = 'assets/kakao_postcode.html';
      // String fileHtmlContents = await rootBundle.loadString(htmlFilePath);
      // print("📗, fileHtmlContents is ${fileHtmlContents}");
      // Uri uri = Uri.dataFromString(
      //     fileHtmlContents,
      //     mimeType: 'text/html',
      //     encoding: Encoding.getByName('utf-8'));
      // uri.path
      // print("📗, [uri] path is ${uri.path}, ${uri.origin}");

      //js.context.callMethod("write", [uri.data]);

      js.context.callMethod('open', [
        "http://plinic.cafe24app.com/api/daumFlutterPost", //TODO. 로컬에 있는 html 파일 불러와야 함!!!! > 여기 코드에는 messageHandler.js 가 없으므로
        "주소검색",
        "width = 500, height = 500, top = 100, left = 200, location = no"
      ]);

      //build query
      final options = AddressOptions(
        addressZoneCode: '',
        addressBasic: '',
        addressDetail: ''
      );
    } else { //remedi_kopo 플러그인이 ANDROID 와 IOS 만 지원
    print("📗, Platform is not web");
    KopoModel model = await Navigator.push(
    context,
    CupertinoPageRoute(
    builder: (context) => RemediKopo(),
    ),
    );

    _addressZoneCodeController.text = model.zonecode!;
    _addressBasicController.text = '${model.address} ${model.buildingName}';
    _addressDetailThreeController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 50)),
            const Padding(padding: EdgeInsets.only(top: 50)),
            const Text('우편번호',
                style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
            TextFormField(
              enabled: false,
              decoration: InputDecoration(
                isDense: false,
              ),
              controller: _addressZoneCodeController,
              style: TextStyle(fontSize: 20),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text('기본주소',
                style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
            TextFormField(
              enabled: false,
              decoration: const InputDecoration(
                isDense: false,
              ),
              controller: _addressBasicController,
              style: TextStyle(fontSize: 20),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text('상세주소',
                style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
            TextFormField(
              enabled: false,
              decoration: const InputDecoration(
                isDense: false,
              ),
              controller: _addressDetailThreeController,
              style: const TextStyle(fontSize: 20),
            ),
            const Padding(padding: EdgeInsets.only(top: 200)),
            const Text("아래 FloatingButton 을 눌러 주소를 검색하세요. ⬇️⬇️⬇️",
                style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _searchAddress,
        tooltip: '주소찾기',
        child: const Icon(Icons.search),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// 서버 API 통신 예제....인 듯.....
class SearchAddressApiProvider {
  final String BASE_URL = "http://plinic.cafe24app.com/api/daumFlutterPost";
  final String POSTS_FETCH_API = "";
  final String POSTS_FETCH_METHOD = "";

  http.Client httpClient = http.Client();

  SearchAddressApiProvider();

  fetchPosts() async {
    final body =
        '{"jsonrpc":"2.0", "method":"$POSTS_FETCH_API.$POSTS_FETCH_METHOD"}';

    print('📗, fetchPosts. body: $body');

    var url = Uri.parse(BASE_URL);

    final response = await httpClient.post(url, body: body);
    if (response.statusCode == 200) {
      // convert it to model
      final parsedJson = json.decode(response.body);
      print("📗, object");
    } else {
      throw Exception('error fetching posts');
    }
  }
}
