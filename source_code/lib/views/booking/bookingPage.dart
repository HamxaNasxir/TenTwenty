import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tentwenty/utils/constants.dart';
import 'package:tentwenty/utils/images.dart';
import 'package:tentwenty/views/booking/bookingDetailPage.dart';
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

class BookingPage extends StatefulWidget {
  UpcomingMoviesModel movieModel;

  BookingPage(this.movieModel);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
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
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Date",
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 30,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 20,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: customColorContainer("${index + 1} Nov", index));
                      }),
                ),
                Container(
                  height: 300,
                  margin: const EdgeInsets.only(top: 30),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 20,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: bookingItem());
                      }),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailPage(widget.movieModel)));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: lightBlueColor, border: Border.all(color: lightBlueColor)),
                  child: CustomText(
                    text: "Book Seat",
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: whiteColor,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  customColorContainer(String title, int index) {
    return Container(
      width: 67,
      height: 32,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(
        right: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: selectedIndex == index
            ? [
                BoxShadow(
                  color: lightBlueColor.withOpacity(0.2),
                  blurRadius: 20.0, // Soften the shaodw
                  spreadRadius: 2.0,
                  offset: const Offset(0.0, 0.0),
                )
              ]
            : null,
        color: selectedIndex == index ? lightBlueColor : greyColor.withOpacity(0.2),
      ),
      child: CustomText(
        text: title,
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: selectedIndex == index ? whiteColor : blackColor,
      ),
    );
  }

  var bottomText = RichText(
    text: const TextSpan(
      // Note: Styles for TextSpans must be explicitly defined.
      // Child text spans will inherit styles from parent
      style: TextStyle(
        fontSize: 12.0,
        color: blackColor,
        fontWeight: FontWeight.w700,
      ),
      children: [
        TextSpan(text: 'From', style: TextStyle(color: greyColor)),
        TextSpan(
          text: ' 50\$',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: ' or ', style: TextStyle(color: greyColor)),
        TextSpan(
          text: '2500 bonus',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );

  bookingItem() {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomText(
                text: "12:00",
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(
                width: 10,
              ),
              CustomText(
                text: "Cinetech + Hall 1",
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: greyColor,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: 250,
            height: 145,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: lightBlueColor),
            ),
            child: Image.asset(seatsImage),
          ),
          const SizedBox(
            height: 10,
          ),
          bottomText
        ],
      ),
    );
  }
}
