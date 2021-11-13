import 'package:charuvidya/Classes/CourseSession.dart';
import 'package:charuvidya/Classes/user.dart';

class CourseProgress {
  int id;
  bool completed;
  int watchSeconds;
  User user;
  CourseSession courseSession;

  CourseProgress(this.id, this.completed, this.watchSeconds, this.user,
      this.courseSession);
}