import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_venue/providers/products_provider.dart';
import 'package:shop_venue/screens/product_details_screen.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchItems =
        Provider.of<Products>(context, listen: false).getsearchItems(query);

    return ListView.builder(
      itemBuilder: (ctx, index) => Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, ProductDetails.routename,
                  arguments: searchItems[index].id);
            },
            title: Text(searchItems[index].title),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(searchItems[index].imageURL),
            ),
          ),
          Divider(),
        ],
      ),
      itemCount: searchItems.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchItems = Provider.of<Products>(context).getsearchItems(query);
    return query.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text('Search product items'),
              ),
            ],
          )
        : ListView.builder(
            itemBuilder: (ctx, index) => Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, ProductDetails.routename,
                        arguments: searchItems[index].id);
                  },
                  title: Text(searchItems[index].title),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(searchItems[index].imageURL),
                  ),
                ),
                Divider(),
              ],
            ),
            itemCount: searchItems.length,
          );
  }
}
