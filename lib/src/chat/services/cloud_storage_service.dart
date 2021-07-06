import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import './../../chat/models/message.dart';
import './../../resources/api_provider.dart';
import 'package:path/path.dart';

import 'db_service.dart';

class CloudStorageService {
  static CloudStorageService instance = CloudStorageService();

  FirebaseStorage _storage;
  Reference _baseRef;
  bool notify = false;
  String _messages = "messages";
  String _images = "images";

  CloudStorageService() {
    _storage = FirebaseStorage.instance;
    _baseRef = _storage.ref();
  }

  uploadMediaMessage(String conversationID, String _uid, File _file, [String toId]) {
    var _timestamp = DateTime.now();
    var _fileName = basename(_file.path);
    _fileName += "_${_timestamp.toString()}";
    try {
      return _baseRef
          .child(_messages)
          .child(_uid)
          .child(_images)
          .child(_fileName)
          .putFile(_file).then((value) async {
            var _imageURL = await value.ref.getDownloadURL();

            await DBService.instance.sendMessage(
              conversationID,
              Message(
                  content: _imageURL,
                  senderID: _uid,
                  timestamp: Timestamp.now(),
                  type: MessageType.Image),
            );
            if(toId != null) {
              if(notify) {
                ApiProvider().post('/wp-admin/admin-ajax.php?action=mstore_flutter_new_chat_message', {'message_url': _imageURL, 'vendor_id': toId});
              }
            } else if(notify) {
              ApiProvider().post('/wp-admin/admin-ajax.php?action=mstore_flutter_new_chat_message', {'message_url': _imageURL});
              notify = false;
            }
          });
    } catch (e) {
      print(e);
    }
  }
}
