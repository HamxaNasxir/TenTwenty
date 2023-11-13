import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tentwenty/network_service/dio_client.dart';
import 'package:tentwenty/network_service/models/upcomingMoviesModel.dart';
import 'package:tentwenty/views/searchMoviePage.dart';
import 'package:tentwenty/views/widgets/customText.dart';
import 'package:tentwenty/views/widgets/movieItem.dart';

import '../../network_service/repository/moviesRepository.dart';
import '../../utils/colors.dart';
import '../baseWidget.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  text: "Dashboard",
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
                : setView(context, model));
      },
    );
  }

  Widget setView(BuildContext context, MoviesRepository model) {
    if (model.loading) {
      const Center(
        child: CircularProgressIndicator(
          color: bottomNavColor,
        ),
      );
    }

    return allMoviesList(context, model);
  }

  allMoviesList(BuildContext context, MoviesRepository model) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: model.upcomingMoviesList.length,
          itemBuilder: (context, index) {
            return movieItem(context, model.upcomingMoviesList[index]);
          }),
    );
  }
}
