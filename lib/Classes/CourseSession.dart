import 'package:charuvidya/Classes/CourseSection.dart';

class CourseSession {
  int id;
  String sessionTitle;
  String sessionDescription;
  String sessionVideo;
  DateTime sessionDuration;
  int sessionOrder;
  String sessionResource;
  String sessionLocation;
  bool isPreview;
  bool isDraft;
  bool isApproved;
  bool isPublishedn;
  String quizLink;
  CourseSection courseSection;

  CourseSession(
      {this.id,
      this.sessionTitle,
      this.sessionDescription,
      this.sessionVideo,
      this.sessionDuration,
      this.sessionOrder,
      this.sessionResource,
      this.sessionLocation,
      this.isPreview,
      this.isDraft,
      this.isApproved,
      this.isPublishedn,
      this.quizLink,
      this.courseSection});

  CourseSession.fromJson(dynamic data){
    id = data["id"];
    sessionTitle = data["sessionTitle"];
    sessionDescription = data["sessionDescription"];
    sessionVideo = data["sessionVideo"];
    sessionDuration = data["sessionDuration"];
    sessionOrder = data["sessionOrder"];
    sessionResource = data["sessionResource"];
    sessionLocation = data["sessionLocation"];
    isPreview = data["isPreview"];
    isDraft = data["isDraft"];
    isApproved = data["isApproved"];
    isPublishedn = data["isPublishedn"];
    quizLink = data["quizLink"];
    courseSection = data["courseSection"];
  }
}
