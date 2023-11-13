import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tentwenty/network_service/models/upcomingMoviesModel.dart';
import 'package:tentwenty/utils/colors.dart';

import '../../utils/constants.dart';
import '../../utils/images.dart';
import '../detailPage.dart';
import 'cachedImageWidget.dart';
import 'customText.dart';

movieItem(BuildContext context, UpcomingMoviesModel moviesModel, {bool isGrid = false}) {
  return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(moviesModel)));
      },
      child: Container(
        height: 180,
        margin: !isGrid ? const EdgeInsets.symmetric(horizontal: 20, vertical: 10) : EdgeInsets.zero,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
        child: Stack(children: <Widget>[
          Positioned.fill(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  foregroundDecoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.center, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black87])),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: cachedImage(
                    AppConstants.imagePath + moviesModel.posterPath,
                  ),
                )),
          ),
          Positioned.fill(
              child: Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: CustomText(
                    text: moviesModel.originalTitle,
                    textAlign: TextAlign.left,
                    color: whiteColor,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  )))
        ]),
      ));
}
