import 'package:aplinkos_ministerija/bloc/nav_bar_bloc/nav_bar_bloc.dart';
import 'package:aplinkos_ministerija/bloc/route_controller/route_controller_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/app_colors.dart';
import '../../constants/strings.dart';

class MobileNavBar extends StatefulWidget {
  final NavBarBloc navBarBloc;

  const MobileNavBar({
    super.key,
    required this.navBarBloc,
  });

  @override
  State<MobileNavBar> createState() => _MobileNavBarState();
}

class _MobileNavBarState extends State<MobileNavBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RouteControllerBloc, RouteControllerState>(
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    Strings.logo,
                    width: 120,
                    fit: BoxFit.fitWidth,
                  ),
                  Row(
                    children: [
                      (state is RouteControllerInitial) ? IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.help,
                          color: AppColors.helpIconColor,
                        ),
                      ) : const SizedBox(),
                      IconButton(
                        onPressed: () {
                          widget.navBarBloc.add(OpenNavBarEvent());
                        },
                        icon: const Icon(Icons.menu),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              height: 1,
              color: AppColors.dividerColor,
            ),
          ],
        );
      },
    );
  }
}
