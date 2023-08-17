import 'package:admin/constants.dart';
import 'package:flutter/material.dart';

class PropertyCard {
  final String? svgSrc, title, location;
  final Color? color;

  PropertyCard({
    this.svgSrc,
    this.title,
    this.location,
    this.color,
  });
}

List demoMyFiles = [
  PropertyCard(
    title: "Taj Akar",
    svgSrc: "assets/icons/Documents.svg",
    location: "Tajura",
    color: primaryColor,
  ),
  PropertyCard(
    title: "Tripoli Mall",
    svgSrc: "assets/icons/google_drive.svg",
    location: "Tarhuna",
    color: Color(0xFFFFA113),
  ),
  PropertyCard(
    title: "Land Bir Al-alim",
    svgSrc: "assets/icons/one_drive.svg",
    location: "Hoon",
    color: Color(0xFFA4CDFF),
  ),
  PropertyCard(
    title: "Demo Apartment",
    svgSrc: "assets/icons/drop_box.svg",
    location: "Benghazi",
    color: Color(0xFF007EE5),
  ),
  PropertyCard(
    title: "Taj Akar",
    svgSrc: "assets/icons/Documents.svg",
    location: "Tajura",
    color: primaryColor,
  ),
  PropertyCard(
    title: "Taj Akar",
    svgSrc: "assets/icons/Documents.svg",
    location: "Tajura",
    color: primaryColor,
  ),
  PropertyCard(
    title: "Tripoli Mall",
    svgSrc: "assets/icons/google_drive.svg",
    location: "Tarhuna",
    color: Color(0xFFFFA113),
  ),
  PropertyCard(
    title: "Land Bir Al-alim",
    svgSrc: "assets/icons/one_drive.svg",
    location: "Hoon",
    color: Color(0xFFA4CDFF),
  ),
  PropertyCard(
    title: "Demo Apartment",
    svgSrc: "assets/icons/drop_box.svg",
    location: "Benghazi",
    color: Color(0xFF007EE5),
  ),
  PropertyCard(
    title: "Taj Akar",
    svgSrc: "assets/icons/Documents.svg",
    location: "Tajura",
    color: primaryColor,
  ),
];
