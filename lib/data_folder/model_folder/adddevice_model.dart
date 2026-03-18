import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';

class AddDeviceModel {
  final bool callStatus;
  final String? message;

  AddDeviceModel({required this.callStatus, this.message});

  factory AddDeviceModel.fromJson(Map<String, dynamic> json) {
    return AddDeviceModel(
      callStatus: json["call_status"] ?? false,
      message: json["message"]?.toString(), // convert to string if present
    );
  }
}

class Message {
  final AddDeviceRequestModel? device;

  Message({this.device});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      device: json["device"] != null
          ? AddDeviceRequestModel.fromJson(json["device"])
          : null,
    );
  }
}

class AddDeviceRequestModel {
  final String deviceId;
  final String custDomainKey;
  final String custId;
  final String custEmail;
  final String? message;
  final String? lastUpdatedTs;
  final String? createdTs;

  AddDeviceRequestModel({
    required this.deviceId,
    required this.custDomainKey,
    required this.custId,
    required this.custEmail,
    this.message,
    this.lastUpdatedTs,
    this.createdTs,
  });

  // Build request model using UserModel + deviceId
  factory AddDeviceRequestModel.fromUser({
    required UserModel user,
    required String deviceId,
  }) {
    return AddDeviceRequestModel(
      deviceId: deviceId,
      custEmail: user.email,
      custId: user.custId,
      custDomainKey: user.custDomainKey,
    );
  }

  factory AddDeviceRequestModel.fromJson(Map<String, dynamic> json) {
    return AddDeviceRequestModel(
      deviceId: json['device_id'] ?? '',
      custDomainKey: json['cust_domainkey'] ?? '',
      custId: json['cust_id'] ?? '',
      custEmail: json['cust_email'] ?? '',
      message: json['message'],
      lastUpdatedTs: json['last_updated_ts']?.toString(),
      createdTs: json['created_ts']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "device_id": deviceId,
      "cust_email": custEmail,
      "cust_id": custId,
      "cust_domainkey": custDomainKey,
      if (message != null) "message": message,
      if (lastUpdatedTs != null) "last_updated_ts": lastUpdatedTs,
      if (createdTs != null) "created_ts": createdTs,
    };
  }
}
