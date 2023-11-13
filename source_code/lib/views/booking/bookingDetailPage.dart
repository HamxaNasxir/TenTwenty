import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tentwenty/utils/constants.dart';
import 'package:tentwenty/utils/images.dart';
import 'package:tentwenty/views/videoPlayer/videoPlayer.dart';
import 'package:tentwenty/views/widgets/cachedImageWidget.dart';
import 'package:tentwenty/views/widgets/customText.dart';

import '../../network_service/dio_client.dart';
import '../../network_service/models/upcomingMoviesModel.dart';
import '../../network_service/repository/moviesRepository.dart';
import '../../utils/colors.dart';
import '../../utils/functions.dart';
import '../../view_model/bottomNavProvider.dart';
import '../../view_model/moviesProvider.dart';
import '../../network_service/models/bottomNavModel.dart';
import '../baseWidget.dart';

class BookingDetailPage extends StatefulWidget {
  UpcomingMoviesModel movieModel;

  BookingDetailPage(this.movieModel);

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: pageBackgroundColor,
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomText(
                text: widget.movieModel.title,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: blackColor,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomText(
                text: "In theaters ${formatDate(widget.movieModel.releaseDate)}",
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: lightBlueColor,
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: blackColor,
              size: 15,
            ),
          ),
          backgroundColor: whiteColor,
        ),
        body: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, top: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 6,
                  child: Container(
                    color: pageBackgroundColor,
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Row(
                              children: [
                                Image.asset(
                                  plusImage,
                                  width: 30,
                                  height: 30,
                                ),
                                Image.asset(
                                  minusImage,
                                  width: 30,
                                  height: 30,
                                ),
                              ],
                            )),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Image.asset(
                              seatsImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(child: customSeatRow("Selected", bgColor4)),
                                Expanded(child: customSeatRow("Not Available", greyColor.withOpacity(0.3))),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(child: customSeatRow("VIP (150\$)", bottomNavColor)),
                                Expanded(child: customSeatRow("Regular (50\$)", lightBlueColor)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: 97,
                            height: 30,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: greyColor.withOpacity(0.1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: CustomText(
                                    text: "4/ 3row",
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const Icon(
                                  Icons.clear,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Container(
                                  height: 50,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: greyColor.withOpacity(0.1)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        text: "Total Price",
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w400,
                                        textAlign: TextAlign.center,
                                      ),
                                      CustomText(
                                        text: "\$ 50",
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )),
                            Expanded(
                              flex: 7,
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: lightBlueColor, border: Border.all(color: lightBlueColor)),
                                child: CustomText(
                                  text: "Proceed to pay",
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: whiteColor,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }

  customSeatRow(String title, Color seatColor) {
    return Row(
      children: [
        Image.asset(
          colorSeatImage,
          color: seatColor,
          width: 17,
          height: 16.16,
        ),
        const SizedBox(
          width: 10,
        ),
        CustomText(
          text: title,
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
