import 'package:flutter/material.dart';
import 'package:stasht/profile.dart';
import 'package:stasht/step_2.dart';

class Sign_In extends StatefulWidget{
  @override
  State<Sign_In> createState() {
    return _Sign_In();
  }

}

class _Sign_In extends State<Sign_In>{
  bool _iisObscure=true;
  int val = -1;
  bool isEmail=false;
  var passwordcontroller=TextEditingController();
  var namecontroller=TextEditingController();

  @override
  Widget build(BuildContext context) {
   return  Scaffold(
       body:SingleChildScrollView(
         child: Padding(padding: const EdgeInsets.only(top: 100,left: 25,right: 25),
             child:Column(crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const Center(
                     child: Text("stasht.",
                       style: TextStyle(fontSize:70,color: Colors.deepPurple, fontWeight: FontWeight.w900,
                           fontFamily: "adobe-clean-cufonfonts",

                           fontStyle: FontStyle.italic),),
                   ),
                   const SizedBox(height: 30,),
                   const Center(
                     child: Text("Sign-in",
                       style: TextStyle(fontSize:20,color: Colors.deepPurple, fontWeight: FontWeight.w600,

                           fontFamily: "adobe-clean-cufonfonts"),),
                   ),
                   const SizedBox(height:15),
                   MaterialButton(
                     onPressed: (){
                       // _trySubmitForm();
                     },
                     height: 40,
                     color: const Color.fromRGBO(2, 152, 216, 1),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(50),
                     ),
                     child:  Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: const [
                         Text(
                           'f',
                           textAlign: TextAlign.center,
                           style: TextStyle(
                               fontSize: 20,
                               fontFamily: "adobe-clean-cufonfonts",
                               fontWeight: FontWeight.w800,
                               color:  Color.fromRGBO(255, 255, 255, 1)),
                         ),
                         SizedBox(width: 10),
                         Text(
                           'Sign-in with Facebook',
                           textAlign: TextAlign.center,
                           style: TextStyle(
                               fontSize: 15,
                               //fontFamily: "adobe-clean-cufonfonts",
                               fontWeight: FontWeight.w400,
                               color:  Color.fromRGBO(255, 255, 255, 1)),
                         ),
                       ],
                     ),
                   ),
                   const SizedBox(height:20),
                   Row(
                       children: const <Widget>[
                         Expanded(
                             child: Divider(height: 1,color: Colors.grey,)
                         ),
                         SizedBox(width: 11,),
                         Text("or",
                           style: TextStyle(color: Colors.grey),),
                         SizedBox(width: 11,),
                         Expanded(
                             child: Divider(height: 1,color: Colors.grey,)
                         ),
                       ]
                   ),
                   const SizedBox(height:20,),
                   // Form(
                   //     key: _formKey,
                   // child:
                   Container(
                     height: 50,
                     width: MediaQuery.of(context).size.width,
                     decoration: BoxDecoration(
                       border: Border.all(color: Colors.grey),
                       borderRadius: BorderRadius.circular(50),
                       color:  Colors.white,
                     ),
                     child:
                     TextFormField(

                       decoration: const InputDecoration( labelText: "Username",
                           labelStyle:
                           TextStyle(color: Colors.blue,
                             fontSize: 15,
                             fontWeight: FontWeight.w400,),
                           border: InputBorder.none,
                           contentPadding: EdgeInsets.only(bottom:10,left: 15,top:5)
                       ),
                       style:const TextStyle(color: Colors.black),
                       validator: (v){
                         if(v!.isEmpty ||
                             !RegExp(
                                 r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                 .hasMatch(v)) {
                           return 'Enter a valid email!';
                         }
                         return null;
                       },
                     ),
                   ),
                   const SizedBox(height: 20,),


                   Container(
                     height: 50,
                     width: MediaQuery.of(context).size.width,
                     decoration: BoxDecoration(
                       border: Border.all(color: Colors.grey),
                       borderRadius: BorderRadius.circular(50),
                       color:  Colors.white,
                     ),
                     child:
                     TextFormField(

                       decoration: const InputDecoration( labelText: "E-mail",
                           labelStyle:
                           TextStyle(color: Colors.blue,
                             fontSize: 15,
                             fontWeight: FontWeight.w400,),
                           border: InputBorder.none,
                           contentPadding: EdgeInsets.only(bottom:10,left: 15,top:5)
                       ),
                       style:const TextStyle(color: Colors.black),
                       validator: (v){
                         if(v!.isEmpty ||
                             !RegExp(
                                 r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                 .hasMatch(v)) {
                           return 'Enter a valid email!';
                         }
                         return null;
                       },
                     ),
                   ),

                   const SizedBox(height: 20,),

                   Container(
                     height: 50,
                     width: MediaQuery.of(context).size.width,
                     decoration: BoxDecoration(
                       border: Border.all(color: Colors.grey),
                       borderRadius: BorderRadius.circular(50),
                       color:  Colors.white,
                     ),
                     child: Center(
                       child: TextFormField(
                         obscureText: _iisObscure,
                         autovalidateMode:AutovalidateMode.onUserInteraction,
                         controller: passwordcontroller,
                         decoration: InputDecoration( labelText: "Password",

                             labelStyle:
                             const TextStyle(color: Colors.blue,
                               fontSize: 15,
                               fontWeight: FontWeight.w400,),
                             border: InputBorder.none,
                             contentPadding: const EdgeInsets.only(bottom:10,left: 15,top:5),
                             suffixIcon: IconButton(
                               icon: Icon(
                                   _iisObscure
                                       ? Icons.visibility_outlined
                                       : Icons.visibility_off),
                               onPressed: () {
                                 setState(() {
                                   _iisObscure = !_iisObscure;
                                 });
                               },
                             )),

                         style:const TextStyle(color: Colors.black),

                       ),
                     ),
                   ),


                   const SizedBox(height:50),
                   GestureDetector(
                     onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => Step_2()));
                     },
                     child:
                     Center(
                       child: Container(
                         height: 40,
                         width: 150,
                         alignment: Alignment.center,
                         decoration: BoxDecoration(color: const Color.fromRGBO(
                             91, 69, 175, 0.8862745098039215),borderRadius: BorderRadius.circular(20)),
                         child: Row(mainAxisAlignment: MainAxisAlignment.center,
                           children: const [
                             Text("Create Account",textAlign:TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w900),),


                           ],),
                       ),
                     ),
                   ),
                   const SizedBox(height: 15,),

                 ]
             )
         ),
       )



   );
  }
}