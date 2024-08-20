import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/sizes.dart';

class LogOrSign extends StatelessWidget {
  const LogOrSign({
    required this.tittle1,
    required this.tittle2,
    required this.tittle3,
    required this.userImagePath,
    required this.onTap1,
    required this.onTap2,

    super.key,
  });
  final String userImagePath;
  final VoidCallback onTap1,onTap2;
  final String tittle1,tittle2,tittle3;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(tDefaultSize),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(tittle3,style: TextStyle(color:tPrimaryColor,fontWeight:FontWeight.w700,fontSize:24),),

          Image(image :AssetImage(userImagePath),
              height:300, // Set the desired height
              fit: BoxFit.contain),
          Column(
            children: [
              OutlinedButton(
                onPressed:onTap1,

                style: OutlinedButton.styleFrom(
                    shape:RoundedRectangleBorder(),
                    foregroundColor:Colors.black54,
                    side: BorderSide(color: Colors.black87,width:2),
                    padding: EdgeInsets.symmetric(vertical:8,horizontal:50)
                ),

                child:Text(tittle1),),


              SizedBox(height: 10,),
              ElevatedButton(onPressed:onTap2,

                style: OutlinedButton.styleFrom(
                    shape:RoundedRectangleBorder(),
                    backgroundColor:Colors.black87,
                    foregroundColor:Colors.white,
                    side: BorderSide(color: Colors.black87,width:2),
                    padding: EdgeInsets.symmetric(vertical:8,horizontal:50)
                ),

                child:Text(tittle2),),
            ],
          ),



          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(height: 2,width:130,color: Colors.grey),
                SizedBox(width: 10,),
                Text("BusHub"),
                SizedBox(width:10,),
                Container(height: 2,width:130,color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
