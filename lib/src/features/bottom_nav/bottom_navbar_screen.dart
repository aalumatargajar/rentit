import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentit/src/common/const/global_variable.dart';
import 'package:rentit/src/common/const/static_data.dart';
import 'package:rentit/src/features/auth/auth_provider.dart';
import 'package:rentit/src/features/bottom_nav/bottom_navbar_provider.dart';

class BottomNavbarScreen extends StatefulWidget {
  const BottomNavbarScreen({super.key});

  @override
  State<BottomNavbarScreen> createState() => _BottomNavbarScreenState();
}

class _BottomNavbarScreenState extends State<BottomNavbarScreen> {
  //! ------------------- INIT STATE ---------------------
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    if (StaticData.adminAuthenticationModel == null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        final provider = Provider.of<AuthenticationProvider>(
          context,
          listen: false,
        );
        provider.getUserData(context: context, id: StaticData.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavbarProvider>(
      builder:
          (context, bottomNavProvider, child) => Scaffold(
            resizeToAvoidBottomInset: false,
            // appBar: AppBar(
            //   leadingWidth: 45,
            //   titleSpacing: 8,
            //   leading: Padding(
            //     padding: EdgeInsets.only(left: 10),
            //     child: CircleAvatar(
            //       backgroundColor: Colors.white,
            //       foregroundColor: colorScheme(context).primary,
            //       child: IconButton(
            //         iconSize: 20,
            //         padding: const EdgeInsets.all(2),
            //         visualDensity: VisualDensity.compact,
            //         onPressed: () {
            //           // context.pushNamed(AppRoutes.editProfile);
            //         },
            //         icon: const Icon(Icons.person),
            //       ),
            //     ),
            //   ),
            //   title: InkWell(
            //     onTap: () {
            //       // context.pushNamed(AppRoutes.editProfile);
            //     },
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Welcome,",
            //           style: txtTheme(
            //             context,
            //           ).bodyMedium?.copyWith(color: Colors.black),
            //         ),
            //         Consumer<AuthenticationProvider>(
            //           builder:
            //               (context, authProvider, child) => Text(
            //                 StaticData.adminAuthenticationModel?.name ?? '',
            //                 maxLines: 1,
            //                 style: txtTheme(context).titleSmall,
            //                 overflow: TextOverflow.ellipsis,
            //               ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            body: SafeArea(
              child: PageView(
                controller: bottomNavProvider.pageController,
                onPageChanged: (index) {
                  bottomNavProvider.changeIndex(index: index);
                },
                children: bottomNavProvider.screens,
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: BottomNavigationBar(
                  selectedLabelStyle: txtTheme(context).labelSmall,
                  unselectedLabelStyle: txtTheme(context).labelSmall,
                  type: BottomNavigationBarType.fixed,
                  enableFeedback: false,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  backgroundColor: colorScheme(context).primary,
                  selectedItemColor: colorScheme(context).onPrimary,
                  unselectedItemColor: colorScheme(
                    context,
                  ).onPrimary.withValues(alpha: 0.5),
                  currentIndex: bottomNavProvider.currentIndex,
                  onTap: (index) => bottomNavProvider.changeIndex(index: index),

                  items: [
                    BottomNavigationBarItem(
                      icon:
                          bottomNavProvider.currentIndex == 0
                              ? Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.home,
                                  size: 20,
                                  color: colorScheme(context).primary,
                                ),
                              )
                              : Icon(
                                Icons.home_outlined,

                                size: 20,
                                color: Colors.white,
                              ),
                      label: '',
                    ),

                    BottomNavigationBarItem(
                      icon:
                          bottomNavProvider.currentIndex == 1
                              ? Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.car_rental,
                                  size: 20,
                                  color: colorScheme(context).primary,
                                ),
                              )
                              : Icon(
                                Icons.car_rental_outlined,

                                size: 20,
                                color: Colors.white,
                              ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon:
                          bottomNavProvider.currentIndex == 2
                              ? Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.history,
                                  size: 20,
                                  color: colorScheme(context).primary,
                                ),
                              )
                              : Icon(
                                Icons.history_outlined,

                                size: 20,
                                color: Colors.white,
                              ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon:
                          bottomNavProvider.currentIndex == 3
                              ? Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 20,
                                  color: colorScheme(context).primary,
                                ),
                              )
                              : Icon(
                                Icons.person_outline,

                                size: 20,
                                color: Colors.white,
                              ),
                      label: '',
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
