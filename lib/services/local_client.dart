import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage {
  // Initialize Hive
  static Future<void> initHive() async {
    await Hive.initFlutter();
  }

  static void registerAdapters() {}

  // Open a box
  Future<Box<T>> openBox<T>(String boxName) async {
    return await Hive.openBox<T>(boxName);
  }

  // Add data to the box
  Future<void> addData<T>(String boxName, T data) async {
    var box = await openBox<T>(boxName);
    await box.add(data);
  }

  // Retrieve data from the box
  Future<List<T>> getData<T>(String boxName) async {
    var box = await openBox<T>(boxName);
    return box.values.toList();
  }

  // Update data in the box
  Future<void> updateData<T>(String boxName, int index, T data) async {
    var box = await openBox<T>(boxName);
    await box.putAt(index, data);
  }

  // Delete data from the box
  Future<void> deleteData(String boxName, int index) async {
    var box = await openBox(boxName);
    await box.deleteAt(index);
  }
}
