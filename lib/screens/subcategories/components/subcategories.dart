import 'package:admin/components/applocal.dart';
import 'package:admin/responsive.dart';
import 'package:admin/server/categories/get/get_all_agricaltural.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../models/agricultural_model/AgriculturalProperty.dart';
import 'add_subcategory_diaog.dart';
import 'subcategory_card.dart';
import 'subcategory_detail.dart';

class SubCategories extends StatefulWidget {
  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  final ValueNotifier<int> _refreshCategoriesNotifier = ValueNotifier<int>(0);
  Future<List<CategoryApi>>? _propertiesFuture;

  @override
  void initState() {
    super.initState();
    _propertiesFuture = fetchAllCategories();
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
            Text(
              "${getLang(context, 'Category')}",
              style: Theme.of(context).textTheme.titleLarge,

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
                      return  AddSubCategoryDialog(refreshCategoriesNotifier: _refreshCategoriesNotifier,);
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
            return FutureBuilder<List<CategoryApi>>(
              future: Future.value(getDummyProperties()),
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
                } else if (snapshot.hasError) {
                  return Text("${getLang(context, 'empty')}");
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
  late Future<List<CategoryApi>> properties;
  final ValueNotifier<int> _refreshPropertiesNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    properties = fetchAllAgricultural();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _refreshPropertiesNotifier,
          builder: (context, value, child) {
          print(value);
            return FutureBuilder<List<CategoryApi>>(
              future: Future.value(getDummyProperties()),
              builder: (context, snapshot) {
                if(snapshot.data!.isEmpty) {
                  return Center(child: Text("${getLang(context, 'error')}"));
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SubCategoryCard(
                        property: snapshot.data![index], info: null, refreshPropertiesNotifier: _refreshPropertiesNotifier,);
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
  final List<CategoryApi> properties;
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
                builder: (context) => SubCategoryDetailDialog(propertyId: propertyId, refreshPropertiesNotifier :refreshPropertiesNotifier),
              );
            } else {
              print("Category ID is null");
            }
          },
          child: SubCategoryCard(property: properties[index], info: null, refreshPropertiesNotifier: refreshPropertiesNotifier,)
      ),


    );
  }
}

List<CategoryApi> getDummyProperties() {
  return List.generate(10, (index) => CategoryApi(name: 'Mojito', image: ''

  ));
}


