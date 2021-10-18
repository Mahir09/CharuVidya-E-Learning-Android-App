class CourseSection {
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

  CourseSection(
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
}
