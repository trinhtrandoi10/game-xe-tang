import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('vi'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'KHE SẮT: CHỈ THỊ ZERO'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In vi, this message translates to:
  /// **'IRON GORGE // ARES OVERRIDE'**
  String get appSubtitle;

  /// No description provided for @offline.
  ///
  /// In vi, this message translates to:
  /// **'NGOẠI TUYẾN'**
  String get offline;

  /// No description provided for @continueCampaign.
  ///
  /// In vi, this message translates to:
  /// **'TIẾP TỤC CHIẾN DỊCH'**
  String get continueCampaign;

  /// No description provided for @newMission.
  ///
  /// In vi, this message translates to:
  /// **'NHIỆM VỤ MỚI'**
  String get newMission;

  /// No description provided for @garage.
  ///
  /// In vi, this message translates to:
  /// **'GARAGE'**
  String get garage;

  /// No description provided for @shop.
  ///
  /// In vi, this message translates to:
  /// **'KHO TIẾP VẬN'**
  String get shop;

  /// No description provided for @settings.
  ///
  /// In vi, this message translates to:
  /// **'THIẾT LẬP'**
  String get settings;

  /// No description provided for @mission.
  ///
  /// In vi, this message translates to:
  /// **'NHIỆM VỤ'**
  String get mission;

  /// No description provided for @returnToMenu.
  ///
  /// In vi, this message translates to:
  /// **'VỀ MENU'**
  String get returnToMenu;

  /// No description provided for @resume.
  ///
  /// In vi, this message translates to:
  /// **'TIẾP TỤC'**
  String get resume;

  /// No description provided for @retry.
  ///
  /// In vi, this message translates to:
  /// **'CHƠI LẠI'**
  String get retry;

  /// No description provided for @completed.
  ///
  /// In vi, this message translates to:
  /// **'NHIỆM VỤ HOÀN TẤT'**
  String get completed;

  /// No description provided for @failed.
  ///
  /// In vi, this message translates to:
  /// **'NHIỆM VỤ THẤT BẠI'**
  String get failed;

  /// No description provided for @objectiveReach.
  ///
  /// In vi, this message translates to:
  /// **'Tiến đến thị trấn Bình Minh'**
  String get objectiveReach;

  /// No description provided for @objectiveDestroy.
  ///
  /// In vi, this message translates to:
  /// **'Vô hiệu hóa xe trinh sát ARES'**
  String get objectiveDestroy;

  /// No description provided for @objectiveCapture.
  ///
  /// In vi, this message translates to:
  /// **'Chiếm radar Nam-1'**
  String get objectiveCapture;

  /// No description provided for @objectiveDefend.
  ///
  /// In vi, this message translates to:
  /// **'Phòng thủ radar Nam-1'**
  String get objectiveDefend;

  /// No description provided for @objectiveComplete.
  ///
  /// In vi, this message translates to:
  /// **'Đường truyền đã an toàn'**
  String get objectiveComplete;

  /// No description provided for @objectiveFailure.
  ///
  /// In vi, this message translates to:
  /// **'T-99 đã bị phá hủy'**
  String get objectiveFailure;

  /// No description provided for @parts.
  ///
  /// In vi, this message translates to:
  /// **'PHỤ TÙNG'**
  String get parts;

  /// No description provided for @data.
  ///
  /// In vi, this message translates to:
  /// **'DỮ LIỆU'**
  String get data;

  /// No description provided for @titan.
  ///
  /// In vi, this message translates to:
  /// **'TITAN'**
  String get titan;

  /// No description provided for @health.
  ///
  /// In vi, this message translates to:
  /// **'GIÁP THÂN'**
  String get health;

  /// No description provided for @ammo.
  ///
  /// In vi, this message translates to:
  /// **'ĐẠN'**
  String get ammo;

  /// No description provided for @reload.
  ///
  /// In vi, this message translates to:
  /// **'NẠP ĐẠN'**
  String get reload;

  /// No description provided for @ready.
  ///
  /// In vi, this message translates to:
  /// **'SẴN SÀNG'**
  String get ready;

  /// No description provided for @capture.
  ///
  /// In vi, this message translates to:
  /// **'CHIẾM ĐÓNG'**
  String get capture;

  /// No description provided for @defend.
  ///
  /// In vi, this message translates to:
  /// **'PHÒNG THỦ'**
  String get defend;

  /// No description provided for @ap.
  ///
  /// In vi, this message translates to:
  /// **'AP'**
  String get ap;

  /// No description provided for @he.
  ///
  /// In vi, this message translates to:
  /// **'HE'**
  String get he;

  /// No description provided for @switchAmmo.
  ///
  /// In vi, this message translates to:
  /// **'ĐỔI ĐẠN'**
  String get switchAmmo;

  /// No description provided for @fire.
  ///
  /// In vi, this message translates to:
  /// **'KHAI HỎA'**
  String get fire;

  /// No description provided for @repair.
  ///
  /// In vi, this message translates to:
  /// **'SỬA CHỮA'**
  String get repair;

  /// No description provided for @lock.
  ///
  /// In vi, this message translates to:
  /// **'KHÓA MỤC TIÊU'**
  String get lock;

  /// No description provided for @t99Name.
  ///
  /// In vi, this message translates to:
  /// **'T-99 BÃO THÉP'**
  String get t99Name;

  /// No description provided for @t99Class.
  ///
  /// In vi, this message translates to:
  /// **'XE TĂNG TRUNG // NGOẠI TUYẾN'**
  String get t99Class;

  /// No description provided for @speed.
  ///
  /// In vi, this message translates to:
  /// **'TỐC ĐỘ'**
  String get speed;

  /// No description provided for @armor.
  ///
  /// In vi, this message translates to:
  /// **'GIÁP'**
  String get armor;

  /// No description provided for @firepower.
  ///
  /// In vi, this message translates to:
  /// **'HỎA LỰC'**
  String get firepower;

  /// No description provided for @equipment.
  ///
  /// In vi, this message translates to:
  /// **'TRANG BỊ'**
  String get equipment;

  /// No description provided for @owned.
  ///
  /// In vi, this message translates to:
  /// **'ĐANG CÓ'**
  String get owned;

  /// No description provided for @buy.
  ///
  /// In vi, this message translates to:
  /// **'MUA'**
  String get buy;

  /// No description provided for @equipped.
  ///
  /// In vi, this message translates to:
  /// **'ĐÃ TRANG BỊ'**
  String get equipped;

  /// No description provided for @repairKit.
  ///
  /// In vi, this message translates to:
  /// **'BỘ SỬA CHỮA DÃ CHIẾN'**
  String get repairKit;

  /// No description provided for @repairKitDescription.
  ///
  /// In vi, this message translates to:
  /// **'Hồi 25% giáp thân và sửa mô-đun gần nhất.'**
  String get repairKitDescription;

  /// No description provided for @apCrate.
  ///
  /// In vi, this message translates to:
  /// **'HỘP ĐẠN AP'**
  String get apCrate;

  /// No description provided for @apCrateDescription.
  ///
  /// In vi, this message translates to:
  /// **'Bổ sung 8 viên xuyên giáp.'**
  String get apCrateDescription;

  /// No description provided for @heCrate.
  ///
  /// In vi, this message translates to:
  /// **'HỘP ĐẠN HE'**
  String get heCrate;

  /// No description provided for @heCrateDescription.
  ///
  /// In vi, this message translates to:
  /// **'Bổ sung 8 viên nổ mạnh.'**
  String get heCrateDescription;

  /// No description provided for @smokeGrenade.
  ///
  /// In vi, this message translates to:
  /// **'LỰU ĐẠN KHÓI KÉP'**
  String get smokeGrenade;

  /// No description provided for @smokeGrenadeDescription.
  ///
  /// In vi, this message translates to:
  /// **'Tạo màn khói che chắn trong 10 giây.'**
  String get smokeGrenadeDescription;

  /// No description provided for @notEnoughParts.
  ///
  /// In vi, this message translates to:
  /// **'Không đủ Phụ tùng.'**
  String get notEnoughParts;

  /// No description provided for @purchaseSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đã thêm vật phẩm vào kho.'**
  String get purchaseSuccess;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'NGÔN NGỮ'**
  String get language;

  /// No description provided for @deviceLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Theo thiết bị'**
  String get deviceLanguage;

  /// No description provided for @vietnamese.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @english.
  ///
  /// In vi, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @cameraShake.
  ///
  /// In vi, this message translates to:
  /// **'RUNG CAMERA'**
  String get cameraShake;

  /// No description provided for @on.
  ///
  /// In vi, this message translates to:
  /// **'BẬT'**
  String get on;

  /// No description provided for @off.
  ///
  /// In vi, this message translates to:
  /// **'TẮT'**
  String get off;

  /// No description provided for @saveStatus.
  ///
  /// In vi, this message translates to:
  /// **'SAVE CỤC BỘ ĐÃ SẴN SÀNG'**
  String get saveStatus;

  /// No description provided for @missionBrief.
  ///
  /// In vi, this message translates to:
  /// **'T-99 vừa khởi động lại trong garage bị phá hủy. Tiến về Bình Minh, dọn đường đến radar Nam-1 và giữ vị trí trước khi ARES gọi viện binh.'**
  String get missionBrief;

  /// No description provided for @startBrief.
  ///
  /// In vi, this message translates to:
  /// **'BẮT ĐẦU HÀNH QUÂN'**
  String get startBrief;

  /// No description provided for @reward.
  ///
  /// In vi, this message translates to:
  /// **'THƯỞNG'**
  String get reward;

  /// No description provided for @missionReward.
  ///
  /// In vi, this message translates to:
  /// **'+420 Phụ tùng'**
  String get missionReward;

  /// No description provided for @victoryMessage.
  ///
  /// In vi, this message translates to:
  /// **'Tín hiệu radar đã thuộc về kháng chiến. Mai đang chờ anh ở nhà máy thép.'**
  String get victoryMessage;

  /// No description provided for @defeatMessage.
  ///
  /// In vi, this message translates to:
  /// **'ARES đã khóa khu vực. Khởi động lại checkpoint và thử một hướng tiếp cận khác.'**
  String get defeatMessage;

  /// No description provided for @touchHint.
  ///
  /// In vi, this message translates to:
  /// **'JOYSTICK TRÁI: DI CHUYỂN  •  KÉO DẤU NGẮM: XOAY PHÁO'**
  String get touchHint;

  /// No description provided for @tutorialMove.
  ///
  /// In vi, this message translates to:
  /// **'Di chuyển đến điểm đánh dấu màu cyan.'**
  String get tutorialMove;

  /// No description provided for @tutorialAim.
  ///
  /// In vi, this message translates to:
  /// **'Kéo vùng phải để xoay tháp pháo, sau đó khai hỏa.'**
  String get tutorialAim;

  /// No description provided for @tutorialCapture.
  ///
  /// In vi, this message translates to:
  /// **'Đứng trong vòng radar để bắt đầu chiếm đóng.'**
  String get tutorialCapture;

  /// No description provided for @storeOffline.
  ///
  /// In vi, this message translates to:
  /// **'Store nền tảng đang ngoại tuyến. Campaign vẫn chơi bình thường.'**
  String get storeOffline;

  /// No description provided for @noRealMoney.
  ///
  /// In vi, this message translates to:
  /// **'Bản MVP chỉ dùng Phụ tùng kiếm được trong game.'**
  String get noRealMoney;

  /// No description provided for @confirmReset.
  ///
  /// In vi, this message translates to:
  /// **'XÓA TIẾN TRÌNH?'**
  String get confirmReset;

  /// No description provided for @resetWarning.
  ///
  /// In vi, this message translates to:
  /// **'Thao tác này sẽ bắt đầu lại campaign và không thể hoàn tác.'**
  String get resetWarning;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'HỦY'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In vi, this message translates to:
  /// **'XÓA SAVE'**
  String get reset;

  /// No description provided for @resetDone.
  ///
  /// In vi, this message translates to:
  /// **'Đã tạo campaign mới.'**
  String get resetDone;

  /// No description provided for @pause.
  ///
  /// In vi, this message translates to:
  /// **'TẠM DỪNG'**
  String get pause;

  /// No description provided for @resumeMission.
  ///
  /// In vi, this message translates to:
  /// **'TIẾP TỤC NHIỆM VỤ'**
  String get resumeMission;

  /// No description provided for @restartMission.
  ///
  /// In vi, this message translates to:
  /// **'KHỞI ĐỘNG LẠI'**
  String get restartMission;

  /// No description provided for @exitMission.
  ///
  /// In vi, this message translates to:
  /// **'RỜI NHIỆM VỤ'**
  String get exitMission;

  /// No description provided for @missionTime.
  ///
  /// In vi, this message translates to:
  /// **'THỜI GIAN'**
  String get missionTime;

  /// No description provided for @enemies.
  ///
  /// In vi, this message translates to:
  /// **'MỤC TIÊU'**
  String get enemies;

  /// No description provided for @radarNam1.
  ///
  /// In vi, this message translates to:
  /// **'RADAR NAM-1'**
  String get radarNam1;

  /// No description provided for @townBinhMinh.
  ///
  /// In vi, this message translates to:
  /// **'BÌNH MINH'**
  String get townBinhMinh;

  /// No description provided for @sceneSpike.
  ///
  /// In vi, this message translates to:
  /// **'THỬ NGHIỆM RENDERER 3D'**
  String get sceneSpike;

  /// No description provided for @sceneSpikeDescription.
  ///
  /// In vi, this message translates to:
  /// **'Kiểm tra Flutter GPU bằng bản đồ Nam-1 thủ tục trên thiết bị thật.'**
  String get sceneSpikeDescription;

  /// No description provided for @unknown.
  ///
  /// In vi, this message translates to:
  /// **'—'**
  String get unknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
