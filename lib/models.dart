// class User {
//   int id;
//   String name;
//
//   User({required this.id, required this.name});
// }
//
// class Project {
//   int id;
//   String name;
//   DateTime startTime;
//   DateTime endTime;
//   List<int> participants;
//
//   Project({required this.id, required this.name, required this.startTime, required this.endTime, required this.participants});
// }


class TasksModel {
  TasksModel({
    required this.success,
    required this.data,
    required this.message,
  });

  final bool success;
  final List<TasksDataModel> data;
  final String message;

  factory TasksModel.fromJson(Map<String, dynamic> json){
    return TasksModel(
      success: json["success"] ?? false,
      data: json["data"] == null ? [] : List<TasksDataModel>.from(json["data"]!.map((x) => TasksDataModel.fromJson(x))),
      message: json["message"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.map((x) => x.toJson()).toList(),
    "message": message,
  };

}

class TasksDataModel {
  TasksDataModel({
    required this.id,
    required this.text,
    required this.startDate,
    required this.endDate,
    required this.progress,
    required this.parent,
    required this.status,
    required this.condition,
    required this.createdAt,
    required this.updatedAt,
    required this.color,
    required this.childs,
  });

  final int id;
  final String text;
  final String startDate;
  final String endDate;
  final int progress;
  final int parent;
  final int status;
  final int condition;
  final String createdAt;
  final String updatedAt;
  final String color;
  final List<TasksDataModel> childs;

  factory TasksDataModel.fromJson(Map<String, dynamic> json){
    return TasksDataModel(
      id: json["id"] ?? 0,
      text: json["text"] ?? "",
      startDate: json["start_date"] ?? "",
      endDate: json["end_date"] ?? "",
      progress: json["progress"] ?? 0,
      parent: json["parent"] ?? 0,
      status: json["status"] ?? 0,
      condition: json["condition"] ?? 0,
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      color: json["color"] ?? "",
      childs: json["childs"] == null ? [] : List<TasksDataModel>.from(json["childs"]!.map((x) => TasksDataModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
    "start_date": startDate,
    "end_date": endDate,
    "progress": progress,
    "parent": parent,
    "status": status,
    "condition": condition,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "color": color,
    "childs": childs.map((x) => x.toJson()).toList(),
  };

}