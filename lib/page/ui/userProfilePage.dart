part of garage_sale;
class UserProfilePage extends StatefulWidget {
  @override
  State createState() => new _UserProfileState();
}
class _UserProfileState extends State<UserProfilePage> {
  final UserProfileViewController controller = UserProfileViewController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:controller._streamCtrl.stream,
        initialData: controller._state,
        builder:(context,snapshot) {
          UserProfileViewState _state = snapshot.data;
          return Scaffold(
              key:_scaffoldKey,
              resizeToAvoidBottomPadding:false,
              appBar:AppBar(
                title: Center(child:Text('Profile')),
              ),
              body:SingleChildScrollView(
                  child:Form(
                      key:_formKey,
                      child:Column(
                        children:<Widget>[
                          SizedBox(height:20,width:20),
                          GestureDetector(
                              onTap:(){
                                if(_state.isInAmend) {
                                  showDialog(context: context,
                                      builder: (_) =>
                                          SimpleDialog(
                                              title: Text('Upload photo'),
                                              children: <Widget>[Center(
                                                  child: RaisedButton(
                                                      child: Container(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 4.0,
                                                              vertical: 4.0),
                                                          child: Column(
                                                              children: <Widget>[
                                                                Icon(Icons.file_upload),
                                                                Text('Upload')
                                                              ]
                                                          )),
                                                      onPressed: () async {
                                                        await controller.pickImage();
                                                        Navigator.of(context).pop();
                                                      }
                                                  )
                                              )
                                              ]
                                          ));
                                }
                              },
                              child:Center(child:Container(
                                  width:80,
                                  height:80,
                                  child:ClipOval(
                                      child:FittedBox(
                                          fit:BoxFit.fill,
                                          child:_state.iconImg == null? (
                                              _state._user.iconUrl == null ?
                                              Image.asset("assets/images/defaultPhoto.png")
                                                  :Image.network(_state._user.iconUrl)):Image.file(_state.iconImg)
                                      ))))
                          ),
                          Text(_state._user.name),
                          SizedBox(width:100,height:50),
                          _state.isInAmend ? (
                              Container(
                                  width:200,
                                  child:TextFormField(
                                      decoration: new InputDecoration(
                                        labelText: 'Email',
                                      ),
                                      maxLines:1,
                                      initialValue: _state._user.email,
                                      validator:(value) {
                                        if(value.isEmpty) {
                                          return "Please input the Email";
                                        }
                                      },
                                      keyboardType:TextInputType.emailAddress,
                                      onSaved:(val){
                                        controller.updateUserInfo(email:val);
                                      }
                                  ))
                          ) : (
                              Center(child:Text(_state._user.email == null ? "Email" : _state._user.email))
                          ),
                          SizedBox(width:100,height:50),
                          _state.isInAmend ? (
                              Container(
                                  width:200,
                                  child:TextFormField(
                                      decoration: new InputDecoration(
                                        labelText: 'Phone',
                                      ),
                                      maxLines:1,
                                      initialValue: _state._user.phone,
                                      validator:(value) {
                                        if(value.isEmpty) {
                                          return "Please Input Your Phone Number";
                                        }
                                      },
                                      onSaved:(val){
                                        controller.updateUserInfo(phone:val);
                                      }
                                  ))
                          ) : (
                              Center(child:Text(_state._user.phone == null ? "Phone" : _state._user.phone))
                          ),
                          SizedBox(width:100,height:50),
                          _state.isInAmend ?
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:<Widget>[
                                RaisedButton(
                                    child: Text('Upload'),
                                    onPressed:() async{
                                      if(_formKey.currentState.validate()){
                                        _formKey.currentState.save();
                                        await controller.saveUser();
                                        controller.editComplete();
                                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("You have just update your profile!")));
                                      }
                                    }
                                ),
                                RaisedButton(
                                    child: Text('Cancel'),
                                    onPressed:(){
                                      controller.editComplete();
                                    }
                                )
                              ]
                          ): Center(
                              child:RaisedButton(
                                  child: Text('Amend'),
                                  onPressed:(){
                                    controller.edit();
                                  }
                              )
                          ),
                          Center(
                            child:RaisedButton(
                                child: Text('Logout'),
                                onPressed:(){
                                  controller.logout().then((success){
                                    while(Navigator.of(context).canPop()){
                                      Navigator.of(context).pop();
                                    };
                                    Navigator.of(context).pushNamed("/Login");
                                  });
                                }
                            )
                          )
                        ],
                      )
                  ))
          );
        }
    );

  }
}