import 'package:admin/components/applocal.dart';
import 'package:admin/responsive.dart';
import 'package:admin/server/categories/get/get_all_categories.dart';
import 'package:admin/server/sub_categories/get/get_subcategries_by_id.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../models/category_model/Category.dart';
import '../../../models/sub_category/SubCategoryModel.dart';
import 'add_subcategory_diaog.dart';
import 'subcategory_card.dart';
import 'subcategory_detail.dart';

class SubCategories extends StatefulWidget {
  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  final ValueNotifier<int> _refreshCategoriesNotifier = ValueNotifier<int>(0);
  Future<List<SubCategory>>? _subCategories;
  Future<List<CategoryApi>>? _categories;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();

    _categories = fetchAllCategories();
    _categories?.then((categories) {
      if (categories.isNotEmpty && selectedCategory == null) {
        setState(() {
          selectedCategory = categories[0].id.toString();
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    MenuAppController menuAppController = context.read<MenuAppController>();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "${getLang(context, 'Category')}",
                  style: Theme.of(context).textTheme.titleLarge,

                ),
                SizedBox(width: 30,),
                FutureBuilder<List<CategoryApi>>(
                  future: _categories,
                  builder: (context, snapshot) {
                    // If the connection is still ongoing, return a loading indicator.
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    // If we're done and we have data, return the dropdown.
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      return DropdownButton<String>(
                        value: selectedCategory,
                        onChanged: (String? newValue) {
                          setState(
                                  () {
                            selectedCategory = newValue;
                            _subCategories = getSubCategoriesById(selectedCategory!);
                          }
                          );
                        },
                        items: snapshot.data!.map((CategoryApi category) {
                          return DropdownMenuItem<String>(
                            value: category.id.toString(),
                            child: Padding(
                              padding: EdgeInsets.only(right: 10 ),
                                child: Center(child: Text(category.name))),
                          );
                        }).toList(),
                        iconSize: 18,
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done && (snapshot.data == null || snapshot.data!.isEmpty)) {
                      return Text('${getLang(context, 'empty')}');
                    }

                    if (snapshot.hasError) {
                      return Text("${getLang(context, 'wentWrong')}");
                    }

                    return Text('${getLang(context, 'Add New Category')}');
                  },
                ),
              ]
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                  defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                      return  AddSubCategoryDialog(refreshCategoriesNotifier: _refreshCategoriesNotifier,selectedCategory : selectedCategory!);
                  }
                );
              },
              icon: Icon(Icons.add),
              label: Text("${getLang(context, 'Add New Category')}"),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        ValueListenableBuilder(
          valueListenable: _refreshCategoriesNotifier,
          builder: (context, value, child) {
            if (selectedCategory == null) {
              return Text('${getLang(context, 'addParentCategory')}');
            }
            _subCategories = getSubCategoriesById(selectedCategory!);
            return FutureBuilder<List<SubCategory>>(
              future: _subCategories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Responsive(
                    mobile: FileInfoCardGridView(
                      properties: snapshot.data!,
                      crossAxisCount: _size.width < 650 ? 2 : 4,
                      childAspectRatio: _size.width < 650 && _size.width > 350
                          ? 1.3
                          : 1, refreshPropertiesNotifier: _refreshCategoriesNotifier,
                    ),
                    tablet: FileInfoCardGridView(properties: snapshot.data!, refreshPropertiesNotifier: _refreshCategoriesNotifier,),
                    desktop: FileInfoCardGridView(
                      properties: snapshot.data!,
                      childAspectRatio: _size.width < 1400 ? 1.1 : 1.4, refreshPropertiesNotifier: _refreshCategoriesNotifier,
                    ),
                  );
                }
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text("${getLang(context, 'empty')}");
                }
                if (snapshot.connectionState == ConnectionState.done && (snapshot.data == null || snapshot.data!.isEmpty)) {
                  return Text('There is no categories available, add new categories!');
                }
                return CircularProgressIndicator();
              },
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _refreshCategoriesNotifier.dispose();
    super.dispose();
  }
}

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  late Future<List<SubCategory>> subcategories;
  final ValueNotifier<int> _refreshPropertiesNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    subcategories = getSubCategoriesById('2');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _refreshPropertiesNotifier,
          builder: (context, value, child) {
          subcategories = getSubCategoriesById('2');
            return FutureBuilder<List<SubCategory>>(
              future: subcategories,
              builder: (context, snapshot) {
                if(snapshot.data!.isEmpty) {
                  return Center(child: Text("${getLang(context, 'error')}"));
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SubCategoryCard(
                        category: snapshot.data![index], info: null, refreshPropertiesNotifier: _refreshPropertiesNotifier,);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${getLang(context, 'error')}");
                }
                return CircularProgressIndicator();
              },
            );
          }
      ),
    );
  }

  @override
  void dispose() {
    _refreshPropertiesNotifier.dispose();
    super.dispose();
  }
}

class FileInfoCardGridView extends StatelessWidget {
  final List<SubCategory> properties;
  final int crossAxisCount;
  final double childAspectRatio;
  final ValueNotifier<int> refreshPropertiesNotifier;

  const FileInfoCardGridView({
    Key? key,
    required this.properties,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1, required this.refreshPropertiesNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: properties.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            var propertyId = properties[index].id;
            print('Property ID: $propertyId');

            if (propertyId != null) {
              showDialog(
                context: context,
                builder: (context) => SubCategoryDetailDialog(propertyId: propertyId.toString(), refreshPropertiesNotifier :refreshPropertiesNotifier),
              );
            } else {
              print("Category ID is null");
            }
          },
          child: SubCategoryCard(category: properties[index], info: null, refreshPropertiesNotifier: refreshPropertiesNotifier,)
      ),
    );
  }
}

