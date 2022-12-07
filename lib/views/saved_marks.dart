import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/controllers/main_controller.dart';

class SavedMarks extends StatelessWidget {
  final _mainController = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    _mainController.getAllMarks();
    return Scaffold(
      appBar: AppBar(
        title: Text("العلامات المرجعيه"),
      ),
      body: Center(
        child: GetBuilder<MainController>(
          builder: (c) {
            return _mainController.loading.value
                ? CircularProgressIndicator()
                : ListView.builder(
                    itemCount: _mainController.marksList.length,
                    itemBuilder: (ctx, index) {
                      return Container(
                        margin: EdgeInsets.all(5),
                        child: TextButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.only(right: 20, top: 10)),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                elevation: MaterialStateProperty.all(5),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ))),
                            onPressed: () {
                              _mainController.changeSurah(
                                  _mainController.marksList[index].page_num);
                              Get.back();
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextButton.icon(
                                  onPressed: (){
                                    _mainController.deleteMark(_mainController.marksList[index].id);
                                  },
                                  label: Text("حذف العلامه"),
                                  icon: Icon(Icons.delete_forever, color: Colors.brown,),
                                ),
                                new Expanded(
                                  child: new Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        new Text(
                                          _mainController
                                                  .marksList[index].surah,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                        const Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0)),
                                        new Text(
                                            " صفحه رقم " +
                                            _mainController
                                                .marksList[index].page_num
                                                .toString(),
                                            textAlign: TextAlign.end,
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(fontSize: 17)),
                                        const Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0)),
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
