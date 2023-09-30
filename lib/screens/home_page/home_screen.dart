
// ignore_for_file: must_be_immutable, use_build_context_synchronously
// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:wallpaper/screens/admin_page/admin_panel.dart';
import 'package:wallpaper/screens/home_page/home_controller.dart';

class HomeScreen extends StatefulWidget {
  bool? isAdmin;

  HomeScreen({super.key, this.isAdmin});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Uint8List> imagesPath = [];
  List bytesList = [];
  List uploadByteList = [];
  double width = 0;
  double height = 0;
  double textHeight = 0;
  double border = 0;
  bool isMobile = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HomeController homeController = Get.put(HomeController());

  PlatformFile? imageFile;

  Future<void> pickImage() async {


    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'png', 'webp', 'jpeg'],
      );

      if (result == null) return;
      setState(() {
        imageFile = result.files.first;
        result.files.forEach((element) {
          if (element.extension == 'jpg' ||
              element.extension == 'png' ||
              element.extension == 'jpeg' ||
              element.extension == 'webp') {
            imagesPath.add(element.bytes!);
          }
        });
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> imagePickerWeb() async {
    List<Image>? fromPicker = await ImagePickerWeb.getMultiImagesAsWidget();

    setState(() {
      fromPicker!.forEach((element) {
        bytesList.add(element.image);
      });
    });

  }

  @override
  Widget build(BuildContext context) {

    final widthM = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    homeController.isImages = false;
                    homeController.isLogout = false;
                    homeController.isCategory = true;
                  });
                },
                child: SizedBox(
                  height: 70,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/category.png",
                        height: 20,
                        width: 20,
                        color: homeController.isCategory
                            ? const Color(0xffFFD800)
                            : Colors.white,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        "Categories",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Divider(
                  height: 0.5,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    homeController.isCategory = false;
                    homeController.isLogout = false;
                    homeController.isImages = true;
                  });
                },
                child: SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/icons/images.png",
                        height: 20,
                        width: 20,
                        color: homeController.isImages
                            ? const Color(0xffFFD800)
                            : Colors.white,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        "Images",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Divider(
                  height: 0.5,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Dialog(
                          backgroundColor: Colors.transparent,
                          child: Container(
                            height: Get.height > 660 ?height * 0.5 : height * 0.43,
                            width: width * 2,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(
                                20,
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onTap: () {
                                        Get.back();
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Get.height * 0.04,
                                ),
                                Image.asset(
                                  'assets/icons/logout.png',
                                  height: height * 0.07,
                                  width: width * 0.6,
                                ),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                Text(
                                  'Are you sure want to logout?',
                                  style: TextStyle(
                                    height: 1.5,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: textHeight * 0.04,
                                    fontFamily: "sfPro",
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: Get.height * 0.03,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                                  children: [

                                    Expanded(
                                      child: GestureDetector(
                                        onTap:
                                            () {
                                          setState(
                                                  () {
                                                Get.back();
                                                Get.to(const AdminPanelScreen());
                                              });
                                        },
                                        child:
                                        Container(
                                          decoration: BoxDecoration(
                                              color: const Color(0xffFFD800),
                                              borderRadius: BorderRadius.circular(
                                                10,
                                              ),
                                              border: Border.all(color: const Color(0xffFFD800), width: 1)),
                                          width:
                                          width * 0.8,
                                          height:
                                          height * 0.06,
                                          alignment:
                                          Alignment.center,
                                          child:
                                          const Text(
                                            "Yes",
                                            style:
                                            TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'sfBold',
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width:
                                      20,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap:
                                            () {
                                          setState(
                                                  () {
                                                Get.back();
                                              });
                                        },
                                        child:
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(
                                                10,
                                              ),
                                              border: Border.all(color: const Color(0xffFFD800), width: 1)),
                                          width:
                                          width * 0.8,
                                          height:
                                          height * 0.06,
                                          alignment:
                                          Alignment.center,
                                          child:
                                          const Text(
                                            "No",
                                            style:
                                            TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: SizedBox(
                  height: 70,
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/icons/signout.png",
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        "Log out",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          if (sizingInformation.isDesktop) {
            isMobile = false;
            width = 250;
            height = 600;
            textHeight = 640;
            border = 1;
          } else if (sizingInformation.isTablet) {
            isMobile = false;
            width = 200;
            height = 690;
            textHeight = 600;
            border = 1;
          } else if (sizingInformation.isMobile) {
            isMobile = true;
            width = 150;
            height = 600;
            textHeight = 550;
            border = 1;
          }
          return Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill),
              ),
              child: sizingInformation.isDesktop
                  ? Row(
                      children: [
                        SizedBox(
                          width: Get.width > 1110
                              ? Get.width * 0.02
                              : Get.width * 0.015,
                        ),
                        Expanded(
                          child: Container(
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                homeController.isImages
                                    ? SizedBox(
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.2,
                                      )
                                    : SizedBox(
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.2,
                                      ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                      visible: isMobile,
                                      child: GestureDetector(
                                        onTap: () {
                                          _scaffoldKey.currentState
                                              ?.openDrawer();
                                        },
                                        child: Container(
                                          height: sizingInformation.isDesktop
                                              ? 50
                                              : 40,
                                          width: width * 0.7,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffFFD800),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.menu),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Menu",
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    homeController.isCategory
                                        ? GestureDetector(
                                            onTap: () {
                                              homeController
                                                  .categoryController
                                                  .clear();
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 2, sigmaY: 2),
                                                    child: Dialog(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      child: Container(
                                                        height: height * 0.74,
                                                        width: width * 3,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 30,
                                                          horizontal: 30,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black,
                                                          border: Border.all(
                                                            color:
                                                                Colors.white,
                                                            width: 3,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            20,
                                                          ),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 2,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                GestureDetector(
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .close,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 30,
                                                                  ),
                                                                  onTap: () {
                                                                    Get.back();
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            const Text(
                                                              'Add category',
                                                              style: TextStyle(
                                                                  height: 1.5,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  fontSize:
                                                                      30,
                                                                  fontFamily:
                                                                      "sfBold",
                                                                  letterSpacing:
                                                                      2),
                                                            ),
                                                            SizedBox(
                                                              height:
                                                              height *
                                                                      0.008,
                                                            ),
                                                            Container(
                                                              height: 2,
                                                              width:
                                                                  width * 0.6,
                                                              color: Colors
                                                                  .yellow,
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(
                                                                height:
                                                                    height *
                                                                        0.08,
                                                              ),
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Text(
                                                                  "Category name",
                                                                  style:
                                                                      TextStyle(
                                                                    letterSpacing:
                                                                        2,
                                                                    fontSize:
                                                                        18,
                                                                    fontFamily:
                                                                        "sfPro",
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height:
                                                                      Get.height *
                                                                          0.02,
                                                                ),
                                                                Container(
                                                                  height:
                                                                      height *
                                                                          0.1,
                                                                  width:
                                                                      width *
                                                                          2.2,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      7,
                                                                    ),
                                                                    border: Border.all(
                                                                        color: Colors.white.withOpacity(
                                                                          0.65,
                                                                        ),
                                                                        width: 1),
                                                                  ),
                                                                  child:
                                                                      TextField(
                                                                    controller:
                                                                        homeController
                                                                            .categoryController,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          "sfPro",
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight.w500,
                                                                    ),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border:
                                                                          InputBorder.none,
                                                                      contentPadding:
                                                                          EdgeInsets.only(
                                                                        left: width *
                                                                            0.08,
                                                                        top:
                                                                            11,
                                                                      ),
                                                                      hintStyle:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        letterSpacing:
                                                                            2,
                                                                        fontFamily:
                                                                            "sfPro",
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(0.6),
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                      hintText:
                                                                          'enter category name',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Expanded(
                                                              child: SizedBox(
                                                                height:
                                                                   height *
                                                                        0.08,
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                            setState(() {

                              if (homeController
                                  .categoryController
                                  .text
                                  .isNotEmpty) {
                                if (widget
                                    .isAdmin!) {

                                  homeController
                                      .categoryName
                                      .add(homeController.categoryController.text);
                                  homeController.onTapCategoryUpload(homeController
                                      .categoryController
                                      .text);



                                  Get.back();
                                } else {
                                  Get.back();
                                  ScaffoldMessenger.of(
                                      context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content:
                                      Text('This operation is not perform due to demo mode.'),
                                      backgroundColor:
                                      Colors.black,
                                    ),
                                  );
                                }
                              } else {
                                Get.back();
                                Get.snackbar(
                                    'Invalid',
                                    "Category name can't be empty",backgroundColor: Colors.red,colorText: Colors.white);
                              }
                              homeController
                                  .categoryController
                                  .clear();
                            });
                                                              },
                                                              child:
                                                                  Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0xffFFD800),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                    30,
                                                                  ),
                                                                ),
                                                                width: width *
                                                                    0.8,
                                                                height:
                                                                    height *
                                                                        0.1,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: const Text(
                                                                  "Upload",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        23,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'sfBold',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: height *
                                                                  0.02,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              height: 70,
                                              width: 180,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffFFD800),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/add.png',
                                                    height: 23,
                                                    width: 23,
                                                  ),
                                                  const SizedBox(
                                                    width: 30,
                                                  ),
                                                  const Text(
                                                    "ADD",
                                                    style: TextStyle(
                                                        fontSize: 28,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.06,
                                ),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Get.height >154?
                                      Visibility(
                                        visible: !isMobile,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: width * 0.1),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.2),
                                          height: Get.width > 1366 ? 450 : 400,
                                          width: Get.width > 1366
                                              ? width * 1.35
                                              : (Get.width > 1100 &&
                                                      Get.width <= 1366)
                                                  ? width * 1.3
                                                  : width * 1,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: const Color(0xffFFD800),
                                                width: 0.5),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                               const SizedBox(
                                                height: 20 ,
                                              ),
                                              Expanded(
                                                flex: 6,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      homeController.isImages =
                                                          false;
                                                      homeController.isLogout =
                                                          false;
                                                      homeController
                                                          .isCategory = true;
                                                    });
                                                  },
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        "assets/icons/category.png",
                                                        height: 40,
                                                        width: 40,
                                                        color: homeController
                                                                .isCategory
                                                            ? const Color(
                                                                0xffFFD800)
                                                            : Colors.white,
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text(
                                                        "Categories",
                                                        style: TextStyle(
                                                            fontSize:
                                                                Get.width > 1110
                                                                    ? 27
                                                                    : 17,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 0.09,
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                              ),
                                              Expanded(
                                                flex: 6,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      homeController
                                                          .isCategory = false;
                                                      homeController.isLogout =
                                                          false;
                                                      homeController.isImages =
                                                          true;
                                                    });
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/icons/images.png",
                                                        height: 40,
                                                        width: 40,
                                                        color: homeController
                                                                .isImages
                                                            ? const Color(
                                                                0xffFFD800)
                                                            : Colors.white,
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text(
                                                        "Images",
                                                        style: TextStyle(
                                                            fontSize:
                                                                Get.width > 1110
                                                                    ? 27
                                                                    : 17,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 0.09,
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                              ),
                                              Expanded(
                                                flex: 6,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {});
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return BackdropFilter(
                                                          filter:
                                                              ImageFilter.blur(
                                                                  sigmaX: 2,
                                                                  sigmaY: 2),
                                                          child: Dialog(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            child: Container(
                                                              height:
                                                              Get.height > 800 ? height * 0.65 : Get.height > 700 && Get.height <=800?  height * 0.6 : height * 0.55,
                                                              width: width * 2.6,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                vertical: 30,
                                                                horizontal: 30,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 3,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  20,
                                                                ),
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 2,
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        Get.height *
                                                                            0.06,
                                                                  ),
                                                                  Image.asset(
                                                                    'assets/icons/logout.png',
                                                                    height:
                                                                        height *
                                                                            0.1,
                                                                    width:
                                                                        width *
                                                                            05,
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        Get.height *
                                                                            0.04,
                                                                  ),
                                                                  const Text(
                                                                    'Are you sure want to logout?',
                                                                    style:
                                                                        TextStyle(
                                                                      height:
                                                                          1.5,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          30,
                                                                      fontFamily:
                                                                          "sfPro",
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        Get.height *
                                                                            0.03,
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [

                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                                  () {
                                                                                Get.back();
                                                                                Get.to(const AdminPanelScreen());
                                                                              });
                                                                        },
                                                                        child:
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                              color: const Color(0xffFFD800),
                                                                              borderRadius: BorderRadius.circular(
                                                                                10,
                                                                              ),
                                                                              border: Border.all(color: const Color(0xffFFD800), width: 1)),
                                                                          width:
                                                                          width * 0.8,
                                                                          height:
                                                                          height * 0.09,
                                                                          alignment:
                                                                          Alignment.center,
                                                                          child:
                                                                          const Text(
                                                                            "Yes",
                                                                            style:
                                                                            TextStyle(
                                                                              fontSize: 27,
                                                                              fontFamily: 'sfBold',
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                                  () {
                                                                                Get.back();
                                                                              });
                                                                        },
                                                                        child:
                                                                        Container(
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.transparent,
                                                                              borderRadius: BorderRadius.circular(
                                                                                10,
                                                                              ),
                                                                              border: Border.all(color: const Color(0xffFFD800), width: 1)),
                                                                          width:
                                                                          width * 0.8,
                                                                          height:
                                                                          height * 0.09,
                                                                          alignment:
                                                                          Alignment.center,
                                                                          child:
                                                                          const Text(
                                                                            "No",
                                                                            style:
                                                                            TextStyle(
                                                                              fontSize: 27,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),

                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        "assets/icons/signout.png",
                                                        height: 40,
                                                        width: 40,
                                                        color: homeController
                                                                .isLogout
                                                            ? const Color(
                                                                0xffFFD800)
                                                            : Colors.white,
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Text(
                                                        "Log out",
                                                        style: TextStyle(
                                                            fontSize:
                                                                Get.width > 1110
                                                                    ? 27
                                                                    : 17,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      ) :
                                      const SizedBox(),
                                      SizedBox(
                                          width: Get.width > 1110
                                              ? Get.width * 0.07
                                              : Get.width * 0.06),
                                      homeController.isCategory
                                          ? Expanded(
                                              child: Container(
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('category')
                                                      .snapshots(),
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                              QuerySnapshot>
                                                          streamSnapshot) {
                                                    if (streamSnapshot
                                                        .hasData) {
                                                      return SingleChildScrollView(
                                                        child: Stack(
                                                          children: [
                                                            streamSnapshot
                                                                .data
                                                                ?.docs
                                                                .length !=
                                                                0
                                                                ?
                                                            Column(
                                                              children: [
                                                                const SizedBox(height : 70,),
                                                                Container(
                                                                  height : Get.height * 0.5,
                                                                  decoration:
                                                                  BoxDecoration(

                                                                    border : Border.all(width: 1,color: Colors.white),

                                                                    borderRadius:
                                                                    const BorderRadius.only(
                                                                      bottomRight: Radius.circular(
                                                                        15,
                                                                      ),
                                                                      bottomLeft: Radius.circular(
                                                                        15,
                                                                      ),
                                                                    ),

                                                                  ),
                                                                  child: ListView
                                                                      .builder(
                                                                    padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                    itemCount:
                                                                    streamSnapshot.data?.docs.length ??
                                                                        0,

                                                                    shrinkWrap:
                                                                    true,
                                                                    itemBuilder:
                                                                        (context,
                                                                        index) {
                                                                      return Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                  height: 92,
                                                                                  alignment: Alignment.center,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.white.withOpacity(0.09),
                                                                                  ),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: [
                                                                                      SizedBox(
                                                                                        width: Get.width * 0.05,
                                                                                      ),
                                                                                      Text(
                                                                                        "${streamSnapshot.data?.docs[index]['name']}",
                                                                                        style: const TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w400),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Container(
                                                                                width: 0.4,
                                                                                height: 92,
                                                                                color: Colors.white,
                                                                              ),
                                                                              Expanded(
                                                                                child: Container(
                                                                                  height: 92,
                                                                                  decoration: const BoxDecoration(),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Expanded(
                                                                                        child: GestureDetector(
                                                                                          child: Container(
                                                                                            height: 92,
                                                                                            decoration: BoxDecoration(
                                                                                              color: Colors.white.withOpacity(0.09),
                                                                                            ),
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                Image.asset(
                                                                                                  'assets/icons/edit.png',
                                                                                                  height: 25,
                                                                                                  width: 25,
                                                                                                ),
                                                                                                const SizedBox(
                                                                                                  width: 20,
                                                                                                ),
                                                                                                const Text(
                                                                                                  "Edit",
                                                                                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          onTap: () {
                                                                                            homeController.editingController.text = streamSnapshot.data?.docs[index]['name'];

                                                                                            showDialog(
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                return BackdropFilter(
                                                                                                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                                                                                  child: Dialog(
                                                                                                    backgroundColor: Colors.transparent,
                                                                                                    child: Container(
                                                                                                      height: height * 0.7,
                                                                                                      width: width * 2.8,
                                                                                                      padding: const EdgeInsets.symmetric(
                                                                                                        vertical: 30,
                                                                                                        horizontal: 30,
                                                                                                      ),
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: Colors.black,
                                                                                                        border: Border.all(
                                                                                                          color: Colors.white,
                                                                                                          width: 3,
                                                                                                        ),
                                                                                                        borderRadius: BorderRadius.circular(
                                                                                                          20,
                                                                                                        ),
                                                                                                      ),
                                                                                                      child: Column(
                                                                                                        children: [
                                                                                                          const SizedBox(
                                                                                                            height: 2,
                                                                                                          ),
                                                                                                          Expanded(
                                                                                                            child: Row(
                                                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                                                              children: [
                                                                                                                GestureDetector(
                                                                                                                  child: const Icon(
                                                                                                                    Icons.close,
                                                                                                                    color: Colors.white,
                                                                                                                    size: 30,
                                                                                                                  ),
                                                                                                                  onTap: () {
                                                                                                                    Get.back();
                                                                                                                  },
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          const SizedBox(
                                                                                                            height: 10,
                                                                                                          ),
                                                                                                          const Expanded(
                                                                                                            child: Text(
                                                                                                              'Edit Name',
                                                                                                              style: TextStyle(height: 1.5, color: Colors.white, fontWeight: FontWeight.w600, fontSize: 30, fontFamily: "sfPro", letterSpacing: 2),
                                                                                                            ),
                                                                                                          ),
                                                                                                          SizedBox(
                                                                                                            height: Get.height * 0.008,
                                                                                                          ),
                                                                                                          Container(
                                                                                                            height: 2,
                                                                                                            width: width * 0.5,
                                                                                                            color: Colors.yellow,
                                                                                                          ),
                                                                                                          Expanded(
                                                                                                            child: SizedBox(
                                                                                                              height: Get.height * 0.07,
                                                                                                            ),
                                                                                                          ),
                                                                                                          Container(
                                                                                                            height:  Get.height > 391?height * 0.13 : height * 0.08,
                                                                                                            width: width * 2,
                                                                                                            decoration: BoxDecoration(
                                                                                                              borderRadius: BorderRadius.circular(
                                                                                                                5,
                                                                                                              ),
                                                                                                              border: Border.all(
                                                                                                                  color: Colors.white.withOpacity(
                                                                                                                    0.65,
                                                                                                                  ),
                                                                                                                  width: 1),
                                                                                                            ),

                                                                                                            child: TextField(
                                                                                                              controller: homeController.editingController,
                                                                                                              style: const TextStyle(fontFamily: "sfPro", color: Colors.white, fontWeight: FontWeight.w500, letterSpacing: 1, fontSize: 24),
                                                                                                              decoration: InputDecoration(
                                                                                                                border: InputBorder.none,
                                                                                                                contentPadding: EdgeInsets.only(
                                                                                                                  left: width * 0.2,
                                                                                                                  top: 23,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                          Expanded(
                                                                                                            child: SizedBox(
                                                                                                              height: Get.height * 0.07,
                                                                                                            ),
                                                                                                          ),
                                                                                                          Expanded(
                                                                                                            child: GestureDetector(
                                                                                                              onTap: () {
                                                                                                                setState(() {
                                                                                                                  if (homeController.editingController.text.isNotEmpty) {
                                                                                                                    if (widget.isAdmin!) {
                                                                                                                      homeController.onTapCategoryEdit(homeController.editingController.text, streamSnapshot.data?.docs[index].id, streamSnapshot.data?.docs[index]['image']);
                                                                                                                      Get.back();
                                                                                                                    } else {
                                                                                                                      Get.back();
                                                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                                                        const SnackBar(
                                                                                                                          content: Text('This operation is not perform due to demo mode.'),
                                                                                                                          backgroundColor: Colors.black,
                                                                                                                        ),
                                                                                                                      );
                                                                                                                    }
                                                                                                                  } else {
                                                                                                                    Get.snackbar('Invalid', "Category name can't be empty",colorText: Colors.white,backgroundColor: Colors.red);
                                                                                                                  }
                                                                                                                });
                                                                                                              },
                                                                                                              child: Container(
                                                                                                                decoration: BoxDecoration(
                                                                                                                  color: const Color(0xffFFD800),
                                                                                                                  borderRadius: BorderRadius.circular(
                                                                                                                    15,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                width: width * 0.8,
                                                                                                                height: height * 0.12,
                                                                                                                alignment: Alignment.center,
                                                                                                                child: const Text(
                                                                                                                  "Done",
                                                                                                                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700, color: Colors.black),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ),
                                                                                                          SizedBox(
                                                                                                            height: height * 0.02,
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                              },
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        width: 0.4,
                                                                                        height: 92,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                      Expanded(
                                                                                        child: GestureDetector(
                                                                                          onTap: () {
                                                                                            showDialog(
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                return BackdropFilter(
                                                                                                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                                                                                  child: Dialog(
                                                                                                    backgroundColor: Colors.transparent,
                                                                                                    child: Container(
                                                                                                      height: height * 0.7,
                                                                                                      width: width * 2.8,
                                                                                                      padding: const EdgeInsets.symmetric(
                                                                                                        vertical: 30,
                                                                                                        horizontal: 30,
                                                                                                      ),
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: Colors.black,
                                                                                                        border: Border.all(
                                                                                                          color: Colors.white,
                                                                                                          width: 3,
                                                                                                        ),
                                                                                                        borderRadius: BorderRadius.circular(
                                                                                                          20,
                                                                                                        ),
                                                                                                      ),
                                                                                                      child: Column(
                                                                                                        children: [
                                                                                                          const SizedBox(
                                                                                                            height: 2,
                                                                                                          ),
                                                                                                          Expanded(
                                                                                                            child: Row(
                                                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                                                              children: [
                                                                                                                GestureDetector(
                                                                                                                  child: const Icon(
                                                                                                                    Icons.close,
                                                                                                                    color: Colors.white,
                                                                                                                    size: 30,
                                                                                                                  ),
                                                                                                                  onTap: () {
                                                                                                                    Get.back();
                                                                                                                  },
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          const SizedBox(
                                                                                                            height: 10,
                                                                                                          ),
                                                                                                          Stack(
                                                                                                            alignment: Alignment.center,
                                                                                                            children: [
                                                                                                              Container(
                                                                                                                height: height * 0.14,
                                                                                                                width: height * 0.14,
                                                                                                                decoration: const BoxDecoration(
                                                                                                                  color: Colors.red,
                                                                                                                  shape: BoxShape.circle,
                                                                                                                ),
                                                                                                              ),
                                                                                                              Image.asset(
                                                                                                                'assets/icons/delete.png',
                                                                                                                height: height * 0.07,
                                                                                                                width: height * 0.07,
                                                                                                                fit: BoxFit.fill,
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Expanded(
                                                                                                            child: SizedBox(
                                                                                                              height: Get.height * 0.035,
                                                                                                            ),
                                                                                                          ),
                                                                                                          SizedBox(
                                                                                                            width: 500,
                                                                                                            child: Text(
                                                                                                              'Are you sure want to delete ${streamSnapshot.data?.docs[index]['name']} Category?',
                                                                                                              style: const TextStyle(
                                                                                                                height: 1.5,
                                                                                                                color: Colors.white,
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                                fontSize: 30,
                                                                                                                fontFamily: "sfPro",
                                                                                                              ),
                                                                                                              textAlign: TextAlign.center,
                                                                                                            ),
                                                                                                          ),
                                                                                                          Expanded(
                                                                                                            child: SizedBox(
                                                                                                              height: Get.height * 0.035,
                                                                                                            ),
                                                                                                          ),

                                                                                                          Expanded(
                                                                                                            child: Row(
                                                                                                              mainAxisAlignment:
                                                                                                              MainAxisAlignment
                                                                                                                  .center,
                                                                                                              children: [
                                                                                                                GestureDetector(
                                                                                                                  onTap:
                                                                                                                      () {
                                                                                                                    if (widget.isAdmin!) {
                                                                                                                      setState(() {
                                                                                                                        homeController.onTapCategoryDelete(streamSnapshot.data?.docs[index].id);
                                                                                                                        Get.back();
                                                                                                                      });
                                                                                                                    } else {
                                                                                                                      Get.back();
                                                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                                                        const SnackBar(
                                                                                                                          content: Text('This operation is not perform due to demo mode.'),
                                                                                                                          backgroundColor: Colors.black,
                                                                                                                        ),
                                                                                                                      );
                                                                                                                    }
                                                                                                                  },
                                                                                                                  child:
                                                                                                                  Container(
                                                                                                                    decoration: BoxDecoration(
                                                                                                                        color: const Color(0xffFFD800),
                                                                                                                        borderRadius: BorderRadius.circular(
                                                                                                                          10,
                                                                                                                        ),
                                                                                                                        border: Border.all(color: const Color(0xffFFD800), width: 1)),
                                                                                                                    width:
                                                                                                                    width * 0.7,
                                                                                                                    height:
                                                                                                                    height * 0.09,
                                                                                                                    alignment:
                                                                                                                    Alignment.center,
                                                                                                                    child:
                                                                                                                    const Text(
                                                                                                                      "Yes",
                                                                                                                      style:
                                                                                                                      TextStyle(
                                                                                                                        fontSize: 22,
                                                                                                                        fontFamily: 'sfBold',
                                                                                                                        color: Colors.black,
                                                                                                                        fontWeight: FontWeight.w600,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),

                                                                                                                const SizedBox(
                                                                                                                  width:
                                                                                                                  20,
                                                                                                                ),
                                                                                                                GestureDetector(
                                                                                                                  onTap:
                                                                                                                      () {
                                                                                                                    setState(
                                                                                                                            () {
                                                                                                                          Get.back();
                                                                                                                        });
                                                                                                                  },
                                                                                                                  child:
                                                                                                                  Container(
                                                                                                                    decoration: BoxDecoration(
                                                                                                                        color: Colors.transparent,
                                                                                                                        borderRadius: BorderRadius.circular(
                                                                                                                          10,
                                                                                                                        ),
                                                                                                                        border: Border.all(color: const Color(0xffFFD800), width: 1)),
                                                                                                                    width:
                                                                                                                    width * 0.7,
                                                                                                                    height:
                                                                                                                    height * 0.09,
                                                                                                                    alignment:
                                                                                                                    Alignment.center,
                                                                                                                    child:
                                                                                                                    const Text(
                                                                                                                      "No",
                                                                                                                      style:
                                                                                                                      TextStyle(
                                                                                                                        fontSize: 22,
                                                                                                                        fontWeight: FontWeight.w600,
                                                                                                                        color: Colors.white,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),

                                                                                                              ],
                                                                                                            ),
                                                                                                          ),

                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                              },
                                                                                            );
                                                                                          },
                                                                                          child: Container(
                                                                                            height: 92,
                                                                                            decoration: BoxDecoration(
                                                                                              color: Colors.white.withOpacity(0.09),
                                                                                            ),
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              children: [
                                                                                                Image.asset(
                                                                                                  'assets/icons/delete.png',
                                                                                                  height: 25,
                                                                                                  width: 25,
                                                                                                ),
                                                                                                const SizedBox(
                                                                                                  width: 20,
                                                                                                ),
                                                                                                const Text(
                                                                                                  "Delete",
                                                                                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          index == streamSnapshot.data!.docs.length - 1
                                                                              ? const SizedBox()
                                                                              : const Divider(
                                                                            color: Colors.white,
                                                                            thickness: 1,
                                                                            height: 0,
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            )

                                                                : const SizedBox(),
                                                            streamSnapshot
                                                                        .data
                                                                        ?.docs
                                                                        .length !=
                                                                    0
                                                                ? Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          height:
                                                                              75,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color:
                                                                                Color(0xffFFD800),
                                                                            border:
                                                                                Border.fromBorderSide(
                                                                              BorderSide(color: Color(0xff1A1A1A), width: 0.5),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              const Text(
                                                                            "Categories",
                                                                            style: TextStyle(
                                                                                fontFamily: 'sfBold',
                                                                                letterSpacing: 1,
                                                                                fontWeight: FontWeight.w700,
                                                                                fontSize: 27,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          height:
                                                                              75,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color:
                                                                                Color(0xffFFD800),
                                                                            border:
                                                                                Border.fromBorderSide(
                                                                              BorderSide(color: Color(0xff1A1A1A), width: 0.5),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              const Text(
                                                                            "Action",
                                                                            style: TextStyle(
                                                                                fontFamily: 'sfBold',
                                                                                letterSpacing: 1,
                                                                                fontWeight: FontWeight.w700,
                                                                                fontSize: 27,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : const SizedBox(),

                                                          ],
                                                        ),
                                                      );
                                                    } else if (streamSnapshot
                                                        .hasError) {
                                                      return const SizedBox();
                                                    } else {
                                                      return const Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    }
                                                  },
                                                ),
                                              ),
                                            )
                                          : Expanded(
                                              child: SingleChildScrollView(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Visibility(
                                                                visible:
                                                                    homeController
                                                                            .isDrop ==
                                                                        false,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      if (homeController
                                                                          .isDrop) {
                                                                        homeController.isDrop =
                                                                            false;
                                                                      } else {
                                                                        homeController.isDrop =
                                                                            true;
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 60,
                                                                    decoration: BoxDecoration(
                                                                        color: const Color(
                                                                            0xffFFD800),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10)),
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                width * 0.18,
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          homeController
                                                                              .category,
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.w800,
                                                                            fontSize:
                                                                                20,
                                                                            fontFamily:
                                                                                "sfBold",
                                                                          ),
                                                                        ),
                                                                        const Spacer(),
                                                                        Image
                                                                            .asset(
                                                                          'assets/icons/arrowDown.png',
                                                                          height:
                                                                              height * 0.02,
                                                                          width:
                                                                              height * 0.02,
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              SizedBox(
                                                                            width:
                                                                                width * 0.3,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: Get.width *
                                                                  0.06,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  homeController
                                                                          .isUploaded =
                                                                      false;
                                                                  imagesPath
                                                                      .clear();
                                                                });
                                                                if (homeController
                                                                        .category !=
                                                                    '4k Wallpaper') {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return StatefulBuilder(
                                                                        builder:
                                                                            (context,
                                                                                updateDialog) {
                                                                          return BackdropFilter(
                                                                            filter:
                                                                                ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                                                            child:
                                                                                Dialog(
                                                                              backgroundColor: Colors.transparent,
                                                                              child: Container(
                                                                                height: imagesPath.isEmpty ? height * 0.72 : height * 0.72,
                                                                                width: width * 2.8,
                                                                                padding: const EdgeInsets.symmetric(
                                                                                  vertical: 25,
                                                                                  horizontal: 25,
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.black,
                                                                                  border: Border.all(
                                                                                    color: Colors.white,
                                                                                    width: 3,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(
                                                                                    20,
                                                                                  ),
                                                                                ),
                                                                                child: Column(
                                                                                  children: [
                                                                                    const SizedBox(
                                                                                      height: 2,
                                                                                    ),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      children: [
                                                                                        GestureDetector(
                                                                                          child: const Icon(
                                                                                            Icons.close,
                                                                                            color: Colors.white,
                                                                                            size: 25,
                                                                                          ),
                                                                                          onTap: () {
                                                                                            Get.back();
                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      height: 5,
                                                                                    ),
                                                                                    const Text(
                                                                                      'Add Image',
                                                                                      style: TextStyle(height: 1.5, color: Colors.white, fontWeight: FontWeight.w600, fontSize: 25, fontFamily: "sfPro", letterSpacing: 2),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: Get.height * 0.008,
                                                                                    ),
                                                                                    Container(
                                                                                      height: 2,
                                                                                      width: width * 0.41,
                                                                                      color: Colors.yellow,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: Get.height * 0.04,
                                                                                    ),
                                                                                    imagesPath.isEmpty
                                                                                        ? GestureDetector(
                                                                                            onTap: () async {
                                                                                              await pickImage();
                                                                                              updateDialog.call(() {});
                                                                                            },
                                                                                            child: Container(
                                                                                              padding: EdgeInsets.symmetric(horizontal: width * 0.30, vertical: width * 0.16),
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.circular(
                                                                                                  10,
                                                                                                ),
                                                                                                color: Colors.white.withOpacity(
                                                                                                  0.10,
                                                                                                ),
                                                                                              ),
                                                                                              child: Stack(
                                                                                                alignment: Alignment.center,
                                                                                                children: [
                                                                                                  Image.asset(
                                                                                                    'assets/images/imag_picker.png',
                                                                                                    height: height * 0.1,
                                                                                                    width: height * 0.1,
                                                                                                  ),
                                                                                                  Stack(
                                                                                                    alignment: Alignment.bottomRight,
                                                                                                    children: [
                                                                                                      SizedBox(
                                                                                                        // color: Colors.red,
                                                                                                        height: height * 0.11,
                                                                                                        width: height * 0.11,
                                                                                                      ),
                                                                                                      Container(
                                                                                                        height: width * 0.09,
                                                                                                        width: width * 0.09,
                                                                                                        decoration: const BoxDecoration(
                                                                                                          color: Color(0xff55A1FF),
                                                                                                          shape: BoxShape.circle,
                                                                                                        ),
                                                                                                        alignment: Alignment.center,
                                                                                                        child: const Wrap(
                                                                                                          children: [
                                                                                                            Icon(
                                                                                                              Icons.add,
                                                                                                              color: Colors.white,
                                                                                                              size: 16,
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        : Padding(
                                                                                            padding: EdgeInsets.symmetric(horizontal: width * 0.15),
                                                                                            child: SizedBox(
                                                                                              height: sizingInformation.isDesktop ? height * 0.24 : height * 0.14,
                                                                                              child: ListView.separated(
                                                                                                separatorBuilder: (context, index) {
                                                                                                  return const SizedBox(
                                                                                                    width: 20,
                                                                                                  );
                                                                                                },
                                                                                                itemCount: imagesPath.length,
                                                                                                physics: const ClampingScrollPhysics(),
                                                                                                scrollDirection: Axis.horizontal,
                                                                                                itemBuilder: (context, index) {
                                                                                                  return Stack(
                                                                                                    alignment: Alignment.topRight,
                                                                                                    children: [
                                                                                                      Container(
                                                                                                        decoration: BoxDecoration(
                                                                                                          borderRadius: BorderRadius.circular(
                                                                                                            8,
                                                                                                          ),
                                                                                                          border: Border.all(color: Colors.white, width: 1),
                                                                                                        ),
                                                                                                        child: ClipRRect(
                                                                                                          borderRadius: BorderRadius.circular(
                                                                                                            8,
                                                                                                          ),
                                                                                                          child: Image.memory(
                                                                                                            Uint8List.fromList(imagesPath[index]),
                                                                                                            width: width * 0.8,
                                                                                                            height: height * 0.23,
                                                                                                            fit: BoxFit.cover,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      GestureDetector(
                                                                                                        child: Container(
                                                                                                          alignment: Alignment.center,
                                                                                                          height: width * 0.12,
                                                                                                          width: width * 0.12,
                                                                                                          child: Container(
                                                                                                            alignment: Alignment.center,
                                                                                                            height: width * 0.09,
                                                                                                            width: width * 0.09,
                                                                                                            decoration: BoxDecoration(
                                                                                                              color: Colors.black,
                                                                                                              borderRadius: BorderRadius.circular(
                                                                                                                5,
                                                                                                              ),
                                                                                                            ),
                                                                                                            child: const Icon(
                                                                                                              Icons.close,
                                                                                                              color: Color(0xffFFD800),
                                                                                                              size: 13,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        onTap: () {
                                                                                                          imagesPath.removeAt(index);
                                                                                                          updateDialog.call(
                                                                                                            () {},
                                                                                                          );

                                                                                                        },
                                                                                                      ),
                                                                                                    ],
                                                                                                  );
                                                                                                },
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                    SizedBox(
                                                                                      height: Get.height * 0.05,
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        if (widget.isAdmin!) {
                                                                                          setState(() {

                                                                                            if( imagesPath.isNotEmpty){

                                                                                              imagesPath.forEach((element) async {
                                                                                                await homeController.uploadImage(element);
                                                                                              });

                                                                                              // homeController.uploadImage(imageFile!.bytes!,);
                                                                                              homeController.isUploaded = true;
                                                                                              Get.back();
                                                                                            }

                                                                                            else {
                                                                                              Get.snackbar('Error', 'PLease select image!',colorText: Colors.white,backgroundColor: Colors.redAccent);
                                                                                            }

                                                                                          });

                                                                                        } else {
                                                                                          Get.back();
                                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                                            const SnackBar(
                                                                                              content: Text('This operation is not perform due to demo mode.'),
                                                                                              backgroundColor: Colors.black,
                                                                                            ),
                                                                                          );
                                                                                        }
                                                                                      },
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(
                                                                                          color: const Color(0xffFFD800),
                                                                                          borderRadius: BorderRadius.circular(23),
                                                                                        ),
                                                                                        width: width * 0.62,
                                                                                        height: height * 0.078,
                                                                                        alignment: Alignment.center,
                                                                                        child: const Text(
                                                                                          "Upload",
                                                                                          style: TextStyle(
                                                                                            fontSize: 18,
                                                                                            color: Colors.black,
                                                                                            fontWeight: FontWeight.w600,
                                                                                            fontFamily: 'sfBold',
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    // SizedBox(height: height * 0.02),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      );
                                                                    },
                                                                  );
                                                                } else {}
                                                              },
                                                              child: Container(
                                                                height: 60,
                                                                width: Get.width >
                                                                        1200
                                                                    ? width *
                                                                        0.9
                                                                    : width *
                                                                        0.7,
                                                                decoration: BoxDecoration(
                                                                    color: const Color(
                                                                        0xffFFD800),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Image.asset(
                                                                      'assets/icons/add.png',
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      "ADD",
                                                                      style: TextStyle(
                                                                          fontSize: Get.width > 1200
                                                                              ? 25
                                                                              : 20,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color:
                                                                              Colors.black),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        homeController.isDrop
                                                            ? SizedBox(
                                                                height: height *
                                                                    0.03)
                                                            : SizedBox(
                                                                height: height *
                                                                    0.13,
                                                              ),
                                                        Stack(
                                                          children: [
                                                            StreamBuilder(
                                                              stream: FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'category')
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  AsyncSnapshot<
                                                                          QuerySnapshot>
                                                                      snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  return Column(
                                                                      crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                      children: [
                                                                  SizedBox(
                                                                    height: sizingInformation.isDesktop && Get.height   >700
                                                                        ? height * 0.8
                                                                        : sizingInformation.isTablet
                                                                            ? height * 0.9
                                                                            : height * 0.6,
                                                                    child:
                                                                        ListView.builder(
                                                                      itemCount:
                                                                          snapshot.data?.docs.length ?? 0,
                                                                      itemBuilder:
                                                                          (context, index) {
                                                                        return snapshot.data?.docs[index]['name'] == homeController.category
                                                                            ? SizedBox(
                                                                                height: sizingInformation.isDesktop
                                                                                    ? height * 1
                                                                                    : sizingInformation.isTablet
                                                                                        ? height * 0.9
                                                                                        : height * 0.6,
                                                                                child: GridView.builder(
                                                                                  itemCount: snapshot.data?.docs[index]['image'].length ?? 0,
                                                                                  // itemCount: 10,
                                                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                                    crossAxisCount: sizingInformation.isDesktop || sizingInformation.isTablet ? 3 : 2,
                                                                                    crossAxisSpacing: sizingInformation.isDesktop ? Get.height * 0.06 : height * 0.02,
                                                                                    mainAxisSpacing: sizingInformation.isDesktop ? Get.height * 0.06 : height * 0.02,
                                                                                    childAspectRatio: 5 / 3,
                                                                                  ),
                                                                                  itemBuilder: (BuildContext context, int ind) {
                                                                                    return Stack(
                                                                                      alignment: FractionalOffset.topRight,
                                                                                      children: [
                                                                                        Stack(
                                                                                          children: [
                                                                                            Container(
                                                                                              clipBehavior: Clip.hardEdge,
                                                                                              height: width * 1,
                                                                                              width: width * 2,
                                                                                              decoration: BoxDecoration(
                                                                                                borderRadius: BorderRadius.circular(
                                                                                                  10,
                                                                                                ),
                                                                                              ),
                                                                                              child: FadeInImage.assetNetwork(

                                                                                                placeholder: 'assets/images/image_placeHolder.png',
                                                                                                image: snapshot.data?.docs[index]['image'][ind]['imageLink'],
                                                                                                fit: BoxFit.cover,
                                                                                              ),
                                                                                            ),
                                                                                            Container(
                                                                                              height: width * 1,
                                                                                              width: width * 2,
                                                                                              decoration: BoxDecoration(
                                                                                                border: Border.all(color: Colors.white, width: 2),
                                                                                                borderRadius: BorderRadius.circular(
                                                                                                  10,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),

                                                                                        GestureDetector(
                                                                                          child: Container(
                                                                                            alignment: Alignment.center,
                                                                                            width:  Get.width > 1500?60 :( Get.width <=1500 && Get.width > 1400) ? 50 : 40,
                                                                                            height: Get.width > 1500?60 :( Get.width <=1500 && Get.width > 1400) ? 50 : 40,
                                                                                            child: Image.asset(
                                                                                              'assets/icons/delete_image.png',
                                                                                              width: Get.width >1500 ?30: 20,
                                                                                              height: Get.width >1500 ?30: 20,
                                                                                            ),
                                                                                          ),
                                                                                          onTap: () {


                                                                                            showDialog(
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                return BackdropFilter(
                                                                                                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                                                                                  child: Dialog(
                                                                                                    backgroundColor: Colors.transparent,
                                                                                                    child: Container(
                                                                                                      height: height * 0.7,
                                                                                                      width: width * 2.8,
                                                                                                      padding: const EdgeInsets.symmetric(
                                                                                                        vertical: 30,
                                                                                                        horizontal: 30,
                                                                                                      ),
                                                                                                      decoration: BoxDecoration(
                                                                                                        color: Colors.black,
                                                                                                        border: Border.all(
                                                                                                          color: Colors.white,
                                                                                                          width: 3,
                                                                                                        ),
                                                                                                        borderRadius: BorderRadius.circular(
                                                                                                          20,
                                                                                                        ),
                                                                                                      ),
                                                                                                      child: Column(
                                                                                                        children: [
                                                                                                          const SizedBox(
                                                                                                            height: 2,
                                                                                                          ),
                                                                                                          Expanded(
                                                                                                            child: Row(
                                                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                                                              children: [
                                                                                                                GestureDetector(
                                                                                                                  child: const Icon(
                                                                                                                    Icons.close,
                                                                                                                    color: Colors.white,
                                                                                                                    size: 30,
                                                                                                                  ),
                                                                                                                  onTap: () {
                                                                                                                    Get.back();
                                                                                                                  },
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          const SizedBox(
                                                                                                            height: 10,
                                                                                                          ),
                                                                                                          Stack(
                                                                                                            alignment: Alignment.center,
                                                                                                            children: [
                                                                                                              Container(
                                                                                                                height: height * 0.14,
                                                                                                                width: height * 0.14,
                                                                                                                decoration: const BoxDecoration(
                                                                                                                  color: Colors.red,
                                                                                                                  shape: BoxShape.circle,
                                                                                                                ),
                                                                                                              ),
                                                                                                              Image.asset(
                                                                                                                'assets/icons/delete.png',
                                                                                                                height: height * 0.07,
                                                                                                                width: height * 0.07,
                                                                                                                fit: BoxFit.fill,
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                          Expanded(
                                                                                                            child: SizedBox(
                                                                                                              height: Get.height * 0.035,
                                                                                                            ),
                                                                                                          ),
                                                                                                          const SizedBox(
                                                                                                            width: 500,
                                                                                                            child: Text(
                                                                                                              'Are you sure want to delete this image?',
                                                                                                              style: TextStyle(
                                                                                                                height: 1.5,
                                                                                                                color: Colors.white,
                                                                                                                fontWeight: FontWeight.w500,
                                                                                                                fontSize: 30,
                                                                                                                fontFamily: "sfPro",
                                                                                                              ),
                                                                                                              textAlign: TextAlign.center,
                                                                                                            ),
                                                                                                          ),
                                                                                                          Expanded(
                                                                                                            child: SizedBox(
                                                                                                              height: Get.height * 0.035,
                                                                                                            ),
                                                                                                          ),

                                                                                                          Expanded(
                                                                                                            child: Row(
                                                                                                              mainAxisAlignment:
                                                                                                              MainAxisAlignment
                                                                                                                  .center,
                                                                                                              children: [
                                                                                                                GestureDetector(
                                                                                                                  onTap:
                                                                                                                      () {
                                                                                                                    if (widget.isAdmin!) {
                                                                                                                      setState(() {
                                                                                                                        homeController.removeItemAtIndex(snapshot.data?.docs[index].id, snapshot.data?.docs[index]['image'], ind);
                                                                                                                      });
                                                                                                                      Get.back();
                                                                                                                    } else {
                                                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                                                        const SnackBar(
                                                                                                                          content: Text('This operation is not perform due to demo mode.'),
                                                                                                                          backgroundColor: Colors.black,
                                                                                                                        ),
                                                                                                                      );
                                                                                                                    }
                                                                                                                  },
                                                                                                                  child:
                                                                                                                  Container(
                                                                                                                    decoration: BoxDecoration(
                                                                                                                        color: const Color(0xffFFD800),
                                                                                                                        borderRadius: BorderRadius.circular(
                                                                                                                          10,
                                                                                                                        ),
                                                                                                                        border: Border.all(color: const Color(0xffFFD800), width: 1)),
                                                                                                                    width:
                                                                                                                    width * 0.7,
                                                                                                                    height:
                                                                                                                    height * 0.09,
                                                                                                                    alignment:
                                                                                                                    Alignment.center,
                                                                                                                    child:
                                                                                                                    const Text(
                                                                                                                      "Yes",
                                                                                                                      style:
                                                                                                                      TextStyle(
                                                                                                                        fontSize: 22,
                                                                                                                        fontFamily: 'sfBold',
                                                                                                                        color: Colors.black,
                                                                                                                        fontWeight: FontWeight.w600,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),

                                                                                                                const SizedBox(
                                                                                                                  width:
                                                                                                                  20,
                                                                                                                ),
                                                                                                                GestureDetector(
                                                                                                                  onTap:
                                                                                                                      () {
                                                                                                                    setState(
                                                                                                                            () {
                                                                                                                          Get.back();
                                                                                                                        });
                                                                                                                  },
                                                                                                                  child:
                                                                                                                  Container(
                                                                                                                    decoration: BoxDecoration(
                                                                                                                        color: Colors.transparent,
                                                                                                                        borderRadius: BorderRadius.circular(
                                                                                                                          10,
                                                                                                                        ),
                                                                                                                        border: Border.all(color: const Color(0xffFFD800), width: 1)),
                                                                                                                    width:
                                                                                                                    width * 0.7,
                                                                                                                    height:
                                                                                                                    height * 0.09,
                                                                                                                    alignment:
                                                                                                                    Alignment.center,
                                                                                                                    child:
                                                                                                                    const Text(
                                                                                                                      "No",
                                                                                                                      style:
                                                                                                                      TextStyle(
                                                                                                                        fontSize: 22,
                                                                                                                        fontWeight: FontWeight.w600,
                                                                                                                        color: Colors.white,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),

                                                                                                              ],
                                                                                                            ),
                                                                                                          ),

                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                              },
                                                                                            );

                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              )
                                                                            : const SizedBox();
                                                                      },
                                                                    ),
                                                                  )
                                                                      ],
                                                                    );
                                                                }
                                                                if (snapshot
                                                                    .hasError) {
                                                                  return const SizedBox();
                                                                } else {
                                                                  return const Center(
                                                                      child:
                                                                          CircularProgressIndicator());
                                                                }
                                                              },
                                                            ),
                                                            (homeController
                                                                    .isDrop)
                                                                ? BackdropFilter(
                                                                    filter: ImageFilter.blur(
                                                                        sigmaX:
                                                                            20,
                                                                        sigmaY:
                                                                            20),
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              StreamBuilder(
                                                                            stream:
                                                                                FirebaseFirestore.instance.collection('category').snapshots(),
                                                                            builder:
                                                                                (context, AsyncSnapshot<QuerySnapshot> stream) {
                                                                              if (stream.hasData) {
                                                                                return Container(
                                                                                  height: Get.height * 0.4,
                                                                                    width: Get.width,
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(10),
                                                                                      color: Colors.white.withOpacity(0.16),
                                                                                    ),
                                                                                    child: SizedBox(
                                                                                      height: Get.height * 0.4,
                                                                                      child: ListView.separated(
                                                                                        shrinkWrap: true,
                                                                                        itemCount: stream.data?.docs.length ?? 0,
                                                                                        // itemCount: 2,
                                                                                        separatorBuilder: (context, index) {
                                                                                          return Padding(
                                                                                            padding: EdgeInsets.only(
                                                                                              left: width * 0.1,
                                                                                              right: width * 0.1,
                                                                                            ),
                                                                                            child: Container(
                                                                                              height: 1,
                                                                                              color: Colors.white.withOpacity(0.5),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                        itemBuilder: (context, index) {
                                                                                          return Column(
                                                                                            children: [
                                                                                              InkWell(
                                                                                                onTap: () {
                                                                                                  setState(() {
                                                                                                    homeController.category = stream.data?.docs[index]['name'];
                                                                                                    homeController.selectedCategory = stream.data!.docs[index].id;
                                                                                                    homeController.lengthOfImage = stream.data?.docs[index]['image'].length;
                                                                                                    homeController.isDrop = false;
                                                                                                  });
                                                                                                },
                                                                                                child: Container(
                                                                                                  height: height * 0.1,
                                                                                                  decoration: BoxDecoration(
                                                                                                      borderRadius: (index == 0)
                                                                                                          ? const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                                                                                                          : (index == (stream.data!.docs.length - 1))
                                                                                                              ? const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                                                                                                              : BorderRadius.circular(0),
                                                                                                      color: (homeController.category == stream.data?.docs[index]['name']) ? const Color(0xffFFD800) : Colors.transparent),
                                                                                                  child: Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                                    children: [
                                                                                                      SizedBox(width: width * 0.1),
                                                                                                      Padding(
                                                                                                        padding: EdgeInsets.only(left: width * 0.1),
                                                                                                        child: Text(
                                                                                                          stream.data?.docs[index]['name'],
                                                                                                          style: (homeController.category == stream.data?.docs[index]['name'])
                                                                                                              ? const TextStyle(
                                                                                                                  color: Color(0xff000000),
                                                                                                                  fontWeight: FontWeight.w900,
                                                                                                                  fontSize: 22,
                                                                                                                  letterSpacing: 1,
                                                                                                                  fontFamily: "sfBold",
                                                                                                                )
                                                                                                              : const TextStyle(
                                                                                                                  color: Colors.white,
                                                                                                                  fontWeight: FontWeight.w800,
                                                                                                                  fontSize: 20,
                                                                                                                  letterSpacing: 1,
                                                                                                                  fontFamily: "sfBold",
                                                                                                                ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ],
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                    ));
                                                                              }
                                                                              if (stream.hasError) {
                                                                                return const SizedBox();
                                                                              } else {
                                                                                return const Center(child: CircularProgressIndicator());
                                                                              }
                                                                            },
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              Get.width * 0.06,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              50,
                                                                          width:
                                                                              width * 0.7,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : const SizedBox(),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                if (homeController
                                                                    .isDrop) {
                                                                  homeController
                                                                          .isDrop =
                                                                      false;
                                                                } else {
                                                                  homeController
                                                                          .isDrop =
                                                                      true;
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                              height: sizingInformation
                                                                      .isDesktop
                                                                  ? 60
                                                                  : 40,
                                                              decoration: BoxDecoration(
                                                                  color: const Color(
                                                                      0xffFFD800),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width:
                                                                        width *
                                                                            0.18,
                                                                  ),
                                                                  Text(
                                                                    homeController
                                                                        .category,
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Color(
                                                                          0xff000000),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      letterSpacing:
                                                                          1,
                                                                      fontSize:
                                                                          22,
                                                                      fontFamily:
                                                                          "sfBold",
                                                                    ),
                                                                  ),
                                                                  const Spacer(),
                                                                  Image.asset(
                                                                    'assets/icons/arrowDown.png',
                                                                    height:
                                                                        height *
                                                                            0.028,
                                                                    width:
                                                                        height *
                                                                            0.028,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                  SizedBox(
                                                                    width: Get.width >
                                                                            1200
                                                                        ? width *
                                                                            0.3
                                                                        : width *
                                                                            0.1,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              Get.width * 0.06,
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              sizingInformation
                                                                      .isDesktop
                                                                  ? 50
                                                                  : 40,
                                                          width: width * 0.7,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        homeController.isCategory
                            ? SizedBox(
                                width: Get.width > 1550
                                    ? widthM * 0.17
                                    : (Get.width > 1366 && Get.width < 1550)
                                        ? widthM * 0.1
                                        : widthM * 0.05)
                            : SizedBox(
                                width: Get.width * 0.05,
                              ),
                      ],
                    )
                  :  Row(
                children: [

                  Expanded(

                    child: Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: width * 0.15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height:
                            sizingInformation.isMobile?Get.height * 0.06:     MediaQuery
                                .of(context)
                                .size
                                .height * 0.12,
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 20),
                              Visibility(
                                visible:  Get.width <= 650,
                                child: GestureDetector(
                                  onTap: () {
                                    _scaffoldKey.currentState?.openDrawer();
                                  },
                                  child: Container(
                                    height: sizingInformation.isDesktop
                                        ? 50
                                        : 40,
                                    width: width * 0.7,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffFFD800),
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.menu),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Menu",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              homeController.isCategory
                                  ? GestureDetector(
                                onTap: () {
                                  homeController.categoryController
                                      .clear();
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 2, sigmaY: 2),
                                        child: Dialog(
                                          backgroundColor:
                                          Colors.transparent,
                                          child: Container(
                                            height:  sizingInformation.isMobile? height * 0.55 : height * 0.48,
                                            width: width * 2,
                                            padding: const EdgeInsets
                                                .symmetric(
                                              vertical: 10,
                                              horizontal: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                20,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 2,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .end,
                                                  children: [
                                                    GestureDetector(
                                                      child:
                                                      const Icon(
                                                        Icons.close,
                                                        color: Colors
                                                            .white,
                                                        size: 20,
                                                      ),
                                                      onTap: () {
                                                        Get.back();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  'Add category',
                                                  style: TextStyle(
                                                      height: 1.5,
                                                      color: Colors
                                                          .white,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600,
                                                      fontSize:
                                                      textHeight *
                                                          0.04,
                                                      fontFamily:
                                                      "sfPro",
                                                      letterSpacing:
                                                      2),
                                                ),
                                                SizedBox(
                                                  height: Get.height *
                                                      0.008,
                                                ),
                                                Container(
                                                  height: 1,
                                                  width: width * 0.3,
                                                  color:
                                                  Colors.yellow,
                                                ),
                                                SizedBox(
                                                  height: Get.height *
                                                      0.04,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    const Text(
                                                      "Category name",
                                                      style:
                                                      TextStyle(
                                                        fontFamily:
                                                        "sfPro",
                                                        color: Colors
                                                            .white,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                      Get.height *
                                                          0.02,
                                                    ),
                                                    Container(
                                                      height: height *
                                                          0.06,
                                                      width:
                                                      width * 1.3,
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                          5,
                                                        ),
                                                        border: Border
                                                            .all(
                                                            color: Colors
                                                                .white
                                                                .withOpacity(
                                                              0.65,
                                                            ),
                                                            width:
                                                            border),
                                                      ),
                                                      child:
                                                      TextField(
                                                        controller:
                                                        homeController
                                                            .categoryController,
                                                        style:
                                                        const TextStyle(
                                                          fontFamily:
                                                          "sfPro",
                                                          color: Colors
                                                              .white,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                        ),
                                                        decoration:
                                                        InputDecoration(
                                                          border:
                                                          InputBorder
                                                              .none,
                                                          contentPadding:
                                                          EdgeInsets
                                                              .only(
                                                            left: width *
                                                                0.08,
                                                            bottom: height *
                                                                0.023,
                                                          ),
                                                          hintStyle:
                                                          TextStyle(
                                                            fontFamily:
                                                            "sfPro",
                                                            color: Colors
                                                                .white
                                                                .withOpacity(
                                                                0.6),
                                                            fontWeight:
                                                            FontWeight
                                                                .w500,
                                                          ),
                                                          hintText:
                                                          'enter category name',
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: Get.height *
                                                      0.05,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {

                                                      if (homeController
                                                          .categoryController
                                                          .text
                                                          .isNotEmpty) {
                                                        if (widget
                                                            .isAdmin!) {

                                                          homeController
                                                              .categoryName
                                                              .add(homeController.categoryController.text);
                                                          homeController.onTapCategoryUpload(homeController
                                                              .categoryController
                                                              .text);



                                                          Get.back();
                                                        } else {
                                                          Get.back();
                                                          ScaffoldMessenger.of(
                                                              context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                              content:
                                                              Text('This operation is not perform due to demo mode.'),
                                                              backgroundColor:
                                                              Colors.black,
                                                            ),
                                                          );
                                                        }
                                                      } else {
                                                        Get.back();
                                                        Get.snackbar(
                                                            'Invalid',
                                                            "Category name can't be empty",backgroundColor: Colors.redAccent,colorText: Colors.white);
                                                      }
                                                      homeController
                                                          .categoryController
                                                          .clear();
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration:
                                                    BoxDecoration(
                                                      color: const Color(
                                                          0xffFFD800),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                        15,
                                                      ),
                                                    ),
                                                    width:
                                                    width * 0.6,
                                                    height:
                                                    height * 0.07,
                                                    alignment:
                                                    Alignment
                                                        .center,
                                                    child: Text(
                                                      "Upload",
                                                      style:
                                                      TextStyle(
                                                        fontSize:
                                                        height *
                                                            0.025,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                  height * 0.02,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: sizingInformation.isDesktop
                                      ? 50
                                      : 40,
                                  width: width * 0.7,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffFFD800),
                                      borderRadius:
                                      BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/icons/add.png',
                                        height: 20,
                                        width: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        "ADD",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight:
                                            FontWeight.w600,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                              )
                                  : const SizedBox(),
                            ],
                          ),
                          SizedBox(
                            height:
                            MediaQuery
                                .of(context)
                                .size
                                .height * 0.1,
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: Get.width > 650,
                                  child: Container(
                                    margin: EdgeInsets.only(left: width * 0.1),
                                    padding:
                                    EdgeInsets.symmetric(horizontal: width * 0.2),
                                    height: 300,
                                    width: width,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: const Color(0xffFFD800), width: 1),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                homeController.isImages = false;
                                                homeController.isLogout = false;
                                                homeController.isCategory = true;
                                              });
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/category.png",
                                                  height: 20,
                                                  width: 20,
                                                  color: homeController.isCategory
                                                      ? const Color(0xffFFD800)
                                                      : Colors.white,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                const Text(
                                                  "Categories",
                                                  style: TextStyle(
                                                      fontSize: 15, color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 1,
                                          child: Divider(
                                            height: 0.5,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                homeController.isCategory = false;
                                                homeController.isLogout = false;
                                                homeController.isImages = true;
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/icons/images.png",
                                                  height: 20,
                                                  width: 20,
                                                  color: homeController.isImages
                                                      ? const Color(0xffFFD800)
                                                      : Colors.white,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                const Text(
                                                  "Images",
                                                  style: TextStyle(
                                                      fontSize: 15, color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          flex: 1,
                                          child: Divider(
                                            height: 0.5,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {});
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 2, sigmaY: 2),
                                                    child: Dialog(
                                                      backgroundColor: Colors.transparent,
                                                      child: Container(
                                                        height: height * 0.45,
                                                        width: width * 2,
                                                        padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 10,
                                                          horizontal: 10,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          border: Border.all(
                                                            color: Colors.white,
                                                            width: 3,
                                                          ),
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 2,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.end,
                                                              children: [
                                                                GestureDetector(
                                                                  child: const Icon(
                                                                    Icons.close,
                                                                    color: Colors.white,
                                                                    size: 20,
                                                                  ),
                                                                  onTap: () {
                                                                    Get.back();
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: Get.height * 0.04,
                                                            ),
                                                            Image.asset(
                                                              'assets/icons/logout.png',
                                                              height: height * 0.07,
                                                              width: width * 0.6,
                                                            ),
                                                            SizedBox(
                                                              height: Get.height * 0.02,
                                                            ),
                                                            Text(
                                                              'Are you sure want to logout?',
                                                              style: TextStyle(
                                                                height: 1.5,
                                                                color: Colors.white,
                                                                fontWeight:
                                                                FontWeight.w500,
                                                                fontSize:
                                                                textHeight * 0.04,
                                                                fontFamily: "sfPro",
                                                              ),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                            SizedBox(
                                                              height: Get.height * 0.03,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap:
                                                                      () {
                                                                    setState(
                                                                            () {
                                                                          Get.back();
                                                                          Get.to(const AdminPanelScreen());
                                                                        });
                                                                  },
                                                                  child:
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                        color: const Color(0xffFFD800),
                                                                        borderRadius: BorderRadius.circular(
                                                                          10,
                                                                        ),
                                                                        border: Border.all(color: const Color(0xffFFD800), width: 1)),
                                                                    width:
                                                                    width * 0.8,
                                                                    height:
                                                                    height * 0.07,
                                                                    alignment:
                                                                    Alignment.center,
                                                                    child:
                                                                    const Text(
                                                                      "Yes",
                                                                      style:
                                                                      TextStyle(
                                                                        fontSize: 22,
                                                                        fontFamily: 'sfBold',
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),

                                                                const SizedBox(
                                                                  width:
                                                                  20,
                                                                ),
                                                                GestureDetector(
                                                                  onTap:
                                                                      () {
                                                                    setState(
                                                                            () {
                                                                          Get.back();
                                                                        });
                                                                  },
                                                                  child:
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.transparent,
                                                                        borderRadius: BorderRadius.circular(
                                                                          10,
                                                                        ),
                                                                        border: Border.all(color: const Color(0xffFFD800), width: 1)),
                                                                    width:
                                                                    width * 0.8,
                                                                    height:
                                                                    height * 0.07,
                                                                    alignment:
                                                                    Alignment.center,
                                                                    child:
                                                                    const Text(
                                                                      "No",
                                                                      style:
                                                                      TextStyle(
                                                                        fontSize: 22,
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors.white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: height * 0.02,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/icons/signout.png",
                                                  height: 20,
                                                  width: 20,
                                                  color: homeController.isLogout
                                                      ? const Color(0xffFFD800)
                                                      : Colors.white,
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                const Text(
                                                  "Log out",
                                                  style: TextStyle(
                                                      fontSize: 15, color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20,),
                                homeController.isCategory
                                    ? Expanded(
                                  child: Container(
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(15),
                                    ),
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('category')
                                          .snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<QuerySnapshot>
                                          streamSnapshot) {
                                        if (streamSnapshot.hasData) {
                                          return SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                streamSnapshot.data?.docs
                                                    .length !=
                                                    0
                                                    ? Row(

                                                  children: [
                                                    Expanded(
                                                      child:
                                                      Container(
                                                        alignment:
                                                        Alignment
                                                            .center,
                                                        height: 60,
                                                        decoration:
                                                        const BoxDecoration(
                                                          color: Color(
                                                              0xffFFD800),
                                                          border: Border
                                                              .fromBorderSide(
                                                            BorderSide(
                                                                color: Color(
                                                                    0xff1A1A1A),
                                                                width:
                                                                0.5),
                                                          ),
                                                        ),
                                                        child:
                                                        const Text(
                                                          "Categories",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                              fontSize:
                                                              20,
                                                              color: Colors
                                                                  .black),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child:
                                                      Container(
                                                        alignment:
                                                        Alignment
                                                            .center,
                                                        height: 60,
                                                        decoration:
                                                        const BoxDecoration(
                                                          color: Color(
                                                              0xffFFD800),
                                                          border: Border
                                                              .fromBorderSide(
                                                            BorderSide(
                                                                color: Color(
                                                                    0xff1A1A1A),
                                                                width:
                                                                0.5),
                                                          ),
                                                        ),
                                                        child:
                                                        const Text(
                                                          "Action",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                              fontSize:
                                                              20,
                                                              color: Colors
                                                                  .black),
                                                        ),
                                                      ),
                                                    ),
                                                  ],

                                                )
                                                    : const SizedBox(),
                                                Container(
                                                  height :  sizingInformation.isMobile? Get.height * 0.6 : Get.height * 0.3,
                                                  decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15,),bottomRight: Radius.circular(15),),border: Border.all(color: Colors.white,width: 0.8,),

                                                  ),

                                                  child: ListView.separated(
                                                    separatorBuilder: (context, index) {
                                                      return const Divider(

                                                        height: 0,color: Colors.white,thickness: 1,             );
                                                    },
                                                    itemCount: streamSnapshot
                                                        .data
                                                        ?.docs
                                                        .length ??
                                                        0,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return SizedBox(
                                                        height: 55,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                              Container(
                                                                alignment:
                                                                Alignment
                                                                    .center,
                                                                decoration:
                                                                const BoxDecoration(
                                                                  color: Color(
                                                                      0xff1A1A1A),

                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width : Get.width * 0.09,
                                                                    ),
                                                                    Text(
                                                                      "${streamSnapshot.data
                                                                          ?.docs[index]['name']}",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                          17,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                          FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Container(color: Colors.white,width: 0.5,),
                                                            Expanded(
                                                              child:
                                                              Container(
                                                                height: 55,
                                                                decoration:
                                                                const BoxDecoration(
                                                                  color: Color(
                                                                      0xff1A1A1A),

                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                      GestureDetector(
                                                                        child:
                                                                        Container(
                                                                          height:
                                                                          55,
                                                                          decoration:
                                                                          const BoxDecoration(
                                                                            color: Color(
                                                                                0xff1A1A1A),

                                                                          ),
                                                                          child:
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment
                                                                                .center,
                                                                            children: [
                                                                              Image.asset(
                                                                                'assets/icons/edit.png',
                                                                                height: 17,
                                                                                width: 17,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              const Text(
                                                                                "Edit",
                                                                                style: TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight
                                                                                        .w400,
                                                                                    color: Colors
                                                                                        .white),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          homeController
                                                                              .editingController
                                                                              .text =
                                                                          streamSnapshot
                                                                              .data
                                                                              ?.docs[index]['name'];

                                                                          showDialog(
                                                                            context: context,
                                                                            builder: (
                                                                                context) {
                                                                              return BackdropFilter(
                                                                                filter: ImageFilter
                                                                                    .blur(
                                                                                    sigmaX: 2,
                                                                                    sigmaY: 2),
                                                                                child: Dialog(
                                                                                  backgroundColor: Colors
                                                                                      .transparent,
                                                                                  child: Container(
                                                                                    height: height *
                                                                                        0.5,
                                                                                    width: width *
                                                                                        2,
                                                                                    padding: const EdgeInsets
                                                                                        .symmetric(
                                                                                      vertical: 10,
                                                                                      horizontal: 10,
                                                                                    ),
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors
                                                                                          .black,
                                                                                      border: Border
                                                                                          .all(
                                                                                        color: Colors
                                                                                            .white,
                                                                                        width: 2,
                                                                                      ),
                                                                                      borderRadius: BorderRadius
                                                                                          .circular(
                                                                                        20,
                                                                                      ),
                                                                                    ),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        const SizedBox(
                                                                                          height: 2,
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment
                                                                                              .end,
                                                                                          children: [
                                                                                            GestureDetector(
                                                                                              child: const Icon(
                                                                                                Icons
                                                                                                    .close,
                                                                                                color: Colors
                                                                                                    .white,
                                                                                                size: 20,
                                                                                              ),
                                                                                              onTap: () {
                                                                                                Get
                                                                                                    .back();
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        Text(
                                                                                          'Edit Name',
                                                                                          style: TextStyle(
                                                                                              height: 1.5,
                                                                                              color: Colors
                                                                                                  .white,
                                                                                              fontWeight: FontWeight
                                                                                                  .w600,
                                                                                              fontSize: textHeight *
                                                                                                  0.04,
                                                                                              fontFamily: "sfPro",
                                                                                              letterSpacing: 2),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: Get
                                                                                              .height *
                                                                                              0.008,
                                                                                        ),
                                                                                        Container(
                                                                                          height: 1,
                                                                                          width: width *
                                                                                              0.3,
                                                                                          color: Colors
                                                                                              .yellow,
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: Get
                                                                                              .height *
                                                                                              0.04,
                                                                                        ),
                                                                                        Container(
                                                                                          height: height *
                                                                                              0.08,
                                                                                          width: width *
                                                                                              1.3,
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: BorderRadius
                                                                                                .circular(
                                                                                              5,
                                                                                            ),
                                                                                            border: Border
                                                                                                .all(
                                                                                                color: Colors
                                                                                                    .white
                                                                                                    .withOpacity(
                                                                                                  0.65,
                                                                                                ),
                                                                                                width: border),
                                                                                          ),
                                                                                          child: TextField(
                                                                                            controller: homeController
                                                                                                .editingController,
                                                                                            style: const TextStyle(
                                                                                              fontFamily: "sfPro",
                                                                                              color: Colors
                                                                                                  .white,
                                                                                              fontWeight: FontWeight
                                                                                                  .w500,
                                                                                            ),
                                                                                            decoration: InputDecoration(
                                                                                              border: InputBorder
                                                                                                  .none,
                                                                                              contentPadding: EdgeInsets
                                                                                                  .only(
                                                                                                left: width *
                                                                                                    0.18,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: Get
                                                                                              .height *
                                                                                              0.05,
                                                                                        ),
                                                                                        GestureDetector(
                                                                                          onTap: () {
                                                                                            setState(() {
                                                                                              if (homeController.editingController.text.isNotEmpty) {
                                                                                                if (widget.isAdmin!) {
                                                                                                  homeController.onTapCategoryEdit(homeController.editingController.text, streamSnapshot.data?.docs[index].id, streamSnapshot.data?.docs[index]['image']);
                                                                                                  Get.back();
                                                                                                } else {
                                                                                                  Get.back();
                                                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                                                    const SnackBar(
                                                                                                      content: Text('This operation is not perform due to demo mode.'),
                                                                                                      backgroundColor: Colors.black,
                                                                                                    ),
                                                                                                  );
                                                                                                }
                                                                                              } else {
                                                                                                Get.snackbar('Invalid', "Category name can't be empty",backgroundColor: Colors.red,colorText: Colors.white);
                                                                                              }
                                                                                            });
                                                                                          },
                                                                                          child: Container(
                                                                                            decoration: BoxDecoration(
                                                                                              color: const Color(
                                                                                                  0xffFFD800),
                                                                                              borderRadius: BorderRadius
                                                                                                  .circular(
                                                                                                10,
                                                                                              ),
                                                                                            ),
                                                                                            width: width *
                                                                                                0.5,
                                                                                            height: height *
                                                                                                0.07,
                                                                                            alignment: Alignment
                                                                                                .center,
                                                                                            child: Text(
                                                                                              "Done",
                                                                                              style: TextStyle(
                                                                                                fontSize: height *
                                                                                                    0.025,
                                                                                                fontWeight: FontWeight
                                                                                                    .w600,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: height *
                                                                                              0.02,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                    Container(color: Colors.white,width: 0.5,),
                                                                    Expanded(
                                                                      child:
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          showDialog(
                                                                            context: context,
                                                                            builder: (
                                                                                context) {
                                                                              return BackdropFilter(
                                                                                filter: ImageFilter
                                                                                    .blur(
                                                                                    sigmaX: 2,
                                                                                    sigmaY: 2),
                                                                                child: Dialog(
                                                                                  backgroundColor: Colors
                                                                                      .transparent,
                                                                                  child: Container(
                                                                                    height: height *
                                                                                        0.5,
                                                                                    width: width *
                                                                                        2,
                                                                                    padding: const EdgeInsets
                                                                                        .symmetric(
                                                                                      vertical: 10,
                                                                                      horizontal: 10,
                                                                                    ),
                                                                                    decoration: BoxDecoration(
                                                                                      color: Colors
                                                                                          .black,
                                                                                      border: Border
                                                                                          .all(
                                                                                        color: Colors
                                                                                            .white,
                                                                                        width: 3,
                                                                                      ),
                                                                                      borderRadius: BorderRadius
                                                                                          .circular(
                                                                                        20,
                                                                                      ),
                                                                                    ),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        const SizedBox(
                                                                                          height: 2,
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment
                                                                                              .end,
                                                                                          children: [
                                                                                            GestureDetector(
                                                                                              child: const Icon(
                                                                                                Icons
                                                                                                    .close,
                                                                                                color: Colors
                                                                                                    .white,
                                                                                                size: 20,
                                                                                              ),
                                                                                              onTap: () {
                                                                                                Get
                                                                                                    .back();
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        Stack(
                                                                                          alignment: Alignment
                                                                                              .center,
                                                                                          children: [
                                                                                            Container(
                                                                                              height: height *
                                                                                                  0.13,
                                                                                              width: height *
                                                                                                  0.13,
                                                                                              decoration: const BoxDecoration(
                                                                                                color: Colors
                                                                                                    .red,
                                                                                                shape: BoxShape
                                                                                                    .circle,
                                                                                              ),
                                                                                            ),
                                                                                            Image
                                                                                                .asset(
                                                                                              'assets/icons/delete.png',
                                                                                              height: height *
                                                                                                  0.08,
                                                                                              width: height *
                                                                                                  0.08,
                                                                                              fit: BoxFit
                                                                                                  .fill,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: Get
                                                                                              .height *
                                                                                              0.02,
                                                                                        ),
                                                                                        Text(
                                                                                          'Are you sure want to delete ${streamSnapshot
                                                                                              .data
                                                                                              ?.docs[index]['name']} Category?',
                                                                                          style: TextStyle(
                                                                                            height: 1.5,
                                                                                            color: Colors
                                                                                                .white,
                                                                                            fontWeight: FontWeight
                                                                                                .w500,
                                                                                            fontSize: textHeight *
                                                                                                0.04,
                                                                                            fontFamily: "sfPro",
                                                                                          ),
                                                                                          textAlign: TextAlign
                                                                                              .center,
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: Get
                                                                                              .height *
                                                                                              0.03,
                                                                                        ),

                                                                                        Row(
                                                                                          mainAxisAlignment:
                                                                                          MainAxisAlignment
                                                                                              .center,
                                                                                          children: [
                                                                                            GestureDetector(
                                                                                              onTap:
                                                                                                  () {
                                                                                                if (widget
                                                                                                    .isAdmin!) {
                                                                                                  setState(() {
                                                                                                    homeController
                                                                                                        .onTapCategoryDelete(
                                                                                                        streamSnapshot
                                                                                                            .data
                                                                                                            ?.docs[index]
                                                                                                            .id);
                                                                                                    Get
                                                                                                        .back();
                                                                                                  });
                                                                                                } else {
                                                                                                  Get
                                                                                                      .back();
                                                                                                  ScaffoldMessenger
                                                                                                      .of(
                                                                                                      context)
                                                                                                      .showSnackBar(
                                                                                                    const SnackBar(
                                                                                                      content: Text(
                                                                                                          'This operation is not perform due to demo mode.'),
                                                                                                      backgroundColor: Colors
                                                                                                          .black,
                                                                                                    ),
                                                                                                  );
                                                                                                }
                                                                                              },
                                                                                              child:
                                                                                              Container(
                                                                                                decoration: BoxDecoration(
                                                                                                    color: const Color(0xffFFD800),
                                                                                                    borderRadius: BorderRadius.circular(
                                                                                                      10,
                                                                                                    ),
                                                                                                    border: Border.all(color: const Color(0xffFFD800), width: 1)),
                                                                                                width:
                                                                                                width * 0.7,
                                                                                                height:
                                                                                                height * 0.07,
                                                                                                alignment:
                                                                                                Alignment.center,
                                                                                                child:
                                                                                                const Text(
                                                                                                  "Yes",
                                                                                                  style:
                                                                                                  TextStyle(
                                                                                                    fontSize: 22,
                                                                                                    fontFamily: 'sfBold',
                                                                                                    color: Colors.black,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),

                                                                                            const SizedBox(
                                                                                              width:
                                                                                              20,
                                                                                            ),
                                                                                            GestureDetector(
                                                                                              onTap:
                                                                                                  () {
                                                                                                setState(
                                                                                                        () {
                                                                                                      Get.back();
                                                                                                    });
                                                                                              },
                                                                                              child:
                                                                                              Container(
                                                                                                decoration: BoxDecoration(
                                                                                                    color: Colors.transparent,
                                                                                                    borderRadius: BorderRadius.circular(
                                                                                                      10,
                                                                                                    ),
                                                                                                    border: Border.all(color: const Color(0xffFFD800), width: 1)),
                                                                                                width:
                                                                                                width * 0.7,
                                                                                                height:
                                                                                                height * 0.07,
                                                                                                alignment:
                                                                                                Alignment.center,
                                                                                                child:
                                                                                                const Text(
                                                                                                  "No",
                                                                                                  style:
                                                                                                  TextStyle(
                                                                                                    fontSize: 22,
                                                                                                    fontWeight: FontWeight.w600,
                                                                                                    color: Colors.white,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),

                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: height *
                                                                                              0.02,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          );
                                                                        },
                                                                        child:
                                                                        Container(
                                                                          height:
                                                                          55,
                                                                          decoration:
                                                                          const BoxDecoration(
                                                                            color: Color(
                                                                                0xff1A1A1A),

                                                                          ),
                                                                          child:
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment
                                                                                .center,
                                                                            children: [
                                                                              Image.asset(
                                                                                'assets/icons/delete.png',
                                                                                height: 17,
                                                                                width: 17,
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              const Text(
                                                                                "Delete",
                                                                                style: TextStyle(
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight
                                                                                        .w400,
                                                                                    color: Colors
                                                                                        .white),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else if (streamSnapshot
                                            .hasError) {
                                          return const SizedBox();
                                        } else {
                                          return const Center(
                                              child:
                                              CircularProgressIndicator());
                                        }
                                      },
                                    ),
                                  ),
                                )
                                    : Expanded(
                                  child: SingleChildScrollView(
                                    physics:
                                    const NeverScrollableScrollPhysics(),
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Visibility(
                                                    visible: homeController
                                                        .isDrop ==
                                                        false,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          if (homeController
                                                              .isDrop) {
                                                            homeController
                                                                .isDrop =
                                                            false;
                                                          } else {
                                                            homeController
                                                                .isDrop =
                                                            true;
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                        height:
                                                        40,

                                                        decoration: BoxDecoration(
                                                            color: const Color(
                                                                0xffFFD800),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                10)),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child:
                                                              SizedBox(
                                                                width:
                                                                width *
                                                                    0.18,
                                                              ),
                                                            ),
                                                            Text(
                                                              homeController
                                                                  .category,
                                                              style:
                                                              TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w800,
                                                                fontSize:
                                                                textHeight *
                                                                    0.03,
                                                                fontFamily:
                                                                "sfPro",
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            Image.asset(
                                                              'assets/icons/arrowDown.png',
                                                              height:
                                                              height *
                                                                  0.02,
                                                              width:
                                                              height *
                                                                  0.02,
                                                            ),
                                                            Expanded(
                                                              child:
                                                              SizedBox(
                                                                width:
                                                                width *
                                                                    0.3,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: Get.width * 0.02,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      homeController
                                                          .isUploaded =
                                                      false;
                                                      imagesPath.clear();
                                                    });
                                                    if (homeController
                                                        .category !=
                                                        'Select category') {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return StatefulBuilder(
                                                            builder: (context,
                                                                updateDialog) {
                                                              return BackdropFilter(
                                                                filter: ImageFilter
                                                                    .blur(
                                                                    sigmaX:
                                                                    20,
                                                                    sigmaY:
                                                                    20),
                                                                child:
                                                                Dialog(
                                                                  backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                                  child:
                                                                  Container(
                                                                    height: sizingInformation
                                                                        .isDesktop
                                                                        ? height *
                                                                        0.7
                                                                        : height *
                                                                        0.6,
                                                                    width: width *
                                                                        2.7,
                                                                    padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                      vertical:
                                                                      10,
                                                                      horizontal:
                                                                      10,
                                                                    ),
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      color:
                                                                      Colors.black,
                                                                      border:
                                                                      Border.all(
                                                                        color:
                                                                        Colors.white,
                                                                        width:
                                                                        2,
                                                                      ),
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                        20,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                    Column(
                                                                      children: [
                                                                        const SizedBox(
                                                                          height: 2,
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .end,
                                                                          children: [
                                                                            GestureDetector(
                                                                              child: const Icon(
                                                                                Icons
                                                                                    .close,
                                                                                color: Colors
                                                                                    .white,
                                                                                size: 20,
                                                                              ),
                                                                              onTap: () {
                                                                                Get
                                                                                    .back();
                                                                              },
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Text(
                                                                          'Add Image',
                                                                          style: TextStyle(
                                                                              height: 1.5,
                                                                              color: Colors
                                                                                  .white,
                                                                              fontWeight: FontWeight
                                                                                  .w600,
                                                                              fontSize: textHeight *
                                                                                  0.04,
                                                                              fontFamily: "sfPro",
                                                                              letterSpacing: 2),
                                                                        ),
                                                                        SizedBox(
                                                                          height: Get
                                                                              .height *
                                                                              0.008,
                                                                        ),
                                                                        Container(
                                                                          height: 1,
                                                                          width: width *
                                                                              0.3,
                                                                          color: Colors
                                                                              .yellow,
                                                                        ),
                                                                        SizedBox(
                                                                          height: Get
                                                                              .height *
                                                                              0.04,
                                                                        ),
                                                                        imagesPath
                                                                            .isEmpty
                                                                            ? GestureDetector(
                                                                          onTap: () async {
                                                                            await pickImage();
                                                                            updateDialog
                                                                                .call(() {});
                                                                          },
                                                                          child: Container(
                                                                            padding: EdgeInsets
                                                                                .symmetric(
                                                                                horizontal: width *
                                                                                    0.3,
                                                                                vertical: width *
                                                                                    0.2),
                                                                            decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius
                                                                                  .circular(
                                                                                10,
                                                                              ),
                                                                              color: Colors
                                                                                  .white
                                                                                  .withOpacity(
                                                                                0.20,
                                                                              ),
                                                                            ),
                                                                            child: Stack(
                                                                              alignment: Alignment
                                                                                  .center,
                                                                              children: [
                                                                                Image
                                                                                    .asset(
                                                                                  'assets/images/imag_picker.png',
                                                                                  height: height *
                                                                                      0.08,
                                                                                  width: height *
                                                                                      0.08,
                                                                                ),
                                                                                Stack(
                                                                                  alignment: Alignment
                                                                                      .bottomRight,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      // color: Colors.red,
                                                                                      height: height *
                                                                                          0.1,
                                                                                      width: height *
                                                                                          0.1,
                                                                                    ),
                                                                                    Container(
                                                                                      height: width *
                                                                                          0.08,
                                                                                      width: width *
                                                                                          0.08,
                                                                                      decoration: const BoxDecoration(
                                                                                        color: Color(
                                                                                            0xff55A1FF),
                                                                                        shape: BoxShape
                                                                                            .circle,
                                                                                      ),
                                                                                      alignment: Alignment
                                                                                          .center,
                                                                                      child: Wrap(
                                                                                        children: [
                                                                                          Icon(
                                                                                            Icons
                                                                                                .add,
                                                                                            color: Colors
                                                                                                .white,
                                                                                            size: width *
                                                                                                0.04,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                            : Padding(
                                                                          padding: EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: width *
                                                                                  0.15),
                                                                          child: SizedBox(
                                                                            height: sizingInformation
                                                                                .isDesktop
                                                                                ? height *
                                                                                0.24
                                                                                : height *
                                                                                0.14,
                                                                            child: ListView
                                                                                .separated(
                                                                              separatorBuilder: (
                                                                                  context,
                                                                                  index) {
                                                                                return const SizedBox(
                                                                                  width: 20,
                                                                                );
                                                                              },
                                                                              itemCount: imagesPath
                                                                                  .length,
                                                                              physics: const ClampingScrollPhysics(),
                                                                              scrollDirection: Axis
                                                                                  .horizontal,
                                                                              itemBuilder: (
                                                                                  context,
                                                                                  index) {
                                                                                return Stack(
                                                                                  alignment: Alignment
                                                                                      .topRight,
                                                                                  children: [
                                                                                    Container(
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius
                                                                                            .circular(
                                                                                          10,
                                                                                        ),
                                                                                        border: Border
                                                                                            .all(
                                                                                            color: Colors
                                                                                                .white,
                                                                                            width: 1),
                                                                                      ),
                                                                                      child: ClipRRect(
                                                                                        borderRadius: BorderRadius
                                                                                            .circular(
                                                                                          10,
                                                                                        ),
                                                                                        child: Image
                                                                                            .memory(
                                                                                          Uint8List
                                                                                              .fromList(
                                                                                              imagesPath[index]),
                                                                                          width: width *
                                                                                              0.8,
                                                                                          height: sizingInformation
                                                                                              .isDesktop
                                                                                              ? height *
                                                                                              0.24
                                                                                              : height *
                                                                                              0.14,
                                                                                          fit: BoxFit
                                                                                              .cover,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      child: Container(
                                                                                        alignment: Alignment
                                                                                            .center,
                                                                                        height: width *
                                                                                            0.2,
                                                                                        width: width *
                                                                                            0.2,
                                                                                        child: Container(
                                                                                          alignment: Alignment
                                                                                              .center,
                                                                                          height: width *
                                                                                              0.13,
                                                                                          width: width *
                                                                                              0.13,
                                                                                          decoration: BoxDecoration(
                                                                                            color: Colors
                                                                                                .black,
                                                                                            borderRadius: BorderRadius
                                                                                                .circular(
                                                                                              8,
                                                                                            ),
                                                                                          ),
                                                                                          child: const Icon(
                                                                                            Icons
                                                                                                .close,
                                                                                            color: Color(
                                                                                                0xffFFD800),
                                                                                            size: 17,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      onTap: () {
                                                                                        imagesPath
                                                                                            .removeAt(
                                                                                            index);
                                                                                        updateDialog
                                                                                            .call(
                                                                                              () {},
                                                                                        );

                                                                                      },
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height: Get
                                                                              .height *
                                                                              0.05,
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap: () {
                                                                            if(imagesPath
                                                                                .isNotEmpty){
                                                                              if (widget
                                                                                  .isAdmin!) {
                                                                                setState(() {
                                                                                  imagesPath
                                                                                      .forEach((
                                                                                      element) async {
                                                                                    await homeController
                                                                                        .uploadImage(
                                                                                        element);
                                                                                  });

                                                                                  // homeController.uploadImage(imageFile!.bytes!,);
                                                                                  homeController
                                                                                      .isUploaded =
                                                                                  true;
                                                                                });
                                                                                Get
                                                                                    .back();
                                                                              } else {
                                                                                Get
                                                                                    .back();
                                                                                ScaffoldMessenger
                                                                                    .of(
                                                                                    context)
                                                                                    .showSnackBar(
                                                                                  const SnackBar(
                                                                                    content: Text(
                                                                                        'This operation is not perform due to demo mode.'),
                                                                                    backgroundColor: Colors
                                                                                        .black,
                                                                                  ),
                                                                                );
                                                                              }
                                                                            }
                                                                            else{
                                                                              Get.snackbar('Error', 'Please select image!',colorText: Colors.white,backgroundColor: Colors.red);
                                                                            }
                                                                          },
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              color: const Color(
                                                                                  0xffFFD800),
                                                                              borderRadius: BorderRadius
                                                                                  .circular(
                                                                                sizingInformation
                                                                                    .isDesktop
                                                                                    ? 20
                                                                                    : 15,
                                                                              ),
                                                                            ),
                                                                            width: width *
                                                                                0.5,
                                                                            height: height *
                                                                                0.07,
                                                                            alignment: Alignment
                                                                                .center,
                                                                            child: Text(
                                                                              "upload",
                                                                              style: TextStyle(
                                                                                fontSize: height *
                                                                                    0.025,
                                                                                fontWeight: FontWeight
                                                                                    .w600,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height: height *
                                                                                0.02),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      );
                                                    } else {}
                                                  },
                                                  child: Container(
                                                    height: sizingInformation.isDesktop
                                                        ? 50
                                                        : 40,
                                                    width: width * 0.7,
                                                    decoration: BoxDecoration(
                                                        color: const Color(0xffFFD800),
                                                        borderRadius:
                                                        BorderRadius.circular(10)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/icons/add.png',
                                                          height: 20,
                                                          width: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        const Text(
                                                          "ADD",
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              color: Colors.black),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            homeController.isDrop
                                                ? SizedBox(
                                                height: height * 0.03)
                                                : SizedBox(
                                              height: height * 0.05,
                                            ),
                                            Stack(
                                              children: [
                                                StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                      'category')
                                                      .snapshots(),
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                          QuerySnapshot>
                                                      snapshot) {
                                                    if (snapshot.hasData) {
                                                      return SingleChildScrollView(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            SizedBox(
                                                              height:
                                                              sizingInformation
                                                                  .isTablet
                                                                  ? height *
                                                                  0.9
                                                                  : height *
                                                                  0.6,

                                                              child: ListView
                                                                  .builder(
                                                                itemCount: snapshot
                                                                    .data
                                                                    ?.docs
                                                                    .length ??
                                                                    0,
                                                                itemBuilder:
                                                                    (context,
                                                                    index) {
                                                                  return snapshot.data
                                                                      ?.docs[index]['name'] ==
                                                                      homeController
                                                                          .category
                                                                      ? SizedBox(
                                                                    height:
                                                                    sizingInformation
                                                                        .isDesktop
                                                                        ? height * 1
                                                                        : sizingInformation
                                                                        .isTablet
                                                                        ? height * 0.9
                                                                        : height * 0.6,

                                                                    child: GridView
                                                                        .builder(
                                                                      itemCount: snapshot
                                                                          .data
                                                                          ?.docs[index]['image']
                                                                          .length ?? 0,
                                                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                        crossAxisCount: sizingInformation
                                                                            .isDesktop ||
                                                                            sizingInformation
                                                                                .isTablet
                                                                            ? 3
                                                                            : 2,
                                                                        crossAxisSpacing: sizingInformation
                                                                            .isDesktop
                                                                            ? Get
                                                                            .height *
                                                                            0.08
                                                                            : height *
                                                                            0.02,
                                                                        mainAxisSpacing: sizingInformation
                                                                            .isDesktop
                                                                            ? Get
                                                                            .height *
                                                                            0.08
                                                                            : height *
                                                                            0.02,
                                                                        childAspectRatio: 5 /
                                                                            3,
                                                                      ),
                                                                      itemBuilder: (
                                                                          BuildContext context,
                                                                          int ind) {
                                                                        return Stack(
                                                                          alignment: FractionalOffset
                                                                              .topRight,
                                                                          children: [
                                                                            Stack(
                                                                              children: [
                                                                                Container(
                                                                                  height: width *
                                                                                      1,
                                                                                  width: width *
                                                                                      2,
                                                                                  clipBehavior: Clip.hardEdge,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius
                                                                                        .circular(
                                                                                      10,
                                                                                    ),
                                                                                  ),
                                                                                  child: FadeInImage
                                                                                      .assetNetwork(

                                                                                    placeholder: 'assets/images/image_placeHolder.png',
                                                                                    image: snapshot
                                                                                        .data
                                                                                        ?.docs[index]['image'][ind]['imageLink'],
                                                                                    fit: BoxFit
                                                                                        .cover,
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  height: width *
                                                                                      1,
                                                                                  width: width *
                                                                                      2,
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border
                                                                                        .all(
                                                                                        color: Colors
                                                                                            .white,
                                                                                        width: 2),
                                                                                    borderRadius: BorderRadius
                                                                                        .circular(
                                                                                      10,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            GestureDetector(
                                                                              child: Stack(
                                                                                alignment: Alignment.center,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width:  sizingInformation.isTablet ?35 : 40,
                                                                                    height:  sizingInformation.isTablet ?35 : 40,

                                                                                  ) ,
                                                                                  Image
                                                                                      .asset(
                                                                                    'assets/icons/delete_image.png',
                                                                                    width: sizingInformation.isTablet || Get.width <500 ?20 : 25,
                                                                                    height:  sizingInformation.isTablet ||Get.width <500 ?20 :25,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              onTap: () {

                                                                                showDialog(
                                                                                  context: context,
                                                                                  builder: (
                                                                                      context) {
                                                                                    return BackdropFilter(
                                                                                      filter: ImageFilter
                                                                                          .blur(
                                                                                          sigmaX: 2,
                                                                                          sigmaY: 2),
                                                                                      child: Dialog(
                                                                                        backgroundColor: Colors
                                                                                            .transparent,
                                                                                        child: Container(
                                                                                          height: height *
                                                                                              0.5,
                                                                                          width: width *
                                                                                              2,
                                                                                          padding: const EdgeInsets
                                                                                              .symmetric(
                                                                                            vertical: 10,
                                                                                            horizontal: 10,
                                                                                          ),
                                                                                          decoration: BoxDecoration(
                                                                                            color: Colors
                                                                                                .black,
                                                                                            border: Border
                                                                                                .all(
                                                                                              color: Colors
                                                                                                  .white,
                                                                                              width: 3,
                                                                                            ),
                                                                                            borderRadius: BorderRadius
                                                                                                .circular(
                                                                                              20,
                                                                                            ),
                                                                                          ),
                                                                                          child: Column(
                                                                                            children: [
                                                                                              const SizedBox(
                                                                                                height: 2,
                                                                                              ),
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment
                                                                                                    .end,
                                                                                                children: [
                                                                                                  GestureDetector(
                                                                                                    child: const Icon(
                                                                                                      Icons
                                                                                                          .close,
                                                                                                      color: Colors
                                                                                                          .white,
                                                                                                      size: 20,
                                                                                                    ),
                                                                                                    onTap: () {
                                                                                                      Get
                                                                                                          .back();
                                                                                                    },
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              Stack(
                                                                                                alignment: Alignment
                                                                                                    .center,
                                                                                                children: [
                                                                                                  Container(
                                                                                                    height: height *
                                                                                                        0.13,
                                                                                                    width: height *
                                                                                                        0.13,
                                                                                                    decoration: const BoxDecoration(
                                                                                                      color: Colors
                                                                                                          .red,
                                                                                                      shape: BoxShape
                                                                                                          .circle,
                                                                                                    ),
                                                                                                  ),
                                                                                                  Image
                                                                                                      .asset(
                                                                                                    'assets/icons/delete.png',
                                                                                                    height: height *
                                                                                                        0.08,
                                                                                                    width: height *
                                                                                                        0.08,
                                                                                                    fit: BoxFit
                                                                                                        .fill,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: Get
                                                                                                    .height *
                                                                                                    0.02,
                                                                                              ),
                                                                                              Text(
                                                                                                'Are you sure want to delete this image?',
                                                                                                style: TextStyle(
                                                                                                  height: 1.5,
                                                                                                  color: Colors
                                                                                                      .white,
                                                                                                  fontWeight: FontWeight
                                                                                                      .w500,
                                                                                                  fontSize: textHeight *
                                                                                                      0.04,
                                                                                                  fontFamily: "sfPro",
                                                                                                ),
                                                                                                textAlign: TextAlign
                                                                                                    .center,
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: Get
                                                                                                    .height *
                                                                                                    0.03,
                                                                                              ),

                                                                                              Row(
                                                                                                mainAxisAlignment:
                                                                                                MainAxisAlignment
                                                                                                    .center,
                                                                                                children: [
                                                                                                  GestureDetector(
                                                                                                    onTap:
                                                                                                        () {
                                                                                                      if (widget
                                                                                                          .isAdmin!) {
                                                                                                        setState(() {
                                                                                                          homeController
                                                                                                              .removeItemAtIndex(
                                                                                                              snapshot
                                                                                                                  .data
                                                                                                                  ?.docs[index]
                                                                                                                  .id,
                                                                                                              snapshot
                                                                                                                  .data
                                                                                                                  ?.docs[index]['image'],
                                                                                                              ind);
                                                                                                        });
                                                                                                        Get.back();
                                                                                                      } else {
                                                                                                        ScaffoldMessenger
                                                                                                            .of(
                                                                                                            context)
                                                                                                            .showSnackBar(
                                                                                                          const SnackBar(
                                                                                                            content: Text(
                                                                                                                'This operation is not perform due to demo mode.'),
                                                                                                            backgroundColor: Colors
                                                                                                                .black,
                                                                                                          ),
                                                                                                        );
                                                                                                      }
                                                                                                    },
                                                                                                    child:
                                                                                                    Container(
                                                                                                      decoration: BoxDecoration(
                                                                                                          color: const Color(0xffFFD800),
                                                                                                          borderRadius: BorderRadius.circular(
                                                                                                            10,
                                                                                                          ),
                                                                                                          border: Border.all(color: const Color(0xffFFD800), width: 1)),
                                                                                                      width:
                                                                                                      width * 0.7,
                                                                                                      height:
                                                                                                      height * 0.07,
                                                                                                      alignment:
                                                                                                      Alignment.center,
                                                                                                      child:
                                                                                                      const Text(
                                                                                                        "Yes",
                                                                                                        style:
                                                                                                        TextStyle(
                                                                                                          fontSize: 22,
                                                                                                          fontFamily: 'sfBold',
                                                                                                          color: Colors.black,
                                                                                                          fontWeight: FontWeight.w600,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),

                                                                                                  const SizedBox(
                                                                                                    width:
                                                                                                    20,
                                                                                                  ),
                                                                                                  GestureDetector(
                                                                                                    onTap:
                                                                                                        () {
                                                                                                      setState(
                                                                                                              () {
                                                                                                            Get.back();
                                                                                                          });
                                                                                                    },
                                                                                                    child:
                                                                                                    Container(
                                                                                                      decoration: BoxDecoration(
                                                                                                          color: Colors.transparent,
                                                                                                          borderRadius: BorderRadius.circular(
                                                                                                            10,
                                                                                                          ),
                                                                                                          border: Border.all(color: const Color(0xffFFD800), width: 1)),
                                                                                                      width:
                                                                                                      width * 0.7,
                                                                                                      height:
                                                                                                      height * 0.07,
                                                                                                      alignment:
                                                                                                      Alignment.center,
                                                                                                      child:
                                                                                                      const Text(
                                                                                                        "No",
                                                                                                        style:
                                                                                                        TextStyle(
                                                                                                          fontSize: 22,
                                                                                                          fontWeight: FontWeight.w600,
                                                                                                          color: Colors.white,
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),

                                                                                                ],
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: height *
                                                                                                    0.02,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                            ),


                                                                          ],
                                                                        );
                                                                      },
                                                                    ),
                                                                  )
                                                                      : const SizedBox();
                                                                },
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                    if (snapshot.hasError) {
                                                      return const SizedBox();
                                                    } else {
                                                      return const Center(
                                                          child:
                                                          CircularProgressIndicator());
                                                    }
                                                  },
                                                ),
                                                (homeController.isDrop)
                                                    ? BackdropFilter(
                                                  filter: ImageFilter
                                                      .blur(
                                                      sigmaX: 20,
                                                      sigmaY: 20),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                        StreamBuilder(
                                                          stream: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                              'category')
                                                              .snapshots(),
                                                          builder: (context,
                                                              AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              stream) {
                                                            if (stream
                                                                .hasData) {
                                                              return Container(
                                                                  width: Get
                                                                      .width,
                                                                  height : Get.height * 0.3,
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    borderRadius: BorderRadius
                                                                        .circular(10),
                                                                    color: Colors.white
                                                                        .withOpacity(
                                                                        0.16),
                                                                  ),
                                                                  child:
                                                                  SizedBox(
                                                                    child: ListView
                                                                        .separated(
                                                                      shrinkWrap: true,
                                                                      itemCount: stream
                                                                          .data?.docs
                                                                          .length ?? 0,
                                                                      separatorBuilder: (
                                                                          context,
                                                                          index) {
                                                                        return Padding(
                                                                          padding: EdgeInsets
                                                                              .only(
                                                                            left: width *
                                                                                0.1,
                                                                            right: width *
                                                                                0.1,
                                                                          ),
                                                                          child: Container(
                                                                            height: 1,
                                                                            color: Colors
                                                                                .white
                                                                                .withOpacity(
                                                                                0.5),
                                                                          ),
                                                                        );
                                                                      },
                                                                      itemBuilder: (
                                                                          context,
                                                                          index) {
                                                                        return Column(
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  homeController
                                                                                      .category =
                                                                                  stream
                                                                                      .data
                                                                                      ?.docs[index]['name'];
                                                                                  homeController
                                                                                      .selectedCategory =
                                                                                      stream
                                                                                          .data!
                                                                                          .docs[index]
                                                                                          .id;
                                                                                  homeController
                                                                                      .lengthOfImage =
                                                                                      stream
                                                                                          .data
                                                                                          ?.docs[index]['image']
                                                                                          .length;
                                                                                  homeController
                                                                                      .isDrop =
                                                                                  false;
                                                                                });
                                                                              },
                                                                              child: Container(
                                                                                height: sizingInformation
                                                                                    .isDesktop
                                                                                    ? height *
                                                                                    0.09
                                                                                    : height *
                                                                                    0.06,
                                                                                decoration: BoxDecoration(
                                                                                    color: (homeController
                                                                                        .category ==
                                                                                        stream
                                                                                            .data
                                                                                            ?.docs[index]['name'])
                                                                                        ? const Color(
                                                                                        0xffFFD800)
                                                                                        : Colors
                                                                                        .transparent),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment
                                                                                      .start,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                        width: width *
                                                                                            0.1),
                                                                                    Padding(
                                                                                      padding: EdgeInsets
                                                                                          .only(
                                                                                          left: width *
                                                                                              0.1),
                                                                                      child: Text(
                                                                                        stream
                                                                                            .data
                                                                                            ?.docs[index]['name'],
                                                                                        style: (homeController
                                                                                            .category ==
                                                                                            stream
                                                                                                .data
                                                                                                ?.docs[index]['name'])
                                                                                            ? TextStyle(
                                                                                          color: Colors
                                                                                              .black,
                                                                                          fontWeight: FontWeight
                                                                                              .bold,
                                                                                          fontSize: textHeight *
                                                                                              0.03,
                                                                                          fontFamily: "sfPro",
                                                                                        )
                                                                                            : TextStyle(
                                                                                          color: Colors
                                                                                              .white,
                                                                                          fontWeight: FontWeight
                                                                                              .w800,
                                                                                          fontSize: textHeight *
                                                                                              0.025,
                                                                                          fontFamily: "sfPro",
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      },
                                                                    ),
                                                                  ));
                                                            }
                                                            if (stream
                                                                .hasError) {
                                                              return const SizedBox();
                                                            } else {
                                                              return const Center(
                                                                  child:
                                                                  CircularProgressIndicator());
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                        Get.width *
                                                            0.02,
                                                      ),
                                                      SizedBox(
                                                        height: 50,
                                                        width: width *
                                                            0.7,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (homeController
                                                        .isDrop) {
                                                      homeController
                                                          .isDrop = false;
                                                    } else {
                                                      homeController
                                                          .isDrop = true;
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  height: 40,

                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffFFD800),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          10)),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width:sizingInformation.isTablet? width * 0.08:width * 0.18 ,
                                                      ),
                                                      Text(
                                                        homeController
                                                            .category,
                                                        style: TextStyle(
                                                          color:
                                                          Colors.black,
                                                          fontWeight:
                                                          FontWeight
                                                              .w800,
                                                          fontSize:
                                                          textHeight *
                                                              0.03,
                                                          fontFamily:
                                                          "sfPro",
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Image.asset(
                                                        'assets/icons/arrowDown.png',
                                                        height:
                                                        height * 0.02,
                                                        width:
                                                        height * 0.02,
                                                      ),
                                                      SizedBox(
                                                        width:
                                                        sizingInformation
                                                            .isTablet
                                                            ? width *
                                                            0.04
                                                            : width *
                                                            0.3,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: Get.width * 0.02,
                                            ),
                                            SizedBox(
                                              height: 40,
                                              width: width * 0.7,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          );
        },
      ),
    );
  }
}
