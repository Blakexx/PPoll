import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/widgets.dart';
import 'dart:collection';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/scheduler.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

int color;

List<Color> colors = [
  Colors.pink,
  Colors.red,
  Colors.deepOrange,
  Colors.orange,
  Colors.amber,
  Colors.yellow,
  Colors.lime,
  Colors.lightGreen,
  Colors.green,
  Colors.teal,
  Colors.cyan,
  Colors.lightBlue,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
  Colors.deepPurple,
  Colors.blueGrey,
  Colors.grey
];

SettingsInfo settings = new SettingsInfo();

String userId;

void main(){
  settings.readData().then((list) async{
    if(list==null){
      Map<String,dynamic> users;
      await http.get(Uri.encodeFull("https://ppoll-polls.firebaseio.com/users.json")).then((r){
        users = json.decode(r.body);
      });
      do{
        userId = "";
        Random r = new Random();
        List<String> nums = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
        for(int i = 0;i<16;i++){
          userId+=(r.nextInt(2)==0?nums[r.nextInt(36)]:nums[r.nextInt(36)].toLowerCase());
        }
      }while(users!=null&&users.keys.contains(userId));
      if(users==null){
        users = new Map<String,dynamic>();
      }
      http.put(Uri.encodeFull("https://ppoll-polls.firebaseio.com/users/"+userId+".json"),body:"0").then((r){
        color = 16;
        settings.writeData("16 "+userId).then((f){
          runApp(new DynamicTheme(
            themedWidgetBuilder: (context, theme){
              return new MaterialApp(
                  theme: theme,
                  home: new HomePage()
              );
            },
            data: (brightness) => new ThemeData(fontFamily: "Poppins",brightness: Brightness.light, canvasColor: colors[color],buttonColor: Colors.black38),
            defaultBrightness: Brightness.light,
          ));
        });
      });
    }else{
      color = int.parse(list[0]);
      userId = list[1];
      runApp(new DynamicTheme(
        themedWidgetBuilder: (context, theme){
          return new MaterialApp(
            theme: theme,
            home: new HomePage()
          );
        },
        data: (brightness) => new ThemeData(fontFamily: "Poppins",brightness: Brightness.light, canvasColor: colors[color],buttonColor: Colors.black38),
        defaultBrightness: Brightness.light,
      ));
    }
  });
}

class HomePage extends StatefulWidget{
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage>{

  final c = TextEditingController();

  String input = "";

  FocusNode f = new FocusNode();

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: !f.hasFocus?new AppBar(
          backgroundColor: Colors.transparent,
          leading: new IconButton(
              icon: new Icon(Icons.palette),
              onPressed: (){
                return showDialog<Null>(
                    context: context,
                    builder: (context){
                      return new Container(
                        // Specify some width
                        width: MediaQuery.of(context).size.width * .7,
                        child: new GridView.count(
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                            padding: const EdgeInsets.all(4.0),
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                            children: [
                              new ColorSelection(0),
                              new ColorSelection(1),
                              new ColorSelection(2),
                              new ColorSelection(3),
                              new ColorSelection(4),
                              new ColorSelection(5),
                              new ColorSelection(6),
                              new ColorSelection(7),
                              new ColorSelection(8),
                              new ColorSelection(9),
                              new ColorSelection(10),
                              new ColorSelection(11),
                              new ColorSelection(12),
                              new ColorSelection(13),
                              new ColorSelection(14),
                              new ColorSelection(15),
                              new ColorSelection(16),
                              new ColorSelection(17)
                            ]
                        ),
                      );
                    }
                );
              }
          ),
          actions: [
            new IconButton(
              icon: new Icon(Icons.search),
              onPressed: (){
                Navigator.push(context,new MaterialPageRoute(builder: (context) => new SearchPage()));
              }
            )
          ],
        elevation: 0.0
      ):new PreferredSize(child: new Container(),preferredSize: new Size(0.0,0.0)),
      body: new Container(
        child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ignore: conflicting_dart_import
                !f.hasFocus?new Text("PPoll",style: new TextStyle(fontSize:80.0*MediaQuery.of(context).size.width/375.0,fontWeight: FontWeight.w100)):new Container(),
                new Container(height: 75.0*MediaQuery.of(context).size.width/375.0,width:250.0*MediaQuery.of(context).size.width/375.0,child: new RaisedButton(
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  child: new Text("Create a Poll",style: new TextStyle(fontSize:30.0,color:Colors.white70)),
                  onPressed: (){
                    Navigator.push(context,new MaterialPageRoute(builder: (context) => new CreatePoll()));
                  },
                )),
                new Container(),new Container(),
                new Container(width: 120.0,child: new Center(child: new TextField(
                  style: new TextStyle(fontSize: 25.0,color:Colors.black),
                  controller: c,
                  maxLength: 4,
                  textAlign: TextAlign.center,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: 'Code',
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    counterText: "",
                  ),
                  onChanged:  (s){
                    input = s;
                  },
                  focusNode: f,
                  inputFormatters: [new UpperCaseTextFormatter()]
                ))),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    new Container(height: 50.0,width: 100.0,child: new RaisedButton(
                      shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
                      child: new Text("View",style: new TextStyle(fontSize: 20.0,color:Colors.white70)),
                      onPressed: (){
                        if(input==null||input.length<4){
                          return showDialog(
                              context: context,
                              builder: (context){
                                return new AlertDialog(
                                    title:new Text("Error"),
                                    content: new Text("Invalid code"),
                                    actions: [
                                      new RaisedButton(
                                          child: new Text("Okay",style:new TextStyle(color: Colors.black)),
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                          color: Colors.grey
                                      )
                                    ]
                                );
                              }
                          );
                        }
                        http.get(Uri.encodeFull("https://ppoll-polls.firebaseio.com/data/"+input+".json")).then((r){
                          Map<String,dynamic> map = json.decode(r.body);
                          if(r.body!="null") {
                            Navigator.push(context,new MaterialPageRoute(builder: (context) => new ViewOrVote(input,false,map["q"],map["c"],map["b"].toString().substring(2,3)=="0",map["b"].toString().substring(0,1)=="0",map["a"],map["b"].toString().substring(4,5)=="0")));
                          }else{
                            showDialog(
                                context: context,
                                builder: (context){
                                  return new AlertDialog(
                                      title:new Text("Error"),
                                      content: new Text("Poll not found"),
                                      actions: [
                                        new RaisedButton(
                                            child: new Text("Okay",style:new TextStyle(color: Colors.black)),
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                            },
                                            color: Colors.grey
                                        )
                                      ]
                                  );
                                }
                            );
                          }
                        });
                      }
                    )),
                    new Container(height: 50.0, width: 100.0,child: new RaisedButton(
                      child: new Text("Vote",style: new TextStyle(fontSize: 20.0,color:Colors.white70)),
                      shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
                      onPressed: (){
                        if(input==null||input.length<4){
                          return showDialog(
                              context: context,
                              builder: (context){
                                return new AlertDialog(
                                    title:new Text("Error"),
                                    content: new Text("Invalid code"),
                                    actions: [
                                      new RaisedButton(
                                          child: new Text("Okay",style:new TextStyle(color: Colors.black)),
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                          color: Colors.grey
                                      )
                                    ]
                                );
                              }
                          );
                        }
                        http.get(Uri.encodeFull("https://ppoll-polls.firebaseio.com/data/"+input+".json")).then((r){
                          Map<String,dynamic> map = json.decode(r.body);
                          if(r.body!="null") {
                            if(map["b"].toString().substring(2,3) == "0") {
                              if (map["i"]==null||!map["i"].contains(userId)) {
                                Navigator.push(context,new MaterialPageRoute(builder: (context) => new ViewOrVote(input,true,map["q"],map["c"],true,map["b"].toString().substring(0,1)=="0",map["a"],map["b"].toString().substring(4,5)=="0")));
                              }else {
                                showDialog(
                                    context: context,
                                    builder: (context){
                                      return new AlertDialog(
                                          title:new Text("Error"),
                                          content: new Text("You have already answered this poll."),
                                          actions: [
                                            new RaisedButton(
                                              child: new Text("Okay",style:new TextStyle(color: Colors.black)),
                                              onPressed: (){
                                                Navigator.of(context).pop();
                                              },
                                              color: Colors.grey
                                            )
                                          ]
                                      );
                                    }
                                );
                              }
                            }else{
                              Navigator.push(context,new MaterialPageRoute(builder: (context) => new ViewOrVote(input,true,map["q"],map["c"],false,map["b"].toString().substring(0,1)=="0",map["a"],map["b"].toString().substring(4,5)=="0")));
                            }
                          }else{
                            showDialog(
                              context: context,
                              builder: (context){
                                return new AlertDialog(
                                  title:new Text("Error"),
                                  content: new Text("Poll not found"),
                                  actions: [
                                    new RaisedButton(
                                      child: new Text("Okay",style:new TextStyle(color: Colors.black)),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                      color: Colors.grey
                                    )
                                  ]
                                );
                              }
                            );
                          }
                        });
                      }
                    )),
                  ]
                ),
                new Container(),
                new Container()
              ]
            )
        )
      )
    );
  }
}

class ColorSelection extends StatelessWidget{
  final int index;

  ColorSelection(this.index);

  @override
  Widget build(BuildContext context) {
    return new GridTile(
        child: new GestureDetector(
            child: new Container(
                color: new Color(colors[index].value)
            ),
            onTapUp: (t){
              color = index;
              settings.writeData(color.toString()+" "+userId);
              DynamicTheme.of(context).setThemeData(new ThemeData(fontFamily: "Poppins",brightness: Brightness.light, canvasColor: colors[color],buttonColor:Colors.black38));
              Navigator.of(context).pop();
            }
        )
    );
  }
}

class SearchPage extends StatefulWidget{
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage>{
  Map<String, dynamic> data;
  @override
  void initState(){
    super.initState();
    http.get((Uri.encodeFull("https://ppoll-polls.firebaseio.com/data.json"))).then((r){
      setState((){data = json.decode(r.body);});
    });
  }

  String search = "";

  bool inSearch = false;

  bool hasSearched = false;

  FocusNode f = new FocusNode();

  TextEditingController c = new TextEditingController();

  @override
  Widget build(BuildContext context){
    Map<String, dynamic> tempMap;
    SplayTreeMap<String, dynamic> sortedMap;
    if(data!=null){
      tempMap = new Map<String,dynamic>();
      tempMap.addAll(data);
      tempMap.removeWhere((key,value){
        return !(key.toUpperCase().contains(search.toUpperCase())||((value as Map<String,dynamic>)["c"] as List).map((s)=>s.toUpperCase()).contains(search.toUpperCase())||((value as Map<String,dynamic>)["q"] as String).toUpperCase().contains(search.toUpperCase()))||(((value as Map<String,dynamic>)["b"] as String).substring(4,5)=="0");
      });
      sortedMap = SplayTreeMap.from(tempMap,(o1,o2){
        if(((tempMap[o2] as Map<String,dynamic>)["a"] as List).reduce((n1,n2)=>n1+n2)-((tempMap[o1] as Map<String,dynamic>)["a"] as List).reduce((n1,n2)=>n1+n2)!=0){
          return ((tempMap[o2] as Map<String,dynamic>)["a"] as List).reduce((n1,n2)=>n1+n2)-((tempMap[o1] as Map<String,dynamic>)["a"] as List).reduce((n1,n2)=>n1+n2);
        }else{
          return o1.compareTo(o2);
        }
      });
    }
    return new Scaffold(
      appBar: new AppBar(
          title:data==null||(!inSearch&&!hasSearched)?new Text(
              "Search",style: new TextStyle(color:Colors.white)
          ):new TextField(
            controller: c,
            autofocus: true,
            autocorrect: false,
            focusNode: f,
            onChanged: (s){
              search = s;
            },
            onSubmitted: (s){
              search = s;
              tempMap.clear();
              tempMap.addAll(data);
              tempMap.removeWhere((key,value){
                return !(key.toUpperCase().contains(search.toUpperCase())||((value as Map<String,dynamic>)["c"] as List).map((s)=>s.toUpperCase()).contains(search.toUpperCase())||((value as Map<String,dynamic>)["q"] as String).toUpperCase().contains(search.toUpperCase()))||(((value as Map<String,dynamic>)["b"] as String).substring(4,5)=="0");
              });
              sortedMap = SplayTreeMap.from(tempMap,(o1,o2){
                if(((tempMap[o2] as Map<String,dynamic>)["a"] as List).reduce((n1,n2)=>n1+n2)-((tempMap[o1] as Map<String,dynamic>)["a"] as List).reduce((n1,n2)=>n1+n2)!=0){
                  return ((tempMap[o2] as Map<String,dynamic>)["a"] as List).reduce((n1,n2)=>n1+n2)-((tempMap[o1] as Map<String,dynamic>)["a"] as List).reduce((n1,n2)=>n1+n2);
                }else{
                  return o1.compareTo(o2);
                }
              });
              setState((){hasSearched = true;inSearch = false;});
            },
          ),
          backgroundColor: Colors.black54,
        actions: [
          hasSearched&&!f.hasFocus?new IconButton(
            icon: new Icon(Icons.close),
            onPressed: (){
              search = "";
              c.text = "";
              tempMap.clear();
              tempMap.addAll(data);
              tempMap.removeWhere((key,value){
                return !(key.toUpperCase().contains(search.toUpperCase())||((value as Map<String,dynamic>)["c"] as List).map((s)=>s.toUpperCase()).contains(search.toUpperCase())||((value as Map<String,dynamic>)["q"] as String).toUpperCase().contains(search.toUpperCase()))||(((value as Map<String,dynamic>)["b"] as String).substring(4,5)=="0");
              });
              sortedMap = SplayTreeMap.from(tempMap,(o1,o2){
                if(((tempMap[o2] as Map<String,dynamic>)["a"] as List).reduce((n1,n2)=>n1+n2)-((tempMap[o1] as Map<String,dynamic>)["a"] as List).reduce((n1,n2)=>n1+n2)!=0){
                  return ((tempMap[o2] as Map<String,dynamic>)["a"] as List).reduce((n1,n2)=>n1+n2)-((tempMap[o1] as Map<String,dynamic>)["a"] as List).reduce((n1,n2)=>n1+n2);
                }else{
                  return o1.compareTo(o2);
                }
              });
              setState((){hasSearched = false;});
            },
          ):inSearch||f.hasFocus?new IconButton(
            icon: new Icon(Icons.clear),
            onPressed: (){
              search = "";
              setState((){c.text = search;inSearch=true;});
            },
          ):new IconButton(
            icon: new Icon(Icons.search),
            onPressed: (){
              setState((){inSearch = true;});
            }
          )
        ]
      ),
      body: new Container(
        child: new Center(
          child: new RefreshIndicator(child: data!=null?new ListView.builder(
            itemBuilder: (context,i){
              return new Padding(padding: EdgeInsets.only(top:5.0),child:new GestureDetector(onTapUp: (t){
                Map<String,dynamic> map = sortedMap[sortedMap.keys.toList()[i]];
                Navigator.push(context,new MaterialPageRoute(builder: (context) => new ViewOrVote(sortedMap.keys.toList()[i],false,map["q"],map["c"],map["b"].toString().substring(2,3)=="0",map["b"].toString().substring(0,1)=="0",map["a"],map["b"].toString().substring(4,5)=="0")));
              },child:new Container(
                height: 50.0,
                child: new ListTile(
                  leading: new Container(
                    width:70.0,
                    child: new Text(sortedMap.keys.toList()[i])
                  ),
                  title: new Text(sortedMap[sortedMap.keys.toList()[i]]["a"].reduce((n1,n2)=>n1+n2).toString()),
                ),
                color: Colors.black38
              )));
            },
            itemCount: sortedMap.length
          ):new CircularProgressIndicator(),
            onRefresh: (){
              Completer c = new Completer<Null>();
              http.get((Uri.encodeFull("https://ppoll-polls.firebaseio.com/data.json"))).then((r){
                data = json.decode(r.body);
                tempMap.clear();
                tempMap.addAll(data);
                tempMap.removeWhere((key,value){
                  return !(key.toUpperCase().contains(search.toUpperCase())||((value as Map<String,dynamic>)["c"] as List).map((s)=>s.toUpperCase()).contains(search.toUpperCase())||((value as Map<String,dynamic>)["q"] as String).toUpperCase().contains(search.toUpperCase()))||(((value as Map<String,dynamic>)["b"] as String).substring(4,5)=="0");
                });
                sortedMap = SplayTreeMap.from(tempMap,(o1,o2){
                  if(((tempMap[o2] as Map<String,dynamic>)["a"] as List).reduce((n1,n2)=>n1+n2)-((tempMap[o1] as Map<String,dynamic>)["a"] as List).reduce((n1,n2)=>n1+n2)!=0){
                    return ((tempMap[o2] as Map<String,dynamic>)["a"] as List).reduce((n1,n2)=>n1+n2)-((tempMap[o1] as Map<String,dynamic>)["a"] as List).reduce((n1,n2)=>n1+n2);
                  }else{
                    return o1.compareTo(o2);
                  }
                });
                setState((){c.complete();});
              });
              return c.future;
            }
          )
        )
      )
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class CreatePoll extends StatefulWidget{
  @override
  CreatePollState createState() => new CreatePollState();
}

bool removing = false;

class CreatePollState extends State<CreatePoll>{

  static int optionCount;

  static List<Widget> list = [];

  bool oneChoice = false;

  bool perm = false;

  static List<String> choices = [];

  static String question;

  int totalCount = 2;

  bool public = false;

  ScrollController s = new ScrollController();

  @override
  void initState(){
    super.initState();
    removing = false;
    optionCount = 2;
    question = null;
    choices.clear();
    list.clear();
    list.add(new Option(0,new GlobalKey()));
    list.add(new Option(1,new GlobalKey()));
    choices.length = 2;
    list.add(new Container(height: 50.0,padding: EdgeInsets.only(left:25.0,right:25.0),child: new RaisedButton(
        child: new ListTile(
            leading: new Icon(Icons.add,color:Colors.white),
            title: new Text("Add",style: new TextStyle(color:Colors.white))
        ),
        onPressed: (){
          if(!isRemoving){
            if(optionCount<20){
              list.insert(list.length-1,new Option(optionCount++,new GlobalKey()));
              if(s.position.pixels>0.0){
                s.jumpTo(s.position.pixels+50);
              }
              choices.length = optionCount;
              setState((){});
            }
          }
        }
    )));
  }

  bool isConnecting = false;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(child: new Scaffold(
      appBar: new AppBar(title: new Text("Create a Poll",style: new TextStyle(color:Colors.white)),backgroundColor: Colors.black54,actions:[
        new IconButton(
          icon: new Icon(!removing?Icons.delete:Icons.check),
          onPressed: (){
            for(int i = 0; i<CreatePollState.list.length-1;i++){
              (CreatePollState.list[i] as Option).key.currentState.setState((){});
            }
            setState((){removing = !removing;});
          }
        )
      ]),
      body: new Container(
        child: new Center(
          child: new ListView(
            controller: s,
            children: [
              new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Text(""),
                  new Padding(padding:EdgeInsets.only(bottom:8.0),child:new Container(height: 50.0,padding: EdgeInsets.only(left:20.0,right:20.0),child: new TextField(
                    decoration: new InputDecoration(
                      hintText: 'Question',
                      filled: true,
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      counterText: "",
                    ),
                    onChanged: (s){
                      question = s;
                    }
                  ))),
                  new Column(
                    children: list
                  ),
                  new Container(height:40.0),
                  new GestureDetector(onTapUp: (d){setState((){oneChoice = !oneChoice;});}, child:new Container(
                    padding: EdgeInsets.only(left:5.0,right:5.0),
                    child: new Container(
                      height: 50.0,
                      color:Colors.black12,
                      child: new Row(
                          children: [
                            new Expanded(child: new Text(" Allow multiple selections",style: new TextStyle(fontSize:17.0,color:Colors.white))),
                            new Switch(
                              value: oneChoice,
                              onChanged: (s){
                                setState((){oneChoice = s;});
                              },
                              activeColor: Colors.black
                            )
                          ]
                      )
                    )
                  )),
                  new GestureDetector(onTapUp: (d){setState((){perm = !perm;});},child:new Container(
                      padding: EdgeInsets.only(left:5.0,right:5.0,top:5.0),
                      child: new Container(
                          height: 50.0,
                          color:Colors.black12,
                          child: new Row(
                              children: [
                                new Expanded(child: new Text(" Allow multiple submissions",style: new TextStyle(fontSize:17.0,color:Colors.white))),
                                new Switch(
                                    value: perm,
                                    onChanged: (s){
                                      setState((){perm = s;});
                                    },
                                    activeColor: Colors.black
                                )
                              ]
                          )
                      )
                  )),
                  new GestureDetector(onTapUp: (d){setState((){public = !public;});},child:new Container(
                      padding: EdgeInsets.only(left:5.0,right:5.0,top:5.0),
                      child: new Container(
                          height: 50.0,
                          color:Colors.black12,
                          child: new Row(
                              children: [
                                new Expanded(child: new Text(" Public",style: new TextStyle(fontSize:17.0,color:Colors.white))),
                                new Switch(
                                    value: public,
                                    onChanged: (s){
                                      setState((){public = s;});
                                    },
                                    activeColor: Colors.black
                                )
                              ]
                          )
                      )
                  )),
                  new Container(height:30.0),
                  !isConnecting?new Container(height:60.0,width:200.0,child:new RaisedButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    child: new Text("Submit",style: new TextStyle(fontSize:25.0,color:Colors.white)),
                    onPressed: ()  async{
                      if(question!=null && !choices.contains(null)&&choices.toSet().length==choices.length&&question!=""&&!choices.contains("")){
                        setState((){isConnecting = true;});
                        String key = "";
                        Random r = new Random();
                        bool used = false;
                        Map<String,dynamic> usedMap;
                        await http.get((Uri.encodeFull("https://ppoll-polls.firebaseio.com/data.json"))).then((r){
                          usedMap = json.decode(r.body);
                        });
                        do{
                          key = "";
                          for(int i = 0; i<4;i++){
                            List<String> nums = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
                            key+=nums[r.nextInt(36)];
                          }
                        }while(usedMap!=null&&usedMap.keys.contains(key));
                        List<int> answers = new List<int>(choices.length);
                        answers = answers.map((i)=>0).toList();
                        String serverData = "{\n\t\"q\": \""+question+"\",\n\t\"c\": "+"["+choices.map((String str)=>"\""+str+"\"").toString().substring(1,choices.map((String str)=>"\""+str+"\"").toString().length-1)+"]"+",\n\t\"b\": \""+(oneChoice?"1 ":"0 ")+(perm?"1 ":"0 ")+(public?"1":"0")+"\",\n\t\"a\": "+answers.toString()+",\n\t\"i\": []\n}";
                        http.put("https://ppoll-polls.firebaseio.com/data/"+key+".json",body:serverData).then((r){
                          setState((){isConnecting = false;});
                          Navigator.push(context,new MaterialPageRoute(builder: (context) => new WillPopScope(onWillPop:(){return new Future<bool>(()=>Navigator.of(context).pop(true));},child: new Scaffold(
                            appBar: new AppBar(title:new Text("Success",style: new TextStyle(color:Colors.white)),backgroundColor: Colors.black54),
                            body:new Container(
                              child: new Center(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    new Text("Your poll has been created with the code",style:new TextStyle(fontSize:15.0*MediaQuery.of(context).size.width/360.0)),
                                    new Text(key,style:new TextStyle(fontSize:120.0*MediaQuery.of(context).size.width/360.0,fontWeight: FontWeight.bold))
                                  ]
                                )
                              )
                            )
                          ))));
                        });
                      }else{
                        String s = "";
                        if((question==null||choices.contains(null)||question==""||choices.contains(""))&&choices.toSet().length!=choices.length){
                          s="Please complete all the fields without duplicates";
                        }else if(question==null||choices.contains(null)||question==""||choices.contains("")){
                          s="Please complete all the fields";
                        }else if(choices.toSet().length!=choices.length){
                          s="Please do not include duplicates";
                        }
                        showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context){
                                return new AlertDialog(
                                    title:new Text("Error"),
                                    content:new Text(s),
                                    actions: [
                                      new RaisedButton(
                                          child: new Text("Okay",style:new TextStyle(color: Colors.black)),
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                          },
                                          color: Colors.grey
                                      )
                                    ]
                                );
                              }
                          );
                      }
                    }
                  )):new Container(
                    height:60.0,width:60.0,
                    child: new CircularProgressIndicator()
                  ),
                  new Container(height:30.0)
                ]
              )
            ]
          )
        )
      )
    ),
    onWillPop: (){
      bool hasEnteredChoices = false;
      for(int i = 0; i<choices.length;i++){
        if(choices[i]!=null){
          hasEnteredChoices = true;
          break;
        }
      }
      if(question!=null||hasEnteredChoices){
        bool yes = true;
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context){
              return new AlertDialog(
                  title:new Text("Are you sure?"),
                  content:new Text("Any changes will be lost"),
                  actions: [
                    new RaisedButton(
                        child: new Text("No",style:new TextStyle(color: Colors.black)),
                        onPressed: (){
                          yes = false;
                          Navigator.of(context).pop();
                        },
                        color: Colors.grey
                    ),
                    new RaisedButton(
                        child: new Text("Yes",style:new TextStyle(color: Colors.black)),
                        onPressed: (){
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        color: Colors.grey
                    ),
                  ]
              );
            }
        );
        return new Future<bool>(()=>false);
      }else{
        return new Future<bool>(()=>true);
      }
    });
  }
}

class ViewOrVote extends StatefulWidget{
  bool public;
  String question;
  List<dynamic> choices;
  bool oneResponse;
  bool oneChoice;
  List<dynamic> scores;
  String code;
  bool vote;
    ViewOrVote(this.code,this.vote,this.question,this.choices,this.oneResponse,this.oneChoice,this.scores,this.public);
  @override
  ViewOrVoteState createState() => new ViewOrVoteState();
}

class ViewOrVoteState extends State<ViewOrVote>{

  String choice;

  Map<String,bool> checked = new Map<String,bool>();

  List<String> choicesString = new List<String>();

  @override
  void initState(){
    super.initState();
    if(!widget.oneChoice){
      for(String s in widget.choices){
        checked.putIfAbsent(s, ()=>false);
      }
    }else{
      for(int i = 0; i<widget.choices.length;i++){
        choicesString.add(widget.choices[i].toString());
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(title:new Text(widget.code,style: new TextStyle(color:Colors.white)),backgroundColor: Colors.black54),
      body: new Container(
        child: new Center(
          child: new ListView(
            children: [
              new Text(widget.question),
              new Column(
                children: widget.vote?(widget.oneChoice?choicesString.map((String key){
                  return new Padding(padding: EdgeInsets.only(top:5.0),child: new Container(color:Colors.black26,child:new RadioListTile(
                      value: key,
                      title: new Text(key),
                      groupValue: choice,
                      onChanged: (v){
                        setState((){
                          choice = v;
                        });
                      }
                  )));
                }).toList():checked.keys.map((String key){
                  return new Padding(padding:EdgeInsets.only(top:5.0),child: new Container(color:Colors.black26,child:new CheckboxListTile(
                      title: new Text(key),
                      value: checked[key],
                      onChanged: (v){
                        setState((){
                          checked[key] = v;
                        });
                      }
                  )));
                }).toList()):(widget.oneChoice?choicesString.map((String key){
                  return new Padding(padding:EdgeInsets.only(top:5.0),child:new Container(color:Colors.black26,child:new ListTile(
                    title: new Text(key),
                    subtitle: new Container(height:15.0,child:new LinearProgressIndicator(
                      value: widget.scores.reduce((a,b)=>a+b)!=0?widget.scores[choicesString.indexOf(key)]/(1.0*widget.scores.reduce((a,b)=>a+b)):0.0
                    )),
                    trailing: new Container(width:35.0,child:new Column(
                      children: [
                        new Text(widget.scores[choicesString.indexOf(key)].toString()),
                        new Text((widget.scores.reduce((a,b)=>a+b)!=0?(widget.scores[choicesString.indexOf(key)]/(1.0*widget.scores.reduce((a,b)=>a+b)))*100.0:0.0).toStringAsFixed(0)+"\%")
                      ]
                    ))
                  )));
                }).toList():checked.keys.map((String key){
                  return new Padding(padding:EdgeInsets.only(top:5.0),child:new Container(color:Colors.black26,child:new ListTile(
                      title: new Text(key),
                      subtitle: new Container(height:15.0,child:new LinearProgressIndicator(
                          value: widget.scores.reduce((a,b)=>a+b)!=0?widget.scores[checked.keys.toList().indexOf(key)]/(1.0*widget.scores.reduce((a,b)=>a+b)):0.0
                      )),
                      trailing: new Container(width:35.0,child:new Column(
                          children: [
                            new Text(widget.scores[checked.keys.toList().indexOf(key)].toString()),
                            new Text((widget.scores.reduce((a,b)=>a+b)!=0?(widget.scores[checked.keys.toList().indexOf(key)]/(1.0*widget.scores.reduce((a,b)=>a+b)))*100.0:0.0).toStringAsFixed(0)+"\%")
                          ]
                      ))
                  )));
                }).toList())
              ),
              widget.vote?new Padding(padding: EdgeInsets.only(top:20.0),child:new Column(crossAxisAlignment: CrossAxisAlignment.center,children:[new Container(
                height:65.0,width:150.0,
                child:new RaisedButton(
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
                  onPressed: (){
                    if(widget.oneChoice){
                      widget.scores[choicesString.indexOf(choice)]++;
                    }else{
                      for(int i = 0; i<widget.scores.length;i++){
                        if(checked.values.toList()[i]){
                          widget.scores[i]++;
                        }
                      }
                    }
                    if((widget.oneChoice&&choice!=null) || !widget.oneChoice){
                      Map<String,dynamic> map;
                      http.get(Uri.encodeFull("https://ppoll-polls.firebaseio.com/data/"+widget.code+".json")).then((r){
                        map = json.decode(r.body);
                        http.put(Uri.encodeFull("https://ppoll-polls.firebaseio.com/data/"+widget.code+"/a.json"),body:widget.scores.toString()).then((r){
                          if(widget.oneResponse){
                            List<dynamic> users = map["i"];
                            if(users!=null){
                              users.add(userId);
                            }
                            http.put(Uri.encodeFull("https://ppoll-polls.firebaseio.com/data/"+widget.code+"/i.json"),body:(users!=null?users.map((s)=>"\""+s+"\"").toList().toString():"[\""+userId+"\"]")).then((r){
                              setState((){widget.vote=false;});
                            });
                          }else{
                            setState((){widget.vote=false;});
                          }
                        });
                      });
                    }
                  },
                  child: new Text("Submit",style:new TextStyle(color:Colors.white,fontSize:25.0))
                ))]
              )):new Container()
            ]
          )
        )
      )
    );
  }
}

class Option extends StatefulWidget{
  bool isRemoved = false;
  GlobalKey key;
  int position;
  Option(this.position,this.key):super(key:key);
  @override
  OptionState createState() => new OptionState();
}

bool isRemoving = false;

class OptionState extends State<Option>{
  FocusNode f = new FocusNode();
  @override
  Widget build(BuildContext context) {
    return new AnimatedOpacity(opacity:widget.isRemoved?0.0:1.0,duration:new Duration(milliseconds:300),child:new Container(height: 50.0,padding: EdgeInsets.only(left:!removing?25.0:0.0,right:25.0),child: new Row(children: [
      removing?new IconButton(
          icon: new Icon(Icons.delete),
          onPressed: (){
            if(!widget.isRemoved&&CreatePollState.optionCount>2){
              isRemoving = true;
              CreatePollState.optionCount--;
              setState((){widget.isRemoved = true;});
              new Timer(new Duration(milliseconds:301),(){
                CreatePollState.choices.removeAt(widget.position);
                CreatePollState.list.removeAt(widget.position);
                isRemoving = false;
                for(int i = 0; i<CreatePollState.list.length-1;i++){
                  (CreatePollState.list[i] as Option).position = i;
                  (CreatePollState.list[i] as Option).key.currentState.setState((){});
                  if(i!=widget.position&&(CreatePollState.list[i] as Option).isRemoved){
                    isRemoving = true;
                  }
                }
                context.ancestorStateOfType(new TypeMatcher<CreatePollState>()).setState((){});
              });
            }
          }
      ):new Container(width:0.0,height:0.0),
      new Expanded(child: new TextField(
        focusNode: f,
        decoration: new InputDecoration(
        hintText: 'Option '+(widget.position+1).toString(),
        filled: true,
        fillColor: Colors.white30,
        border: InputBorder.none,
        counterText: "",
        ),
        onChanged: (s){
          CreatePollState.choices[widget.position] = s;
        }
      ))])));
  }
}

class Settings extends StatefulWidget{
  @override
  SettingsState createState() => new SettingsState();
}

class SettingsState extends State<Settings>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Settings",style: new TextStyle(color:Colors.white)),backgroundColor: Colors.black54),
      body: new Container(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

            ]
          )
        )
      )
    );
  }
}

class SettingsInfo{
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return new File('$path/themeinfo.txt');
  }

  Future<List<String>> readData() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();

      if(contents.split(" ").length!=2){
        return null;
      }

      List<String> list = contents.split(" ");

      return list;
    } catch (e) {
      return null;
    }
  }

  Future<File> writeData(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }

}