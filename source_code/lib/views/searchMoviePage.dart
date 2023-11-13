import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tentwenty/utils/constants.dart';
import 'package:tentwenty/views/widgets/cachedImageWidget.dart';
import 'package:tentwenty/views/widgets/customText.dart';

import '../network_service/dio_client.dart';
import '../network_service/models/upcomingMoviesModel.dart';
import '../network_service/repository/moviesRepository.dart';
import '../utils/colors.dart';
import '../utils/images.dart';
import 'baseWidget.dart';
import 'detailPage.dart';

class SearchPage extends StatefulWidget {
  final List<UpcomingMoviesModel> upcomingMovies;

  SearchPage({required this.upcomingMovies});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<UpcomingMoviesModel> filteredMovies = [];
  TextEditingController searchController = TextEditingController();
  bool showSearchBar = true;

  @override
  void initState() {
    super.initState();
    filteredMovies = widget.upcomingMovies;
  }

  void _updateFilteredMovies(String query) {
    setState(() {
      filteredMovies = widget.upcomingMovies.where((movie) => movie.title.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  clearResult() {
    searchController.clear();
    filteredMovies = widget.upcomingMovies;
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget<MoviesRepository>(
      model: MoviesRepository(
        apiService: Provider.of<ApiService>(context),
      ),
      onModelReady: (MoviesRepository model) => null,
      builder: (BuildContext context, MoviesRepository model, _) {
        return Scaffold(
          backgroundColor: pageBackgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: buildSearchBar(model),
            toolbarHeight: 70,
            backgroundColor: whiteColor,
          ),
          body: model.loading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: bottomNavColor,
                  ),
                )
              : setBody(),
        );
      },
    );
  }

  setBody() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchController.text.isNotEmpty
              ? showSearchBar
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Top results",
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: greyColor.withOpacity(0.4),
                        ),
                      ],
                    )
                  : const SizedBox()
              : SizedBox(),
          Container(
            margin: EdgeInsets.only(top: searchController.text.isNotEmpty ? 40 : 0),
            child: ListView.builder(
              itemCount: filteredMovies.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(filteredMovies[index])));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: cachedImage(
                                      AppConstants.imagePath + filteredMovies[index].posterPath,
                                      search: true,
                                      width: 130,
                                      height: 100,
                                    )),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: filteredMovies[index].title,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      CustomText(
                                        text: filteredMovies[index].releaseDate,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500,
                                        color: greyTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.more_horiz,
                          color: lightBlueColor,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar(MoviesRepository repository) {
    return showSearchBar
        ? Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 30.0),
            decoration: BoxDecoration(
              color: pageBackgroundColor,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.search,
                          size: 19,
                        )),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: TextField(
                    onChanged: (value) {
                      _updateFilteredMovies(value);
                    },
                    onSubmitted: (_) async {
                      showSearchBar = false;
                      repository.setLoading(true);
                      await repository.searchMovieByQuery(searchController.text);
                      repository.setLoading(false);
                      filteredMovies = repository.upcomingMoviesList;
                      repository.notifyListeners();
                    },
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'TV shows, movies and more',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        clearResult();
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.clear,
                          size: 30,
                          color: greyColor,
                        )),
                  ),
                )
              ],
            ),
          )
        : Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 30.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: blackColor,
                    size: 15,
                  ),
                ),
                const SizedBox(
                  width: 18,
                ),
                CustomText(
                  text: !repository.loading ? "${filteredMovies.length} Result Found" : "searching...",
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          );
  }
}
