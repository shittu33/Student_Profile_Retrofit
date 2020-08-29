import 'package:flutter/material.dart';

class OptionAlertDialog extends StatelessWidget {
  const OptionAlertDialog({
    Key key,
    @required this.title,
    this.onNegativeTap,
    this.negativeTitle,
    this.onPositiveTap,
    this.positiveTitle,
  }) : super(key: key);

  final String title;
  final Function() onNegativeTap;
  final String negativeTitle;
  final Function() onPositiveTap;
  final String positiveTitle;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        actionsPadding: EdgeInsets.all(0),
        title: Text(title),
        actions: <Widget>[
          negativeTitle != null
              ? FlatButton(
                  onPressed: onNegativeTap,
                  child: Text(negativeTitle),
                )
              : null,
          positiveTitle != null
              ? FlatButton(
                  onPressed: onPositiveTap,
                  child: Text(positiveTitle),
                )
              : null,
        ]);
  }
}

class TextPopUpMenuButton extends StatelessWidget {
  TextPopUpMenuButton({
    Key key,
    @required this.list,
    this.icon,
    @required this.onButtonTap,
  }) : super(key: key);

  final IconData icon;
  final List list;
  final Function(dynamic choice) onButtonTap;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: icon != null ? Icon(icon) : Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) {
        return list
            .map((choice) => PopupMenuItem(
                child: GestureDetector(
                  onTap: ()=> onButtonTap(choice),
                    child: Text(choice)))
        )
            .toList();
      },
//      onSelected: (selected){
//
//        print("kjdjfkdk jfjk");
//        return onButtonTap(selected);
//      },
    );
  }
}
