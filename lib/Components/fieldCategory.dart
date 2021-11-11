import 'dart:math';

import 'package:charuvidya/Components/subFeildCategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class FieldCategory extends StatefulWidget {
  final jsonData;

  const FieldCategory({Key key, this.jsonData}) : super(key: key);

  @override
  _FieldCategoryState createState() => _FieldCategoryState();
}

class _FieldCategoryState extends State<FieldCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('Home')),
      ),
      body: (widget.jsonData != null) ? ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          // String name = widget.jsonData['courseCategoryTitle'].toString();
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  title: Text("${widget.jsonData[index]['courseCategoryTitle'].toString()}",textAlign: TextAlign.center,),
                ),
                Text(
                  'Count : ${Random().nextInt(20)}',
                  // textAlign: TextAlign.end,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                      textColor: const Color(0xFF6200EE),
                      onPressed: () {
                        print(index);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            fullscreenDialog: false,
                            builder: (context) => SubFieldCategory(
                              index: widget.jsonData[index]['id'],
                            ),
                          ),
                        );
                      },
                      child: const Text('View'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        itemCount: widget.jsonData == null ? 0 : widget.jsonData.length,
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}
