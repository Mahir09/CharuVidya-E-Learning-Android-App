import 'package:charuvidya/Classes/CourseCategory.dart';
import 'package:charuvidya/Classes/CourseLevel.dart';
import 'package:charuvidya/Classes/user.dart';
// /course/{courseId}/course-sections-sessions
// /course/3/course-sections-session
class Course {
  int id;
  String courseTitle;
  String courseDiscription;
  String courseObjectives;
  String courseSubTitle;
  String previewVideoUrl;
  int courseLength;
  int minStudents;
  int maxStudents;
  String logo;
  DateTime courseCreatedOn;
  DateTime courseUpdatedOn;
  String courseRootDir;
  int amount;
  bool isDraft;
  bool isApproved;
  DateTime courseApprovalDate;
  CourseLevel courseLevel;
  CourseCategory courseCategory;
  User user;
  User reviewer;
  bool enrolled;

  Course({
    this.id,
    this.courseTitle,
    this.courseDiscription,
    this.courseObjectives,
    this.courseSubTitle,
    this.previewVideoUrl,
    this.courseLength,
    this.minStudents,
    this.maxStudents,
    this.logo,
    this.courseCreatedOn,
    this.courseUpdatedOn,
    this.courseRootDir,
    this.amount,
    this.isDraft,
    this.isApproved,
    this.courseApprovalDate,
    this.courseLevel,
    this.courseCategory,
    this.user,
    this.reviewer,
    this.enrolled,
  });

  // Course({
  //   this.id,
  //   this.courseTitle,
  //   this.courseDiscription,
  //   this.courseObjectives,
  //   this.courseSubTitle,
  //   this.previewVideoUrl,
  //   this.courseLength,
  //   this.minStudents,
  //   this.maxStudents,
  //   this.logo,
  //   this.amount,
  //   this.isDraft,
  //   this.isApproved,
  //   this.enrolled,
  // });
}
