import 'package:admin/models/commercial_model/CommercialProperty.dart';
import 'package:admin/models/industrial_model/CommercialProperty.dart';
import 'package:admin/responsive.dart';
import 'package:admin/server/commercial/get/get_all_commercial.dart';
import 'package:admin/server/industrial/get/get_all_industrial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../controllers/MenuAppController.dart';
import 'add_industrial_diaog.dart';
import 'industrial_card.dart';
import 'industrial_detail.dart';

class IndustrialProperties extends StatefulWidget {
  @override
  _IndustrialPropertiesState createState() => _IndustrialPropertiesState();
}

class _IndustrialPropertiesState extends State<IndustrialProperties> {
  final ValueNotifier<int> _refreshPropertiesNotifier = ValueNotifier<int>(0);
  Future<List<IndustrialPropertyApi>>? _propertiesFuture;

  @override
  void initState() {
    super.initState();
    _propertiesFuture = fetchIndustrials(); // Fetch once during initialization
  }


  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    MenuAppController menuAppController =
    context.read<MenuAppController>();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Industrial Properties",
              style: Theme.of(context).textTheme.titleMedium,
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
                  builder: (context)  {
                    if(menuAppController.userPermissions.contains('Add'))
                      return AddIndustrialDialog(refreshPropertiesNotifier: _refreshPropertiesNotifier,);
                    else return AlertDialog(
                      title: Text('Invalid credential'),
                      content: Text('OPS!...you dont have the credentials to add Properties'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Dismiss'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  }

                );
              },
              icon: Icon(Icons.add),
              label: Text("Add New Property"),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        ValueListenableBuilder(
          valueListenable: _refreshPropertiesNotifier,
          builder: (context, value, child) {
            return FutureBuilder<List<IndustrialPropertyApi>>(
              future: fetchIndustrials(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Responsive(
                    mobile: FileInfoCardGridView(
                      properties: snapshot.data!,
                      crossAxisCount: _size.width < 650 ? 2 : 4,
                      childAspectRatio: _size.width < 650 && _size.width > 350
                          ? 1.3
                          : 1, refreshPropertiesNotifier: _refreshPropertiesNotifier,
                    ),
                    tablet: FileInfoCardGridView(properties: snapshot.data!, refreshPropertiesNotifier: _refreshPropertiesNotifier,),
                    desktop: FileInfoCardGridView(
                      properties: snapshot.data!,
                      childAspectRatio: _size.width < 1400 ? 1.1 : 1.4, refreshPropertiesNotifier: _refreshPropertiesNotifier,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("There is no Commercial Properties available.");
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
    _refreshPropertiesNotifier.dispose();
    super.dispose();
  }


}

class PropertyListPage extends StatefulWidget {
  @override
  _PropertyListPageState createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  late Future<List<CommercialPropertyApi>> properties;
  final ValueNotifier<int> _refreshPropertiesNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    properties = fetchCommercials();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _refreshPropertiesNotifier,
          builder: (context, value, child) {
          print(value);
            return FutureBuilder<List<IndustrialPropertyApi>>(
              future: fetchIndustrials(),
              builder: (context, snapshot) {
                if(snapshot.data!.isEmpty) {
                  return Center(child: Text("No properties available"));
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return IndustrialCard(
                        property: snapshot.data![index], info: null, refreshPropertiesNotifier: _refreshPropertiesNotifier,);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("There is no Commercial Properties available.");
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
  final List<IndustrialPropertyApi> properties;
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
                builder: (context) => IndustrialDetailDialog(propertyId: propertyId, refreshPropertiesNotifier :refreshPropertiesNotifier),
              );
            } else {
              print("Property ID is null");
            }
          },
          child: IndustrialCard(property: properties[index], info: null, refreshPropertiesNotifier: refreshPropertiesNotifier,)
      ),


    );
  }
}

