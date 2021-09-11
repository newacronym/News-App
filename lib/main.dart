import 'package:flutter/material.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:flutter/services.dart';
import 'models/article.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'News App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Article> articles;
  bool isNewsAvailable = false;
  _MyHomePageState() {
    AlanVoice.addButton("b1baaa0049a6a4b18d2f53f542c48a762e956eca572e1d8b807a3e2338fdd0dc/stage");
    AlanVoice.callbacks.add((command) => _handleCommand(command.data));
  }
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
        //body: SafeArea(child:Container()),
        body: !isNewsAvailable ? Center(
        child:Text('Try saying: give me some news form CNN'))
            : ListView.builder(
                itemCount: articles.length,
                itemBuilder:(BuildContext context , index){
                  final Article article = articles[index];
                  return NewsCard(image: article.image, title: article.title);
                  }),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    super.dispose();}

  void _handleCommand(Map<String, dynamic> command) {
    List<Article> list = List<Article>();

    command["articles"].forEach((article) {
      list.add(Article(article["urlToImage"], article["title"],
          article["description"], article["url"], article["source"]));
    });
    setState(() {
      this.articles = list;
      isNewsAvailable = true;
    });
  }
}
class NewsCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String url;
  final String source;

  const NewsCard({
    Key key,
    @required this.image,
    @required this.title,
    this.description,
    this.url,
    this.source,
  }) : super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      height: 300,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Container(
              child: CachedNetworkImage(
                height: 200,
                fit: BoxFit.contain,
                imageUrl: image ??
                    "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.nbcnews.com%2F&psig=AOvVaw185P2ySPvsiZBXFr69zuln&ust=1600283305062000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCJDAr4Pu6-sCFQAAAAAdAAAAABAS",
                placeholder: (context,url) => CircularProgressIndicator(),
                errorWidget: (context,url,err) => Icon(Icons.error),
              ),
            ),
            const SizedBox(height:5),
            Text(title),
          ],
        ),
      ),
    );
  }
}

