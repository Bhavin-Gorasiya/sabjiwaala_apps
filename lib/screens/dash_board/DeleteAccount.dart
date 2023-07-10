import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';


import '../../../../View Models/CustomViewModel.dart';
import '../../../../api/app_preferences.dart';
import '../../Widgets/app_dialogs.dart';
import '../../theme/colors.dart';
import '../../utils/helper.dart';
import '../auth/signup_screen.dart';

BuildContext? parentContextProfile;

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      parentContextProfile = context;
    });

    // final providerListener = Provider.of<CustomViewModel>(context);

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 30, top: 40),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 30),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Padding(
                  padding: EdgeInsets.only(right: 10, left: 10),
                  child: Icon(Icons.delete_forever,
                      color: AppColors.primary, size: 80),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Delete\nYour account",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2?.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 1),
              child: Text(
                "By clicking on the delete you're agree to delete your account.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5?.copyWith(),
              ),
            ),
            InkWell(
              onTap: () async {
                String? _isLoggedIn = await AppPreferences.getLoggedin();

                if (_isLoggedIn == "31") {
                  final _confirm =
                      await AppDialog.gotoLoginConfirmation(context);
                  if (_confirm) {
                    AppPreferences.clearAll();

                    pop(context);
                    pushReplacement(context, const LoginScreen());
                  }
                } else {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      contentPadding:
                          const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 20.0),
                      title: Center(
                        child: Text(
                          'Delete Account?',
                          textScaleFactor: 1,
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              'This operation is permanent. Are you sure you want to delete your account?',
                              textScaleFactor: 1,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(),
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              height: 40,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "No",
                                        textScaleFactor: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final _provider =
                                            context.read<CustomViewModel>();
                                        EasyLoading.show(status: 'Deleting...');
                                        var _isLoggedIn =
                                            await AppPreferences.getLoggedin();
                                        await _provider
                                            .deleteAccount()
                                            .then((value) async {
                                          EasyLoading.dismiss();
                                          if (value == "success") {
                                            commonToast(context,
                                                "Account has been deleted");
                                            AppPreferences.clearAll();
                                            pop(context);
                                            pop(context);
                                            pushReplacement(
                                                context, const LoginScreen());
                                          } else {
                                            commonToast(context, value);
                                          }
                                        });
                                      },
                                      child: Text(
                                        "Delete",
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            ?.copyWith(),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Center(
                    child: Text(
                      "Delete",
                      style: Theme.of(context).textTheme.button?.copyWith(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
