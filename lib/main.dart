import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter DropDownButton',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? dropdownvalue;
  String? dropdownvalue2 ="";
  String? dropdownId = "";
  List<OptionModel> dropdownData1 = [];
  List<OptionModel> dropdownData2 = [];

  @override
  void initState() {
    super.initState();
    //getDropdown1Value();
  }

  Future<List<OptionModel>> getDropdown1Value() async {
    var baseUrl = "/*use your 1st dropdown api url*/"; // eg., https://gssskhokhar.com/api/classes/
    var headers = {
      'Content-type': 'application/json',
    };
    var body = <String, String>{
      // Enter your body list here
      //eg., "data":"str",

    };
    var response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(body),
    );
    var jsonData = json.decode(response.body);
    print("jsonData -> ${jsonData}");
    dropdownData1 = [];
    if(jsonData["message"] == ""){
      for (var data in jsonData["options"]) {

        OptionModel dropDownModelData = OptionModel(
            id:data['id'],
            val: data['value']);
        dropdownData1.add(dropDownModelData);
      }
    }

    return dropdownData1;
  }

  Future<List<OptionModel>> getDropdown2Value(String newvalue) async {

    var appt =dropdownData1;
    var baseUrl = "/*use your 2nd dropdown api url*/";
    var headers = {
      'Content-type': 'application/json',
    };
    if(newvalue != "") {
      for (int i = 0; i < appt.length; i++) {
        if (appt[i].val == newvalue) {
          dropdownId = appt[i].id;
        }
      }
    }
    else
    {
      dropdownId = "1";
    }
    var body = <String, String>{
      "data":dropdownId!
    };

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(body),
    );
    var jsonData = json.decode(response.body);
    print("jsonData -> ${jsonData}");
    dropdownData2 = [];
    if(jsonData["message"] == ""){
      for (var data in jsonData["options"]) {
        OptionModel dropDownModelData = OptionModel(
            id:data['id'],
            val: data['value']);
        dropdownData2.add(dropDownModelData);

      }
    }

    return dropdownData2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DropDown List"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            FutureBuilder<List<OptionModel>?>(
              future: getDropdown1Value(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!;
                  return
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: DropdownButtonHideUnderline(
                                child:
                                DropdownButton(
                                  itemHeight: 50.0,
                                  // Initial Value
                                  value: dropdownvalue ?? data[0].val,
                                  // Down Arrow Icon
                                  icon: const Icon(Icons.keyboard_arrow_down),

                                  // Array list of items
                                  items: data.map<DropdownMenuItem<String>>((OptionModel items) {
                                    return DropdownMenuItem(
                                      value: items.val,
                                      child: Text(items.val!),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue = newValue!;
                                      getDropdown2Value(dropdownvalue!);
                                    });
                                  },
                                ))));
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),

            FutureBuilder<List<OptionModel>?>(
              future: getDropdown2Value(dropdownvalue ?? ""),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!;
                  print("data ${data}  ${dropdownData2.length}  ${dropdownvalue2}");
                  return
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: DropdownButtonHideUnderline(
                                child:
                                DropdownButton(
                                  // Initial Value
                                  // value: dropdownvalue2 != "" ? data[0].val : "",
                                  value:  data[0].val,

                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  // Array list of items
                                  items: data.map<DropdownMenuItem<String>>((OptionModel items) {
                                    return DropdownMenuItem(
                                      value: items.val != null ? items.val : null,
                                      // value: items.val,
                                      child: Text(items.val!),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownvalue2 = newValue!;
                                    });
                                  },
                                ))));
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
class OptionModel {
  String? id;
  String? val;

  OptionModel({this.id, this.val});

  OptionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    val = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.val;
    return data;
  }
}