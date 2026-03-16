import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zedbee_bms/data_folder/model_folder/adddevice_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/building_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/deletedevice_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/devicelist_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/equipment_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/floor_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/roomlist_model.dart';
import 'package:zedbee_bms/data_folder/model_folder/user_model.dart';
import 'package:zedbee_bms/data_folder/request_model/buildings_request.dart';
import 'package:zedbee_bms/data_folder/request_model/devicelist_request.dart';
import 'package:zedbee_bms/data_folder/request_model/equipment_request.dart';
import 'package:zedbee_bms/data_folder/request_model/floor_request.dart';
import 'package:zedbee_bms/utils/local_storage.dart';

class AuthService {
  static const String baseUrl =
      'https://zedbee.io/api/micro/service/call/post/BZHEZISEWY/mobile';
  // Default Headers
  final Map<String, String> _defaultHeaders = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "key": "dabf7de1-7ab9-4f00-90a8-298c45839015",
  };

  // Login API response
  Future<UserModel> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: _defaultHeaders,
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.body.isEmpty) {
      throw Exception("Invalid email or password");
    }

    final data = jsonDecode(response.body);

    // print(data);

    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? "Invalid email or password");
    }

    final user = UserModel.fromJson(data);

    if (user.login != true) {
      throw Exception("Invalid email or password");
    }

    await LocalStorage.saveDomainKey(user.custDomainKey);
    return user;
  }

  // Building API Request .....
  Future<List<BuildingModel>> fetchBuildings() async {
    try {
      final custKey = await LocalStorage.getDomainKey();
      if (custKey == null || custKey.isEmpty) {
        throw Exception('Customer domain key missing. Please login.');
      }

      final url = Uri.parse('$baseUrl/buildingList');
      final headers = Map<String, String>.from(_defaultHeaders)
        ..addAll({"custDomainKey": custKey});
      final body = BuildingsRequest.build(custKey);
      final response = await http.post(url, headers: headers, body: body);
      if (response.body.isEmpty) {
        throw Exception('Empty response');
      }

      final decoded = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(decoded['message'] ?? 'No buildings Found');
      }

      final hits = decoded['result']?['hits']?['hits'] as List<dynamic>?;

      if (hits == null) return [];

      // Extract area & group names
      final Set<String> areaNames = {};
      final Set<String> groupNames = {};

      final buildings = hits.map((e) {
        final source = e['_source'] as Map<String, dynamic>;

        if (source['area_name'] != null) {
          areaNames.add(source['area_name'].toString());
        }

        if (source['group_name'] != null) {
          groupNames.add(source['group_name'].toString());
        }

        return BuildingModel.fromJson(source, custKey);
      }).toList();

      return buildings;
    } catch (e) {
      throw Exception("No Building Found: $e");
    }
  }

  // Floor List API response
  Future<List<FloorModel>> fetchFloors() async {
    try {
      // Get customer domain key
      final custKey = await LocalStorage.getDomainKey();
      if (custKey == null || custKey.isEmpty) {
        throw Exception('Customer domain key missing. Please login.');
      }

      final url = Uri.parse('$baseUrl/floorList');

      // Default header + customer domain key
      final headers = Map<String, String>.from(_defaultHeaders)
        ..addAll({"custDomainKey": custKey});

      // Request body for Floor List
      final body = FloorRequest.build(custKey);

      final response = await http.post(url, headers: headers, body: body);

      if (response.body.isEmpty) {
        throw Exception('Empty response from server');
      }

      final decoded = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(decoded['message'] ?? 'Floors Not Found');
      }

      final hits = decoded['result']?['hits']?['hits'] as List<dynamic>?;

      if (hits == null) return [];

      return hits.map((e) {
        final source = e['_source'] as Map<String, dynamic>;
        return FloorModel.fromJson(source, custKey);
      }).toList();
    } catch (e) {
      throw Exception("Floors Not Found: $e");
    }
  }

  // Room list API response .....
  Future<List<RoomModel>> fetchRooms() async {
    try {
      final custKey = await LocalStorage.getDomainKey();
      final floorId = await LocalStorage.getFloorId();
      if (custKey == null || custKey.isEmpty) {
        throw Exception('Customer domain key missing. Please login.');
      }

      final url = Uri.parse('$baseUrl/roomList');

      final headers = Map<String, String>.from(_defaultHeaders)
        ..addAll({"custDomainKey": custKey});

      final body = jsonEncode({
        "query": {
          "_source": [
            "area_name",
            "building_id",
            "building_name",
            "room_id",
            "floor_name",
            "group_name",
            "room_name",
            "floor_id",
          ],
          "query": {
            "bool": {
              "must": [
                {
                  "match": {"is_active": true},
                },
                {
                  "match": {"floor_id": floorId},
                },
              ],
              "should": [],
            },
          },
          "sort": [
            {
              "last_updated_ts": {"order": "desc"},
            },
          ],
          "size": 1000,
          "from": 0,
        },
        "domainKey": custKey,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.body.isEmpty) {
        throw Exception('Empty response from server');
      }

      final decoded = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(decoded['message'] ?? 'Rooms Not Found');
      }

      final hits = decoded['result']?['hits']?['hits'] as List<dynamic>?;

      if (hits == null) return [];

      return hits
          .map((e) {
            final source = e['_source'] as Map<String, dynamic>?; // safe cast
            if (source == null) return null; // skip invalid entries
            return RoomModel.fromJson(source);
          })
          .whereType<RoomModel>()
          .toList(); // remove nulls
    } catch (e) {
      throw Exception("Rooms Not Found: $e");
    }
  }

  // Equipment API
  Future<List<EquipmentModel>> fetchEquipments() async {
    try {
      final custKey = await LocalStorage.getDomainKey();
      if (custKey == null || custKey.isEmpty) {
        throw Exception("Customer domain key missing. Please login.");
      }

      final url = Uri.parse('$baseUrl/equipmentList');

      final headers = Map<String, String>.from(_defaultHeaders)
        ..addAll({"custDomainKey": custKey});

      // PASS INTO REQUEST
      final body = EquipmentRequest.build(custKey);

      final response = await http.post(url, headers: headers, body: body);

      if (response.body.isEmpty) {
        throw Exception("Empty response");
      }

      final decoded = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(decoded["message"] ?? "Equipment Not Found");
      }

      final hits = decoded['result']?['hits']?['hits'] as List<dynamic>?;

      if (hits == null) return [];

      return hits
          .map(
            (e) =>
                EquipmentModel.fromJson(e['_source'] as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception("Equipment Not Found: $e");
    }
  }

  // add devie api
  Future<AddDeviceModel> addDevice(AddDeviceRequestModel request) async {
    try {
      //  Fetch domain key stored during login
      final custKey = await LocalStorage.getDomainKey();
      if (custKey == null || custKey.isEmpty) {
        throw Exception("Customer domain key missing. Please login.");
      }

      // API URL
      final url = Uri.parse('$baseUrl/addDevice');

      // Headers (include custDomainKey)
      final headers = Map<String, String>.from(_defaultHeaders)
        ..addAll({"custDomainKey": custKey});

      // Convert body to JSON
      final body = jsonEncode(request.toJson());

      // Call API
      final response = await http.post(url, headers: headers, body: body);

      if (response.body.isEmpty) {
        throw Exception("Empty response from server");
      }

      final decoded = jsonDecode(response.body);

      // Basic error handling
      if (response.statusCode != 200) {
        throw Exception(decoded["message"] ?? "Add device Failed");
      }

      // Convert raw JSON → model
      return AddDeviceModel.fromJson(decoded);
    } catch (e) {
      throw Exception("Add device Failed: $e");
    }
  }

  // Delete device api
  Future<AddDeviceModel> deleteDevice(DeletedeviceModel request) async {
    try {
      final custKey = await LocalStorage.getDomainKey();

      if (custKey == null || custKey.isEmpty) {
        throw Exception("Customer domain key missing.");
      }

      final url = Uri.parse('$baseUrl/delDevice');

      final headers = Map<String, String>.from(_defaultHeaders)
        ..addAll({"custDomainKey": custKey});

      final body = jsonEncode(request.toJson());

      final response = await http.post(url, headers: headers, body: body);

      if (response.body.isEmpty) {
        throw Exception("Empty response");
      }

      final decoded = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(decoded["message"] ?? "Delete failed");
      }

      return AddDeviceModel.fromJson(decoded);
    } catch (e) {
      throw Exception("Delete device error: $e");
    }
  }

  // Fetch Devices List
  Future<DeviceListResponse> fetchDeviceList() async {
    final url = Uri.parse("$baseUrl/deviceList");

    // Get saved domainKey from storage
    final custKey = await LocalStorage.getDomainKey();

    // If domainKey missing, throw error
    if (custKey == null || custKey.isEmpty) {
      throw Exception("Domain Key not found");
    }

    final body = DevicelistRequest.build(custKey);

    try {
      final response = await http.post(
        url,
        headers: _defaultHeaders,
        body: body,
      );

      if (response.statusCode != 200) {
        throw Exception(
          "Device failed: ${response.statusCode} - ${response.body}",
        );
      }

      final data = jsonDecode(response.body);

      return DeviceListResponse.fromJson(data);
    } catch (e) {
      throw Exception("Device Error: $e");
    }
  }
}
