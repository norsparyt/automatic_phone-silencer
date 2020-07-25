import 'package:flutter/material.dart';

class GetDynamicIcon{
  Icon getIcon(String category,Color color,double size){
    Icon dynamicIcon;
    switch(category)
    {
      case 'WORK': dynamicIcon=Icon(Icons.work,color: color,size: size,);break;
      case 'MEETINGS': dynamicIcon=Icon(Icons.group,color: color,size: size,);break;
      case 'CLASSES': dynamicIcon=Icon(Icons.class_,color: color,size: size,);break;
      case 'OTHER': dynamicIcon=Icon(Icons.content_paste,color: color,size: size,);break;
      case 'DOZE': dynamicIcon=Icon(Icons.airline_seat_individual_suite,color: color,size: size,);break;
      case 'SILENCE ZONE': dynamicIcon=Icon(Icons.volume_off,color: color,size: size,);break;
      default: dynamicIcon=Icon(Icons.error,color: color,size: 30,);print("ERROR: NO CATEGORY AVAILABLE. COULD NOT RETURN AN ICON");
    }
    return dynamicIcon;
  }
}
