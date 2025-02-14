import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EmployeeList extends StatefulWidget {
  final List<dynamic> employees;
  final Function(dynamic) onEmployeeTap;

  const EmployeeList({
    super.key,
    required this.employees,
    required this.onEmployeeTap,
  });

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Repeats the animation for skeleton effect
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.employees.length,
      itemBuilder: (context, index) {
        final employee = widget.employees[index];

        return GestureDetector(
          onTap: () => widget.onEmployeeTap(employee),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey[300],
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: employee['objectUrl'],
                    fit: BoxFit.cover,
                    width: 52,
                    height: 52,
                    placeholder: (context, url) => AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _controller.value,
                          child: const Icon(
                            Icons.image,
                            size: 28,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.person,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              employee['employeeName'],
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
            subtitle:
                Text('ID: ${employee['employeeId']} - ${employee['position']}'),
          ),
        );
      },
    );
  }
}
