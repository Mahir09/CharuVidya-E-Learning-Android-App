import 'package:flutter/material.dart';

class SliderModel {
  String imageAssetPath;
  String title;
  String desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc("E-learning app from CHARUSAT university");
  sliderModel.setTitle("Charu-Vidhya");
  sliderModel.setImageAssetPath("assets/CV.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc(
      "Best courses and specialization from the faculties of charusat");
  sliderModel.setTitle("Best Courses");
  sliderModel.setImageAssetPath("assets/faculty.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc("Learn from your comfort");
  sliderModel.setTitle("learning made easy");
  sliderModel.setImageAssetPath("assets/learn.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
