import 'package:aamir_ai/Home.dart';
import 'package:aamir_ai/services/connection.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            const InternetConnection(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Talkio',style: TextStyle(fontSize: 55,color: Color(0xff2945FF),fontWeight: FontWeight.w800,fontFamily: 'Syne'),),
                const SizedBox(height: 10,),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20)
                    ,child: const Text("Your loyal companion, who won't judge your weird questions",style: TextStyle(fontSize: 18,fontFamily: 'Syne',fontWeight:FontWeight.w500),textAlign: TextAlign.center,)),
                const SizedBox(height: 20,),
                SizedBox(
                  child: Image.asset(
                    'assets/images/splash_img.png', // Replace 'image.png' with your image asset path
                    width: 250, // Adjust width as needed
                    height: 250, // Adjust height as needed
                    fit: BoxFit.contain, // You can use different BoxFit values based on your requirement
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
                  },
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: const Color(0xff2945FF),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: const Center(child: Text('Get started',style: TextStyle(color: Colors.white),)),
                  ),
                ),
                const SizedBox(height: 40,),
                const Text('By',style: TextStyle(fontSize: 18,fontFamily: 'Syne',fontWeight:FontWeight.w500),),
                const Text('Aamir Almani',style: TextStyle(fontSize: 20,fontFamily: 'Syne',fontWeight:FontWeight.w500),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
