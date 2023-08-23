import 'package:admin/components/applocal.dart';
import 'package:admin/server/categories/delete/delete_category_by_id.dart';
import 'package:admin/server/categories/get/get_category_by_id.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../models/category_model/Category.dart';
import 'edit_category_form.dart';

class CategoryDetailDialog extends StatelessWidget {
  final String propertyId;
  final ValueNotifier<int> refreshPropertiesNotifier;

  CategoryDetailDialog({
    required this.propertyId,
    required this.refreshPropertiesNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: refreshPropertiesNotifier,
      builder: (BuildContext context, int value, Widget? child) {
        return Dialog(
          child: FutureBuilder<CategoryApi>(
            future: fetchCategoryById(propertyId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                CategoryApi property = snapshot.data!;
                MenuAppController menuAppController =
                context.read<MenuAppController>();


                String imageUrl = property.image;

                return SingleChildScrollView(
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: EditCategoryForm(
                                      property: property,
                                      refreshPropertiesNotifier:
                                      refreshPropertiesNotifier,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Image.network(
                              imageUrl,
                              height: 300,
                              width: 300,
                              fit: BoxFit.cover,
                            ),
                            InkWell(
                              onTap: () async {
                                _showDeleteConfirmation(
                                    context, menuAppController, property);
                              },
                              child: Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${getLang(context, 'Category name')}: ${property.name}'),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${getLang(context, 'failedToLoad')}");
              }
              return Container(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(),
              );
            },
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context,
      MenuAppController menuAppController,
      CategoryApi property) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('${getLang(context, 'Confirm Deletion')}'),
            content: Text('${getLang(context, 'imageDeletionConfirm')}'),
            actions: <Widget>[
              TextButton(
                child: Text('${getLang(context, 'Cancel')}'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              TextButton(
                child: Text('${
                getLang(context, 'Delete')
                }'),
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  _showDeletingImageDialog(context);
                  String imageId = property.image;
                  bool isDeleted = await deleteCategoryById(propertyId);
                  if (isDeleted) {
                    Fluttertoast.showToast(msg: "${
                    getLang(context, 'imageDeletedSuccessfully')
                    }");
                    refreshPropertiesNotifier.value++;
                    Navigator.of(context).pop();
                  } else {
                    Fluttertoast.showToast(msg: "${getLang(context, 'failedToDeleteImage')}");
                  }
                },
              ),
            ],
          );
      },
    );
  }

  void _showDeletingImageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Deleting Image..."),
            ],
          ),
        );
      },
    );
  }
}
