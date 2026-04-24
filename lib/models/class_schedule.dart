class ClassSchedule {
  int? id;
  String course;
  String day;
  String startTime;
  String endTime;
  String room;
  String semester;
  bool isMakeup;
  bool isCancelled;

  ClassSchedule({
    this.id,
    required this.course,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.semester,
    this.isMakeup = false,
    this.isCancelled = false,
  });

  factory ClassSchedule.fromMap(Map<String, dynamic> json) => ClassSchedule(
    id: json['id'],
    course: json['course'],
    day: json['day'],
    startTime: json['startTime'],
    endTime: json['endTime'],
    room: json['room'],
    semester: json['semester'],
    isMakeup: json['isMakeup'] == 1,
    isCancelled: json['isCancelled'] == 1,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'course': course,
    'day': day,
    'startTime': startTime,
    'endTime': endTime,
    'room': room,
    'semester': semester,
    'isMakeup': isMakeup ? 1 : 0,
    'isCancelled': isCancelled ? 1 : 0,
  };
}
