import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../models/agricultural_model/AgriculturalProperty.dart';
import '../../../server/agricultural/get/get_all_agricaltural.dart';
import 'add_agricaltural_diaog.dart';
import 'property_card.dart';

class MyProperties extends StatefulWidget {
  @override
  _MyPropertiesState createState() => _MyPropertiesState();
}

class _MyPropertiesState extends State<MyProperties> {
  late Future<List<AgriculturalPropertyApi>> _propertiesFuture;



  @override
  void initState() {
    super.initState();
    _propertiesFuture = fetchAllAgricultural();
  }


  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: defaultPadding),
    ]
    );
  }
}

class PropertyListPage extends StatefulWidget {
  @override
  _PropertyListPageState createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  late Future<List<AgriculturalPropertyApi>> properties;


  @override
  void initState() {
    super.initState();
    properties = fetchAllAgricultural();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AgriculturalPropertyApi>>(
        future: properties,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return PropertyListCard(property: snapshot.data![index], info: null,);
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  final List<AgriculturalPropertyApi> properties;
  final int crossAxisCount;
  final double childAspectRatio;


  const FileInfoCardGridView({
    Key? key,
    required this.properties,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
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
      itemBuilder: (context, index) => PropertyListCard(property: properties[index], info: null,),
    );
  }
}

