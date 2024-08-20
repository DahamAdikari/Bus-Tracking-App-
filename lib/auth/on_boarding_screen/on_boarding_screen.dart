import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:test_4/auth/log_in.dart';
import '../Role_Selection_Screen/selection_screen.dart';
import '../constants/colors.dart';
import '../constants/image_strings.dart';
import '../constants/text_strings.dart';
import 'model_on_boarding.dart';
import 'on_boarding_page_widget.dart';


class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final controller = LiquidController();

  int currentPage =0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;


    final pages = [
      OnBoardingPageWidgets(
        model: OnBoardingModel(
            image: bOnBoardImage1,
            title: bOnBoardingTittle1,
            SubTitle: bOnBoardingSubTittle1,
            CounterText: bOnBoardCounter1,
            size: size.height,
            bgColor: bOnBoardingColor1
        ),
      ),
      OnBoardingPageWidgets(
        model: OnBoardingModel(
            image: bOnBoardImage2,
            title: bOnBoardingTittle2,
            SubTitle: bOnBoardingSubTittle2,
            CounterText: bOnBoardCounter2,
            size: size.height,
            bgColor: bOnBoardingColor2
        ),
      ),
      OnBoardingPageWidgets(
        model: OnBoardingModel(
            image: bOnBoardImage3,
            title: bOnBoardingTittle3,
            SubTitle: bOnBoardingSubTittle3,
            CounterText: bOnBoardCounter3,
            size: size.height,
            bgColor: bOnBoardingColor3
        ),
      ),
    ];


    return  SafeArea(
      child: Scaffold(
        body: Stack(
            alignment: Alignment.center,
            children: [
              LiquidSwipe(
                pages :pages,
                liquidController: controller,
                slideIconWidget: Icon(Icons.arrow_back_ios),
                enableSideReveal: true,
                onPageChangeCallback: onPageChanedCallback,

              ),
              Positioned(
                bottom: 47.0,
                child: OutlinedButton(
                  onPressed: (){
                    int nextPage = controller.currentPage +1;
                    if (nextPage<3){
                      controller.animateToPage(page: nextPage);}
                    else { Get.to(()=>const LogInScreen());}

                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, side: const BorderSide(color: Colors.black54),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20.0),

                  ),
                  child: Container(
                    padding: const EdgeInsets.all(22.0),
                    decoration: const BoxDecoration(
                        color: tDarkColor,shape: BoxShape.circle
                    ),
                    child: Icon(Icons.arrow_forward_ios),
                  ),

                ),
              ),
              Positioned(
                  top:10,right:20,
                  child: TextButton(
                    onPressed:(){
                      Get.to(()=>const LogInScreen());
                    },
                    child: const Text("skip",style: TextStyle(color: Colors.grey,),
                    ),
                  )),
              Positioned(
                  bottom:200,
                  child:AnimatedSmoothIndicator(
                    count:3,
                    activeIndex:controller.currentPage,
                    effect: const WormEffect(
                      activeDotColor: tPrimaryColor,

                    ),
                  )
              ),
            ]
        ),
      ),
    );
  }

  void onPageChanedCallback(int activePageIndex) {
    setState(() {
      currentPage = activePageIndex;
    });


  }
}


