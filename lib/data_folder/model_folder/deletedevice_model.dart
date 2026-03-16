import 'user_model.dart';

class DeletedeviceModel {
  final String deviceId;
  final String custDomainKey;
  final String custId;
  final String custEmail;

  DeletedeviceModel({
    required this.deviceId,
    required this.custDomainKey,
    required this.custId,
    required this.custEmail,
  });

  factory DeletedeviceModel.fromUser({
    required UserModel user,
    required String deviceId,
  }) {
    return DeletedeviceModel(
      deviceId: deviceId,
      custDomainKey: user.custDomainKey,
      custId: user.custId,
      custEmail: user.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "device_id": deviceId,
      "cust_domainkey": custDomainKey,
      "cust_id": custId,
      "cust_email": custEmail,
    };
  }
}