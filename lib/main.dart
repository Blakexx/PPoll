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
      bool usedId = false;
      do{
        userId = "";
        Random r = new Random();
        List<String> nums = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
        for(int i = 0;i<16;i++){
          userId+=(r.nextInt(2)==0?nums[r.nextInt(36)]:nums[r.nextInt(36)].toLowerCase());
        }
        await http.get(Uri.encodeFull("https://ppoll-polls.firebaseio.com/users/"+userId+".json")).then((r){
          usedId = r.body!="null";
        });
      }while(usedId);
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
              icon: new Icon(Icons.settings),
              onPressed: (){
                Navigator.push(context,new MaterialPageRoute(builder: (context) => new Settings()));
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
                new Container(width: 150.0,child: new Center(child: new TextField(
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
                      child: new Text("View",style: new TextStyle(fontSize: 20.0,color:Colors.white70)),
                      onPressed: (){

                      }
                    )),
                    new Container(height: 50.0, width: 100.0,child: new RaisedButton(
                      child: new Text("Vote",style: new TextStyle(fontSize: 20.0,color:Colors.white70)),
                      onPressed: (){
                        http.get(Uri.encodeFull("https://ppoll-polls.firebaseio.com/data/"+input+".json")).then((r){
                          Map<String,dynamic> map = json.decode(r.body);
                          if(r.body!="null") {
                            if(map[map.keys.toList()[0]]["b"].toString().substring(2,3) == "0") {
                              if (map[map.keys.toList()[0]]["i"]==null||!map[map.keys.toList()[0]]["i"].contains(userId)) {
                                print("User has not answered yet");
                                Navigator.push(context,new MaterialPageRoute(builder: (context) => new ViewOrVote(input,true,map[map.keys.toList()[0]]["q"],map[map.keys.toList()[0]]["c"],true,map[map.keys.toList()[0]]["b"].toString().substring(0,1)=="0",map[map.keys.toList()[0]]["a"])));
                              }else {
                                print("User has already answered");
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
                              print("Multible responses allowed.");
                              Navigator.push(context,new MaterialPageRoute(builder: (context) => new ViewOrVote(input,true,map[map.keys.toList()[0]]["q"],map[map.keys.toList()[0]]["c"],false,map[map.keys.toList()[0]]["b"].toString().substring(0,1)=="0",map[map.keys.toList()[0]]["a"])));
                            }
                          }else{
                            print("item does not exist");
                            showDialog(
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
    list.add(new Container(height: 50.0,padding: EdgeInsets.only(left:30.0,right:30.0),child: new RaisedButton(
        child: new ListTile(
            leading: new Icon(Icons.add,color:Colors.white),
            title: new Text("Add",style: new TextStyle(color:Colors.white))
        ),
        onPressed: (){
          if(optionCount<20){
            list.insert(list.length-1,new Option(optionCount++,new GlobalKey()));
            if(s.position.pixels>0.0){
              s.jumpTo(s.position.pixels+50);
            }
            choices.length = optionCount;
            setState((){});
          }
        }
    )));
  }

  bool isConnecting = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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
                  new Container(height: 50.0,padding: EdgeInsets.only(left:30.0,right:30.0),child: new TextField(
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
                  )),
                  new Text(""),
                  new Column(
                    children: list
                  ),
                  new Container(height:40.0),
                  new Container(
                    padding: EdgeInsets.only(left:10.0,right:10.0),
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
                  ),
                  new Container(
                      padding: EdgeInsets.only(left:10.0,right:10.0,top:5.0),
                      child: new Container(
                          height: 50.0,
                          color:Colors.black12,
                          child: new Row(
                              children: [
                                new Expanded(child: new Text(" Allow multiple responses",style: new TextStyle(fontSize:17.0,color:Colors.white))),
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
                  ),
                  new Container(height:30.0),
                  !isConnecting?new Container(height:60.0,width:200.0,child:new RaisedButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    child: new Text("Submit",style: new TextStyle(fontSize:25.0,color:Colors.white)),
                    onPressed: ()  async{
                      if(question!=null && !choices.contains(null)){
                        setState((){isConnecting = true;});
                        String key = "";
                        Random r = new Random();
                        bool used = false;
                        do{
                          key = "";
                          for(int i = 0; i<4;i++){
                            List<String> nums = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
                            key+=nums[r.nextInt(36)];
                          }
                          await http.get(Uri.encodeFull("https://ppoll-polls.firebaseio.com/data"+key+".json")).then((r){
                            used = r.body!="null";
                          });
                        }while(used);
                        List<int> answers = new List<int>(choices.length);
                        answers = answers.map((i)=>0).toList();
                        String serverData = "{\n\t\"q\": \""+question+"\",\n\t\"c\": "+"["+choices.map((String str)=>"\""+str+"\"").toString().substring(1,choices.map((String str)=>"\""+str+"\"").toString().length-1)+"]"+",\n\t\"b\": \""+(oneChoice?"1 ":"0 ")+(perm?"1":"0")+"\",\n\t\"a\": "+answers.toString()+",\n\t\"i\": []\n}";
                        http.post("https://ppoll-polls.firebaseio.com/data/"+key+".json",body:serverData).then((r){
                          setState((){isConnecting = false;});
                          /*return showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context){
                                return new AlertDialog(
                                    title:new Text("Success"),
                                    content:new Text("Your poll has been created with the code "+key),
                                    actions: [
                                      new RaisedButton(
                                          child: new Text("Okay",style:new TextStyle(color: Colors.black)),
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                          color: Colors.grey
                                      )
                                    ]
                                );
                              }
                          );*/
                          Navigator.push(context,new MaterialPageRoute(builder: (context) => new WillPopScope(onWillPop:(){return new Future<bool>(()=>Navigator.of(context).pop(true));},child: new Scaffold(
                            appBar: new AppBar(title:new Text("Success",style: new TextStyle(color:Colors.white)),backgroundColor: Colors.black54),
                            body:new Container(
                              child: new Center(
                                child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    new Text("Your poll has been created with the code"),
                                    new Text(key,style:new TextStyle(fontSize:120.0*MediaQuery.of(context).size.width/360.0,fontWeight: FontWeight.bold))
                                  ]
                                )
                              )
                            )
                          ))));
                        });
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
    );
  }
}

class ViewOrVote extends StatefulWidget{
  String question;
  List<dynamic> choices;
  bool oneResponse;
  bool oneChoice;
  List<dynamic> scores;
  String code;
  bool vote;
    ViewOrVote(this.code,this.vote,this.question,this.choices,this.oneResponse,this.oneChoice,this.scores);
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
                children: widget.oneChoice?choicesString.map((String key){
                  return new RadioListTile(
                      value: key,
                      title: new Text(key),
                      groupValue: choice,
                      onChanged: (v){
                        setState((){
                          choice = v;
                        });
                      }
                  );
                }).toList():checked.keys.map((String key){
                  return new CheckboxListTile(
                      title: new Text(key),
                      value: checked[key],
                      onChanged: (v){
                        setState((){
                          checked[key] = v;
                        });
                      }
                  );
                }).toList()
              )
            ]
          )
        )
      )
    );
  }
}

class Option extends StatefulWidget{
  GlobalKey key;
  int position;
  Option(this.position,this.key):super(key:key);
  @override
  OptionState createState() => new OptionState();
}

class OptionState extends State<Option>{
  FocusNode f = new FocusNode();
  @override
  Widget build(BuildContext context) {
    return new Container(height: 50.0,padding: EdgeInsets.only(left:!removing?30.0:0.0,right:30.0),child: new Row(children: [
      removing?new IconButton(
          icon: new Icon(Icons.delete),
          onPressed: (){
            if(CreatePollState.list.length>3){
              CreatePollState.optionCount--;
              CreatePollState.choices.removeAt(widget.position);
              CreatePollState.list.removeAt(widget.position);
              for(int i = 0; i<CreatePollState.list.length-1;i++){
                (CreatePollState.list[i] as Option).position = i;
                (CreatePollState.list[i] as Option).key.currentState.setState((){});
              }
              context.ancestorStateOfType(new TypeMatcher<CreatePollState>()).setState((){});
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
      ))]));
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