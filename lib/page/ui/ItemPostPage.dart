part of garage_sale;
class ItemPostPage extends StatefulWidget{
  @override
  State createState() => _ItemPostState();
}
class _ItemPostState extends State<ItemPostPage> {
  final ItemPostViewController controller = ItemPostViewController();
  PersistentBottomSheetController bottomSheet = null;
  _ItemPostState(){
  }
  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> _getCategoryLists(List<String> items){
    return items.map((String str){
      return DropdownMenuItem(
        value: str,
        child: Text(str)
      );
    }).toList();
  }
  Widget _getImageWidget(_Image file) {
    if (file == null) {
      return null;
    }
    Image origin = Image.memory(file.data);
    return ImageWidget(
      image:file,
      size:null,
      loadFromRawData:true,
      decorator: ImageDecorator(actionableDecorator: {
        'actions':<Widget>[
          Positioned(
              top:20,
              right:20,
              child:IconButton(icon: Icon(Icons.delete),
                  onPressed: (){
                    controller.deleteImage(file);
                  })
          ),
          Positioned(
            top:20,
            left:20,
            child:IconButton(icon: Icon(Icons.edit),
                onPressed: (){
                  controller.setEditingImage(file);
                  ShowPickImageBottomSheet();
                })
          )
        ]
      }),
    );
  }
  void ShowPickImageBottomSheet() {
    if (bottomSheet != null) {
      bottomSheet.close();
    }
    bottomSheet = _scaffoldKey.currentState
        .showBottomSheet(
            (context) {
          return Container(
              padding: const EdgeInsets
                  .symmetric(vertical: 4.0),
              color: Colors.blueGrey,
              height: 60,
              child: Row(
                  mainAxisSize: MainAxisSize
                      .max,
                  mainAxisAlignment: MainAxisAlignment
                      .start,
                  children: <Widget>[
                    FlatButton(
                        child: Column(
                          children: <
                              Widget>[
                            Icon(Icons
                                .insert_drive_file,
                                color: Colors
                                    .grey[200]),
                            SizedBox(
                                height: 10,
                                width: 10),
                            Text('File',
                                style: TextStyle(
                                    color: Colors
                                        .grey[200]))
                          ],
                        ),
                        onPressed: () {
                          controller
                              .pickImage(
                              ImageSource
                                  .gallery);
                        }
                    ),
                    SizedBox(width: 8),
                    FlatButton(
                        child: Column(
                          children: <
                              Widget>[
                            Icon(Icons
                                .camera_enhance,
                                color: Colors
                                    .grey[200]),
                            SizedBox(
                                height: 10,
                                width: 10),
                            Text('Camera',
                                style: TextStyle(
                                    color: Colors
                                        .grey[200]))
                          ],
                        ),
                        onPressed: () {
                          controller
                              .pickImage(
                              ImageSource
                                  .camera);
                        }
                    )
                  ]
              ));
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:controller._streamCtrl.stream,
        initialData: controller._state,
        builder:(context,snapshot) {
            ItemPostViewState _state = snapshot.data;
            Widget view = null;
            if(_state.isPosting){
              view = Center(child:LoadingSignal(message:'Posting your item...'));
            } else {
              Widget column = null;
              List<_Image> descriptionImageUrls = [];
              descriptionImageUrls.addAll(_state.descriptionImages);
              int i = descriptionImageUrls.length - 1;
              if (i < 0)
                i = 0;
              for (; i < 4; i ++) {
                descriptionImageUrls.add(null);
              }
              if (_state.image != null) {
                column = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _getImageWidget(_state.image),
                      _getImageWidget(descriptionImageUrls[0]),
                      _getImageWidget(descriptionImageUrls[1]),
                      _getImageWidget(descriptionImageUrls[2]),
                      _getImageWidget(descriptionImageUrls[3])
                    ].where((widget) => widget != null).toList());
              }
               view = SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      DropdownButtonFormField<String>(
                                          decoration: new InputDecoration(
                                              labelText: 'Category'
                                          ),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Please choose the category";
                                            }
                                          },
                                          onSaved: (value) {
                                            controller.updateItemInfo(
                                                category: value);
                                          },
                                          value: controller._state._item
                                              .category,
                                          onChanged: (value) {
                                            controller.updateItemInfo(
                                                isSync: true, category: value);
                                          },
                                          //value:_state._item.category,
                                          items: _getCategoryLists(
                                              _appRuntimeInfo
                                                  .supportedCategories.map((Map<
                                                  String,
                                                  String> map) => map['value'])
                                                  .toList())
                                      ),
                                      TextFormField(
                                          decoration: new InputDecoration(
                                            labelText: 'Name',
                                          ),
                                          maxLines: 1,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Please input the name";
                                            }
                                          },
                                          onSaved: (val) {
                                            controller.updateItemInfo(
                                                name: val);
                                          }
                                      ),
                                      TextFormField(
                                          decoration: new InputDecoration(
                                            labelText: 'Price',
                                          ),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Please input the price";
                                            }
                                          },
                                          maxLines: 1,
                                          keyboardType: TextInputType.number,
                                          onSaved: (val) {
                                            controller.updateItemInfo(
                                                price: double.parse(val));
                                          }
                                      ),
                                      TextFormField(
                                          decoration: new InputDecoration(
                                            labelText: 'description',
                                          ),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Please input the description";
                                            }
                                          },
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 5,
                                          onSaved: (val) {
                                            controller.updateItemInfo(
                                                description: val);
                                          }
                                      )
                                    ])),
                            Divider(),
                            column,
                            Align(
                              alignment: FractionalOffset.centerRight,
                              child: Container(
                                  width: 132,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: RaisedButton(
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.add_box),
                                          Text("Add Picture")
                                        ],
                                      ),
                                      onPressed: () {
                                        ShowPickImageBottomSheet();
                                      }
                                  )),

                            ),
                            Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: RaisedButton(
                                    child: Text('Post'),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        await controller.postItem();
                                        if (bottomSheet != null) {
                                          bottomSheet.close();
                                          bottomSheet = null;
                                        }
                                        Navigator.of(context).pop(
                                            controller._state._item);
                                      }
                                    }
                                ))
                          ].where((widget) {
                            return widget != null;
                          }).toList()
                      )
                  )
              );
            }
            return GestureDetector(
                onTap:(){
                  if(bottomSheet != null){
                    bottomSheet.close();
                    bottomSheet = null;
                  }
                },
                child:Scaffold(
                  key:_scaffoldKey,
                  appBar: AppBar(
                    title: Text('Post Item'),
                  ),
                  body: view
                ));
          });
  }
}