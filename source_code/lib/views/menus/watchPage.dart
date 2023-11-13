import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tentwenty/network_service/models/upcomingMoviesModel.dart';
import 'package:tentwenty/utils/constants.dart';
import 'package:tentwenty/views/searchMoviePage.dart';
import 'package:tentwenty/views/widgets/customText.dart';
import 'package:tentwenty/views/widgets/movieItem.dart';

import '../../network_service/dio_client.dart';
import '../../network_service/repository/moviesRepository.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../view_model/bottomNavProvider.dart';
import '../../view_model/moviesProvider.dart';
import '../../network_service/models/bottomNavModel.dart';
import '../baseWidget.dart';
import '../detailPage.dart';

class WatchPage extends StatelessWidget {
  List<UpcomingMoviesModel> filteredMovies = [];

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return BaseWidget<MoviesRepository>(
      model: MoviesRepository(
        apiService: Provider.of<ApiService>(context),
      ),
      onModelReady: (MoviesRepository model) => model.initModel(),
      builder: (BuildContext context, MoviesRepository model, _) {
        return Scaffold(
          backgroundColor: pageBackgroundColor,
          appBar: AppBar(
            leading: Container(
              alignment: Alignment.center,
              child: CustomText(
                text: "Watch",
                fontSize: 16.0,
              ),
            ),
            leadingWidth: 100,
            actions: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(
                        upcomingMovies: model.upcomingMoviesList,
                      ),
                    ),
                  );
                },
                child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 22),
                    child: const Icon(
                      Icons.search,
                      size: 19,
                    )),
              )
            ],
          ),
          body: model.loading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: bottomNavColor,
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: model.upcomingMoviesList.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 3 / 2),
                      itemBuilder: (context, index) {
                        return movieItem(context, model.upcomingMoviesList[index], isGrid: true);
                      }),
                ),
        );
      },
    );
  }
}
