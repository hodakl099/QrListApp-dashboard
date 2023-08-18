import 'package:admin/models/agricultural_model/AgriculturalProperty.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';

class CategoryCard extends StatelessWidget {
  final CategoryApi property;

  const CategoryCard({
    Key? key,
    required this.property, required info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final cardWidth = mediaQuery.size.width * 0.3;
    final imagePadding = 8.0;

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
                  property.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.delete, color: Colors.white54),
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


Widget buildNetworkImage({
  required CategoryApi property,
  required double height,
  required double width,
  required double padding}) {

  String? imageUrl;
  if (property.image.isNotEmpty) {
    if (property.image is String) {
      imageUrl = property.image;
    } else if (property.image is Map) {
      imageUrl = property.image;
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

