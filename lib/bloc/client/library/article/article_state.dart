
part of "article_bloc.dart";

class LibraryArticleState{}

class LibraryArticleInitialState extends LibraryArticleState{}

class LibraryArticleLoadingState extends LibraryArticleState{}

class LibraryArticleLoadedState extends LibraryArticleState{
  List<LibraryView>? view;
  LibraryArticleLoadedState(this.view);
}

class LibraryArticleErrorState extends LibraryArticleState{}