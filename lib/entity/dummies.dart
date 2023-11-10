import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/entity/product/product_status.dart';
import 'package:fast_app_base/entity/product/vo_product.dart';
import 'package:fast_app_base/entity/product_post/vo_product_post.dart';
import 'package:fast_app_base/entity/user/vo_address.dart';
import 'package:fast_app_base/entity/user/vo_user.dart';

String picSum(int id) {
  return "https://picsum.photos/id/$id/200/200";
}

final user1 =
    User(id: 1, nickname: "홍길동", profileUrl: picSum(1010), temperature: 36.7);
final user2 =
    User(id: 2, nickname: "바다", profileUrl: picSum(900), temperature: 36.5);
final user3 =
    User(id: 3, nickname: "파도", profileUrl: picSum(700), temperature: 37.0);

final product1 = Product(
    user1,
    "아이폰13",
    700000,
    "깨끗하게 잘 쓰던 물건이에요."
        "잘 쓰면 좋겠습니다."
        "감사합니다.",
    ProductStatus.normal,
    [
      picSum(100),
      picSum(101),
      picSum(102),
      picSum(103),
    ]);
final product2 = Product(
    user2,
    "세탁기",
    500000,
    "세탁은 잘 되는 상태에요."
        "저렴하게 내놓습니다.",
    ProductStatus.normal,
    [
      picSum(200),
      picSum(201),
      picSum(202),
      picSum(203),
    ]);
final product3 = Product(
    user3,
    "스마트TV",
    50000,
    "화질 괜찮아요"
        "좋은 주인 만나길 기다립니다.",
    ProductStatus.normal,
    [
      picSum(300),
      picSum(301),
      picSum(302),
      picSum(303),
    ]);

final post1 = ProductPost(
    product1.user,
    product1,
    "post1의 내용입니다.",
    const Address("서울시 특별한 주소", "동대문"),
    0,
    2,
    DateTime.now().subtract(30.minutes));
final post2 = ProductPost(
    product2.user,
    product2,
    "post2의 내용입니다.",
    const Address("안산시 특별한 주소", "선부동"),
    3,
    1,
    DateTime.now().subtract(60.minutes));
final post3 = ProductPost(product3.user, product3, "post3의 내용입니다.",
    const Address("수원시 특별한 주소", "인계동"), 2, 0, DateTime.now().subtract(2.hours));

final postList = [post1, post2, post3, post1, post2, post3];
