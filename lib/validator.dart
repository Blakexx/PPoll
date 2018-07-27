import 'dart:convert';
import 'package:http/http.dart' as http;
import 'key.dart';

void main(){
  http.get(Uri.encodeFull(database+"/data.json?auth="+secretKey)).then((r){
    Map<String, dynamic> map = json.decode(r.body);
    bool allValid = true;
    for(String s in map.keys){
      if(map[s]["b"][2]==1&&map[s]["t"]==null){
        allValid = false;
        print(s+" is invalid");
      }
    }
    if(allValid){
      print("All are valid");
    }
  });
}