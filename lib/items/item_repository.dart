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
    required this.name,
  });

  /// Deserialization
  factory TaskItem.fromJson(Map<String, dynamic> json) =>
      _$TaskItemFromJson(json);

  /// Item's id
  final String id;

  /// Li

  /// Item's name
  final String name;

  /// Serialization
  Map<String, dynamic> toJson() => _$TaskItemToJson(this);

  /// CopyWith
  TaskItem copyWith({
    String? id,
    String? name,
  }) {
    return TaskItem(
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
      itemDb.forEach(
        (String id) {
          final currentItem = itemDb[id];
          formattedItems[id] = currentItem?.toJson();
        } as void Function(
          String key,
          TaskItem value,
        ),
      );
    }

    return formattedItems;
  }

  /// Create a new item with a given [name]
  String createItem({
    required String name,
  }) {
    /// Dynamically generates the id
    final id = name.hashValue;

    /// Create our new TaskItem object and pass our two parameters
    final item = TaskItem(
      id: id,
      name: name,
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
    required String name,
  }) async {
    final currentItem = itemDb[id];

    if (currentItem == null) {
      return Future.error(Exception('Item not found'));
    }

    itemDb[id] = TaskItem(
      id: id,
      name: name,
    );
  }
}
