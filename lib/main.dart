import 'package:chicken_combat/common/config.dart';
import 'package:chicken_combat/common/localization/localizations_config.dart';
import 'package:chicken_combat/common/themes.dart';
import 'package:chicken_combat/presentation/flash/flash_screen.dart';
import 'package:chicken_combat/utils/notification_manager.dart';
import 'package:chicken_combat/widgets/background_cloud_map2_widget.dart';
import 'package:chicken_combat/widgets/custom_expanedable_draggable_fab_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationManager.init();
  await Config.getPreferences();
  await configureLocalTimeZone();
  runApp(const MyApp());
}

Future<void> configureLocalTimeZone() async {
  tz.initializeTimeZones();
  var locationName = 'Asia/Ho_Chi_Minh';
  tz.setLocalLocation(tz.getLocation(locationName));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Itim",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      builder: (context, child) {
        AppSizes.init(context);
        return MediaQuery.withClampedTextScaling(
            minScaleFactor: 1.0,
            maxScaleFactor: 1.2,
            child: GestureDetector(
              child: child,
            ));
      },
      locale: LocalizationsConfig.getCurrentLocale(),
      supportedLocales: LocalizationsConfig.supportedLocales,
      localizationsDelegates: LocalizationsConfig.localizationsDelegates,
      localeResolutionCallback: (locale, supportedLocales) =>
          LocalizationsConfig.localeResolutionCallback(
              locale, supportedLocales.toList()),
      home: FlashScreen(),
    );
  }
}


class DragItem extends StatefulWidget {
  const DragItem({super.key});

  @override
  State<DragItem> createState() => _DragItemState();
}

class _DragItemState extends State<DragItem> {

  bool _isShowFloatingButton = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _isShowFloatingButton ? DraggableStackWidget(
          initialDraggableOffset:
              Offset(12, MediaQuery.of(context).size.height * 11 / 14),
              onTapAction: () {
              },
              onTapClose: () {
                setState(() {
                  _isShowFloatingButton = !_isShowFloatingButton;
                });
              },
        ) : Container(),
        body: BackgroundCloudMap2Widget(heightContent: 1000),
    );
  }
}

