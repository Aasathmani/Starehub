import 'dart:ui';

import 'package:app/src/ui/home/home.dart';
import 'package:app/src/ui/home/home2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show Encoding, json;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Form Demo',
      theme: new ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: new AppointmentForm(),
    );
  }
}

class AppointmentForm extends StatefulWidget {
  @override
  AppointmentFormState createState() => new AppointmentFormState();
}

class AppointmentFormState extends State<AppointmentForm> {

  var email='';
  var fname='', lname='', mobile='';
  var validate = true;
  var chosenCategory='', chosenService='', dateTime='', notes='';
  bool _termsChecked = false;
  int radioValue = -1;
  bool _autoValidate = false;
  DateTime pickedDate = DateTime.now();
  TimeOfDay pickedTime = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();

/*@override
  void initState(){
    super.initState();
    pickedDate=DateTime.now();
    time=TimeOfDay.now();
  }*/
  void initState() {
    _getserviceList();
    _getcategoryList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(

        title: new Text("Book Appointment",style:TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: new SingleChildScrollView(
        child: new Container(
            margin: const EdgeInsets.all(20.0),
            child: new Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: new Column(
                  children: <Widget>[
                    new SizedBox(
                      height: 20.0,
                    ),
                    new TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 15),
                          ),
                          labelText: 'First Name'),
                      onSaved: (value) {
                        fname = value;
                        print(fname);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    new SizedBox(
                      height: 20.0,
                    ),
                    new TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 10),
                          ),
                          labelText: 'Last Name'),
                      onSaved: (value) {
                        lname = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    new SizedBox(
                      height: 20.0,
                    ),
                    new TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 10),
                          ),
                          labelText: 'Mobile Number'),
                      onSaved: (value) {
                        mobile = value;
                      },
                      validator: (value) {
                        String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regExp = new RegExp(pattern);
                        if (value == null || value.isEmpty) {
                          return "Required";
                        } else if (!regExp.hasMatch(value)) {
                          return 'Please enter valid mobile number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    new SizedBox(
                      height: 20.0,
                    ),
                    new TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 10),
                          ),
                          labelText: 'Email'),
                      onSaved: (value) {
                        email = value;
                      },
                      validator: (value) {
                        String pattern =
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                        RegExp regExp = new RegExp(pattern);
                        if (value == null || value.isEmpty) {
                          return "Required";
                        } else if (!regExp.hasMatch(value)) {
                          return 'Please enter valid Email address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    new SizedBox(
                      height: 20.0,
                    ),
                    new DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 10),
                          ),
                        ),
                        isExpanded: true,
                        value: _mycategory,
                        //elevation: 5,
                        style: TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == "Select Category") {
                            return "Required";
                          }
                          return null;
                        },

                        items: categoryList?.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['name'].toString(),
                                child: Text(item['name'] ?? "Select Category"),
                              );
                            })?.toList() ??
                            [],
                        hint: Text(
                          "Select Category",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _mycategory = value;
                            //_getcategoryList();
                            print(_mycategory);
                          });
                        }),
                    new SizedBox(
                      height: 20.0,
                    ),
                    new DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 10),
                          ),
                        ),
                        isExpanded: true,
                        value: _myservice,
                        //elevation: 5,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == "Select Services") {
                            return "Required";
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.black),
                        items: serviceList?.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['title'].toString(),
                                child: Text(item['title'] ?? "Select Services"),
                              );
                            })?.toList() ??
                            [],
                        hint: Text(
                          "Select Services",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _myservice = value;
                            print(_myservice);
                          });
                        }),
                    new SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                        onTap: () {
                          _pickDate(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(05)),
                          ),
                          child: ListTile(
                            title: Text(
                                "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}"),
                            leading: Text("Date:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            trailing: Icon(Icons.calendar_today_outlined),
                          ),
                        )),
                    new SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        _pickTime(context);
                      }, //
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(05)),
                        ),
                        child: ListTile(
                          title:
                              Text("${pickedTime.hour}:${pickedTime.minute}"),
                          leading: Text("Time:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          trailing: Icon(Icons.alarm_outlined),
                        ),
                      ),
                    ),
                    new SizedBox(
                      height: 20.0,
                    ),
                    new TextFormField(
                      maxLines: null,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 10),
                          ),
                          labelText: 'Notes'),
                      onSaved: (value) {
                        notes = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                    ),
                    new SizedBox(
                      height: 20.0,
                    ),
                    new ButtonTheme(
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      height:50,
                      minWidth: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.deepOrange,
                        onPressed: () {

                          dateTimeFormatter(pickedDate, pickedTime);
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();



                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Processing Data')));
                            _insertappointment();

                          }

                        },
                        child: new Text('Submit',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }

  _pickDate(BuildContext context) async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: pickedDate,
    );
    if (date != null)
      setState(() {
        pickedDate = date;
      });
  }

  _pickTime(BuildContext context) async {
    TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: pickedTime,
    );
    if (time != null)
      setState(() {
        pickedTime = time;
      });
  }

  dateTimeFormatter(pickeddate, pickedtime) {
    dateTime = pickeddate.year.toString() +
        "-" +
        pickeddate.month.toString() +
        "-" +
        pickeddate.day.toString() +
        " " +
        pickedtime.hour.toString() +
        ":" +
        pickedtime.minute.toString() +
        ":00";
    print(dateTime);
  }

  List serviceList;
  String _myservice;

  String serviceUrl = 'https://starehub.com/android_api/FetchServices.php';

  Future<String> _getserviceList() async {
    await http.post(Uri.parse(serviceUrl), headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }, body: {
      "key": '621c64f8fdaa244a217b2e8984cdeea36f311412',
    }).then((response) {
      var data = json.decode(response.body);

//      print(data);
      setState(() {
        serviceList = data;
      });
    });
  }

  List categoryList;
  String _mycategory;

  String categoryUrl = 'https://starehub.com/android_api/FetchCategory.php';

  Future<String> _getcategoryList() async {
    await http.post(Uri.parse(categoryUrl), headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }, body: {
      "key": '621c64f8fdaa244a217b2e8984cdeea36f311412',
    }).then((response) {
      var data = json.decode(response.body);

      setState(() {
        categoryList = data;
      });
    });
  }

  String appointUrl = 'https://starehub.com/android_api/InsertAppointment.php';
 var datareturned;
  Future<String> _insertappointment() async {
    Map data = {
      "key": '621c64f8fdaa244a217b2e8984cdeea36f311412',
      "service_name": _myservice,
      "date_time": dateTime,
      "first_name": fname,
      "last_name": lname,
      "phone": mobile,
      "email": email,
      "notes": notes,
    };
    await http.post(Uri.parse(appointUrl),
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body:
            data,
       //encoding: Encoding.getByName("utf8"),
    )


        .then((response) {
     var  data = json.decode(response.body);
      print(data);
      datareturned=data[0]['result'];
      print(datareturned);
     if(datareturned=="success"){
       showAlertDialog( context);
     }

    });
  }
  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        _formKey.currentState.reset();
        Navigator.pop(context);


      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Booking Successful!"),
      content: Text("Your appointment booked successfully!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
