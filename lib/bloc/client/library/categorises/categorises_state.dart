
part of "categorises_cubit.dart";

class LibraryCategorisesState{}

class LibraryCategorisesInitialState extends LibraryCategorisesState{}

class LibraryCategorisesLoadingState extends LibraryCategorisesState{}

class LibraryCategorisesLoadedState extends LibraryCategorisesState{
  List<LibraryCategoriesView>? categories;
  LibraryCategorisesLoadedState(this.categories);
}

class LibraryCategorisesErrorState extends LibraryCategorisesState{}