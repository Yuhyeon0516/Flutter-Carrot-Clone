import 'dart:io';
import 'dart:math';

import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/util/app_keyboard_util.dart';
import 'package:fast_app_base/common/widget/round_button_theme.dart';
import 'package:fast_app_base/common/widget/w_round_button.dart';
import 'package:fast_app_base/entity/dummies.dart';
import 'package:fast_app_base/entity/product/product_status.dart';
import 'package:fast_app_base/entity/product/vo_product.dart';
import 'package:fast_app_base/entity/product_post/vo_simple_product_post.dart';
import 'package:fast_app_base/entity/user/vo_address.dart';
import 'package:fast_app_base/screen/main/tab/home/provider/post_provider.dart';
import 'package:fast_app_base/screen/post_detail/s_post_detail.dart';
import 'package:fast_app_base/screen/write/d_select_image_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class WriteScreen extends ConsumerStatefulWidget {
  const WriteScreen({super.key});

  @override
  ConsumerState<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends ConsumerState<WriteScreen>
    with KeyboardDetector {
  final List<String> imageList = [];
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    titleController.addListener(() {
      setState(() {});
    });

    priceController.addListener(() {
      setState(() {});
    });

    descriptionController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: "내 물건 팔기".text.bold.make(),
          actions: [
            Tap(
              child: "임시저장".text.make().p(15),
              onTap: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ImageSelectWidget(
                imageList,
                onTap: () async {
                  final selectedSource = await SelectImageSourceDialog().show();

                  if (selectedSource == null) {
                    return;
                  }

                  final file =
                      await ImagePicker().pickImage(source: selectedSource);

                  if (file == null) {
                    return;
                  }
                  setState(() {
                    imageList.add(file.path);
                  });
                },
                onTapDeleteImage: (path) {
                  setState(() {
                    imageList.remove(path);
                  });
                },
              ),
              _TitleEditor(titleController),
              const Height(30),
              _PriceEditor(priceController),
              const Height(30),
              _DescEditor(descriptionController),
            ],
          ),
        ).pSymmetric(h: 20),
        bottomSheet: isKeyboardOn
            ? null
            : RoundButton(
                isEnabled: isValid,
                text: isLoading ? "저장중" : "작성 완료",
                isFullWidth: true,
                borderRadius: 6,
                rightWidget: isLoading
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(),
                      ).pOnly(
                        right: 80,
                      )
                    : null,
                onTap: () {
                  final title = titleController.text;
                  final price = int.parse(priceController.text);
                  final description = descriptionController.text;

                  setState(() {
                    isLoading = true;
                  });
                  final simpleProductPost = SimpleProductPost(
                    6,
                    user3,
                    Product(
                        user3, title, price, ProductStatus.normal, imageList),
                    title,
                    const Address("서울시 송파구", "잠실"),
                    0,
                    0,
                    DateTime.now(),
                  );
                  final list = ref.read(postProvider);
                  ref.read(postProvider.notifier).state = List.of(list)
                    ..add(
                      simpleProductPost,
                    );
                  Nav.pop(context);
                  Nav.push(PostDetailScreen(
                    simpleProductPost.id,
                    simpleProductPost: simpleProductPost,
                  ));
                },
              ),
      ),
    );
  }

  bool get isValid =>
      isNotBlank(titleController.text) &&
      isNotBlank(priceController.text) &&
      isNotBlank(descriptionController.text);
}

class _ImageSelectWidget extends StatelessWidget {
  final List<String> imageList;
  final VoidCallback onTap;
  final void Function(String path) onTapDeleteImage;

  const _ImageSelectWidget(this.imageList,
      {required this.onTap, required this.onTapDeleteImage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SelectImageButton(onTap: onTap, imageList: imageList)
                .pOnly(top: 10, right: 5),
            ...imageList.map(
              (e) => Stack(
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        File(e),
                        fit: BoxFit.fill,
                      ).box.rounded.make(),
                    ),
                  ).pOnly(left: 4, right: 10, top: 10),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Transform.rotate(
                        angle: pi / 4,
                        child: Tap(
                          onTap: () {
                            onTapDeleteImage(e);
                          },
                          child: const Icon(Icons.add_circle),
                        ),
                      ).pOnly(left: 30, bottom: 30),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SelectImageButton extends StatelessWidget {
  const SelectImageButton({
    super.key,
    required this.onTap,
    required this.imageList,
  });

  final VoidCallback onTap;
  final List<String> imageList;

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: onTap,
      child: SizedBox(
        height: 80,
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: imageList.length.toString(),
                    style: const TextStyle(color: Colors.orange),
                  ),
                  const TextSpan(text: "/10"),
                ],
              ),
            ),
          ],
        ).box.rounded.border(color: Colors.grey).make(),
      ),
    );
  }
}

class _TitleEditor extends StatelessWidget {
  final TextEditingController controller;

  const _TitleEditor(this.controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "제목".text.bold.make(),
        const Height(5),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "제목",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        )
      ],
    );
  }
}

class _PriceEditor extends StatefulWidget {
  final TextEditingController controller;

  const _PriceEditor(this.controller);

  @override
  State<_PriceEditor> createState() => _PriceEditorState();
}

class _PriceEditorState extends State<_PriceEditor> {
  bool isDonateMode = false;
  final priceNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "거래 방식".text.bold.make(),
        const Height(5),
        Row(
          children: [
            RoundButton(
              theme: isDonateMode
                  ? RoundButtonTheme.whiteWithBlueBorder
                  : RoundButtonTheme.blue,
              text: "판매하기",
              onTap: () {
                widget.controller.clear();

                setState(() {
                  isDonateMode = false;
                });

                delay(() {
                  AppKeyboardUtil.show(context, priceNode);
                });
              },
            ),
            RoundButton(
              theme: !isDonateMode
                  ? RoundButtonTheme.whiteWithBlueBorder
                  : RoundButtonTheme.blue,
              text: "나눔하기",
              onTap: () {
                widget.controller.text = "0";
                setState(() {
                  isDonateMode = true;
                });
              },
            ),
          ],
        ),
        const Height(10),
        TextField(
          keyboardType: TextInputType.number,
          focusNode: priceNode,
          enabled: !isDonateMode,
          controller: widget.controller,
          decoration: const InputDecoration(
            hintText: "￦ 가격을 입력해주세요.",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        )
      ],
    );
  }
}

class _DescEditor extends StatelessWidget {
  final TextEditingController controller;

  const _DescEditor(this.controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "자세한 설명".text.bold.make(),
        const Height(5),
        TextField(
          controller: controller,
          maxLines: 7,
          decoration: const InputDecoration(
            hintText: "게시글 내용을 작성해주세요.",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        )
      ],
    );
  }
}
