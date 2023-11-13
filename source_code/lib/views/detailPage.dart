import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tentwenty/utils/constants.dart';
import 'package:tentwenty/utils/images.dart';
import 'package:tentwenty/views/booking/bookingPage.dart';
import 'package:tentwenty/views/videoPlayer/videoPlayer.dart';
import 'package:tentwenty/views/widgets/cachedImageWidget.dart';
import 'package:tentwenty/views/widgets/customText.dart';

import '../network_service/dio_client.dart';
import '../network_service/models/upcomingMoviesModel.dart';
import '../network_service/repository/moviesRepository.dart';
import '../utils/colors.dart';
import '../utils/functions.dart';
import '../view_model/bottomNavProvider.dart';
import '../view_model/moviesProvider.dart';
import '../network_service/models/bottomNavModel.dart';
import 'baseWidget.dart';

class DetailPage extends StatelessWidget {
  final Key bottomNavKey = GlobalKey();
  UpcomingMoviesModel movieModel;

  DetailPage(this.movieModel);

  List colors = [
    bgColor1,
    bgColor2,
    bgColor3,
    bgColor4,
  ];

  @override
  Widget build(BuildContext context) {
    return BaseWidget<MoviesRepository>(
      model: MoviesRepository(
        apiService: Provider.of<ApiService>(context),
      ),
      onModelReady: (MoviesRepository model) async {
        model.setLoading(true);

        await model.getMovieDetail(movieModel.id.toString());
        await model.getTrailerUrl(movieModel.id.toString());
        model.setLoading(false);
        model.notifyListeners();
      },
      builder: (BuildContext context, MoviesRepository model, _) {
        return Scaffold(
          backgroundColor: whiteColor,
          body: model.loading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: bottomNavColor,
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                        flex: 6,
                        child: Container(
                          color: Colors.black26,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: cachedImage(
                                  AppConstants.imagePath + movieModel.posterPath,
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 60),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Icon(
                                        Icons.arrow_back_ios,
                                        color: whiteColor,
                                        size: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 18,
                                    ),
                                    CustomText(
                                      text: "Watch",
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      color: whiteColor,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(bottom: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomText(
                                      text: movieModel.originalTitle,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      color: bgColor4,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomText(
                                      text: "In theaters ${formatDate(movieModel.releaseDate)}",
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                      color: whiteColor,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    customContainerButton(context, lightBlueColor, "Get Tickets", model),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    customContainerButton(
                                      context,
                                      Colors.transparent,
                                      "Watch Trailer",
                                      model,
                                      showIcon: true,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                    Expanded(
                        flex: 4,
                        child: Container(
                          margin: const EdgeInsets.only(left: 40, right: 40, top: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "Genres",
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 30,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: model.movieDetailModel.genres.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return customColorContainer(colors[index], model.movieDetailModel.genres[index].name);
                                    }),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Divider(
                                color: greyColor.withOpacity(0.2),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              CustomText(
                                text: "Overview",
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomText(
                                text: movieModel.overview,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: greyColor,
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
        );
      },
    );
  }

  customColorContainer(Color backgroundColor, String title) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(
        right: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor,
      ),
      child: CustomText(
        text: title,
        fontSize: 12.0,
        fontWeight: FontWeight.w600,
        color: whiteColor,
      ),
    );
  }

  customContainerButton(BuildContext context, Color buttonColor, String buttonText, MoviesRepository model, {bool showIcon = false}) {
    return GestureDetector(
      onTap: () {
        String url = model.videosList.firstWhere((element) => element.type == "Trailer").key;
        if (buttonText == "Watch Trailer") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayer(movieModel.title, url)));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BookingPage(movieModel)));
        }
      },
      child: Container(
        width: 245,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: buttonColor, border: Border.all(color: lightBlueColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showIcon
                ? const Icon(
                    Icons.play_arrow,
                    color: whiteColor,
                  )
                : const SizedBox(),
            CustomText(
              text: buttonText,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
