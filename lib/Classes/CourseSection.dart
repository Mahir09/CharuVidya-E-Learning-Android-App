import 'package:charuvidya/Classes/Course.dart';

class CourseSection {
  int id;
  String sectionTitle;
  String sectionDescription;
  int sectionOrder;
  bool isDraft;
  bool isApproved;
  Course course;

  CourseSection(
      {this.id,
      this.sectionTitle,
      this.sectionDescription,
      this.sectionOrder,
      this.isDraft,
      this.isApproved,
      this.course});
}
