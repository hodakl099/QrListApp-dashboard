import 'package:admin/models/commercial_model/CommercialProperty.dart';
import 'package:admin/models/industrial_model/CommercialProperty.dart';
import 'package:admin/server/commercial/get/get_commercial_by_id.dart';
import 'package:admin/server/industrial/delete/delete_industrial_image_by_id.dart';
import 'package:admin/server/industrial/delete/delete_industrial_video_by_id.dart';
import 'package:admin/server/industrial/get/get_industrial_by_id.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../controllers/MenuAppController.dart';
import '../../../server/agricultural/delete/delete_agricultural_image_by_id.dart';
import '../../../server/agricultural/delete/delete_agricultural_video_by_id.dart';
import 'edit_industrial_form.dart';

class IndustrialDetailDialog extends StatelessWidget {
  final String propertyId;
  final ValueNotifier<int> refreshPropertiesNotifier;

  // Constant Suffix.
  static const String acresSuffix = "M²";
  static const String priceSuffix = "LYD";

  IndustrialDetailDialog({required this.propertyId, required this.refreshPropertiesNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: refreshPropertiesNotifier,
      builder: (BuildContext context, int value, Widget? child) {
       return Dialog(
          child: FutureBuilder<IndustrialPropertyApi>(
            future: fetchIndustrialById(propertyId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                IndustrialPropertyApi property = snapshot.data!;
                List<String> imageUrls = [];
                List<VideoPlayerController> videoControllers = [];

                MenuAppController menuAppController =
                context.read<MenuAppController>();

                for (var image in property.images) {
                  imageUrls.add(image['url']);
                }

                for (var video in property.videos) {
                  videoControllers.add(VideoPlayerController.network(video['url']));
                }

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
                                  child: EditIndustrialForm(
                                    property: property,
                                    refreshPropertiesNotifier: refreshPropertiesNotifier,
                                  ),
                                ); else {
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
                              }
                            );
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
                                        return AlertDialog(
                                          title: Text('Confirm Deletion'),
                                          content: Text('Are you sure you want to delete this Image?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(dialogContext).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Delete'),
                                              onPressed: () async {
                                                Navigator.of(dialogContext).pop();
                                                _showDeletingImageDialog(context);
                                                String imageId = property.images[index]['imageId'].toString();
                                                bool isDeleted = await deleteIndustrialImageById(propertyId, imageId);
                                                Navigator.of(context).pop();
                                                if (isDeleted) {
                                                  final snackBar = SnackBar(content: Text('Image Deleted Successfully'));
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  refreshPropertiesNotifier.value++;
                                                } else {
                                                  final snackBar = SnackBar(content: Text('Failed to delete the image.'));
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                      SizedBox(height: 10,),
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
                                      child:   InkWell(
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext dialogContext) {
                                              if(menuAppController.userPermissions.contains('Delete'))
                                              return AlertDialog(
                                                title: Text('Confirm Deletion'),
                                                content: Text('Are you sure you want to delete this Video?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(dialogContext).pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Delete'),
                                                    onPressed: () async {
                                                      Navigator.of(dialogContext).pop();
                                                      _showDeletingVideoDialog(context);
                                                      int index = videoControllers.indexOf(controller);
                                                      String videoId = property.videos[index]['videoId'].toString();
                                                      bool isDeleted = await deleteIndustrialVideoById(propertyId, videoId);
                                                      if (isDeleted) {
                                                        final snackBar = SnackBar(content: Text('Video Deleted Successfully'));
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                        refreshPropertiesNotifier.value++;
                                                        Navigator.of(context).pop();
                                                      } else {
                                                        final snackBar = SnackBar(content: Text('Failed to delete the video.'));
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      }
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
                                        child: Icon(Icons.delete, color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Agent Contact: ${property.agentContact}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Property Type: ${property.propertyType}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Location: ${property.location}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Acres: ${property.acres}${IndustrialDetailDialog.acresSuffix}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Price: ${property.price}${IndustrialDetailDialog.priceSuffix}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Zoning Information: ${property.zoningInfo}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Celling Height: ${property.cellingHeight}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Number of Loading Docks: ${property.numberOfLoadingDocks}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Power Capabilities: ${property.powerCapabilities}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Access to Transportation: ${property.accessToTransportation}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Environmental Reports : ${property.environmentalReports}'),
                      ),


                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("Failed to load property. Please try again later.");
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
