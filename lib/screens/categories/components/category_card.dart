import 'package:admin/components/applocal.dart';
import 'package:admin/responsive.dart';
import 'package:admin/server/categories/delete/delete_category_by_id.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../models/category_model/Category.dart';


class CategoryCard extends StatelessWidget {
  final CategoryApi category;
  final ValueNotifier<int>? refreshPropertiesNotifier;

  const CategoryCard(
      {Key? key,
      required this.category,
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
                          title: Text('${getLang(context, 'Confirm Deletion')}'),
                          content: Text(
                              '${getLang(context, 'deleteForever')}'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('${getLang(context, 'Cancel')}'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('${getLang(context, 'Delete')}'),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                bool isDeleted =
                                    await deleteCategoryById(category.id!.toString());
                                if (isDeleted) {
                                  Fluttertoast.showToast(
                                      toastLength: Toast.LENGTH_LONG,
                                      msg: '${getLang(context, 'Category deleted successfully')}'
                                  );
                                  refreshPropertiesNotifier?.value++;
                                } else {
                                  Fluttertoast.showToast(
                                    toastLength: Toast.LENGTH_LONG,
                                      msg: '${getLang(context, 'Failed to delete Category')}'
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
                category: category,
              ),
            ),
            desktop: Expanded(
              child: buildNetworkImage(
                category: category,
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
                  category.name ?? '',
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
  required CategoryApi category,
  required double height,
  required double width,
  required double padding
}) {
  String? imageUrl = category.image;  // Directly get the imageUrl field

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
        return Image.asset('assets/images/foodplaceholder.jpeg', fit: BoxFit.cover);
      },
    ),
  );
}
