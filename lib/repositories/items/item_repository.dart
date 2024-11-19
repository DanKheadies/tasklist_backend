import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:tasklist_backend/hash_extension.dart';

part 'item_repository.g.dart';

@visibleForTesting

/// Data source - in-memory cache
Map<String, TaskItem> itemDb = {};

@JsonSerializable()

/// TaskItem class
class TaskItem extends Equatable {
  /// Constructor
  const TaskItem({
    required this.id,
    required this.listId,
    required this.name,
    required this.description,
    required this.status,
  });

  /// Deserialization
  factory TaskItem.fromJson(Map<String, dynamic> json) =>
      _$TaskItemFromJson(json);

  /// Item's id
  final String id;

  /// List id of where the item belongs
  final String listId;

  /// Item's name
  final String name;

  /// Item's description
  final String description;

  /// Item's status
  final bool status;

  /// Serialization
  Map<String, dynamic> toJson() => _$TaskItemToJson(this);

  /// CopyWith
  TaskItem copyWith({
    String? id,
    String? listId,
    String? name,
    String? description,
    bool? status,
  }) {
    return TaskItem(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        listId,
        name,
        description,
        status,
      ];
}

/// Repository class for TaskItem
class TaskItemRepository {
  /// Check in the internal data source for a item with the give [id]
  Future<TaskItem?> itemById(String id) async {
    return itemDb[id];
  }

  /// Get all the items from the data source
  Map<String, dynamic> getAllItems() {
    final formattedItems = <String, dynamic>{};

    if (itemDb.isNotEmpty) {
      itemDb.forEach((key, value) {
        formattedItems[key] = value.toJson();
      });
    }

    return formattedItems;
  }

  /// Get items by list id
  Map<String, dynamic> getItemsByList(String listId) {
    final formattedItems = <String, dynamic>{};
    if (itemDb.isNotEmpty) {
      itemDb.forEach((key, value) {
        if (value.listId == listId) {
          formattedItems[key] = value.toJson();
        }
      });
    }
    return formattedItems;
  }

  /// Create a new item with a given [name]
  String createItem({
    required String name,
    required String listId,
    required String description,
    required bool status,
  }) {
    /// Dynamically generates the id
    final id = name.hashValue;

    /// Create our new TaskItem object and pass our two parameters
    final item = TaskItem(
      id: id,
      listId: listId,
      name: name,
      description: description,
      status: status,
    );

    /// Add a new TaskItem object to our data.source
    itemDb[id] = item;

    return id;
  }

  /// Deletes the TaskItem object with the give [id]
  void deleteItem(String id) {
    itemDb.remove(id);
  }

  /// Update operation
  Future<void> updateItem({
    required String id,
    required String listId,
    required String name,
    required String description,
    required bool status,
  }) async {
    final currentItem = itemDb[id];

    if (currentItem == null) {
      return Future.error(Exception('Item not found'));
    }

    itemDb[id] = TaskItem(
      id: id,
      listId: listId,
      name: name,
      description: description,
      status: status,
    );
  }
}
