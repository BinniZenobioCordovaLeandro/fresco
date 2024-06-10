import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/shared/interface/abstract.service.dart';

class FirestoreService implements AbstractService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<Map<String, dynamic>>> get(
    String endpoint, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? orderBy,
  }) async {
    CollectionReference collectionReference = firestore.collection(endpoint);
    QuerySnapshot querySnapshot;
    Query<Object?> query = collectionReference;
    if (params?.isNotEmpty == true) {
      params?.forEach((key, value) {
        if (key.contains('At')) {
          query = query.where(key, isGreaterThan: params[key]);
        } else {
          query = query.where(key, isEqualTo: params[key]);
        }
      });
    }
    if (orderBy?.isNotEmpty == true) {
      orderBy?.forEach((key, value) {
        query = query.orderBy(key, descending: !value);
      });
    }
    querySnapshot = await query.get(
      const GetOptions(
        source: Source.serverAndCache,
        serverTimestampBehavior: ServerTimestampBehavior.previous,
      ),
    );
    List<Map<String, dynamic>> response = [];
    for (var document in querySnapshot.docs) {
      response.add(document.data() as Map<String, dynamic>);
    }
    return Future.value(List<Map<String, dynamic>>.from(response));
  }

  @override
  Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, dynamic>? params, required String body}) async {
    CollectionReference collectionReference = firestore.collection(endpoint);
    var result = await collectionReference
        .add(json.decode(body) as Map<String, dynamic>);
    result.update({
      ...jsonDecode(body),
      "id": result.id,
    });
    return Future.value(Map<String, dynamic>.from({
      ...jsonDecode(body),
      "id": result.id,
    }));
  }

  @override
  Future<Map<String, dynamic>> patch(String endpoint,
      {Map<String, dynamic>? params, required String body}) async {
    CollectionReference collectionReference = firestore.collection(endpoint);
    if (params?["id"] == null) {
      throw Exception("Id is required");
    }
    await collectionReference
        .doc(params!["id"])
        .set(json.decode(body) as Map<String, dynamic>);
    return Future.value(jsonDecode(body) as Map<String, dynamic>);
  }

  @override
  Future delete(String endpoint, {Map<String, dynamic>? params}) async {
    if (params?["id"] == null) {
      throw Exception("Id is required");
    }
    CollectionReference collectionReference = firestore.collection(endpoint);
    await collectionReference.doc(params!["id"]).delete();
    return Future.value();
  }
}
