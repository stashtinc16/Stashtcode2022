
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:image_picker/image_picker.dart';

import 'app_bar.dart';

class Profile extends StatefulWidget{
  @override
  State<Profile> createState() {
    return _Profile();
  }

}

class _Profile extends State<Profile>{
  File? _image;
  final picker = ImagePicker();
  bool _iisObscure=true;
  var passwordcontroller=TextEditingController();
  bool status1 = true;
  bool status2 = true;
  bool status3 = false;




  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppbar(context, "Settings"),

      body:SingleChildScrollView(child:
      SafeArea(
          child: Padding(
        padding: EdgeInsets.only(top: 0),
        child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                color: const Color.fromRGBO(121, 121, 127, 0.4),
                alignment: Alignment.center,
                child: _image != null
                    ? Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: InkWell(
                    onTap: () => getImage(),
                    child: Container(
                      height: 108,
                      width: 108,
                      decoration: BoxDecoration(

                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color.fromRGBO(207, 216, 220, 1),

                        ),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(
                              _image!,
                            )),
                      ),
                    ),
                  ),
                )
                    : Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: InkWell(
                    onTap: () => getImage(),
                    child: Container(
                      height: 108,
                      width: 108,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromRGBO(234, 243, 248, 1),
                        border: Border.all(
                          color: const Color.fromRGBO(207, 216, 220, 1),
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Color.fromRGBO(38, 50, 56, 0.35),
                        size: 38,
                      ),
                    ),

                  ),
                ),),
             Padding(padding:EdgeInsets.only(top: 30) ,child:
             const Icon(Icons.linked_camera_outlined,color: Colors.white,size: 30,),)
            ],),
          Padding(
            padding: EdgeInsets.only(left: 20,right: 20,top: 15),
            child: Column(mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Container(height: 50,
                   width:250,
                   child: TextFormField(
                 decoration: const InputDecoration( labelText: "Display Name",
                     labelStyle:
                     TextStyle(color: Colors.grey,
                       fontSize: 15,
                       fontWeight: FontWeight.w400,),
                     border: InputBorder.none,
                     contentPadding: EdgeInsets.only(bottom:10,top:5)
                 ),
                 style:const TextStyle(color: Colors.black,fontSize: 20),
               )),
               Text("Change",style: TextStyle(color: Colors.deepPurpleAccent,
                 fontSize: 16,
                 fontWeight: FontWeight.w400,),
               ),
             ],
           ),
              Container(width: MediaQuery.of(context).size.width,
              height: 1,color: Colors.grey,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(height: 50,
                    width:250,
                    child:  TextFormField(

                      decoration: const InputDecoration( labelText: "E-mail",
                          labelStyle:
                          TextStyle(color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom:10,top:5)
                      ),
                      style:const TextStyle(color: Colors.black,fontSize: 20),
                      validator: (v){
                        if(v!.isEmpty ||
                            !RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(v)) {
                          return 'Enter a valid email!';
                        }
                        return null;
                      },
                    ),),
                  Text("Change",style: TextStyle(color: Colors.deepPurpleAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,),
                  ),

                ],
              ),
              Container(width: MediaQuery.of(context).size.width,
                height: 1,color: Colors.grey,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(height: 50,
                    width:250,
                    child:  TextFormField(
                      obscureText: _iisObscure,
                      autovalidateMode:AutovalidateMode.onUserInteraction,
                      controller: passwordcontroller,
                      decoration: InputDecoration( labelText: "Password",
                          labelStyle:
                          TextStyle(color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom:10,top:5),
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

                      style:const TextStyle(color: Colors.black,fontSize: 20),

                    ),),
                  Text("Change",style: TextStyle(color: Colors.deepPurpleAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,),
                  ),

                ],
              ),
              Container(width: MediaQuery.of(context).size.width,
                height: 1,color: Colors.grey,),
              SizedBox(height: 15,),
              Text("Connected Accounts",textAlign: TextAlign.start ,style:  TextStyle(color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w400,),),
                SizedBox(height: 15,),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 40,
                      decoration: BoxDecoration(color: Colors.grey,shape: BoxShape.circle),
                    ),
                    SizedBox(width: 15,),
                    Column(
                      children: [
                        Text("Google",textAlign: TextAlign.start ,style:  TextStyle(color: Colors.black,
                          fontSize: 14,),),
                        Text("Photos",textAlign: TextAlign.start ,style:  TextStyle(color: Colors.grey,
                          fontSize: 12,),)
                      ],
                    ),
                    SizedBox(width: 160,),
                    FlutterSwitch(
                      width: 45,
                      height: 25,
                      toggleColor: Colors.white,
                      activeColor: Colors.deepPurpleAccent,
                      value: status1,
                      onToggle: (val) {
                        setState(() {
                          status1 = val;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 40,
                      decoration: BoxDecoration(color: Colors.grey,shape: BoxShape.circle),
                    ),
                    SizedBox(width: 15,),
                        Text("Photos",textAlign: TextAlign.start ,style:  TextStyle(color: Colors.black,
                          fontSize: 14,),),

                    SizedBox(width: 160,),
                    FlutterSwitch(
                      width: 45,
                      height: 25,
                      toggleColor: Colors.white,
                      activeColor: Colors.deepPurpleAccent,
                      value: status2,
                      onToggle: (val) {
                        setState(() {
                          status2 = val;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 40,
                      decoration: BoxDecoration(color: Colors.grey,shape: BoxShape.circle),
                    ),
                    SizedBox(width: 15,),

                        Text("Dropbox",textAlign: TextAlign.start ,style:  TextStyle(color: Colors.black,
                          fontSize: 14,),),


                    SizedBox(width: 160,),
                    FlutterSwitch(
                      width: 45,
                      height: 25,
                      toggleColor: Colors.white,
                      activeColor: Colors.deepPurpleAccent,
                      value: status3,
                      onToggle: (val) {
                        setState(() {
                          status3 = val;
                        });
                      },
                    )
                  ],
                ),
          ],),)
        ],
      ),)))
    );
  }
}