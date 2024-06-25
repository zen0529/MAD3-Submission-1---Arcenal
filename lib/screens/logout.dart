import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile3_midterm/controller/authcontroller.dart';
import 'package:mobile3_midterm/services.dart/waiting_dialog.dart';

class logout extends StatelessWidget {
  const logout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 350),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: SizedBox(
                width: 200,
                height: 34,
                child: Material(
                  elevation: 10,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      onSubmit(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.logout),
                        SizedBox(
                          width: 3,
                        ),
                        Text('Log out'),
                      ],
                    ),
                  ),
                ),
              )),
          SizedBox(height: 300),
        ],
      ),
    );
  }

  onSubmit(BuildContext context) async {
    WaitingDialog.show(context, future: AuthController.I.logout());
    // Wait for the logout process to complete
    await AuthController.I.logout();
    // Navigate to the login screen
    GoRouter.of(context).go('/login');
  }
}
