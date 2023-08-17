import 'package:flutter/material.dart';
import '../../../constants.dart';


class EmployeeCard extends StatelessWidget {
  final String username;
  final List<String> permissions;
  final String email;


  const EmployeeCard({
    Key? key,
    required this.username,
    required this.permissions, required user, required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.3;

    return Container(
      width: cardWidth,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {

                },
                child: Icon(Icons.delete, color: Colors.white54),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Text(
            username,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            'Permissions:',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.0,
            ),
          ),
          for (String permission in permissions)
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                permission,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}