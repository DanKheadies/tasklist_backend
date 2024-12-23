import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tasklist_backend/hash_extension.dart';

part 'list_repository.g.dart';

@visibleForTesting

/// Data source - in-memory cache
Map<String, TaskList> listDb = {};

@JsonSerializable()

/// TaskList class
class TaskList extends Equatable {
  /// Constructor
  const TaskList({
    required this.id,
    required this.name,
  });

  /// Deserialization
  factory TaskList.fromJson(Map<String, dynamic> json) =>
      _$TaskListFromJson(json);

  /// List's id
  final String id;

  /// List's name
  final String name;

  /// Serialization
  Map<String, dynamic> toJson() => _$TaskListToJson(this);

  /// CopyWith
  TaskList copyWith({
    String? id,
    String? name,
  }) {
    return TaskList(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}

/// Repository class for TaskList
class TaskListRepository {
  /// Check in the internal data source for a list with the give [id]
  Future<TaskList?> listById(String id) async {
    return listDb[id];
  }

  /// Get all the lists from the data source
  Map<String, dynamic> getAllLists() {
    final formattedLists = <String, dynamic>{};

    if (listDb.isNotEmpty) {
      // listDb.forEach(
      //   (String id) {
      //     final currentList = listDb[id];
      //     formattedLists[id] = currentList?.toJson();
      //   } as void Function(
      //     String key,
      //     TaskList value,
      //   ),
      // );
      listDb.forEach(
        (key, value) {
          formattedLists[key] = value.toJson();
        },
      );
    }

    return formattedLists;
  }

  /// Create a new list with a given [name]
  String createList({
    required String name,
  }) {
    /// Dynamically generates the id
    final id = name.hashValue;

    /// Create our new TaskList object and pass our two parameters
    final list = TaskList(
      id: id,
      name: name,
    );

    /// Add a new TaskList object to our data.source
    listDb[id] = list;

    return id;
  }

  /// Deletes the TaskList object with the give [id]
  void deleteList(String id) {
    listDb.remove(id);
  }

  /// Update operation
  Future<void> updateList({
    required String id,
    required String name,
  }) async {
    final currentList = listDb[id];

    if (currentList == null) {
      return Future.error(Exception('List not found'));
    }

    listDb[id] = TaskList(
      id: id,
      name: name,
    );
  }
}
