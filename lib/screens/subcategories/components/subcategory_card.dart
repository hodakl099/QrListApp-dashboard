import 'package:admin/models/agricultural_model/AgriculturalProperty.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../server/agricultural/delete/delete_category_by_id.dart';

class SubCategoryCard extends StatelessWidget {
  final CategoryApi property;
  final ValueNotifier<int>? refreshPropertiesNotifier;

  const SubCategoryCard(
      {Key? key,
      required this.property,
      required info,
      required this.refreshPropertiesNotifier})
      : super(key: key);

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
                InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Deletion'),
                          content: Text(
                              'Are you sure you want to delete this property?'),
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
                                bool isDeleted =
                                    await deleteAgriculturalById(property.id!);
                                if (isDeleted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Property deleted successfully')),
                                  );
                                  refreshPropertiesNotifier?.value++;
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Failed to delete property')),
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(Icons.delete, color: Colors.white54),
                )
            ],
          ),
          SizedBox(height: 8),
          Responsive(
            mobile: Expanded(
              child: buildNetworkImage(
                height: 100,
                width: cardWidth - (2 * (16.0 + imagePadding)),
                padding: imagePadding,
                category: property,
              ),
            ),
            desktop: Expanded(
              child: buildNetworkImage(
                category: property,
                height: 150,
                width: cardWidth - (2 * (16.0 + imagePadding)),
                padding: imagePadding,
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  property.name ?? '',
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

Widget buildNetworkImage(
    {required CategoryApi category,
    required double height,
    required double width,
    required double padding}) {
  String? imageUrl;
  if (category.image.isNotEmpty) {
    if (category.image is String) {
      imageUrl = category.image;
    } else if (category.image is Map) {
      imageUrl = category.image;
    }
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
      imageUrl ?? '',
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        );
      },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return Image.asset('assets/images/tajakar.png', fit: BoxFit.cover);
      },
    ),
  );
}
