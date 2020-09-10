import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:greenillu/products/product_list.dart';
import 'package:greenillu/widgets/appdrawer.dart';
import 'package:greenillu/utils/sharedpref.dart';
import 'package:greenillu/appconfig/config.dart';
import 'package:http/http.dart' as http;


const PADDING_16 = EdgeInsets.all(16.0);
const PADDING_8 = EdgeInsets.all(8.0);

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: LoginFields(),
    );
  }
}

class LoginFields extends StatefulWidget {
  @override
  LoginFieldsState createState() => LoginFieldsState();
}

class LoginFieldsState extends State<LoginFields> {
  String _username;
  String _password;
  bool _isDetailValid = true;
  bool _isValidating = false;

  @override
  void initState() {
    super.initState();
    _username = 'YOUR_USERNAME';
    _password = 'YOUR_PASSWORD';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: SingleChildScrollView(
          child: Container(
            padding: PADDING_16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: PADDING_8,
                  child: _buildFormField(
                    icon: Icon(Icons.person),
                    labelText: "Username",
                    hintText: "Username",
                    initialText: _username,
                    onChanged: _onUsernameChanged,
                  ),
                ),
                Padding(
                  padding: PADDING_8,
                  child: _buildFormField(
                    icon: Icon(Icons.lock),
                    labelText: "Password",
                    hintText: "Password",
                    initialText: _password,
                    obscureText: true,
                    onChanged: _onPasswordChanged,
                  ),
                ),
                _isDetailValid
                    ? SizedBox(
                  width: 0.0,
                  height: 0.0,
                )
                    : Padding(
                  padding: PADDING_8,
                  child: Text(
                    "Invalid Username / Password",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: _isValidating ? () {} : _validateUser,
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Padding(
                    padding: PADDING_8,
                    child: _isValidating
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )
                        : Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildFormField({
    Icon icon,
    String labelText,
    String hintText,
    String initialText,
    TextInputType inputType = TextInputType.text,
    bool obscureText = false,
    onChanged,
  }) {
    return TextField(
      decoration: InputDecoration(
        icon: icon,
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      controller: TextEditingController(text: initialText),
      keyboardType: inputType,
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }

  void _onUsernameChanged(String value) {
    _username = value;
  }

  void _onPasswordChanged(String value) {
    _password = value;
  }

  void _validateUser() {
    setState(() {
      _isValidating = true;
    });

    wp.WordPress wordPress = new wp.WordPress(
      baseUrl: AppConfig.Appurls['baseurl'],  //YOUR WEBSITE URL
      authenticator: wp.WordPressAuthenticator.JWT,
      adminName: '',
      adminKey: '',
    );

    final response =
    wordPress.authenticateUser(username: _username, password: _password);
    print(response);
    response.then((user) {
      setState(() {
        _isDetailValid = true;
        _isValidating = false;

        _onValidUser(wordPress, user);
      });
    }).catchError((err) {
      print(err.toString());
      setState(() {
        _isDetailValid = false;
        _isValidating = false;
      });
    });
  }

  void _onValidUser (wp.WordPress wordPress, wp.User user)  async{
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setString('email', _username);
    //prefs.setString('password', _password);
    this._getUserToken();

    Navigator.pushReplacement(
      context,

      MaterialPageRoute(
        builder: (context) => ProductsListPage(
         // wordPress: wordPress,
         // user: user,
        ),
      ),
    );
  }

  Future<dynamic> _getUserToken() async {
    var urlt = AppConfig.getApiUrl('token') + "?username=$_username&password=$_password"; //Appurls['wpapi'] + AppConfig.Namespaces["token"]
    print(urlt);
    var responseT = await http.post(urlt
    ).catchError(
          (error) {
        return false;
      },
    );
    if(responseT.statusCode == 200){
      //SharedPreferences prefs = await SharedPreferences.getInstance();
      // fill our menus list with results and update state
      //setState(() {
        var tokendata = json.decode(responseT.body);
        addAuthToken(tokendata['token']);
        //prefs.setString('token', tokendata['token']);
        print('--------------token---------${tokendata}');
        //print(prefs.getString('token'));
      //});
    }
  }
}
