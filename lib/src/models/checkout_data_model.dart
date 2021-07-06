// To parse this JSON data, do
//
//     final checkoutData = checkoutDataFromJson(jsonString);

import 'dart:convert';

CheckoutFormData checkoutDataFromJson(String str) => CheckoutFormData.fromJson(json.decode(str));

String checkoutDataToJson(CheckoutFormData data) => json.encode(data.toJson());

class CheckoutFormData {
  CheckoutFormData({
    this.fieldgroups,
    this.data,
  });

  Fieldgroups fieldgroups;
  FieldData data;

  factory CheckoutFormData.fromJson(Map<String, dynamic> json) => CheckoutFormData(
    fieldgroups: json["fieldgroups"] == null ? null : Fieldgroups.fromJson(json["fieldgroups"]),
    data: json["data"] == null ? null : FieldData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "fieldgroups": fieldgroups == null ? null : fieldgroups.toJson(),
    "data": data == null ? null : data.toJson(),
  };
}

class FieldData {
  FieldData({
    this.nonce,
    this.checkoutNonce,
    this.wpnonce,
    this.checkoutLogin,
    this.saveAccountDetails,
    this.stripeConfirmPi,
    this.userLogged,
  });

  Nonce nonce;
  String checkoutNonce;
  String wpnonce;
  String checkoutLogin;
  String saveAccountDetails;
  String stripeConfirmPi;
  bool userLogged;

  factory FieldData.fromJson(Map<String, dynamic> json) => FieldData(
    nonce: json["nonce"] == null ? null : Nonce.fromJson(json["nonce"]),
    checkoutNonce: json["checkout_nonce"] == null ? null : json["checkout_nonce"],
    wpnonce: json["_wpnonce"] == null ? null : json["_wpnonce"],
    checkoutLogin: json["checkout_login"] == null ? null : json["checkout_login"],
    saveAccountDetails: json["save_account_details"] == null ? null : json["save_account_details"],
    stripeConfirmPi: json["stripe_confirm_pi"] == null ? null : json["stripe_confirm_pi"],
    userLogged: json["user_logged"] == null ? null : json["user_logged"],
  );

  Map<String, dynamic> toJson() => {
    "nonce": nonce == null ? null : nonce.toJson(),
    "checkout_nonce": checkoutNonce == null ? null : checkoutNonce,
    "_wpnonce": wpnonce == null ? null : wpnonce,
    "checkout_login": checkoutLogin == null ? null : checkoutLogin,
    "save_account_details": saveAccountDetails == null ? null : saveAccountDetails,
    "stripe_confirm_pi": stripeConfirmPi == null ? null : stripeConfirmPi,
    "user_logged": userLogged == null ? null : userLogged,
  };
}

class Nonce {
  Nonce({
    this.ajaxUrl,
    this.wcAjaxUrl,
    this.updateOrderReviewNonce,
    this.applyCouponNonce,
    this.removeCouponNonce,
    this.optionGuestCheckout,
    this.checkoutUrl,
    this.debugMode,
    this.i18NCheckoutError,
  });

  String ajaxUrl;
  String wcAjaxUrl;
  String updateOrderReviewNonce;
  String applyCouponNonce;
  String removeCouponNonce;
  String optionGuestCheckout;
  String checkoutUrl;
  bool debugMode;
  String i18NCheckoutError;

  factory Nonce.fromJson(Map<String, dynamic> json) => Nonce(
    ajaxUrl: json["ajax_url"] == null ? null : json["ajax_url"],
    wcAjaxUrl: json["wc_ajax_url"] == null ? null : json["wc_ajax_url"],
    updateOrderReviewNonce: json["update_order_review_nonce"] == null ? null : json["update_order_review_nonce"],
    applyCouponNonce: json["apply_coupon_nonce"] == null ? null : json["apply_coupon_nonce"],
    removeCouponNonce: json["remove_coupon_nonce"] == null ? null : json["remove_coupon_nonce"],
    optionGuestCheckout: json["option_guest_checkout"] == null ? null : json["option_guest_checkout"],
    checkoutUrl: json["checkout_url"] == null ? null : json["checkout_url"],
    debugMode: json["debug_mode"] == null ? null : json["debug_mode"],
    i18NCheckoutError: json["i18n_checkout_error"] == null ? null : json["i18n_checkout_error"],
  );

  Map<String, dynamic> toJson() => {
    "ajax_url": ajaxUrl == null ? null : ajaxUrl,
    "wc_ajax_url": wcAjaxUrl == null ? null : wcAjaxUrl,
    "update_order_review_nonce": updateOrderReviewNonce == null ? null : updateOrderReviewNonce,
    "apply_coupon_nonce": applyCouponNonce == null ? null : applyCouponNonce,
    "remove_coupon_nonce": removeCouponNonce == null ? null : removeCouponNonce,
    "option_guest_checkout": optionGuestCheckout == null ? null : optionGuestCheckout,
    "checkout_url": checkoutUrl == null ? null : checkoutUrl,
    "debug_mode": debugMode == null ? null : debugMode,
    "i18n_checkout_error": i18NCheckoutError == null ? null : i18NCheckoutError,
  };
}

class Fieldgroups {
  Fieldgroups({
    this.billing,
    this.shipping,
    this.order,
  });

  List<Ing> billing;
  List<Ing> shipping;
  List<OrderField> order;

  factory Fieldgroups.fromJson(Map<String, dynamic> json) => Fieldgroups(
    billing: json["billing"] == null ? null : List<Ing>.from(json["billing"].map((x) => Ing.fromJson(x))),
    shipping: json["shipping"] == null ? null : List<Ing>.from(json["shipping"].map((x) => Ing.fromJson(x))),
    order: json["order"] == null ? null : List<OrderField>.from(json["order"].map((x) => OrderField.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "billing": billing == null ? null : List<dynamic>.from(billing.map((x) => x.toJson())),
    "shipping": shipping == null ? null : List<dynamic>.from(shipping.map((x) => x.toJson())),
    "order": order == null ? null : List<dynamic>.from(order.map((x) => x.toJson())),
  };
}

class Ing {
  Ing({
    this.label,
    this.required,
    this.ingClass,
    this.autocomplete,
    this.priority,
    this.value,
    this.key,
    this.type,
    this.dotappOptions,
    this.placeholder,
    this.labelClass,
    this.validate,
    this.countryField,
    this.country,
    this.clear,
  });

  String label;
  bool required;
  List<Class> ingClass;
  String autocomplete;
  int priority;
  String value;
  String key;
  String type;
  List<DotappOption> dotappOptions;
  String placeholder;
  List<String> labelClass;
  List<String> validate;
  String countryField;
  String country;
  bool clear;

  factory Ing.fromJson(Map<String, dynamic> json) => Ing(
    label: json["label"] == null ? null : json["label"],
    required: json["required"] == null ? null : json["required"],
    //ingClass: json["class"] == null ? null : List<Class>.from(json["class"].map((x) => classValues.map[x])),
    autocomplete: json["autocomplete"] == null ? null : json["autocomplete"],
    priority: json["priority"] == null ? null : json["priority"],
    value: json["value"] == null ? null : json["value"],
    key: json["key"] == null ? null : json["key"],
    type: json["type"] == null ? null : json["type"],
    dotappOptions: json["dotapp_options"] == null ? null : List<DotappOption>.from(json["dotapp_options"].map((x) => DotappOption.fromJson(x))),
    placeholder: json["placeholder"] == null ? null : json["placeholder"],
    labelClass: json["label_class"] == null ? null : List<String>.from(json["label_class"].map((x) => x)),
    validate: json["validate"] == null ? null : List<String>.from(json["validate"].map((x) => x)),
    countryField: json["country_field"] == null ? null : json["country_field"],
    country: json["country"] == null ? null : json["country"],
    clear: json["clear"] == null ? null : json["clear"],
  );

  Map<String, dynamic> toJson() => {
    "label": label == null ? null : label,
    "required": required == null ? null : required,
    "class": ingClass == null ? null : List<dynamic>.from(ingClass.map((x) => classValues.reverse[x])),
    "autocomplete": autocomplete == null ? null : autocomplete,
    "priority": priority == null ? null : priority,
    "value": value == null ? null : value,
    "key": key == null ? null : key,
    "type": type == null ? null : type,
    "dotapp_options": dotappOptions == null ? null : List<dynamic>.from(dotappOptions.map((x) => x.toJson())),
    "placeholder": placeholder == null ? null : placeholder,
    "label_class": labelClass == null ? null : List<dynamic>.from(labelClass.map((x) => x)),
    "validate": validate == null ? null : List<dynamic>.from(validate.map((x) => x)),
    "country_field": countryField == null ? null : countryField,
    "country": country == null ? null : country,
    "clear": clear == null ? null : clear,
  };
}

class DotappOption {
  DotappOption({
    this.label,
    this.value,
    this.regions,
  });

  String label;
  String value;
  List<Region> regions;

  factory DotappOption.fromJson(Map<String, dynamic> json) => DotappOption(
    label: json["label"] == null ? null : json["label"],
    value: json["value"] == null ? null : json["value"],
    regions: json["regions"] == null ? null : List<Region>.from(json["regions"].map((x) => Region.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "label": label == null ? null : label,
    "value": value == null ? null : value,
    "regions": regions == null ? null : List<dynamic>.from(regions.map((x) => x.toJson())),
  };
}

class Region {
  Region({
    this.label,
    this.value,
  });

  String label;
  String value;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    label: json["label"] == null ? null : json["label"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toJson() => {
    "label": label == null ? null : label,
    "value": value == null ? null : value,
  };
}

enum Class { FORM_ROW_FIRST, FORM_ROW_LAST, FORM_ROW_WIDE, ADDRESS_FIELD, UPDATE_TOTALS_ON_CHANGE, WCFM_CUSTOM_HIDE }

final classValues = EnumValues({
  "address-field": Class.ADDRESS_FIELD,
  "form-row-first": Class.FORM_ROW_FIRST,
  "form-row-last": Class.FORM_ROW_LAST,
  "form-row-wide": Class.FORM_ROW_WIDE,
  "update_totals_on_change": Class.UPDATE_TOTALS_ON_CHANGE,
  "wcfm_custom_hide": Class.WCFM_CUSTOM_HIDE
});

class OrderField {
  OrderField({
    this.type,
    this.orderClass,
    this.label,
    this.placeholder,
    this.value,
    this.key,
  });

  String type;
  List<String> orderClass;
  String label;
  String placeholder;
  dynamic value;
  String key;

  factory OrderField.fromJson(Map<String, dynamic> json) => OrderField(
    type: json["type"] == null ? null : json["type"],
    orderClass: json["class"] == null ? null : List<String>.from(json["class"].map((x) => x)),
    label: json["label"] == null ? null : json["label"],
    placeholder: json["placeholder"] == null ? null : json["placeholder"],
    value: json["value"],
    key: json["key"] == null ? null : json["key"],
  );

  Map<String, dynamic> toJson() => {
    "type": type == null ? null : type,
    "class": orderClass == null ? null : List<dynamic>.from(orderClass.map((x) => x)),
    "label": label == null ? null : label,
    "placeholder": placeholder == null ? null : placeholder,
    "value": value,
    "key": key == null ? null : key,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
