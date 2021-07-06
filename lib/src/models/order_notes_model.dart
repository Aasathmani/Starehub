// To parse this JSON data, do
//
//     final orderNote = orderNoteFromJson(jsonString);

import 'dart:convert';

List<OrderNote> orderNoteFromJson(String str) => List<OrderNote>.from(json.decode(str).map((x) => OrderNote.fromJson(x)));

String orderNoteToJson(List<OrderNote> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderNote {
  OrderNote({
    this.id,
    this.author,
    this.dateCreated,
    this.dateCreatedGmt,
    this.note,
    this.customerNote,
    this.links,
  });

  int id;
  String author;
  DateTime dateCreated;
  DateTime dateCreatedGmt;
  String note;
  bool customerNote;
  Links links;

  factory OrderNote.fromJson(Map<String, dynamic> json) => OrderNote(
    id: json["id"] == null ? null : json["id"],
    author: json["author"] == null ? null : json["author"],
    dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
    dateCreatedGmt: json["date_created_gmt"] == null ? null : DateTime.parse(json["date_created_gmt"]),
    note: json["note"] == null ? null : json["note"],
    customerNote: json["customer_note"] == null ? null : json["customer_note"],
    links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "author": author == null ? null : author,
    "date_created": dateCreated == null ? null : dateCreated.toIso8601String(),
    "date_created_gmt": dateCreatedGmt == null ? null : dateCreatedGmt.toIso8601String(),
    "note": note == null ? null : note,
    "customer_note": customerNote == null ? null : customerNote,
    "_links": links == null ? null : links.toJson(),
  };
}

class Links {
  Links({
    this.self,
    this.collection,
    this.up,
  });

  List<Collection> self;
  List<Collection> collection;
  List<Collection> up;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    self: json["self"] == null ? null : List<Collection>.from(json["self"].map((x) => Collection.fromJson(x))),
    collection: json["collection"] == null ? null : List<Collection>.from(json["collection"].map((x) => Collection.fromJson(x))),
    up: json["up"] == null ? null : List<Collection>.from(json["up"].map((x) => Collection.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "self": self == null ? null : List<dynamic>.from(self.map((x) => x.toJson())),
    "collection": collection == null ? null : List<dynamic>.from(collection.map((x) => x.toJson())),
    "up": up == null ? null : List<dynamic>.from(up.map((x) => x.toJson())),
  };
}

class Collection {
  Collection({
    this.href,
  });

  String href;

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    href: json["href"] == null ? null : json["href"],
  );

  Map<String, dynamic> toJson() => {
    "href": href == null ? null : href,
  };
}
