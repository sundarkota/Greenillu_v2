import 'dart:async';
import 'dart:convert';// as convert
import 'package:http/http.dart' as http;

class HttpGetData{
  static List listModel = [];
  static Future<List> getJsonData(url,data) async{
       var responseData = await http.get(url);
       //List listModel = [];
      if(responseData.statusCode == 200){
        final data = jsonDecode(responseData.body);
        //print(data);
        for(Map i in data){
            listModel.add(data.fromJson(i));
          }
      } else {
        print('Request failed with status: ${url} ${responseData.statusCode}.');
      }
  }
}