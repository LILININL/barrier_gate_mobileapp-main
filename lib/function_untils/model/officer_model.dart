import 'dart:convert';
import 'package:barrier_gate/ehp_end_point_library/ehp_endpoint/ehp_api.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Officer extends EHPData {
  int? officer_id;
  String? officer_name;
  String? officer_group_list_text;
  String? officer_login_name;
  String? officer_login_password_md5;
  String? officer_login_password;
  String? officer_pname;
  String? officer_fname;
  String? officer_lname;
  String? officer_phone;
  String? officer_mobile;
  String? officer_email;
  String? officer_active;
  String? officer_cid;
  String? officer_cid_hash256;
  String? is_admin;
  String? is_admin_bgs;
  int? villageproject_id;
  String? is_legal_entity;
  String? is_security_guard;
  String? is_resident;
  String? sync_data;
  String? token_phone;
  static Officer newInstance() {
    return Officer(
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null);
  }

  Officer(
      this.officer_id,
      this.officer_name,
      this.officer_group_list_text,
      this.officer_login_name,
      this.officer_login_password_md5,
      this.officer_login_password,
      this.officer_pname,
      this.officer_fname,
      this.officer_lname,
      this.officer_phone,
      this.officer_mobile,
      this.officer_email,
      this.officer_active,
      this.officer_cid,
      this.officer_cid_hash256,
      this.is_admin,
      this.is_admin_bgs,
      this.villageproject_id,
      this.is_legal_entity,
      this.is_security_guard,
      this.is_resident,
      this.sync_data,
      this.token_phone);
  @override
  Officer fromJson(Map<String, dynamic> json) {
    return Officer(
      json['officer_id'],
      json['officer_name']?.toString(),
      json['officer_group_list_text']?.toString(),
      json['officer_login_name']?.toString(),
      json['officer_login_password_md5']?.toString(),
      json['officer_login_password']?.toString(),
      json['officer_pname']?.toString(),
      json['officer_fname']?.toString(),
      json['officer_lname']?.toString(),
      json['officer_phone']?.toString(),
      json['officer_mobile']?.toString(),
      json['officer_email']?.toString(),
      json['officer_active']?.toString(),
      json['officer_cid']?.toString(),
      json['officer_cid_hash256']?.toString(),
      json['is_admin']?.toString(),
      json['is_admin_bgs']?.toString(),
      json['villageproject_id'],
      json['is_legal_entity']?.toString(),
      json['is_security_guard']?.toString(),
      json['is_resident']?.toString(),
      json['sync_data']?.toString(),
      json['token_phone']?.toString(),
    );
  }

  @override
  EHPData getInstance() {
    return Officer.newInstance();
  }

  @override
  Map<String, dynamic> toJson() => {
        'officer_id': officer_id,
        'officer_name': officer_name,
        'officer_group_list_text': officer_group_list_text,
        'officer_login_name': officer_login_name,
        'officer_login_password_md5': officer_login_password_md5,
        'officer_login_password': officer_login_password,
        'officer_pname': officer_pname,
        'officer_fname': officer_fname,
        'officer_lname': officer_lname,
        'officer_phone': officer_phone,
        'officer_mobile': officer_mobile,
        'officer_email': officer_email,
        'officer_active': officer_active,
        'officer_cid': officer_cid,
        'officer_cid_hash256': officer_cid_hash256,
        'is_admin': is_admin,
        'is_admin_bgs': is_admin_bgs,
        'villageproject_id': villageproject_id,
        'is_legal_entity': is_legal_entity,
        'is_security_guard': is_security_guard,
        'is_resident': is_resident,
        'sync_data': sync_data,
        'token_phone': token_phone
      };
  @override
  String getTableName() {
    return 'officer';
  }

  @override
  String getKeyFieldName() {
    return 'officer_id';
  }

  @override
  String getKeyFieldValue() {
    return officer_id.toString();
  }

  @override
  String getDefaultRestURIParam() {
    return '\$gendartclass=1';
  }

  @override
  List<String> getFieldNameForUpdate() {
    return [
      "officer_id",
      "officer_name",
      "officer_group_list_text",
      "officer_login_name",
      "officer_login_password_md5",
      "officer_login_password",
      "officer_pname",
      "officer_fname",
      "officer_lname",
      "officer_phone",
      "officer_mobile",
      "officer_email",
      "officer_active",
      "officer_cid",
      "officer_cid_hash256",
      "is_admin",
      "is_admin_bgs",
      "villageproject_id",
      "is_legal_entity",
      "is_security_guard",
      "is_resident",
      "sync_data",
      "token_phone"
    ];
  }

  @override
  List<int> getFieldTypeForUpdate() {
    return [
      2,
      6,
      6,
      6,
      6,
      6,
      6,
      6,
      6,
      6,
      6,
      6,
      6,
      6,
      6,
      6,
      6,
      2,
      6,
      6,
      6,
      6,
      6
    ];
  }
}
