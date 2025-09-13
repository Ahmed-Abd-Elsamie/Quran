import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/controllers/main_controller.dart';
import 'package:quran/modules/marks/controller/mark_controller.dart';

class SavedMarks extends StatelessWidget {
  final _mainController = Get.put(MainController());
  final _marksController = Get.put(MarksController());

  @override
  Widget build(BuildContext context) {
    _marksController.getAllMarks();
    return Scaffold(
      appBar: AppBar(
        title: Text("العلامات المرجعيه"),
      ),
      body: Center(
        child: GetBuilder<MarksController>(
          builder: (c) {
            if (_marksController.loading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (_marksController.marksList.isEmpty) {
              return Center(
                child: Text(
                  "لا توجد علامات مرجعية",
                  style: TextStyle(fontSize: 17),
                ),
              );
            }
            return ListView.builder(
              itemCount: _marksController.marksList.length,
              itemBuilder: (ctx, index) {
                return Container(
                  margin: EdgeInsets.all(5),
                  child: TextButton(
                      style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                              EdgeInsets.only(right: 20, top: 10)),
                          backgroundColor:
                              WidgetStateProperty.all(Colors.white),
                          elevation: WidgetStateProperty.all(5),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ))),
                      onPressed: () {
                        print(
                            _marksController.marksList[index].type.toString());
                        _mainController.changeSurah(
                            _marksController.marksList[index].page_num);
                        Get.back();
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextButton.icon(
                            onPressed: () {
                              _marksController.deleteMark(
                                  _marksController.marksList[index].id);
                            },
                            label: Text("حذف العلامه"),
                            icon: Icon(
                              Icons.delete_forever,
                              color: Colors.brown,
                            ),
                          ),
                          new Expanded(
                            child: new Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  new Text(
                                    _marksController.marksList[index].surah,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  const Padding(
                                      padding: const EdgeInsets.only(top: 5.0)),
                                  new Text(
                                      " صفحه رقم " +
                                          _marksController
                                              .marksList[index].page_num
                                              .toString(),
                                      textAlign: TextAlign.end,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(fontSize: 17)),
                                  new Text(
                                      _marksController.marksList[index].type ==
                                              1
                                          ? "علامه القراءه"
                                          : "علامه الحفظ".toString(),
                                      textAlign: TextAlign.end,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(fontSize: 17)),
                                  const Padding(
                                      padding: const EdgeInsets.only(top: 5.0)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
