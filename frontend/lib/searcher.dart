import 'package:flutter/material.dart';

class Searcher extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('Search result for: $query'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Suggestion $index for "$query"'),
          onTap: () {
            query = 'Suggestion $index';
            showResults(context);
          },
        );
      },
    );
  }
}