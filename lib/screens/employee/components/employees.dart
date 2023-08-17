import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../server/firebase/fetch_users.dart';
import 'add_employee_diaog.dart';
import 'employee_card.dart';

class Employees extends StatefulWidget {
  @override
  _EmployeesState createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  final ValueNotifier<int> _refreshPropertiesNotifier = ValueNotifier<int>(0);
  Future<List<User>>? _employeesFuture;

  @override
  void initState() {
    super.initState();
    _employeesFuture = fetchEmployees(); // Fetch once during initialization
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Employees",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                  defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      AddEmployeeDialog(refreshPropertiesNotifier: _refreshPropertiesNotifier,),
                );
              },
              icon: Icon(Icons.add),
              label: Text("Add New Employee"),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        ValueListenableBuilder(
          valueListenable: _refreshPropertiesNotifier,
          builder: (context, value, child) {
            return FutureBuilder<List<User>>(
              future: fetchEmployees(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Responsive(
                    mobile: FileInfoCardGridView(
                      users: snapshot.data!,
                      crossAxisCount: _size.width < 650 ? 2 : 4,
                      childAspectRatio: _size.width < 650 && _size.width > 350
                          ? 1.3
                          : 1, refreshPropertiesNotifier: _refreshPropertiesNotifier,
                    ),
                    tablet: FileInfoCardGridView(users: snapshot.data!, refreshPropertiesNotifier: _refreshPropertiesNotifier,),
                    desktop: FileInfoCardGridView(
                      users: snapshot.data!,
                      childAspectRatio: _size.width < 1400 ? 1.1 : 1.4, refreshPropertiesNotifier: _refreshPropertiesNotifier,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("There are no Employees.");
                }
                return CircularProgressIndicator();
              },
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _refreshPropertiesNotifier.dispose();
    super.dispose();
  }
}

class FileInfoCardGridView extends StatelessWidget {
  final List<User> users;
  final int crossAxisCount;
  final double childAspectRatio;
  final ValueNotifier<int> refreshPropertiesNotifier;

  const FileInfoCardGridView({
    Key? key,
    required this.users,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1, required this.refreshPropertiesNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: users.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: defaultPadding,
          mainAxisSpacing: defaultPadding,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) => EmployeeCard(user: users[index], username: users[index].username, permissions: users[index].permissions, email: users[index].email,)
    );
  }
}
