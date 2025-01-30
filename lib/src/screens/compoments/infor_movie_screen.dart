import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class InforMovieScreen extends StatefulWidget {
  const InforMovieScreen({super.key});

  @override
  State<InforMovieScreen> createState() => _InforMovieScreenState();
}

class _InforMovieScreenState extends State<InforMovieScreen> {
  CarouselController carouselController = CarouselController();
  int currentPage = 0;
  @override
  void initState() {
    if (carouselController.hasClients) {
      carouselController.animateTo(150,
          duration: const Duration(milliseconds: 500), curve: Curves.bounceIn);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Trường Sinh Giới (World Of Immortals)",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://res.cloudinary.com/dksr7si4o/image/upload/v1709205846/images/hhninja-luyen-khi-muoi-van-nam-1_250x350_kprzvw.jpg",
                          progressIndicatorBuilder: (context, url, progress) =>
                              const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List.generate(
                          3,
                          (index) => Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: CircleAvatar(
                              backgroundColor: currentPage == index
                                  ? Colors.white
                                  : Colors.grey[500],
                              radius: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(
            //   height: 5,
            // ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tổng số tập: 15/?"),
                      Text("26 phút/tập"),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        const Text("Thể loại: "),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 5,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadiusDirectional.all(
                                        Radius.circular(5)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xff30cfd0),
                                        Color(0xff330867)
                                      ],
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Viễn Tưởng",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Chất lượng: FHD"),
                      Text("Vietsub"),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Phát hành:"),
                      Text("Trung Quốc / 2024"),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text("Nội dung:"),
                  const ReadMoreText(
                    "Trên đời này liệu có ai bất tử? Dù có tài hoa tuyệt đỉnh, nổi tiếng thiên hạ, cuối cùng cũng phải hóa thành đống xương khô; Dù có là con của trời, nắm trong tay vạn dặm giang sơn, cuối cùng cũng sẽ biến thành một nắm hoàng thổ. Câu chuyện kể về Tiêu Thần bị thiên nữ hoàng gia Triệu Lâm Nhi truy sát, vô tình lạc vào Đảo Rồng hoang dã ở Trường Sinh Giới. Đây là một con đường cụt không có lối về nhà, phải đối mặt với đầy rẫy quái thú và kẻ thù. Sự lưu luyến với người thân, bằng hữu và cố hương luôn là điểm tựa để Tiêu Thần đứng vững chiến đấu với quái thú và kẻ thù ở vùng đất kỳ lạ này. Trong cuộc chiến cuồng nhiệt, sự cám dỗ của cảm xúc và dục vọng, Tiêu Thần đi theo bước chân của những người trường sinh bất tử, từ từ vén lên bức màn bí ẩn về một thế giới thần thoại cổ xưa bị cát bụi phong ấn...",
                    style: TextStyle(color: Colors.grey),
                    trimMode: TrimMode.Line,
                    trimLines: 3,
                    colorClickableText: Colors.black,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    moreStyle: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontWeight: FontWeight.bold),
                    lessStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(5)),
                            child: const Center(
                              child: Text(
                                "Xem từ đầu",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(5)),
                            child: const Center(
                              child: Text(
                                "Xem mới nhất",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Danh sách tập:"),
                  const SizedBox(
                    height: 10,
                  ),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 5,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            mainAxisExtent: 40),
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadiusDirectional.all(
                            Radius.circular(5)),
                        // color: Colors.orange,
                        color: Colors.grey[400],
                      ),
                      child: Center(
                        child: Text(
                          index.toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Phim khác:",
                    style: TextStyle(
                        color: Colors.grey[500], fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 5,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 250,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 4.0),
                    itemBuilder: (context, index) {
                      return Container(
                        width: 200,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xff30cfd0),
                                  Color(0xff330867)
                                ])),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              clipBehavior: Clip.antiAlias,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  topLeft: Radius.circular(5)),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://phimimg.com/upload/vod/20250128-1/ede258f75b02c54deeb80dd9f8d43565.jpg",
                                progressIndicatorBuilder:
                                    (context, url, progress) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                            ),
                            const Text(
                              "Name",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
