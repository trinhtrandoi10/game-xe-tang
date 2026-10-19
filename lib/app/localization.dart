import 'package:flutter/material.dart';

import '../game/domain/save/save_game.dart';

class AppStrings {
  AppStrings(Locale locale)
    : isVietnamese = locale.languageCode.toLowerCase().startsWith('vi');

  final bool isVietnamese;

  String get appTitle => text('appTitle');

  String get appSubtitle => text('appSubtitle');

  String text(String key) => (isVietnamese ? _vi : _en)[key] ?? key;

  static const _vi = <String, String>{
    'appTitle': 'KHE SẮT: CHỈ THỊ ZERO',
    'appSubtitle': 'IRON GORGE // ARES OVERRIDE',
    'offline': 'NGOẠI TUYẾN',
    'continueCampaign': 'TIẾP TỤC CHIẾN DỊCH',
    'newMission': 'NHIỆM VỤ MỚI',
    'garage': 'GARAGE',
    'shop': 'KHO TIẾP VẬN',
    'settings': 'THIẾT LẬP',
    'mission': 'NHIỆM VỤ',
    'returnToMenu': 'VỀ MENU',
    'resume': 'TIẾP TỤC',
    'retry': 'CHƠI LẠI',
    'completed': 'NHIỆM VỤ HOÀN TẤT',
    'failed': 'NHIỆM VỤ THẤT BẠI',
    'objectiveReach': 'Tiến đến thị trấn Bình Minh',
    'objectiveDestroy': 'Vô hiệu hóa xe trinh sát ARES',
    'objectiveCapture': 'Chiếm radar Nam-1',
    'objectiveDefend': 'Phòng thủ radar Nam-1',
    'objectiveComplete': 'Đường truyền đã an toàn',
    'objectiveFailure': 'T-99 đã bị phá hủy',
    'parts': 'PHỤ TÙNG',
    'data': 'DỮ LIỆU',
    'titan': 'TITAN',
    'health': 'GIÁP THÂN',
    'ammo': 'ĐẠN',
    'reload': 'NẠP ĐẠN',
    'ready': 'SẴN SÀNG',
    'capture': 'CHIẾM ĐÓNG',
    'defend': 'PHÒNG THỦ',
    'ap': 'AP',
    'he': 'HE',
    'switchAmmo': 'ĐỔI ĐẠN',
    'fire': 'KHAI HỎA',
    'repair': 'SỬA CHỮA',
    'lock': 'KHÓA MỤC TIÊU',
    't99Name': 'T-99 BÃO THÉP',
    't99Class': 'XE TĂNG TRUNG // NGOẠI TUYẾN',
    'speed': 'TỐC ĐỘ',
    'armor': 'GIÁP',
    'firepower': 'HỎA LỰC',
    'equipment': 'TRANG BỊ',
    'owned': 'ĐANG CÓ',
    'buy': 'MUA',
    'equipped': 'ĐÃ TRANG BỊ',
    'repairKit': 'BỘ SỬA CHỮA DÃ CHIẾN',
    'repairKitDescription': 'Hồi 25% giáp thân và sửa mô-đun gần nhất.',
    'apCrate': 'HỘP ĐẠN AP',
    'apCrateDescription': 'Bổ sung 8 viên xuyên giáp.',
    'heCrate': 'HỘP ĐẠN HE',
    'heCrateDescription': 'Bổ sung 8 viên nổ mạnh.',
    'smokeGrenade': 'LỰU ĐẠN KHÓI KÉP',
    'smokeGrenadeDescription': 'Tạo màn khói che chắn trong 10 giây.',
    'notEnoughParts': 'Không đủ Phụ tùng.',
    'purchaseSuccess': 'Đã thêm vật phẩm vào kho.',
    'language': 'NGÔN NGỮ',
    'deviceLanguage': 'Theo thiết bị',
    'vietnamese': 'Tiếng Việt',
    'english': 'English',
    'cameraShake': 'RUNG CAMERA',
    'on': 'BẬT',
    'off': 'TẮT',
    'saveStatus': 'SAVE CỤC BỘ ĐÃ SẴN SÀNG',
    'missionBrief':
        'T-99 vừa khởi động lại trong garage bị phá hủy. Tiến về Bình Minh, dọn đường đến radar Nam-1 và giữ vị trí trước khi ARES gọi viện binh.',
    'startBrief': 'BẮT ĐẦU HÀNH QUÂN',
    'reward': 'THƯỞNG',
    'missionReward': '+420 Phụ tùng',
    'victoryMessage':
        'Tín hiệu radar đã thuộc về kháng chiến. Mai đang chờ anh ở nhà máy thép.',
    'defeatMessage':
        'ARES đã khóa khu vực. Khởi động lại checkpoint và thử một hướng tiếp cận khác.',
    'touchHint': 'JOYSTICK TRÁI: DI CHUYỂN  •  KÉO DẤU NGẮM: XOAY PHÁO',
    'tutorialMove': 'Di chuyển đến điểm đánh dấu màu cyan.',
    'tutorialAim': 'Kéo vùng phải để xoay tháp pháo, sau đó khai hỏa.',
    'tutorialCapture': 'Đứng trong vòng radar để bắt đầu chiếm đóng.',
    'storeOffline':
        'Store nền tảng đang ngoại tuyến. Campaign vẫn chơi bình thường.',
    'noRealMoney': 'Bản MVP chỉ dùng Phụ tùng kiếm được trong game.',
    'confirmReset': 'XÓA TIẾN TRÌNH?',
    'resetWarning':
        'Thao tác này sẽ bắt đầu lại campaign và không thể hoàn tác.',
    'cancel': 'HỦY',
    'reset': 'XÓA SAVE',
    'resetDone': 'Đã tạo campaign mới.',
    'pause': 'TẠM DỪNG',
    'resumeMission': 'TIẾP TỤC NHIỆM VỤ',
    'restartMission': 'KHỞI ĐỘNG LẠI',
    'exitMission': 'RỜI NHIỆM VỤ',
    'missionTime': 'THỜI GIAN',
    'enemies': 'MỤC TIÊU',
    'radarNam1': 'RADAR NAM-1',
    'townBinhMinh': 'BÌNH MINH',
    'sceneSpike': 'THỬ NGHIỆM RENDERER 3D',
    'sceneSpikeDescription':
        'Kiểm tra Flutter GPU bằng bản đồ Nam-1 thủ tục trên thiết bị thật.',
    'unknown': '—',
  };

  static const _en = <String, String>{
    'appTitle': 'IRON GORGE: ARES OVERRIDE',
    'appSubtitle': 'KHE SẮT // ZERO DIRECTIVE',
    'offline': 'OFFLINE',
    'continueCampaign': 'CONTINUE CAMPAIGN',
    'newMission': 'NEW MISSION',
    'garage': 'GARAGE',
    'shop': 'SUPPLY DEPOT',
    'settings': 'SETTINGS',
    'mission': 'MISSION',
    'returnToMenu': 'RETURN TO MENU',
    'resume': 'RESUME',
    'retry': 'RETRY',
    'completed': 'MISSION COMPLETE',
    'failed': 'MISSION FAILED',
    'objectiveReach': 'Advance to Binh Minh town',
    'objectiveDestroy': 'Disable ARES scout vehicles',
    'objectiveCapture': 'Capture Nam-1 radar',
    'objectiveDefend': 'Defend Nam-1 radar',
    'objectiveComplete': 'The uplink is secure',
    'objectiveFailure': 'The T-99 was destroyed',
    'parts': 'PARTS',
    'data': 'DATA',
    'titan': 'TITAN',
    'health': 'HULL',
    'ammo': 'AMMO',
    'reload': 'RELOADING',
    'ready': 'READY',
    'capture': 'CAPTURE',
    'defend': 'DEFEND',
    'ap': 'AP',
    'he': 'HE',
    'switchAmmo': 'SWITCH',
    'fire': 'FIRE',
    'repair': 'REPAIR',
    'lock': 'LOCK TARGET',
    't99Name': 'T-99 STEEL STORM',
    't99Class': 'MEDIUM TANK // OFFLINE CORE',
    'speed': 'SPEED',
    'armor': 'ARMOR',
    'firepower': 'FIREPOWER',
    'equipment': 'EQUIPMENT',
    'owned': 'OWNED',
    'buy': 'BUY',
    'equipped': 'EQUIPPED',
    'repairKit': 'FIELD REPAIR KIT',
    'repairKitDescription': 'Restores 25% hull and repairs the nearest module.',
    'apCrate': 'AP AMMO CRATE',
    'apCrateDescription': 'Adds 8 armor-piercing rounds.',
    'heCrate': 'HE AMMO CRATE',
    'heCrateDescription': 'Adds 8 high-explosive rounds.',
    'smokeGrenade': 'DOUBLE SMOKE GRENADE',
    'smokeGrenadeDescription': 'Creates cover smoke for 10 seconds.',
    'notEnoughParts': 'Not enough Parts.',
    'purchaseSuccess': 'Item added to inventory.',
    'language': 'LANGUAGE',
    'deviceLanguage': 'Device',
    'vietnamese': 'Tiếng Việt',
    'english': 'English',
    'cameraShake': 'CAMERA SHAKE',
    'on': 'ON',
    'off': 'OFF',
    'saveStatus': 'LOCAL SAVE READY',
    'missionBrief':
        'The T-99 has rebooted inside a ruined garage. Push toward Binh Minh, clear the route to Nam-1 radar, and hold the position before ARES calls reinforcements.',
    'startBrief': 'BEGIN ADVANCE',
    'reward': 'REWARD',
    'missionReward': '+420 Parts',
    'victoryMessage':
        'The radar uplink belongs to the resistance. Mai is waiting at the steelworks.',
    'defeatMessage':
        'ARES has sealed the sector. Restart the checkpoint and try a different approach.',
    'touchHint': 'LEFT JOYSTICK: MOVE  •  DRAG RETICLE: AIM TURRET',
    'tutorialMove': 'Move to the cyan objective marker.',
    'tutorialAim': 'Drag the right zone to aim, then fire.',
    'tutorialCapture': 'Stay inside the radar ring to begin capture.',
    'storeOffline':
        'The platform store is offline. The campaign remains fully playable.',
    'noRealMoney': 'The MVP uses only Parts earned in gameplay.',
    'confirmReset': 'RESET PROGRESS?',
    'resetWarning': 'This starts a new campaign and cannot be undone.',
    'cancel': 'CANCEL',
    'reset': 'RESET SAVE',
    'resetDone': 'New campaign created.',
    'pause': 'PAUSED',
    'resumeMission': 'RESUME MISSION',
    'restartMission': 'RESTART MISSION',
    'exitMission': 'EXIT MISSION',
    'missionTime': 'TIME',
    'enemies': 'TARGETS',
    'radarNam1': 'NAM-1 RADAR',
    'townBinhMinh': 'BINH MINH',
    'sceneSpike': '3D RENDERER SPIKE',
    'sceneSpikeDescription':
        'Validate Flutter GPU with the procedural Nam-1 pad on a physical device.',
    'unknown': '—',
  };
}

Locale resolveGameLocale(Locale deviceLocale, LocalePreference preference) {
  return switch (preference) {
    LocalePreference.vi => const Locale('vi'),
    LocalePreference.en => const Locale('en'),
    LocalePreference.device =>
      deviceLocale.languageCode.toLowerCase().startsWith('vi')
          ? const Locale('vi')
          : const Locale('en'),
  };
}

LocalePreference localePreferenceForLocale(Locale locale) {
  return locale.languageCode.toLowerCase().startsWith('vi')
      ? LocalePreference.vi
      : LocalePreference.en;
}
