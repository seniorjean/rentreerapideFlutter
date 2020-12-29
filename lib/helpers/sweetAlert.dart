import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


// The easiest way for creating RFlutter Alert
textAlert(context , {title , content}) {
  Alert(
    context: context,
    title: "${title}",
    desc: "${content}",
  ).show();
}


sweetDialog(context , {title = '' , Widget Content , buttonText = 'ok' , desc = '' ,type=''}){
  // Reusable alert style
  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: true,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        // color: Colors.red,
      ),
      constraints: BoxConstraints.expand(width: 300),
      //First to chars "55" represents transparency of color
      overlayColor: Color(0x55000000),
      alertElevation: 0,
      alertAlignment: Alignment.topCenter);

  AlertType t;
  if(type != ''){
    switch(type){
      case 'info': t = AlertType.info; break;
      case 'success': t = AlertType.success; break;
      case 'error': t = AlertType.error; break;
      case 'warning': t = AlertType.warning; break;
    }
  }

  // Alert dialog using custom alert style
  Alert(
    context: context,
    style: alertStyle,
    type: t,
    title: "${title}",
    desc: "${desc}",
    buttons: [
      DialogButton(
        child: Text(
          "${buttonText}",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        color: Color.fromRGBO(0, 179, 134, 1.0),
        radius: BorderRadius.circular(0.0),
      ),
    ],
  ).show();
}

sweetConfirm(context , {title = '' , Widget Content , noButtonText = 'Non' , yesButtonText = 'Oui' , desc = '' ,type='' , noAction , yesAction}){
  // Reusable alert style
  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(),
      animationDuration: Duration(milliseconds: 369),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: BorderSide(color: Colors.grey,),
      ),
      titleStyle: TextStyle(fontWeight: FontWeight.bold),
      constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width),
      //First to chars "55" represents transparency of color
      overlayColor: Color(0x55000000),
      alertElevation: 1.0,
      alertPadding: EdgeInsets.fromLTRB(9.0, 24.3, 9.0, 9.0),
      alertAlignment: Alignment.topCenter);

  if(noAction == null){
    noAction = (){
      Navigator.pop(context);
    };
  }
  if(yesAction == null){
    yesAction = (){
      Navigator.pop(context);
    };
  }

  AlertType t;
  if(type != ''){
    switch(type){
      case 'info': t = AlertType.info; break;
      case 'success': t = AlertType.success; break;
      case 'error': t = AlertType.error; break;
      case 'warning': t = AlertType.warning; break;
    }
  }

  // Alert dialog using custom alert style
  Alert(
    context: context,
    style: alertStyle,
    type: t,
    content: Content,
    title: "${title}",
    desc: "${desc}",
    buttons: [
      DialogButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel_outlined , color: Colors.white,),
            SizedBox(width:3.3),
            Text("${noButtonText}", style: TextStyle(color: Colors.white, fontSize: 20),)
          ],
        ),
        onPressed: () => noAction(),
        color: Colors.red,
        radius: BorderRadius.circular(0.0),
      ),

      DialogButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check , color: Colors.white,),
            SizedBox(width:3.3),
            Text("${yesButtonText}", style: TextStyle(color: Colors.white, fontSize: 20),),
          ],
        ),
        onPressed: () => yesAction(),
        color: Colors.green,
        radius: BorderRadius.circular(0.0),
      ),
    ],
  ).show();
}

showLoader(context , {desc = '' , title = 'Veillez patienter SVP'}){
  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      //First to chars "55" represents transparency of color
      overlayColor: Color(0x55000000),
      alertElevation: 0,
      alertAlignment: Alignment.center

  );


  Alert(
    context: context,
    title: "${title}",
    desc: "${desc}",
    content: Center(
      child: CircularProgressIndicator(),
    ),
    style: alertStyle,
    buttons: []

  ).show();
}

hideLoader(context){
  Navigator.of(context).pop();
}


addAddressDialog(context , {Widget content , onSaved}){
  // Reusable alert style
  var alertStyle = AlertStyle(
      animationType: AnimationType.fromLeft,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      descStyle: TextStyle(),
      animationDuration: Duration(milliseconds: 369),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.6),
        side: BorderSide(color: Colors.grey,),
      ),
      titleStyle: TextStyle(fontFamily: 'Montserrat'),
      constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width),
      //First to chars "55" represents transparency of color
      overlayColor: Color(0x55000000),
      alertElevation: 1.0,
      alertPadding: EdgeInsets.fromLTRB(9.0, 9.0, 9.0, 9.0),
      alertAlignment: Alignment.center
  );

  // Alert dialog using custom alert style
  Alert(
    context: context,
    style: alertStyle,
    title: "Ajouter une Addresse",
    desc: "",
    content: content,
    buttons: [
      DialogButton(
        child: Text(
          "Annuler",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: (){
          Navigator.of(context).pop();
        },
        color: Colors.red,
        radius: BorderRadius.circular(0.0),
      ),

      DialogButton(
        child: Text(
          "Ajouter",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: ()=>onSaved(),
        color: Colors.green,
        radius: BorderRadius.circular(0.0),
      ),


    ],
  ).show();
}
