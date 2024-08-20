import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class ForegtPasswordBtnWidget extends StatelessWidget {
  const ForegtPasswordBtnWidget({

    required this.btnIcon,
    required this.tittle,
    required this .subtittle,
    required this. onTap,
    super.key,
  });


  final IconData btnIcon;
  final String tittle,subtittle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: bOnBoardingColor3,
        ),

        child: Row(
          children: [
            Icon(btnIcon ,size: 60.0,),
            SizedBox(width: 10.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tittle,style:TextStyle(fontSize:18,fontWeight: FontWeight.w600),),
                Text(subtittle,style:TextStyle(fontSize:14,fontWeight: FontWeight.w500),),
              ],
            )
          ],
        ),

      ),
    );
  }
}
