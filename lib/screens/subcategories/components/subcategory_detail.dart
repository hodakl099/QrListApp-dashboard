import 'package:admin/models/agricultural_model/AgriculturalProperty.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../server/agricultural/delete/delete_category_image_by_id.dart';
import '../../../server/agricultural/delete/delete_agricultural_video_by_id.dart';
import '../../../server/agricultural/get/get_category_by_id.dart';
import 'edit_subcategory_form.dart';

class SubCategoryDetailDialog extends StatelessWidget {
  final String propertyId;
  final ValueNotifier<int> refreshPropertiesNotifier;

  // Constant Suffix.
  static const String acresSuffix = "M²";
  static const String priceSuffix = "LYD";

  SubCategoryDetailDialog(
      {required this.propertyId, required this.refreshPropertiesNotifier});

  @override
  Widget build(BuildContext context) {


    return ValueListenableBuilder(
      valueListenable: refreshPropertiesNotifier,
      builder: (BuildContext context, int value, Widget? child) {
        return Dialog(
          child: FutureBuilder<CategoryApi>(
            future: fetchAgriculturalById(propertyId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                CategoryApi property = snapshot.data!;
                List<String> imageUrls = [];
                List<VideoPlayerController> videoControllers = [];
                MenuAppController menuAppController =
                    context.read<MenuAppController>();


                return SingleChildScrollView(
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
                                  if (menuAppController.userPermissions
                                      .contains('Edit'))
                                    return Dialog(
                                      child: EditSubCategoryForm(
                                        property: property,
                                        refreshPropertiesNotifier:
                                            refreshPropertiesNotifier,
                                      ),
                                    );
                                  else {
                                    return AlertDialog(
                                      title: Text('Invalid credential'),
                                      content: Text(
                                          'OPS!...you dont have the credentials to Edit Properties'),
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
                                });
                          },
                        ),
                      ),
                      CarouselSlider.builder(
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index, _) {
                          if (imageUrls.isNotEmpty) {
                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Image.network(
                                  imageUrls[index],
                                  fit: BoxFit.cover,
                                ),
                                InkWell(
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                          if(menuAppController.userPermissions.contains('Delete'))
                                            return  AlertDialog(
                                          title: Text('Confirm Deletion'),
                                          content: Text(
                                              'Are you sure you want to delete this Image?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(dialogContext)
                                                    .pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Delete'),
                                              onPressed: () async {
                                                Navigator.of(dialogContext)
                                                    .pop();
                                                _showDeletingImageDialog(
                                                    context);
                                                String imageId = property.image;
                                                bool isDeleted =
                                                    await deleteAgriculturalImageById(
                                                        propertyId, imageId);
                                                if (isDeleted) {
                                                  final snackBar = SnackBar(
                                                      content: Text(
                                                          'Image Deleted Successfully'));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                  refreshPropertiesNotifier
                                                      .value++;
                                                  Navigator.of(context).pop();
                                                } else {
                                                  final snackBar = SnackBar(
                                                      content: Text(
                                                          'Failed to delete the image.'));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                }
                                              },
                                            ),
                                          ],
                                        ); else {
                                          return AlertDialog(
                                            title: Text('Invalid credential'),
                                            content: Text('OPS!...you dont have the credentials to Delete Images'),
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
                                  child: Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            );
                          } else {
                            return Container(
                              color: Colors.grey,
                              child: Center(
                                child: Text(
                                  'No Images Available. Please add at least one image.',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }
                        },
                        options: CarouselOptions(
                          height: 300,
                          viewportFraction: 1,
                          enlargeCenterPage: true,
                          autoPlay: false,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      for (var controller in videoControllers)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 400,
                              height: 400,
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Chewie(
                                    controller: ChewieController(
                                      videoPlayerController: controller,
                                      aspectRatio: 16 / 9,
                                      autoPlay: false,
                                      looping: false,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: InkWell(
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (BuildContext dialogContext) {
                                           if(menuAppController.userPermissions.contains('Delete'))
                                            return AlertDialog(
                                              title: Text('Confirm Deletion'),
                                              content: Text(
                                                  'Are you sure you want to delete this Image?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(dialogContext)
                                                        .pop();
                                                  },
                                                ),
                                              ],
                                            ); else {
                                            return AlertDialog(
                                               title: Text('Invalid credential'),
                                               content: Text('OPS!...you dont have the credentials to Delete Videos'),
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
                                      child:
                                          Icon(Icons.delete, color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Category name: ${property.name}'),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("Failed to load Category. Please try again later.");
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

  void _showDeletingVideoDialog(BuildContext context) {
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
              Text("Deleting Video..."),
            ],
          ),
        );
      },
    );
  }
}
