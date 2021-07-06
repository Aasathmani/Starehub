// To parse this JSON data, do
//
//     final paymentVerificationResponse = paymentVerificationResponseFromJson(jsonString);

import 'dart:convert';

PaymentVerificationResponse paymentVerificationResponseFromJson(String str) => PaymentVerificationResponse.fromJson(json.decode(str));

String paymentVerificationResponseToJson(PaymentVerificationResponse data) => json.encode(data.toJson());

class PaymentVerificationResponse {
  PaymentVerificationResponse({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  Data data;

  factory PaymentVerificationResponse.fromJson(Map<String, dynamic> json) => PaymentVerificationResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    //data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.domain,
    this.status,
    this.reference,
    this.amount,
    this.message,
    this.gatewayResponse,
    this.dataPaidAt,
    this.dataCreatedAt,
    this.channel,
    this.currency,
    this.ipAddress,
    this.metadata,
    this.log,
    this.fees,
    this.feesSplit,
    this.authorization,
    this.customer,
    this.plan,
    this.split,
    this.orderId,
    this.paidAt,
    this.createdAt,
    this.requestedAmount,
    this.posTransactionData,
    this.transactionDate,
    this.planObject,
    this.subaccount,
  });

  int id;
  String domain;
  String status;
  String reference;
  int amount;
  dynamic message;
  String gatewayResponse;
  DateTime dataPaidAt;
  DateTime dataCreatedAt;
  String channel;
  String currency;
  dynamic ipAddress;
  int metadata;
  dynamic log;
  int fees;
  dynamic feesSplit;
  Authorization authorization;
  Customer customer;
  dynamic plan;
  PlanObject split;
  dynamic orderId;
  DateTime paidAt;
  DateTime createdAt;
  dynamic requestedAmount;
  dynamic posTransactionData;
  DateTime transactionDate;
  PlanObject planObject;
  PlanObject subaccount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    domain: json["domain"] == null ? null : json["domain"],
    status: json["status"] == null ? null : json["status"],
    reference: json["reference"] == null ? null : json["reference"],
    amount: json["amount"] == null ? null : json["amount"],
    message: json["message"],
    gatewayResponse: json["gateway_response"] == null ? null : json["gateway_response"],
    dataPaidAt: json["paid_at"] == null ? null : DateTime.parse(json["paid_at"]),
    dataCreatedAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    channel: json["channel"] == null ? null : json["channel"],
    currency: json["currency"] == null ? null : json["currency"],
    ipAddress: json["ip_address"],
    metadata: json["metadata"] == null ? null : json["metadata"],
    log: json["log"],
    fees: json["fees"] == null ? null : json["fees"],
    feesSplit: json["fees_split"],
    authorization: json["authorization"] == null ? null : Authorization.fromJson(json["authorization"]),
    customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
    plan: json["plan"],
    split: json["split"] == null ? null : PlanObject.fromJson(json["split"]),
    orderId: json["order_id"],
    paidAt: json["paidAt"] == null ? null : DateTime.parse(json["paidAt"]),
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    requestedAmount: json["requested_amount"],
    posTransactionData: json["pos_transaction_data"],
    transactionDate: json["transaction_date"] == null ? null : DateTime.parse(json["transaction_date"]),
    planObject: json["plan_object"] == null ? null : PlanObject.fromJson(json["plan_object"]),
    subaccount: json["subaccount"] == null ? null : PlanObject.fromJson(json["subaccount"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "domain": domain == null ? null : domain,
    "status": status == null ? null : status,
    "reference": reference == null ? null : reference,
    "amount": amount == null ? null : amount,
    "message": message,
    "gateway_response": gatewayResponse == null ? null : gatewayResponse,
    "paid_at": dataPaidAt == null ? null : dataPaidAt.toIso8601String(),
    "created_at": dataCreatedAt == null ? null : dataCreatedAt.toIso8601String(),
    "channel": channel == null ? null : channel,
    "currency": currency == null ? null : currency,
    "ip_address": ipAddress,
    "metadata": metadata == null ? null : metadata,
    "log": log,
    "fees": fees == null ? null : fees,
    "fees_split": feesSplit,
    "authorization": authorization == null ? null : authorization.toJson(),
    "customer": customer == null ? null : customer.toJson(),
    "plan": plan,
    "split": split == null ? null : split.toJson(),
    "order_id": orderId,
    "paidAt": paidAt == null ? null : paidAt.toIso8601String(),
    "createdAt": createdAt == null ? null : createdAt.toIso8601String(),
    "requested_amount": requestedAmount,
    "pos_transaction_data": posTransactionData,
    "transaction_date": transactionDate == null ? null : transactionDate.toIso8601String(),
    "plan_object": planObject == null ? null : planObject.toJson(),
    "subaccount": subaccount == null ? null : subaccount.toJson(),
  };
}

class Authorization {
  Authorization({
    this.authorizationCode,
    this.bin,
    this.last4,
    this.expMonth,
    this.expYear,
    this.channel,
    this.cardType,
    this.bank,
    this.countryCode,
    this.brand,
    this.reusable,
    this.signature,
    this.accountName,
  });

  String authorizationCode;
  String bin;
  String last4;
  String expMonth;
  String expYear;
  String channel;
  String cardType;
  String bank;
  String countryCode;
  String brand;
  bool reusable;
  String signature;
  dynamic accountName;

  factory Authorization.fromJson(Map<String, dynamic> json) => Authorization(
    authorizationCode: json["authorization_code"] == null ? null : json["authorization_code"],
    bin: json["bin"] == null ? null : json["bin"],
    last4: json["last4"] == null ? null : json["last4"],
    expMonth: json["exp_month"] == null ? null : json["exp_month"],
    expYear: json["exp_year"] == null ? null : json["exp_year"],
    channel: json["channel"] == null ? null : json["channel"],
    cardType: json["card_type"] == null ? null : json["card_type"],
    bank: json["bank"] == null ? null : json["bank"],
    countryCode: json["country_code"] == null ? null : json["country_code"],
    brand: json["brand"] == null ? null : json["brand"],
    reusable: json["reusable"] == null ? null : json["reusable"],
    signature: json["signature"] == null ? null : json["signature"],
    accountName: json["account_name"],
  );

  Map<String, dynamic> toJson() => {
    "authorization_code": authorizationCode == null ? null : authorizationCode,
    "bin": bin == null ? null : bin,
    "last4": last4 == null ? null : last4,
    "exp_month": expMonth == null ? null : expMonth,
    "exp_year": expYear == null ? null : expYear,
    "channel": channel == null ? null : channel,
    "card_type": cardType == null ? null : cardType,
    "bank": bank == null ? null : bank,
    "country_code": countryCode == null ? null : countryCode,
    "brand": brand == null ? null : brand,
    "reusable": reusable == null ? null : reusable,
    "signature": signature == null ? null : signature,
    "account_name": accountName,
  };
}

class Customer {
  Customer({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.customerCode,
    this.phone,
    this.metadata,
    this.riskAction,
    this.internationalFormatPhone,
  });

  int id;
  dynamic firstName;
  dynamic lastName;
  String email;
  String customerCode;
  dynamic phone;
  dynamic metadata;
  String riskAction;
  dynamic internationalFormatPhone;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"] == null ? null : json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"] == null ? null : json["email"],
    customerCode: json["customer_code"] == null ? null : json["customer_code"],
    phone: json["phone"],
    metadata: json["metadata"],
    riskAction: json["risk_action"] == null ? null : json["risk_action"],
    internationalFormatPhone: json["international_format_phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email == null ? null : email,
    "customer_code": customerCode == null ? null : customerCode,
    "phone": phone,
    "metadata": metadata,
    "risk_action": riskAction == null ? null : riskAction,
    "international_format_phone": internationalFormatPhone,
  };
}

class PlanObject {
  PlanObject();

  factory PlanObject.fromJson(Map<String, dynamic> json) => PlanObject(
  );

  Map<String, dynamic> toJson() => {
  };
}
