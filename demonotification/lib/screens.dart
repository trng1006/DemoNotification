import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Import main.dart để xài ké biến flutterLocalNotificationsPlugin
import 'main.dart'; 

// --- MÀN HÌNH TRANG CHỦ ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _token = "Đang lấy token...";

  // Dữ liệu giả lập cho danh sách tin tức
  final List<Map<String, String>> _newsArticles = [
    {
      "id": "101",
      "title": "Giá xăng trong nước dự báo tăng mạnh vào kỳ điều hành ngày mai",
      "summary": "Do ảnh hưởng từ thị trường thế giới, giá xăng RON 95 có thể vượt mốc 25.000 đồng/lít, các doanh nghiệp bán lẻ đang chuẩn bị phương án điều chỉnh.",
    },
    {
      "id": "102",
      "title": "Căng thẳng leo thang tại Trung Đông, giá vàng thế giới biến động",
      "summary": "Các cuộc đụng độ mới nhất tại khu vực biên giới đã đẩy giá vàng và tài sản trú ẩn an toàn lên mức cao kỷ lục trong tuần qua.",
    },
    {
      "id": "103",
      "title": "OPEC+ bất ngờ quyết định cắt giảm sản lượng khai thác dầu mỏ",
      "summary": "Liên minh các nước xuất khẩu dầu mỏ thống nhất giảm thêm 2 triệu thùng/ngày nhằm giữ giá dầu thô ổn định trước bối cảnh kinh tế suy thoái.",
    },
    {
      "id": "104",
      "title": "Liên Hợp Quốc kêu gọi ngừng bắn khẩn cấp, mở hành lang nhân đạo",
      "summary": "Hàng triệu dân thường đang mắc kẹt trong vùng chiến sự. Các tổ chức quốc tế đang nỗ lực đưa xe viện trợ y tế và lương thực vào khu vực an toàn.",
    },
    {
      "id": "105",
      "title": "Nguồn cung xăng dầu toàn cầu đối mặt nguy cơ gián đoạn nghiêm trọng",
      "summary": "Các lệnh trừng phạt kinh tế và việc phong tỏa các tuyến đường biển huyết mạch khiến nhiều quốc gia châu Âu lo ngại thiếu hụt năng lượng vào mùa đông.",
    },
    {
      "id": "106",
      "title": "Hội đồng Bảo an họp khẩn về tình hình sử dụng vũ khí công nghệ cao",
      "summary": "Cuộc họp tập trung vào việc kiểm soát drone tự sát và các cuộc tấn công mạng nhằm vào cơ sở hạ tầng năng lượng trọng yếu.",
    },
    {
      "id": "107",
      "title": "Giá dầu Brent thô quay đầu giảm nhẹ sau nhiều chuỗi ngày tăng nóng",
      "summary": "Sự can thiệp của Mỹ bằng việc xả kho dự trữ chiến lược đã tạm thời hạ nhiệt thị trường, tuy nhiên các chuyên gia đánh giá đây chỉ là giải pháp ngắn hạn.",
    },
    {
      "id": "108",
      "title": "Các nước đồng minh tăng cường viện trợ quân sự cho vùng chiến sự",
      "summary": "Các gói viện trợ mới bao gồm hệ thống phòng không, đạn pháo và thiết bị rà phá bom mìn nhằm hỗ trợ lực lượng phòng vệ.",
    },
    {
      "id": "109",
      "title": "Chính phủ tung gói hỗ trợ bình ổn giá xăng dầu cho doanh nghiệp vận tải",
      "summary": "Trước áp lực chi phí logistics tăng cao, Bộ Tài chính đề xuất giảm thuế bảo vệ môi trường đối với nhiên liệu bay và dầu diesel.",
    },
    {
      "id": "110",
      "title": "Đàm phán hòa bình bước vào giai đoạn bế tắc",
      "summary": "Cuộc gặp gỡ giữa các phái đoàn cấp cao không đạt được thỏa thuận chung về việc rút quân. Giao tranh vẫn tiếp diễn tại các thành phố lớn.",
    }
  ];

  @override
  void initState() {
    super.initState();
    // Lấy Device Token (Khớp slide của Minh)
    FirebaseMessaging.instance.getToken().then((token) {
      setState(() { _token = token ?? "Lỗi Token"; });
      print("Device Token FCM: $_token"); 
    });
  }

  void _showLocalNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'kênh_tin_tuc', 'Thông báo tin tức',
      importance: Importance.max, priority: Priority.high,
    );
    const NotificationDetails platformChannelDetails = NotificationDetails(android: androidDetails);
    
    // Gọi biến plugin đã được khởi tạo bên main.dart
    await flutterLocalNotificationsPlugin.show(
      0, 
      '📰 Báo mới về fen ơi!', 
      'Có một bài viết cực hay vừa được cập nhật. Nhấn vào để xem ngay!', 
      platformChannelDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Bản Tin Hôm Nay'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Khu vực nút nhận thông báo và hiển thị token
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _showLocalNotification,
                  icon: const Icon(Icons.notifications_active),
                  label: const Text(
                    'Nhận báo mới',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Rút gọn token hiển thị để UI đỡ bị rối
                Text(
                  'FCM Token: ${_token.length > 15 ? "${_token.substring(0, 15)}..." : _token}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                )
              ],
            ),
          ),
          
          // Khu vực danh sách bài báo
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _newsArticles.length,
              itemBuilder: (context, index) {
                final article = _newsArticles[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Nhớ đảm bảo bên main.dart fen đã define route '/detail' nhé
                      Navigator.pushNamed(
                        context, 
                        '/detail', 
                        arguments: article['id'],
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Ảnh thumbnail giả lập
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 80,
                              height: 80,
                              color: Colors.blue[50],
                              child: const Icon(Icons.article, color: Colors.blue, size: 40),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Text bài báo
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article['title']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 16,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  article['summary']!,
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- MÀN HÌNH CHI TIẾT ---
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ép kiểu an toàn hơn xíu trong trường hợp quên truyền argument
    final String articleId = ModalRoute.of(context)?.settings.arguments as String? ?? 'Chưa rõ ID';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết tin tức'),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.menu_book, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 24),
              Text(
                'Bạn đang đọc bài viết mã số:\n$articleId',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Nội dung đầy đủ của bài viết sẽ được fetch từ API thông qua ID này và hiển thị ở đây...',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}