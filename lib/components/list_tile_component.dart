import 'package:flutter/material.dart';

class EmployeeList extends StatelessWidget {
  final List<dynamic> employees;
  final Function(dynamic) onEmployeeTap;

  const EmployeeList({
    Key? key,
    required this.employees,
    required this.onEmployeeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];

        return GestureDetector(
          onTap: () => onEmployeeTap(employee),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                employee['objectUrl'],
              ),
              radius: 26,
            ),
            title: Text(
              employee['employeeName'],
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
            subtitle: Text(
                'ID: ${employee['employeeId']} - ${employee['position']}'),
          ),
        );
      },
    );
  }
}
