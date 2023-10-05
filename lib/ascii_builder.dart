

import 'package:enough_ascii_art/enough_ascii_art.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildASCII(String thisText, TextStyle text, String path) { //future builder associated with ascii text
    return FutureBuilder(
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Padding(padding: EdgeInsets.symmetric(horizontal: 60),child:FittedBox(
                    fit: BoxFit.fitWidth,
                    child:Text(
                      '${snapshot.error} occurred',
                      style: const TextStyle(fontSize: 18),
                    )
                  ),)
                );
              } else if (snapshot.hasData) { //if fetchCreateText works
                final data = snapshot.data as String;
                return Padding(padding: EdgeInsets.symmetric(horizontal:60),child:Center(child:FittedBox(
                    fit: BoxFit.fitWidth,
                    child:Center(
                      child: Text(
                        data,
                        style: text,
                      )
                    ))
                  ));
                
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          future: fetchCreateText(thisText, path),
        );
  }


String spaceToUnderscore(String toUnderscore){
  String newString = toUnderscore.replaceAll(RegExp(' '), '_');
  return newString;
}

String numbersToText(String toNum){
  const Map<String, String> lookupInt = {
    '0' : 'Zero',
    '1' :'One',
    '2' :'Two',
    '3' :'Three',
    '4' :'Four',
    '5' :'Five',
    '6' :'Six',
    '7' :'Seven',
    '8' :'Eight',
    '9' :'Nine',
    };
  for (var i = 0; i < toNum.length; i++) {
    if (lookupInt.containsKey(toNum[i])) {
      toNum = toNum.replaceRange(i, i+1, lookupInt[toNum[i]]!);
    }
  }
  return toNum;
}
Future<String> fetchCreateText(String thisText, String path) async {
  thisText = numbersToText(spaceToUnderscore(thisText));
  var file = await rootBundle.loadString(path);
  var figure = renderFiglet(thisText, Font.text(file));
  return figure;
}