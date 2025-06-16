
part of "article_bloc.dart";

class LibraryArticleEvent{}

class LibraryArticleGetEvent extends LibraryArticleEvent{
  int id;
  LibraryArticleGetEvent(this.id);
}