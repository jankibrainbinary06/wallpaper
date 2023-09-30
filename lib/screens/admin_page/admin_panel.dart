import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:wallpaper/common/common_textfield.dart';
import 'package:wallpaper/screens/admin_page/admin_panel_controller.dart';
import 'package:wallpaper/utils/textstyle.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final AdminPanelController adminPanelController =
  Get.put(AdminPanelController());
  Reference storageReference = FirebaseStorage.instance.ref();

  double width = 0;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.isDesktop) {
          width = 700;
        } else if (sizingInformation.isTablet) {
          width = 450;
        } else if (sizingInformation.isMobile) {
          width = 300;
        }
        return Scaffold(
          body: Container(
            alignment: Alignment.center,
            width: MediaQuery
                .of(context)
                .size
                .width,
            decoration: const BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill),
            ),
            child: GetBuilder<AdminPanelController>(
              id: "admin",
              builder: (controller) {
                return SingleChildScrollView(
                  child: sizingInformation.isDesktop?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     SizedBox(height: sizingInformation.isDesktop?  250: 10,)
,                      Container(
                        width: width * 1,
                        height:  Get.height * 0.1 ,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding:  const EdgeInsets.only(left: 40),
                          child: CommonTextField(
                            controller: controller.emailController,
                            onChange: controller.signInValidation(),
                            hintText: "enter email ID",
                            child: Padding(
                              padding:  const EdgeInsets.only(
                                  right: 50,),                            child: Image.asset(
                                "assets/icons/email.png",
                                height: Get.height > 850? 40 :30,
                                width: Get.height > 850? 40 :30,
                              ),
                            ),
                          ),
                        ),
                      ),
                      controller.emailError == ''
                          ? const SizedBox()
                          : SizedBox(height: Get.height * 0.01),
                      (controller.emailError == '')
                          ? const SizedBox()
                          : Text(
                        controller.emailError,
                        style: errorTextStyle,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: width * 1,
                        height: sizingInformation.isDesktop ?  Get.height * 0.1 : Get.height * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
alignment: Alignment.center,
                        child: Padding(
                          padding:  const EdgeInsets.only(left: 40),
                          child: CommonTextField(
                            isObsecure: true,
                            controller: controller.passwordController,
                            hintText: "enter password",
                            onChange: controller.signInValidation(),
                            child: Padding(
                              padding:  const EdgeInsets.only(
                                  right: 50),
                              child: Image.asset(
                                "assets/icons/lock.png",
                                height: Get.height > 850? 40 :30,
                                width: Get.height > 850? 40 :30,
                              ),
                            ),
                          ),
                        ),
                      ),
                      controller.passError == ''
                          ? const SizedBox()
                          : SizedBox(height: Get.height * 0.01),
                      (controller.passError == '')
                          ? const SizedBox()
                          : Text(
                        controller.passError,
                        style: errorTextStyle,
                      ),
                      const SizedBox(
                        height: 110,
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.onTapLogin(context);
                        },

                        child: Container(
                        height :   Get.height * 0.1,
                          width: 250,
                          decoration: BoxDecoration(
                            color: const Color(0xffFFD800),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child:  const Text(
                            "Sign In",

                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontFamily: "sfBold")
                          ),
                        ),
                      ),
                    ],
                  ) :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: sizingInformation.isDesktop?  250: 10,)
                      ,                      Container(
                        width: width * 1.1,
                        height:  Get.height * 0.081,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding:  EdgeInsets.only(left: sizingInformation.isMobile? 20 : 40),
                          child: CommonTextField(

                            controller: controller.emailController,
                            onChange: controller.signInValidation(),
                            hintText: "enter email ID",
                            child: Padding(
                              padding:  const EdgeInsets.only(
                                right: 20,),                            child: Image.asset(
                              "assets/icons/email.png",
                              height:  30,
                              width: 30,
                            ),
                            ),
                          ),
                        ),
                      ),
                      controller.emailError == ''
                          ? const SizedBox()
                          : SizedBox(height: Get.height * 0.01),
                      (controller.emailError == '')
                          ? const SizedBox()
                          : Text(
                        controller.emailError,
                        style: errorTextStyle,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: width * 1.1,
                        height:  Get.height * 0.081,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding:  EdgeInsets.only(left: sizingInformation.isMobile? 20 : 40),
                          child: CommonTextField(
                            isObsecure: true,
                            controller: controller.passwordController,
                            hintText: "enter password",
                            onChange: controller.signInValidation(),
                            child: Padding(
                              padding:  const EdgeInsets.only(
                                  right: 20),
                              child: Image.asset(
                                "assets/icons/lock.png",
                                height: 30,
                                width: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                      controller.passError == ''
                          ? const SizedBox()
                          : SizedBox(height: Get.height * 0.01),
                      (controller.passError == '')
                          ? const SizedBox()
                          : Text(
                        controller.passError,
                        style: errorTextStyle,
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.onTapLogin(context);
                        },
                        child: Container(
                          height: 60,
                          width:  200,
                          decoration: BoxDecoration(
                            color: const Color(0xffFFD800),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child:  Text(
                            "Sign In",

                            style:sizingInformation.isDesktop? const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontFamily: "sfBold"):const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                                fontFamily: "sfBold"),
                          ),
                        ),
                      ),
                    ],
                  ) ,
                );
              },
            ),
          ),

        );
      },
    );
  }
}
