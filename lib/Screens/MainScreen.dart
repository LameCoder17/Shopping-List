import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_list/Model/dataModel.dart';
import 'package:shopping_list/Screens/LoginScreen.dart';
import 'package:shopping_list/Services/Auth.dart';
import 'package:shopping_list/Services/Database.dart';
import 'package:shopping_list/Utils/Colors.dart';
import 'package:sizer/sizer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<FirebaseDataModel> _allData = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _quantity = TextEditingController();
  String _type = 'kg';

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
                style: NeumorphicStyle(
                  color: Kolors.accent2
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: Kolors.background,
      body: SingleChildScrollView(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection(AuthenticationHelper().id).snapshots(),
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
                // print(snapshot.data!.docs[0]['name']);
                _allData.clear();
                snapshot.data!.docs.forEach((element) => _allData.add(FirebaseDataModel.fromMap(element))
                );

                return _allData.length != 0 ? Container(
                  child: ListView.builder(
                    itemCount: _allData.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index){
                      return GestureDetector(
                        onTap: (){
                          _name.text = _allData[index].name;
                          _quantity.text = _allData[index].quantity.split(' ')[0];
                          _type = _allData[index].quantity.split(' ')[1];
                          print(_type);
                          _addOrUpdate('Update', _allData[index].id);
                        },
                        child: Dismissible(
                          key: Key(_allData[index].id),
                          background: Container(
                            color: Kolors.accent,
                          ),
                          onDismissed: (direction) async {
                            await Database.deleteItem(_allData[index].id).then((value){
                              setState(() {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Item Successfully Deleted', style: GoogleFonts.nunito(fontSize: 14.0.sp),)
                                    ));
                              });
                            });
                          },
                          child: Neumorphic(
                            margin: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 15.0.sp),
                            style: NeumorphicStyle(
                              lightSource: LightSource.top,
                              depth: 3,

                            ),
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
                                    child: Text(_allData[index].name, style: GoogleFonts.nunito(fontSize: 16.0.sp, fontWeight: FontWeight.bold, color: Kolors.accent2)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10.0.sp),
                                    alignment: Alignment.center,
                                    child: Text(_allData[index].quantity, style: GoogleFonts.nunito(fontSize: 18.0.sp, color: Kolors.accent),),
                                  )
                                ],
                              ),
                            )
                          ),
                        )
                      );
                    },
                  ),
                ) : Center(
                  child: Text('No Items Added Yet !', style: GoogleFonts.nunito(fontSize: 16.0.sp, color: Kolors.accent),),
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
          _name.clear();
          _quantity.clear();
          _addOrUpdate('Add');
        },
      ),
    );
  }

  _addOrUpdate(String action, [String id = '']) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Kolors.background,
              title: Text('$action Item', style: GoogleFonts.nunito(fontSize: 16.0.sp, color: Kolors.accent, fontWeight: FontWeight.bold),),
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Neumorphic(
                        style: NeumorphicStyle(
                          color: Kolors.foreground,
                          lightSource: LightSource.bottom,
                          depth: 2,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.name,
                          style: GoogleFonts.nunito(decoration: TextDecoration.none, decorationColor: Kolors.foreground, color: Kolors.accent2),
                          controller: _name,
                          validator: (value) {
                            return value!.isNotEmpty ? null : 'Enter Name !';
                          },
                          decoration: InputDecoration(
                              hintText: 'Enter Item Name',
                              hintStyle: GoogleFonts.nunito(fontSize: 12.0.sp, color: Kolors.accent2),
                            filled: true,
                            fillColor: Kolors.foreground,
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[300]!)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Kolors.accent)),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[300]!)),
                            errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[300]!)),
                            focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[300]!)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Neumorphic(
                        style: NeumorphicStyle(
                          color: Kolors.foreground,
                          lightSource: LightSource.bottom,
                          depth: 2,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                controller: _quantity,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  return value!.isNotEmpty ? null : 'Enter Quantity !';
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter Quantity',
                                  hintStyle: GoogleFonts.nunito(fontSize: 12.0.sp, color: Kolors.accent2),
                                  filled: true,
                                  fillColor: Kolors.foreground,
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[300]!)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Kolors.accent)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[300]!)),
                                  errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[300]!)),
                                  focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[300]!)),
                                ),

                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField(
                                  value: _type,
                                  onChanged: (String? val){
                                    _type = val!;
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Kolors.foreground,
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey[300]!)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Kolors.accent)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey[300]!)),
                                    errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey[300]!)),
                                    focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey[300]!)),
                                  ),
                                  items: <String>['kg', 'g', 'pkt']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
              actions: <Widget>[
                MaterialButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                MaterialButton(
                  child: Text(action),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if(action == 'Add'){
                        await Database.addItem({
                          'name' : _name.text,
                          'quantity' : '${_quantity.text} $_type'
                        }).then((value){
                          if(value){
                            _name.clear();
                            _quantity.clear();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item Successfully Added')));
                            Navigator.of(context).pop();
                          }
                        });
                      }
                      else{
                        Database.updateItem(id, {
                          'name' : _name.text,
                          'quantity' : '${_quantity.text} $_type'
                        }).then((value){
                          if(value){
                            _name.clear();
                            _quantity.clear();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item Successfully Updated')));
                            Navigator.of(context).pop();
                          }
                        });
                      }
                    }
                  },
                ),
              ],
            );
          });
        });
  }
}
