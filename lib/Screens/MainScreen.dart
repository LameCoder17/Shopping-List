import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_list/Model/dataModel.dart';
import 'package:shopping_list/Screens/LoginScreen.dart';
import 'package:shopping_list/Services/Auth.dart';
import 'package:shopping_list/Utils/Colors.dart';
import 'package:sizer/sizer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<FirebaseDataModel> _allData = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: Text(
          'Shopping List',
          style: GoogleFonts.montserrat(
              fontSize: 16.0.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        actions: [
          Center(
            child: GestureDetector(
              onTap: (){
                AuthenticationHelper().signOut().then((value) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                });
              },
              child: NeumorphicIcon(
                Icons.logout,
                size: 18.0.sp,
              ),
            ),
          )
        ],
      ),
      backgroundColor: Kolors.background,
      body: SingleChildScrollView(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('items').snapshots(),
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return NeumorphicProgressIndeterminate();
              }
              else if(snapshot.hasError){
                return Center(
                  child: Text('An error occurred'),
                );
              }
              else{
                print(snapshot.data!.docs[0]['name']);
                _allData.clear();
                snapshot.data!.docs.forEach((element) => _allData.add(FirebaseDataModel.fromMap(element))
                );

                return Container(
                  child: ListView.builder(
                    itemCount: _allData.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index){
                      return Neumorphic(
                        margin: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 15.0.sp),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Kolors.foreground
                          ),
                          height: 10.h,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.0.sp),
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(_allData[index].name, style: GoogleFonts.nunito(fontSize: 16.0.sp, fontWeight: FontWeight.bold, color: Kolors.accent2)),
                                    Text(_allData[index].createdBy, style: GoogleFonts.nunito(fontSize: 10.0.sp, color: Kolors.accent)),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.0.sp),
                                alignment: Alignment.center,
                                child: Text(_allData[index].quantity, style: GoogleFonts.nunito(fontSize: 18.0.sp, color: Kolors.accent2),),
                              )
                            ],
                          ),
                        )
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Kolors.accent,
        child: NeumorphicIcon(
          Icons.add,
          size: 20.0.sp,
          style: NeumorphicStyle(
            color: Kolors.background
          ),
        ),
        onPressed: (){
          print('Yes');
        },
      ),
    );
  }
}
