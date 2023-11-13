import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/entity/dummies.dart';
import 'package:fast_app_base/screen/main/fab/w_floating_carrot_button.dart';
import 'package:fast_app_base/screen/main/fab/w_floating_carrot_button.riverpod.dart';
import 'package:fast_app_base/screen/main/tab/home/w_product_post_item.dart';
import 'package:fast_app_base/screen/notification/s_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeFragment extends ConsumerStatefulWidget {
  const HomeFragment({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends ConsumerState<HomeFragment> {
  final scrollController = ScrollController();

  String title = "병점동";

  @override
  void initState() {
    scrollController.addListener(() {
      final floatingState = ref.read(floatingButtonStateProvider);

      if (scrollController.position.pixels > 100 && !floatingState.isSmall) {
        ref.read(floatingButtonStateProvider.notifier).changeButtonSize(true);
      } else if (scrollController.position.pixels < 100 &&
          floatingState.isSmall) {
        ref.read(floatingButtonStateProvider.notifier).changeButtonSize(false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          AppBar(
            centerTitle: true,
            title: PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  title = value;
                });
              },
              itemBuilder: (BuildContext context) => ["인계동", "동대문"]
                  .map((e) => PopupMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              child: Text(title),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Nav.push(const NotificationScreen());
                },
                icon: const Icon(Icons.notifications_none_rounded),
              )
            ],
          ),
          Expanded(
            child: ListView.separated(
              padding:
                  const EdgeInsets.only(bottom: FloatingCarrotButton.height),
              controller: scrollController,
              itemBuilder: (context, index) => ProductPostItem(postList[index]),
              itemCount: postList.length,
              separatorBuilder: (context, index) =>
                  const Line().pSymmetric(h: 15),
            ),
          ),
        ],
      ),
    );
  }
}
