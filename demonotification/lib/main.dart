import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Nhúng file giao diện vào đây
import 'screens.dart'; 

// 1. Hàm chạy ngầm (Background) - Phải để ngoài class
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Đã nhận tin nhắn chạy ngầm: ${message.messageId}");
}

// Cấu hình Local Notification để hiện Popup khi app đang mở (Foreground)
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// GlobalKey để Routing (Chuyển trang) mà không cần Context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Đăng ký hàm xử lý ngầm
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _setupNotifications();
  }

  void _setupNotifications() async {
    // 1. Xin quyền (Khớp slide của Luận - Android 13+)
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true, badge: true, sound: true,
    );

    // 2. Cấu hình Local Notification cho Android
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
         // Xử lý khi click vào Local Notification
      },
    );

    // 3. Xử lý FOREGROUND (Khớp slide của Khoa)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
         ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
           SnackBar(content: Text('Tin mới: ${message.notification!.title}')),
         );
      }
    });

    // 4. Xử lý BACKGROUND - Click thông báo mở app (Khớp slide của Nguyên)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    // 5. Xử lý TERMINATED - App tắt hẳn, click mở lên (Khớp slide của Nguyên)
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  // Hàm đọc Payload và điều hướng (Routing)
  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'news') {
      final articleId = message.data['id'] ?? 'Không rõ ID';
      navigatorKey.currentState?.pushNamed(
        '/detail',
        arguments: articleId, 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, 
      title: 'Demo Notification',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/detail': (context) => const DetailScreen(),
      },
    );
  }
}