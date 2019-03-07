import 'package:flutter/material.dart';
import 'subscription_model.dart';
import 'subscription_card.dart';
import 'subscription_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money controller',
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
      home: MyHomePage(title: 'My subscriptions'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double total = 0.0;
  Stream<QuerySnapshot> documentsStream;

  @override
  initState() {
    super.initState();
    queryValues();
  }

  void queryValues() async {
    documentsStream = Firestore.instance
        .collection('subscriptions')
        .snapshots();
    await documentsStream.listen((snapshot) {
      double tempTotal = snapshot.documents.fold(0, (tot, doc) => tot + doc.data['amount']);
      setState(() {total = tempTotal;});
      debugPrint(total.toString());
    });
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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showNewSubscriptionForm,
          ),
          IconButton(
            icon: Icon(Icons.settings)
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child:_buildBody(context),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: Text('Total: $total'),
          ),
        ],
      ),
    );
  }
  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: documentsStream,
      builder: (context, snapshot) {
        if(!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final subscription = Subscription.fromSnapshot(data);

    return Padding(
      key: ValueKey(subscription.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(subscription.name),
          trailing: Text(subscription.value.toString() + subscription.currency),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => SubscriptionForm(subscription: subscription)
                )
            );
          },
        ),
      ),
    );
  }

  Future _showNewSubscriptionForm() async {
    Subscription newSubscription = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return SubscriptionForm();
        },
      ),
    );
  }
}
