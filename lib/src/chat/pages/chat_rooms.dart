import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/app_state_model.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../services/db_service.dart';
import 'chat_page.dart';

class ChatRoomList extends StatefulWidget {
  final String id;
  const ChatRoomList({Key key, this.id}) : super(key: key);
  @override
  _ChatRoomListState createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {

  double _height;
  double _width;
  final appStateModel = AppStateModel();
  String error;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.2,
        title: Text(appStateModel.blocks.localeText.chat),
      ),
      body: Container(
        height: _height,
        width: _width,
        child: _conversationsListViewWidget(),
      ),
    );
  }

  Widget _conversationsListViewWidget() {
    return StreamBuilder<List<Conversation>>(
      stream: DBService.instance.getConversations(widget.id, _showDialogeOnError),
      builder: (context, snapshot) {
        var _data = snapshot.data;
        if (_data != null) {
          return _data.length != 0
              ? ListView.builder(
            itemCount: _data.length,
            itemBuilder: (_context, _index) {
              print(_data[_index].userAvatar);
              print(_data[_index].vendorAvatar);
              return Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ChatPage(chatId: _data[_index].chatId, vendorId: _data[_index].vendorId, vendorName: _data[_index].vendorName, vendorAvatar: _data[_index].vendorAvatar
                        );
                      }));
                    },
                    title: appStateModel.user.id.toString() == _data[_index].userId ? Text(_data[_index].vendorName) : Text(_data[_index].userName),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                              _data[_index].messages.last.type == MessageType.Text
                                  ? _data[_index].messages.last.content
                                  : "Attachment: Image", maxLines: 2,),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            timeago.format(_data[_index].messages.last.timestamp.toDate()),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    leading: appStateModel.user.id.toString() == _data[_index].userId ? CircleAvatar(radius: 30.0, foregroundImage: NetworkImage(appStateModel.user.avatarUrl)) : CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      child: Container(
                        width: 80,
                        decoration:  BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end:
                              Alignment(0.8, 0.0),
                              colors:  <Color>[
                                Colors.pink,
                                Colors.pinkAccent.withOpacity(.7)
                              ],
                            )
                        ),
                        child: Center(
                          child: Text(
                            _data[_index].vendorName[0],
                            style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Rubik'
                            ),
                          ),
                        ),
                      ),
                    ),/*Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: appStateModel.user.id.toString() == _data[_index].userId ? CircleAvatar(child: Text('A')) : NetworkImage(_data[_index].userAvatar),
                        ),
                      ),
                    ),*/
                  ),
                  Divider()
                ],
              );
            },
          )
              : Align(
            child: Text(
              appStateModel.blocks.localeText.noConversationsYet,
              style: TextStyle(fontSize: 15.0),
            ),
          );
        } else if(error != null) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: SelectableText(error)),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }

  _showDialogeOnError(FirebaseException e) {
    setState(() {
      error = e.message;
    });
  }
}
