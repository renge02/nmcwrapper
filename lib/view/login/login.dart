import 'package:flutter/material.dart';
import 'package:nmc_wrapper/data/remote/network/api.end.points.dart';

import 'package:nmc_wrapper/repository/loginRepo/login.repo.dart';
import 'package:nmc_wrapper/repository/registerRepo/service.locator.dart';
import 'package:nmc_wrapper/utils/extensions.dart';
import 'package:nmc_wrapper/utils/secure.storage.dart';
import 'package:nmc_wrapper/view/dashboard/dashboard.dart';
import 'package:nmc_wrapper/view/forget_password/forget_screen.dart';
import 'package:nmc_wrapper/view/registration/registration.dart';
import 'package:nmc_wrapper/view/shared/widgets/custom_alert.dart';
import 'package:nmc_wrapper/view/shared/widgets/custom_text_field.dart';
import 'package:nmc_wrapper/view/webview/webview.dart';
import 'package:provider/provider.dart';

import '../../utils/app_strings.dart';

class LoginScreen extends StatefulWidget {
  final int index;

  const LoginScreen({super.key, this.index = 0});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final provider = LoginProvider();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.index,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) return;
      _clearFields();
    });
  }

  void _clearFields() {
    userNameController.clear();
    passwordController.clear();

    FocusScope.of(context).unfocus();

    _formKey.currentState?.reset();

    provider.clearData(); // optional
  }

  @override
  void dispose() {
    _tabController.dispose();
    provider.dispose();
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color(0xFF0F4C75),
        body: ChangeNotifierProvider.value(
          value: provider,
          child: Consumer<LoginProvider>(
            builder: (ctx, provider, _) {
              provider.isLoading
                  ? context.showLoader(fullScreen: true)
                  : context.hideLoader();

              if (provider.error != null) {
                showAlert(context, 'Unable to login, ${provider.error}');
              }

              if (provider.data != null) {
                if (_tabController.index == 1) {
                  departmentlogin();
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.pushReplacementWidget(const DashboardScreen());
                  });
                }
              }
              return SafeArea(
                child: Column(
                  children: [
                    Center(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/nmc_logo.png',
                                  height: 44,
                                ),
                                6.height(),

                                Image.asset(
                                  'assets/images/app_logo.png',
                                  fit: BoxFit.cover,
                                ).size(height: 150, width: double.infinity),
                                15.height(),
                                Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TabBar(
                                    controller: _tabController,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    indicator: BoxDecoration(
                                      color: const Color(0xFF7A1236),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.black87,
                                    dividerColor: Colors.transparent,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    tabs: const [
                                      Tab(text: "Citizen"),
                                      Tab(text: "Department"),
                                    ],
                                  ),
                                ),

                                20.height(),
                                SizedBox(
                                  height: 420,
                                  child: TabBarView(
                                    controller: _tabController,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      _citizenLogin(provider),
                                      _departmentLogin(provider),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ).expanded(),
                    Container(
                      width: double.infinity,
                      color: const Color(0xFF7A1236),
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        AppStrings.translate(context, 'copyright'),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _citizenLogin(LoginProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.translate(context, 'login'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7A1236),
          ),
        ),

        15.height(),

        CustomTextField(
          title: AppStrings.translate(context, 'username'),
          showRequiredSign: true,
          textInputType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          length: 80,
          lines: 1,
          textController: userNameController,
          validator: (value) {
            if (value!.trim().isEmpty) {
              return AppStrings.translate(context, 'enter_username');
            }

            return null;
          },
        ),

        12.height(),

        /// PASSWORD
        CustomTextField(
          title: AppStrings.translate(context, 'password'),
          showRequiredSign: true,
          textInputType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          length: 20,
          lines: 1,
          textController: passwordController,
          isPassword: true,
          validator: (value) {
            if (value!.trim().isEmpty || value.length < 8) {
              return AppStrings.translate(context, 'enter_password');
            }

            return null;
          },
        ),
        12.height(),

        /// FORGOT PASSWORD
        Row(
          children: [
            GestureDetector(
              onTap: () {
                context.pushWidget(ForgotPasswordScreen(userType: 'CITIZEN'));
              },
              child: Text(
                AppStrings.translate(context, 'forgot_password'),
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        12.height(),

        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7A1236),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                //simulating api delay
                provider.login(
                  userNameController.text.trim(),
                  passwordController.text.trim(),
                );
              }
            },
            child: Text(
              AppStrings.translate(context, 'continue'),
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),

        15.height(),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.translate(context, 'dont_have_account'),
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to Register Screen
                context.pushWidget(RegistrationScreen());
              },
              child: Text(
                AppStrings.translate(context, 'register_here'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),

        12.height(),
      ],
    );
  }

  Widget _departmentLogin(LoginProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.translate(context, 'dept_login'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7A1236),
          ),
        ),

        15.height(),

        CustomTextField(
          title: AppStrings.translate(context, 'username'),
          showRequiredSign: true,
          textInputType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          length: 80,
          lines: 1,
          textController: userNameController,
          validator: (value) {
            if (value!.trim().isEmpty) {
              return AppStrings.translate(context, 'enter_username');
            }

            return null;
          },
        ),

        12.height(),

        /// PASSWORD
        CustomTextField(
          title: AppStrings.translate(context, 'password'),
          showRequiredSign: true,
          textInputType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          length: 20,
          lines: 1,
          textController: passwordController,
          isPassword: true,
          validator: (value) {
            if (value!.trim().isEmpty || value.length < 8) {
              return AppStrings.translate(context, 'enter_password');
            }

            return null;
          },
        ),
        12.height(),

        /// FORGOT PASSWORD
        Row(
          children: [
            GestureDetector(
              onTap: () {
                context.pushWidget(ForgotPasswordScreen(userType: 'EMPLOYEE'));
              },
              child: Text(
                AppStrings.translate(context, 'forgot_password'),
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        12.height(),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7A1236),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                //simulating api delay
                provider.departmentLogin(
                  userNameController.text.trim(),
                  passwordController.text.trim(),
                );
              }
            },
            child: Text(
              AppStrings.translate(context, 'continue'),
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  departmentlogin() async {
    String token = await getIt<SecureStorage>().getToken() ?? '';
    String userData = await getIt<SecureStorage>().getUserData() ?? '';
    final String webUrl =
        '${ApiEndPoints.baseAPIUrl}/upyog-ui/employee/pgr/HomeDashboard';
    context.pushReplacementWidget(
      WebPage(webUrl: webUrl, token: token, userData: userData),
    );
  }
}
