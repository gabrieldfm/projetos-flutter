import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: Home()
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _lista = ["aaaa", "bbb"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("widgets"),),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index){
                final item = _lista[index];
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.delete, color: Colors.white,),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Colors.green,
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.edit, color: Colors.white,),
                      ],
                    ),
                  ),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction){

                  },
                  key: Key(item), 
                  child: ListTile(
                    title: Text(item),
                  )
                );
              },
              itemCount: _lista.length,
            )
          )
        ],
      ),
    );
  }
}
