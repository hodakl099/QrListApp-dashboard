
import 'package:admin/models/commercial_model/CommercialProperty.dart';
import 'package:admin/models/industrial_model/CommercialProperty.dart';
import 'package:admin/models/office_model/CommercialProperty.dart';
import 'package:admin/responsive.dart';
import 'package:admin/server/commercial/delete/delete_commercial_by_id.dart';
import 'package:admin/server/industrial/delete/delete_industrial_by_id.dart';
import 'package:admin/server/office/delete/delete_office_by_id.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../server/agricultural/delete/delete_agricultural_by_id.dart';

class OfficeCard extends StatelessWidget {
  final OfficePropertyApi property;
  final ValueNotifier<int>? refreshPropertiesNotifier;

  const OfficeCard({
    Key? key,
    required this.property, required info, required this.refreshPropertiesNotifier
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final cardWidth = mediaQuery.size.width * 0.3;
    final imagePadding = 8.0;

    MenuAppController menuAppController = context.read<MenuAppController>();

    return Container(
      width: cardWidth,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  property.agentContact ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      if (menuAppController.userPermissions.contains('Delete'))
                      return AlertDialog(
                        title: Text('Confirm Deletion'),
                        content: Text('Are you sure you want to delete this property?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Delete'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              bool isDeleted = await deleteOfficeById(property.id!);
                              if (isDeleted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Property deleted successfully')),
                                );
                                refreshPropertiesNotifier?.value++;
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to delete property')),
                                );
                              }
                            },
                          ),
                        ],
                      ); else {
                        return AlertDialog(
                          title: Text('Invalid credential'),
                          content: Text('OPS!...you dont have the credentials to Delete Properties'),
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
                    },
                  );
                },
                child: Icon(Icons.delete, color: Colors.white54),
              ),
            ],
          ),
          SizedBox(height: 8),
          Responsive(
            mobile: Expanded(
              child: buildNetworkImage(
                height: 100,
                width: cardWidth - (2 * (16.0 + imagePadding)),
                padding: imagePadding, property: property,
              ),
            ),
            desktop: Expanded(
              child: buildNetworkImage(
                property: property,
                height: 150,
                width: cardWidth - (2 * (16.0 + imagePadding)),
                padding: imagePadding,
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Location",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.grey[600]),
              ),
              Flexible(
                child: Text(
                  property.location ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget buildNetworkImage({
  required OfficePropertyApi property,
  required double height,
  required double width,
  required double padding}) {

  String? imageUrl;
  if (property.images.isNotEmpty) {
    if (property.images[0] is String) {
      imageUrl = property.images[0];
    } else if (property.images[0] is Map) {
      imageUrl = property.images[0]['url'];
    }
  }

  if (imageUrl == null || imageUrl.isEmpty) {
    return Container(
      padding: EdgeInsets.all(padding),
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Image.asset('assets/images/tajakar.png', fit: BoxFit.cover),
    );
  }

  return Container(
    padding: EdgeInsets.all(padding),
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: primaryColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        );
      },
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return Image.asset('assets/images/tajakar.png', fit: BoxFit.cover);
      },
    ),
  );
}