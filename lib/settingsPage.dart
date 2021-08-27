import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'fundamentals/preferredTheme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
   var storage = GetStorage();
   late bool? unspecificOccurences;

   late PreferredTheme preferredTheme;

   @override
  void initState() {
    super.initState();
    unspecificOccurences = storage.read('unspecificOccurences');
    if(unspecificOccurences == null) {
      unspecificOccurences = true;
    }
   }

  @override
  Widget build(BuildContext context) {
    preferredTheme = context.watch<PreferredTheme>();

    var textDescription = TextStyle(
        fontSize: 14,
        color: (Theme.of(context).brightness == Brightness.dark) ? Colors.white60 : Colors.black54
    );
    var boxDecoration = BoxDecoration(
        boxShadow: (Theme.of(context).brightness == Brightness.dark) ? null : [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10),
        color: (Theme.of(context).brightness == Brightness.dark) ? Colors.black26 : Colors.white
    );
    return Container(
      alignment: Alignment.topCenter,
      child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
        constraints: BoxConstraints(
            maxWidth: 500
        ),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              width: double.infinity,

              decoration: boxDecoration,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Klassen-unspezifisches',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                  ),
                  CupertinoSwitch(value: unspecificOccurences!, onChanged: (value) {
                    storage.write('unspecificOccurences', value);
                    setState(() {
                      unspecificOccurences = value;
                    });
                  }),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                  'Dir werden auf dem Vertretungsplan ${(unspecificOccurences!) ? '' : 'keine '}Ereignisse angezeigt, die nicht einer spezifischen Klasse zugeordnet sind. ${(unspecificOccurences!) ? 'Diese können trotzdem relevant für dich sein.' : 'Auch wenn diese dennoch für dich relevant sein könnten.'}',
              style: textDescription
              ),
            ),

            Container(
                margin: EdgeInsets.only(top: 30),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: boxDecoration,
                width: double.infinity,
              child:



              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Erscheinungsbild der App',
                  style: TextStyle(
                    fontSize: 17
                  ),
                  ),
                  ListTile(
                    title: Text("Hell"),
                    leading: Radio(
                      value: 0,
                      groupValue: context.watch<PreferredTheme>().value,
                      onChanged: (value) {
                        preferredTheme.setValue(value as int);
                      },
                      activeColor: (Theme.of(context).brightness == Brightness.dark) ? Theme.of(context).accentColor : Colors.blue,

                    ),
                  ),
                  ListTile(
                    title: Text("Dunkel"),
                    leading: Radio(
                      value: 1,
                      groupValue: context.watch<PreferredTheme>().value,
                      onChanged: (value) {
                        preferredTheme.setValue(value as int);
                      },
                      activeColor: (Theme.of(context).brightness == Brightness.dark) ? Theme.of(context).accentColor : Colors.blue,
                    ),
                  ),
                  ListTile(
                    title: Text("System"),
                    leading: Radio(
                      value: 2,
                      groupValue: context.watch<PreferredTheme>().value,
                      onChanged: (value) {
                        preferredTheme.setValue(value as int);
                      },
                      activeColor: (Theme.of(context).brightness == Brightness.dark) ? Theme.of(context).accentColor : Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
               Container(
                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                 alignment: Alignment.centerLeft,
                 child: Text(
                  'Das Erscheinungsbild der App ist ${(context.watch<PreferredTheme>().value == 0) ? 'immer hell' : (context.watch<PreferredTheme>().value == 1) ? 'immer dunkel' : 'abhängig vom Betriebssystem'}.',
                style: textDescription,
              ),)

          ],
        ),
      ),),
    );
  }
}
