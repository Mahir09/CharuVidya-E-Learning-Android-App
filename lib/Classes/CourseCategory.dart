class CourseCategory {
  int id;
  String courseCategoryTitle;
  String logo;
  bool isParent;
  int parentId;

  CourseCategory(
      {this.id,
        this.courseCategoryTitle,
        this.logo,
        this.isParent,
        this.parentId});
}