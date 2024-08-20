import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/sizes.dart';

class Bus_Registration_form extends StatelessWidget {

  const Bus_Registration_form({
    super.key,
    });

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding:const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              //  Image(image: AssetImage(AppLogoImage),height:size.height*0.2),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text("Hello!",style: TextStyle(color: tPrimaryColor,fontSize:30,fontWeight: FontWeight.w900),),
                  Text("Please fill this to register your bus ",style: TextStyle(color: tPrimaryColor,fontSize:17,fontWeight: FontWeight.w500),),

                ],
              ),
              Container(
                padding:const EdgeInsets.symmetric(vertical: tDefaultSize-10),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            label: Text("Bus Number",style: TextStyle(color: tPrimaryColor),),
                            hintText: "Bus Number",
                            prefixIcon: Icon(Icons.numbers,color: tPrimaryColor,),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0,color: tPrimaryColor)
                            )
                        ),
                      ),
                      SizedBox(height: 14,),
                      TextFormField(
                        decoration: InputDecoration(
                            label: Text("Bus Owner",style: TextStyle(color: tPrimaryColor),),
                            hintText: "Bus Owner Name",
                            prefixIcon: Icon(Icons.directions_bus_outlined,color: tPrimaryColor,),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0,color: tPrimaryColor)
                            )
                        ),
                      ),
                      SizedBox(height: 14,),
                      TextFormField(
                        decoration: InputDecoration(
                            label: Text("App Holder",style: TextStyle(color: tPrimaryColor),),
                            hintText: "App Holder Name",
                            prefixIcon: Icon(Icons.touch_app_outlined,color: tPrimaryColor,),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0,color: tPrimaryColor)
                            )
                        ),
                      ),
                      SizedBox(height: 14,),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            label: Text("Email address",style: TextStyle(color: tPrimaryColor),),
                            hintText: "Email address",
                            prefixIcon: Icon(Icons.email_outlined,color: tPrimaryColor,),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0,color: tPrimaryColor)
                            )
                        ),
                      ),
                      SizedBox(height: 14,),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            label: Text("Conatct Number",style: TextStyle(color: tPrimaryColor),),
                            hintText: "Conatct Number",
                            prefixIcon: Icon(Icons.phone,color: tPrimaryColor,),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0,color: tPrimaryColor)
                            )
                        ),
                      ),
                      SizedBox(height: 50,),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: (){},

                          style: OutlinedButton.styleFrom(
                              shape:RoundedRectangleBorder(),
                              backgroundColor:Colors.black87,
                              foregroundColor:Colors.white,
                              side: BorderSide(color: Colors.black87,width:2),
                              padding: EdgeInsets.symmetric(vertical:8,horizontal:50)
                          ),

                          child:Text("REGISTER"),),
                      ),
                      // SizedBox(height: 3,),
                      // Align(alignment:Alignment.center,child:  Text("OR",style:TextStyle(fontSize:13)),),
                      // SizedBox(height: 3,),
                      // SizedBox(
                      //   width:double.infinity,
                      //   child: OutlinedButton.icon(
                      //     icon: Image(image: AssetImage(GoogleLogo),width: 20,),
                      //     onPressed: (){},
                      //
                      //     style: OutlinedButton.styleFrom(
                      //         shape:RoundedRectangleBorder(),
                      //         foregroundColor:Colors.black54,
                      //         side: BorderSide(color: Colors.black87,width:0.7),
                      //         padding: EdgeInsets.symmetric(vertical:8,horizontal:50)
                      //     ),
                      //
                      //     label:Text("Sing_In with Google",style: TextStyle(fontWeight: FontWeight.w700),),),
                      // ),

                      // SizedBox(height: 8,),
                      // TextButton(onPressed:onTap1,
                      //
                      //   child: const Text.rich(
                      //       TextSpan(
                      //           text: "Already have an Account?",
                      //           style: TextStyle(color: Colors.black87),
                      //           children: [
                      //             TextSpan(text: " LogIn",
                      //                 style: TextStyle(color: Colors.blue)),
                      //           ]
                      //       )
                      //   ),
                      // ),






                    ],
                  ),
                ),

              ),
            ],
          ),
        ),
      ),

    );
  }
}


