import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Utils/RegExInputFormatter.dart';
import 'Utils/sizeconfig.dart';
import 'View/legendsTable.dart';

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

double calculateBMI({String weight, String height}) {
  double _weight;
  double _height;

  try {
    _weight = double.parse(weight);
    _height = double.parse(height);
  } on FormatException {
    print('Invalid format');
  }

  var result = (_weight / pow(_height, 2));
  print('result is $result');
  return result;
}

class _AppBodyState extends State<AppBody> {
  String calculatedBmi = 'Fill in your data';
  final _amountValidator = RegExInputFormatter.withRegex(
      '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$');
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final snackBar = SnackBar(
    content: Text('Cannot calculate\nOne or more field is empty'),
    elevation: 20.0,
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 2),
  );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight / 4,
            decoration: BoxDecoration(
              color: Colors.deepOrange.shade600,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
            ),
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      '$calculatedBmi',
                      style: GoogleFonts.montserrat(fontSize: 40),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 23.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: weightController,
                          maxLength: 4,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Weight ",
                              counter: Offstage(),
                              hintText: "Eg: 57.2",
                              suffixText: "kg",
                              alignLabelWithHint: false,
                              filled: true),
                          keyboardType: TextInputType.number,
                          inputFormatters: [_amountValidator],
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: heightController,
                          maxLength: 4,
                          decoration: InputDecoration(
                              counter: Offstage(),
                              border: OutlineInputBorder(),
                              labelText: "Height",
                              hintText: "Eg: 1.7",
                              suffixText: "m",
                              alignLabelWithHint: false,
                              filled: true),
                          keyboardType: TextInputType.number,
                          inputFormatters: [_amountValidator],
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text(
                          "CALCULATE",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.green,
                        onPressed: () {
                          print('Button calculate pressed');
                          print('height is ' + heightController.text);
                          print('weight is ' + weightController.text);
                          if (weightController.text == "" ||
                              heightController.text == "") {
                            Scaffold.of(context).showSnackBar(snackBar);
                          } else {
                            setState(() {
                              String answer = calculateBMI(
                                      height: heightController.text,
                                      weight: weightController.text)
                                  .toStringAsFixed(1);
                              calculatedBmi = answer;
                            });
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text(
                          "RESET",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.red,
                        onPressed: () {
                          FocusManager.instance.primaryFocus.unfocus();
                          weightController.clear();
                          heightController.clear();
                          Fluttertoast.showToast(
                            msg: "Cleared",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.orange,
                            textColor: Colors.white,
                          );
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30),
                LegendsTable(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

//TODO: letak info icon kat toolbar
//TODO: Share icon as fab
//TODO: Letak funtion reset