import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list/presentational/search/search-results.dart';
import 'package:shopping_list/utils/product-search-delegate.dart';

class SearchPage extends ProductSearchDelegate<SearchPage> {
  final String listId;
  var queriedText;

  SearchPage(this.listId) : super(keyboardType: TextInputType.visiblePassword);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
            focusInput();
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _resultList();
  }

  @override
  Widget buildResults(BuildContext context) {
    return _resultList();
  }

  _resultList() {
    return SearchResultsWidget(query);
  }
}
