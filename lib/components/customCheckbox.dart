import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:annette_app/fundamentals/task.dart';

/// Die Klasse CustomCheckbox erstellt ein selbstgebautes Checkbox-Widget, welches abgehakt werden kann
/// und dabei ein entsprechendes VoidCallback an das Eltern Widget übermittelt.
class CustomCheckbox extends StatefulWidget {
  final Task? task;
  final VoidCallback? onChanged;

  CustomCheckbox({Key? key,this.task, this.onChanged}) : super(key: key);

  @override
  CustomCheckboxState createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  bool? checked;
  Task? task;

  void toggle() {
    setState(() {
      checked = !checked!;
    });
  }

  @override
  void initState() {
    super.initState();
    task = widget.task;

    if(task!.isChecked == 1) {
      checked = true;
    } else {
      checked = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        pressedOpacity: 1.0,
        child: (checked == true)
            ? Icon(
                CupertinoIcons.check_mark_circled_solid,
                color: CupertinoColors.activeGreen,
          size: 30,
              )
            : Icon(
                CupertinoIcons.circle,
                color: Theme.of(context).colorScheme.secondary,
               // color: CupertinoColors.secondaryLabel,
          size: 30,
              ),
        onPressed: () {widget.onChanged!(); toggle();},
    );
  }
}