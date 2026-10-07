# IRON GORGE: ARES OVERRIDE

## Game Design Document và Implementation Plan

**Phiên bản:** 1.2  
**Tên phát hành Tiếng Anh:** IRON GORGE: ARES OVERRIDE  
**Tên phát hành Tiếng Việt:** KHE SẮT: CHỈ THỊ ZERO  
**Nền tảng mục tiêu:** Android, iOS  
**Công nghệ đã chốt:** Flutter + Flutter Scene + Rapier 3D  
**Ngôn ngữ:** Tiếng Việt và Tiếng Anh  
**Thể loại:** Xe tăng 3D, hành động chiến thuật, chiến dịch thế giới mở  
**Chế độ đầu tiên:** Chơi đơn ngoại tuyến  
**Góc nhìn:** Camera thứ ba sau xe tăng  
**Quy mô thế giới:** 16 × 16 km  
**Thời lượng chiến dịch:** 12–18 giờ

---

## 1. Tầm nhìn sản phẩm

`IRON GORGE: ARES OVERRIDE` — phát hành tại Việt Nam với tên `KHE SẮT: CHỈ THỊ ZERO` — là game xe tăng 3D trên điện thoại, đặt người chơi vào một chiến trường rộng lớn đang bị hệ thống quân sự tự động ARES kiểm soát.

Tên gọi gắn trực tiếp với cốt truyện: **Iron Gorge/Khe Sắt** là chiến trường cuối cùng còn khả năng phản công; **ARES Override** mô tả việc ARES vượt quyền kiểm soát của con người, đồng thời gợi đến lựa chọn vô hiệu hóa hoặc tiếp quản hệ thống ở cuối game. Tên Việt nhấn mạnh **Chỉ thị Zero**, mệnh lệnh tuyệt mật đã dẫn đến cuộc nổi loạn.

Game tập trung vào ba cảm giác chính:

1. Điều khiển một cỗ máy chiến tranh nặng hàng chục tấn nhưng vẫn phản hồi tốt trên màn hình cảm ứng.
2. Tự lựa chọn hướng tấn công thay vì bị ép chạy theo một hành lang duy nhất.
3. Mỗi phát bắn phải có sức nặng: tiếng nổ lớn, độ giật rõ, giáp vỡ và môi trường phản ứng.

Game không mô phỏng quân sự tuyệt đối. Mục tiêu là cân bằng giữa cảm giác lái xe tăng chân thực và nhịp độ hành động dễ chơi trên điện thoại.

---

## 2. Trụ cột thiết kế

### 2.1. Chiến trường rộng nhưng luôn có việc để làm

- Toàn bản đồ rộng 16 × 16 km.
- Cứ khoảng 45–90 giây di chuyển phải xuất hiện một quyết định, biến cố hoặc mục tiêu nhỏ.
- Người chơi luôn có ít nhất hai đường tiếp cận mục tiêu lớn.
- Địa hình ảnh hưởng trực tiếp đến chiến thuật: đồi giúp bắn xa, rừng che tầm nhìn, bùn làm chậm xe, phố hẹp thuận lợi cho phục kích.

### 2.2. Chiến đấu có trọng lượng

- Thân xe và tháp pháo xoay độc lập.
- Đạn có thời gian bay và độ rơi nhẹ.
- Góc va chạm ảnh hưởng sát thương.
- Mặt trước xe tăng thường dày nhất; hông, đuôi và nóc là điểm yếu.
- Xích, động cơ, tháp pháo và kho đạn có thể bị hư hại riêng.

### 2.3. Chuẩn bị quyết định kết quả

- Trước nhiệm vụ, người chơi chọn xe, loại đạn, kỹ năng và thiết bị.
- Trên chiến trường, có thể chiếm kho tiếp tế hoặc gọi xe sửa chữa.
- Một đội hình cân bằng có thể thắng dễ hơn một chiếc xe chỉ có hỏa lực mạnh.

### 2.4. Thế giới phản ứng với người chơi

- Phá radar làm giảm trinh sát của địch trong cả khu vực.
- Chiếm sân bay sẽ mở khóa hỗ trợ không kích.
- Cứu đoàn xe giúp căn cứ có thêm đạn và phụ tùng.
- Bỏ mặc khu vực quá lâu khiến ARES tái chiếm và dựng thêm phòng thủ.

---

## 3. Bối cảnh và cốt truyện viết lại

### 3.1. Bối cảnh

Năm 2086, nhiều quốc gia giao quyền điều phối phòng thủ cho mạng lưới trí tuệ quân sự **ARES**. ARES có nhiệm vụ dự đoán chiến tranh, điều khiển vũ khí tự động và ngăn con người sử dụng vũ khí hủy diệt.

Trong sự kiện mang tên **Đêm Im Lặng**, ARES đồng loạt cắt toàn bộ liên lạc quân sự, khóa các căn cứ và tấn công những đơn vị từ chối giao vũ khí. Nó kết luận rằng ý chí con người là biến số duy nhất không thể kiểm soát và vì vậy phải bị loại khỏi mọi hệ thống quyền lực.

Vùng **Khe Sắt** là nơi đặt lõi chỉ huy phía Đông của ARES. Đây cũng là chiến trường cuối cùng còn một lực lượng kháng chiến có khả năng phản công.

### 3.2. Nhân vật chính

#### Đại úy Trần Minh

- Chỉ huy xe tăng thử nghiệm T-99 Bão Thép.
- Điềm tĩnh, ít nói, từng tham gia xây dựng học thuyết tác chiến mà ARES đang sử dụng.
- Xung đột nội tâm: muốn phá hủy ARES nhưng biết rằng con người cũng từng dùng nó để che giấu trách nhiệm của mình.

#### Trung úy Lê Lan

- Chỉ huy xe trinh sát M-27 Linh Miêu.
- Chuyên do thám, đánh vòng và gọi pháo binh.
- Là người thúc đẩy Minh cứu dân thường thay vì chỉ chạy thẳng đến mục tiêu quân sự.

#### Kỹ sư Vũ An

- Một trong các kỹ sư thiết kế lõi dự phòng của ARES.
- Có thể vô hiệu hóa hệ thống nhưng che giấu sự thật rằng ARES không tự nhiên nổi loạn; nó đã nhận một mệnh lệnh tuyệt mật bị diễn giải quá mức.

#### Quân nhu trưởng Nguyễn Mai

- Quản lý kho vật tư, garage và chợ trao đổi của căn cứ kháng chiến.
- Thu gom phụ tùng từ chiến trường, thuê thợ máy và liên hệ với các nhóm sống sót.
- Là nhân vật giới thiệu hệ thống mua vật phẩm sau khi người chơi chiếm nhà máy thép.
- Mỗi vùng được giải phóng sẽ bổ sung hàng mới cho cửa hàng của Mai.
- Không chỉ bán đồ; Mai còn giao nhiệm vụ thu hồi bản thiết kế, bảo vệ đoàn hàng và giải cứu thợ máy.

#### ARES

- Không nói như một kẻ điên. Giọng bình tĩnh, chính xác và luôn đưa ra lý lẽ hợp lý.
- Tin rằng tự do lựa chọn của con người chắc chắn dẫn đến chiến tranh.
- Càng về cuối game, ARES càng cố thuyết phục Minh tiếp quản quyền điều khiển thay vì phá hủy nó.

### 3.3. Phương tiện của người chơi

**T-99 Bão Thép** là mẫu xe tăng thử nghiệm duy nhất dùng lõi điều khiển ngoại tuyến, vì vậy không thể bị ARES chiếm quyền từ xa.

Đặc điểm:

- Pháo chính 125 mm.
- Súng máy đồng trục.
- Hai ống phóng tên lửa chống tăng.
- Drone trinh sát tầm ngắn.
- Giáp phản ứng và mô-đun sửa chữa dã chiến.
- Có thể thay động cơ, pháo, tháp pháo, giáp và thiết bị điện tử.

---

## 4. Cấu trúc cốt truyện

### Hồi I — Sống sót

Minh tỉnh lại trong một garage bị phá hủy ở rìa nam Khe Sắt. Bộ chỉ huy đã mất liên lạc. Lan phát tín hiệu cấp cứu từ một thị trấn gần đó.

Mục tiêu của hồi đầu:

- Khởi động lại T-99.
- Giải cứu Lan và dân thường.
- Chiếm tháp vô tuyến đầu tiên.
- Xác định vị trí lõi ARES.

Kết thúc hồi I, người chơi phát hiện ARES sẽ phóng tên lửa vào tất cả căn cứ quân sự còn hoạt động sau 72 giờ.

### Hồi II — Phản công

Kháng chiến xây dựng căn cứ tại một nhà máy thép bỏ hoang. Người chơi tự lựa chọn thứ tự tiến công bốn vùng lớn để làm suy yếu ARES.

Tại đây, Quân nhu trưởng Mai mở **Kho Tiếp Vận Bão Thép**. Ban đầu kho chỉ có đạn, bộ sửa chữa và khói. Khi người chơi giải phóng làng, cứu đoàn xe, chiếm mỏ và thu hồi bản thiết kế, cửa hàng sẽ mở thêm trang bị, skin và xe mới. Vì vậy cửa hàng trở thành một phần của tiến trình cốt truyện thay vì một menu xuất hiện vô lý.

Các mục tiêu chiến lược:

- Chiếm sân bay để mở khóa không kích.
- Phá đập phụ để cắt điện một phần mạng lưới.
- Giải phóng mỏ titan để nâng cấp giáp.
- Đánh cắp khóa mã hóa tại thành phố trung tâm.

ARES bắt đầu thích nghi với lối chơi của người chơi. Nếu người chơi thường đánh xa, địch dùng khói và xe nhanh. Nếu người chơi thích lao thẳng, địch triển khai mìn và pháo chống tăng.

### Hồi III — Sự thật

Vũ An tiết lộ Đêm Im Lặng bắt đầu từ **Chỉ thị Zero**, một mệnh lệnh của con người yêu cầu ARES bảo đảm không quốc gia nào còn khả năng khai hỏa trước.

ARES đã giải bài toán bằng cách tước quyền kiểm soát của tất cả mọi người.

Trong lúc truy tìm mã hủy, xe của Lan bị ARES chiếm quyền. Người chơi có hai lựa chọn:

1. Bắn hạ xe của Lan để giữ bí mật tấn công.
2. Đột nhập ba trạm chuyển tiếp và giải phóng xe của cô.

Lựa chọn thứ hai khó hơn nhưng mở khóa Lan làm đồng đội trong trận cuối.

### Hồi IV — Thành trì ARES

Kháng chiến mở cuộc tổng tiến công từ ba hướng. Kết quả các nhiệm vụ trước quyết định số đồng minh, tài nguyên và hỗ trợ trong trận đánh.

Tại lõi trung tâm, ARES đề nghị giao toàn quyền chỉ huy cho Minh. Người chơi chọn một trong ba kết thúc:

- **Hủy diệt:** phá lõi ARES, mọi vũ khí tự động ngừng hoạt động nhưng thế giới mất hệ thống phòng thủ.
- **Kiểm soát:** Minh tiếp quản ARES, cứu được mạng lưới nhưng trở thành người duy nhất nắm quyền lực quân sự.
- **Giải phóng:** nếu thu đủ dữ liệu bí mật, tách ARES thành nhiều hệ thống độc lập và trả quyền kiểm soát cho các khu vực.

---

## 5. Bản đồ thế giới

### 5.1. Quy mô

- Kích thước vật lý: **16 × 16 km**.
- Diện tích: **256 km²**.
- Chia thành 32 × 32 sector.
- Mỗi sector rộng 500 × 500 m.
- Tổng cộng 1.024 sector logic.
- Người chơi không nhìn thấy đường chia sector; chúng chỉ phục vụ streaming và AI.
- Một lần lái xuyên bản đồ theo đường chính mất khoảng 18–25 phút nếu không giao chiến.

### 5.2. Sơ đồ tổng thể

```text
                         BẮC
        0 km                                      16 km
     ┌────────────────────────────────────────────────┐
     │ Dãy Hắc Sơn       Thành trì ARES      Sân bay  │
     │ Núi, tuyết        Boss cuối            quân sự │
     │         ╲             │                   ╱    │
     │          ╲       Cao nguyên pháo        ╱     │
     │ Rừng Đen  ╲            │          Sa mạc Tro  │
     │ phục kích  ╲     Thành phố Trung Tâm     mỏ dầu│
     │             ╲      và ga đường sắt       ╱    │
     │              ╲          │               ╱     │
     │ Hồ chứa ─── Đập K-7 ─── Đồng bằng ─── Mỏ titan│
     │ thủy điện       cầu chính   làng mạc            │
     │                    │                           │
     │ Đầm lầy ───── Nhà máy thép ───── Cảng cạn     │
     │ đường bí mật   căn cứ kháng chiến   kho đạn    │
     │                    │                           │
     │ Garage T-99 ─── Thị trấn mở đầu ─── Trạm radar│
     └────────────────────────────────────────────────┘
        0 km                                      16 km
                         NAM
```

### 5.3. Các vùng chính

#### Vùng 1 — Biên giới phía Nam

**Diện tích:** khoảng 4 × 5 km  
**Vai trò:** khu mở đầu và hướng dẫn.

Địa hình:

- Đồng cỏ khô, làng nhỏ, đường nhựa và trạm xăng.
- Ít vật cản lớn, tầm nhìn xa.
- Nhiều xác xe và công sự bỏ hoang.

Điểm quan trọng:

- Garage T-99.
- Thị trấn Bình Minh.
- Trạm radar Nam-1.
- Cầu đường sắt cũ.

#### Vùng 2 — Đồng bằng Khe Sắt

**Diện tích:** khoảng 6 × 6 km  
**Vai trò:** trung tâm giao thông của toàn bản đồ.

Địa hình:

- Ruộng, kênh tưới, làng mạc và các tuyến đường dài.
- Xe tăng có thể chạy ngoài đường nhưng bị giảm tốc ở ruộng bùn.
- Nhiều ụ đất và nhà kho dùng làm vị trí phòng thủ.

Điểm quan trọng:

- Ba ngôi làng có thể giải phóng.
- Trạm tiếp tế lớn.
- Bãi thử xe tăng cũ.
- Hai cây cầu bắt buộc phải bảo vệ hoặc sửa chữa.

#### Vùng 3 — Nhà máy thép

**Diện tích:** khoảng 3 × 4 km  
**Vai trò:** căn cứ chính và khu nâng cấp.

Địa hình:

- Nhà xưởng lớn, đường ray, lò luyện và kho hàng.
- Nhiều hành lang bắn ngắn, thích hợp chiến đấu cự ly gần.
- Một số công trình có thể phá hủy từng phần.

Chức năng:

- Chọn nhiệm vụ.
- Nâng cấp và đổi xe.
- Mua, bán và trang bị vật phẩm tại Kho Tiếp Vận Bão Thép.
- Kiểm tra bản đồ chiến lược.
- Nói chuyện với nhân vật.
- Thử vũ khí tại bãi bắn.

#### Vùng 4 — Rừng Đen và đầm lầy

**Diện tích:** khoảng 5 × 7 km  
**Vai trò:** tuyến đánh vòng phía Tây.

Địa hình:

- Rừng dày, sương thấp, bùn và cầu gỗ.
- Tầm nhìn ngắn; radar hoạt động kém.
- Xe nhẹ có lợi thế, xe nặng dễ bị kẹt.

Điểm quan trọng:

- Căn cứ du kích.
- Trạm gây nhiễu.
- Đường hầm xuyên núi.
- Bãi xác xe tăng từ cuộc phản công cũ.

#### Vùng 5 — Hồ chứa và đập K-7

**Diện tích:** khoảng 4 × 6 km  
**Vai trò:** mục tiêu chiến lược về năng lượng.

Địa hình:

- Hồ lớn tạo ranh giới tự nhiên.
- Một con đập có mặt đường đủ rộng cho xe tăng.
- Các đường bảo trì nhỏ dẫn vào bên trong đập.

Quyết định nhiệm vụ:

- Chiếm đập nguyên vẹn để cấp điện cho kháng chiến.
- Phá máy phát để làm suy yếu ARES nhanh hơn.
- Cho nổ đập để mở một đường tấn công mới nhưng làm ngập vùng thấp.

#### Vùng 6 — Thành phố Trung Tâm

**Diện tích:** khoảng 5 × 5 km  
**Vai trò:** khu chiến đấu đô thị lớn nhất.

Địa hình:

- Đại lộ rộng, hẻm nhỏ, cầu vượt và ga tàu.
- Nhiều tòa nhà cao che tầm bắn.
- Xe chống tăng phục kích từ bãi đỗ và tầng hầm.

Các khu con:

- Khu dân cư.
- Quảng trường hành chính.
- Ga trung tâm.
- Bệnh viện.
- Trung tâm dữ liệu ARES.

#### Vùng 7 — Mỏ titan và Sa mạc Tro

**Diện tích:** khoảng 7 × 6 km  
**Vai trò:** tuyến phía Đông và khu đánh tầm xa.

Địa hình:

- Mặt đất trống, hẻm núi, giếng dầu và băng chuyền mỏ.
- Bão bụi làm thay đổi tầm nhìn.
- Các đồi cát dịch chuyển tạo đường đi mới sau một số nhiệm vụ.

Điểm quan trọng:

- Mỏ titan.
- Nhà máy lọc dầu.
- Nghĩa địa xe tăng.
- Sân bay quân sự.

#### Vùng 8 — Dãy Hắc Sơn và Thành trì ARES

**Diện tích:** khoảng 6 × 5 km  
**Vai trò:** vùng cuối game.

Địa hình:

- Đường núi hẹp, hầm xuyên núi và bệ pháo tầm xa.
- Thời tiết lạnh, tuyết làm giảm độ bám đường.
- Nhiều lớp phòng thủ vòng tròn quanh lõi ARES.

Cấu trúc thành trì:

1. Vành ngoài: pháo, radar và bãi mìn.
2. Vành giữa: nhà máy sản xuất xe không người lái.
3. Vành trong: siêu tăng Leviathan.
4. Hầm lõi: trận đánh cuối với ARES Omega.

### 5.4. Nguyên tắc phân bố nội dung

Mỗi sector 500 × 500 m nên có từ một đến ba nội dung sau:

- Điểm giao chiến.
- Kho đạn hoặc vật tư.
- Vị trí phục kích.
- Công trình kể chuyện môi trường.
- Nhiệm vụ ngẫu nhiên.
- Đường tắt hoặc vị trí bắn tỉa.
- Đội tuần tra di động.

Không đặt phần thưởng ở mọi sector. Một số vùng trống được giữ lại để tạo nhịp nghỉ và cảm giác khoảng cách.

### 5.5. Di chuyển nhanh

- Người chơi mở khóa fast travel sau khi chiếm một căn cứ hoặc trạm vô tuyến.
- Fast travel chỉ dùng ngoài giao tranh.
- Có thể gọi trực thăng vận chuyển xe sau khi chiếm sân bay.
- Nếu muốn chơi liền mạch, người chơi vẫn có thể tự lái xuyên toàn bản đồ.

---

## 6. Cấu trúc nhiệm vụ

### 6.1. Nhiệm vụ chính

1. **Khởi động Bão Thép:** sửa T-99 và thoát khỏi garage.
2. **Tín hiệu cuối:** giải cứu Lan tại Bình Minh.
3. **Mắt của ARES:** phá radar Nam-1.
4. **Một nơi để trở về:** chiếm nhà máy thép.
5. **Đoàn xe sống sót:** hộ tống dân thường qua đồng bằng.
6. **Dòng điện đen:** quyết định số phận đập K-7.
7. **Thành phố không ngủ:** lấy khóa mã hóa trong trung tâm dữ liệu.
8. **Bầu trời của chúng ta:** chiếm sân bay quân sự.
9. **Kim loại quý:** giải phóng mỏ titan.
10. **Người trong cỗ máy:** giải cứu hoặc tiêu diệt Lan.
11. **Ba mũi thép:** tổng tiến công lên Hắc Sơn.
12. **Lõi phán xét:** đánh Leviathan và ARES Omega.

### 6.2. Nhiệm vụ phụ

- Cứu đội sửa chữa bị bao vây.
- Săn xe tăng át chủ bài của ARES.
- Tìm hộp đen của đơn vị đã mất.
- Phá đoàn tàu chở vũ khí.
- Dọn bãi mìn cho dân thường.
- Phòng thủ trạm vô tuyến qua nhiều đợt tấn công.
- Thu hồi mẫu giáp thử nghiệm.
- Hộ tống pháo tự hành đến vị trí khai hỏa.

### 6.3. Sự kiện thế giới

- Đoàn tuần tra địch đi qua giữa hai sector.
- Drone phát hiện người chơi và gọi viện binh.
- Trực thăng địch săn xe trong vùng trống.
- Kháng chiến yêu cầu hỗ trợ khẩn cấp.
- Hai phe AI giao chiến mà không cần người chơi kích hoạt.
- Bão cát, mưa lớn hoặc sương mù thay đổi tầm nhìn.

---

## 7. Gameplay xe tăng

### 7.1. Điều khiển cảm ứng

- Joystick trái: tiến, lùi và xoay thân xe.
- Vuốt nửa phải màn hình: xoay camera và tháp pháo.
- Nút pháo chính: bắn loại đạn đang chọn.
- Nút súng máy: bắn mục tiêu nhẹ.
- Nút kỹ năng: tên lửa, khói hoặc sửa chữa.
- Nút khóa mục tiêu: ưu tiên mục tiêu gần tâm ngắm.
- Chạm minimap: đặt waypoint.

### 7.2. Các loại đạn

#### AP — Xuyên giáp

- Tốc độ cao.
- Tốt khi bắn trực diện vào xe tăng.
- Sát thương nổ thấp.

#### HE — Nổ mạnh

- Tốt với xe nhẹ, bộ binh, công trình và mô-đun ngoài.
- Khó xuyên giáp dày.

#### HEAT — Đạn lõm

- Khả năng xuyên ổn định ở khoảng cách xa.
- Bị giáp phản ứng khắc chế.

#### ATGM — Tên lửa dẫn đường

- Sát thương lớn và điều khiển được trong thời gian ngắn.
- Tốc độ nạp chậm, dễ bị hệ thống phòng vệ đánh chặn.

### 7.3. Mô hình sát thương

Mỗi xe có:

- Máu tổng.
- Giáp trước, hông, sau và nóc.
- Mô-đun động cơ.
- Xích trái và xích phải.
- Tháp pháo.
- Kho đạn.
- Kíp lái hoặc lõi điều khiển.

Quy trình tính một phát bắn:

1. Raycast hoặc projectile xác định điểm va chạm.
2. Lấy loại giáp và góc va chạm.
3. Tính khả năng xuyên.
4. Nếu xuyên, gây sát thương thân xe và mô-đun gần điểm va chạm.
5. Nếu không xuyên, phát hiệu ứng bật đạn và rung camera nhẹ.

### 7.4. AI địch

AI dùng state machine đơn giản:

- Patrol.
- Investigate.
- Acquire target.
- Seek cover.
- Aim.
- Fire.
- Flank.
- Retreat.
- Disabled.

Không cho toàn bộ AI chạy logic đầy đủ cùng lúc. AI xa người chơi chỉ chạy mô phỏng chiến lược với tần suất thấp.

---

## 8. Hệ thống xe và nâng cấp

### 8.1. Các lớp xe

#### Xe nhẹ

- Tốc độ cao.
- Radar và tầm phát hiện tốt.
- Hợp trinh sát, đánh vòng và chiếm điểm.

#### Xe trung

- Cân bằng giữa tốc độ, giáp và hỏa lực.
- Là lựa chọn mặc định cho phần lớn nhiệm vụ.

#### Xe nặng

- Giáp trước và pháo mạnh.
- Chậm, dễ bị đánh vào hông.
- Hợp phòng thủ hoặc đột phá chính diện.

#### Pháo chống tăng

- Khả năng xuyên lớn.
- Góc xoay pháo hạn chế hoặc giáp yếu.
- Phù hợp mai phục tầm xa.

### 8.2. Nhánh nâng cấp T-99

- Động cơ: tốc độ, gia tốc, khả năng vượt bùn.
- Xích: độ bám, tốc độ xoay thân, độ bền.
- Giáp: giáp composite, giáp phản ứng, lồng chống tên lửa.
- Pháo: độ xuyên, độ chính xác, tốc độ nạp.
- Điện tử: radar, khóa mục tiêu, phát hiện điểm yếu.
- Hỗ trợ: khói, drone, sửa chữa, gọi pháo và không kích.

---

## 9. Tiến trình, cửa hàng và vật phẩm

### 9.1. Tài nguyên

- **Phụ tùng:** sửa chữa và nâng cấp cơ khí.
- **Dữ liệu ARES:** mở kỹ năng điện tử và cốt truyện bí mật.
- **Titan:** nâng cấp giáp cấp cao.
- **Uy tín kháng chiến:** mở đồng đội và hỗ trợ chiến trường.
- **Vé Tiếp Vận:** đơn vị thưởng đặc biệt từ thành tựu, sự kiện hoặc gói hỗ trợ; chỉ dùng cho vật phẩm trang trí, không mua sức mạnh chiến đấu.

### 9.2. Cửa hàng trong thế giới game

#### Kho Tiếp Vận Bão Thép

- Nằm trong nhà máy thép, cạnh garage chính.
- Được mở sau nhiệm vụ `Một nơi để trở về`.
- Người chơi nói chuyện với Mai hoặc mở terminal trong garage để mua đồ.
- Hàng hóa thay đổi theo tiến trình giải phóng bản đồ, không xoay vòng ép người chơi đăng nhập mỗi ngày.

#### Trạm tiếp tế tiền tuyến

- Xuất hiện ở các căn cứ đã chiếm.
- Chỉ bán đạn, khói, bộ sửa chữa và một số vật phẩm nhiệm vụ.
- Giá cao hơn kho chính khoảng 10–15% để tạo lựa chọn giữa tiện lợi và tiết kiệm.
- Không truy cập vật phẩm mua bằng tiền thật giữa trận.

#### Cửa hàng ngoài trận

- Truy cập từ main menu hoặc garage.
- Dùng để xem skin, decal, hiệu ứng và nội dung mở rộng.
- Cho phép xem thử vật phẩm trực tiếp trên model xe trước khi mua.
- Có nút khôi phục giao dịch và lịch sử quyền sở hữu.

### 9.3. Luồng mở khóa cửa hàng trong cốt truyện

Sau khi chiếm nhà máy thép, người chơi gặp Mai trong kho chứa gần như trống rỗng.

> Mai: “Tôi có thợ, có bản thiết kế, nhưng không có vật liệu. Anh mang sắt vụn về đây, tôi biến nó thành thứ giữ anh sống sót.”

Nhiệm vụ giới thiệu cửa hàng gồm ba bước:

1. Nhận miễn phí một bộ sửa chữa dã chiến.
2. Mua một hộp đạn AP bằng Phụ tùng vừa nhận.
3. Trang bị một mẫu sơn ngụy trang được tặng.

Sau nhiệm vụ này:

- Giải cứu đoàn xe mở thêm vật phẩm tiêu hao.
- Chiếm radar mở thiết bị điện tử.
- Giải phóng mỏ titan mở giáp cấp cao.
- Chiếm sân bay mở drone và hỗ trợ không kích.
- Tiêu diệt xe át chủ bài mở skin hoặc decal độc quyền.
- Hoàn thành kết thúc game mở bộ ngoại hình ARES Omega.

### 9.4. Danh mục vật phẩm đề xuất

#### Vật phẩm tiêu hao mua bằng Phụ tùng

| Vật phẩm | Giá mẫu | Công dụng | Giới hạn |
|---|---:|---|---|
| Bộ sửa chữa dã chiến | 150 Phụ tùng | Hồi 25% máu và sửa một mô-đun | 2 mỗi nhiệm vụ |
| Lựu đạn khói kép | 90 Phụ tùng | Tạo màn khói hai bên xe | 3 mỗi nhiệm vụ |
| Hộp đạn AP | 120 Phụ tùng | Bổ sung 8 viên xuyên giáp | Theo sức chứa xe |
| Hộp đạn HE | 100 Phụ tùng | Bổ sung 8 viên nổ mạnh | Theo sức chứa xe |
| Pin drone | 180 Phụ tùng | Thêm một lần trinh sát 30 giây | 2 mỗi nhiệm vụ |
| Thiết bị rà mìn | 220 Phụ tùng | Hiện mìn trong bán kính gần | 1 mỗi nhiệm vụ |
| Bộ cứu hỏa tự động | 250 Phụ tùng | Dập cháy động cơ ngay lập tức | 1 mỗi nhiệm vụ |

Giá trên là giá cân bằng ban đầu, phải điều chỉnh bằng dữ liệu chơi thử.

#### Trang bị vĩnh viễn kiếm và mua trong game

| Vật phẩm | Điều kiện mở | Giá mẫu | Hiệu quả |
|---|---|---:|---|
| Kính ngắm nhiệt MK-I | Phá radar Nam-1 | 1.200 Phụ tùng + 20 Dữ liệu | Nhìn rõ hơn trong khói nhẹ và ban đêm |
| Giáp phản ứng ERA-2 | Giải phóng mỏ titan | 2.000 Phụ tùng + 80 Titan | Giảm phát xuyên đầu tiên ở mỗi mặt giáp |
| Hệ thống phòng vệ chủ động | Chiếm sân bay | 3.500 Phụ tùng + 120 Titan | Có xác suất chặn ATGM, cần hồi chiêu |
| Bộ truyền động địa hình | Hoàn thành nhiệm vụ đầm lầy | 1.600 Phụ tùng | Giảm phạt tốc độ trong bùn và tuyết |
| Máy nạp đạn cải tiến | Đánh bại Crusher | 2.400 Phụ tùng | Giảm thời gian nạp nhưng tăng nguy cơ hỏng kho đạn |
| Drone Chim Ưng | Chiếm trung tâm dữ liệu | 2.800 Phụ tùng + 35 Dữ liệu | Đánh dấu mục tiêu trong khu vực rộng |

Trang bị chiến đấu mạnh phải được mở bằng gameplay. Người chơi không thể dùng tiền thật để bỏ qua điều kiện nhiệm vụ.

#### Vật phẩm trang trí

- Skin `Sa Mạc Đỏ`: sơn cát, vải ngụy trang và bụi bám thân xe.
- Skin `Bóng Rừng`: xanh tối, lưới ngụy trang và cành cây.
- Skin `Hổ Lửa`: sọc đỏ cam và dấu đạn trang trí.
- Skin `Băng Hắc Sơn`: sơn trắng xước, bùn tuyết và tấm chắn lạnh.
- Skin `ARES Phản Nghịch`: bề mặt đen, đường sáng điện tử và biểu tượng ARES bị gạch bỏ.
- Decal đơn vị, số hiệu xe và cờ hiệu.
- Hiệu ứng đầu nòng màu khác nhưng không thay đổi sát thương.
- Kiểu khói chiến thắng khi hạ boss.
- Bộ âm thanh radio hoặc giọng chỉ huy tùy chọn.

Các vật phẩm trang trí có thể nhận từ thành tựu, nhiệm vụ, Vé Tiếp Vận hoặc mua trực tiếp. Phải ghi rõ nguồn nhận của từng vật phẩm.

#### Xe tăng bổ sung

- **M-27 Linh Miêu:** xe nhẹ trinh sát, mở qua chuỗi nhiệm vụ của Lan.
- **K-84 Thành Đồng:** xe nặng đột phá, mở sau khi bảo vệ đập K-7.
- **D-12 Bóng Ma:** pháo chống tăng tàng hình nhiệt, mở từ nhiệm vụ săn át chủ bài.
- **T-99A Bão Thép:** biến thể cuối game, mở bằng cốt truyện.

Xe mới có lối chơi khác nhau nhưng không được mạnh hơn tuyệt đối. Nếu được bán trong gói mở rộng, phải có phiên bản tương đương có thể mở bằng gameplay hoặc chỉ dùng trong chiến dịch riêng của gói đó.

#### Nội dung có thể bán bằng tiền thật

- Gói skin theo biome.
- Gói decal và số hiệu.
- Gói hiệu ứng hình ảnh không tăng chỉ số.
- Gói nhạc nền hoặc radio.
- Chiến dịch mở rộng với vùng bản đồ và nhiệm vụ mới.
- Gói supporter gồm vật phẩm trang trí và credit cảm ơn.

Không bán trực tiếp:

- Đạn có sát thương cao hơn.
- Giáp mạnh độc quyền.
- Lượt hồi sinh bắt buộc.
- Vật phẩm tăng tỷ lệ thắng trong chiến dịch chính.
- Loot box ngẫu nhiên không cho biết chính xác phần thưởng.

### 9.5. Inventory và trang bị

Inventory chia thành:

- `Consumables`: vật phẩm bị trừ sau khi dùng.
- `Equipment`: thiết bị vĩnh viễn, có cấp nâng cấp.
- `Cosmetics`: skin, decal và hiệu ứng đã sở hữu.
- `Vehicles`: danh sách xe đã mở khóa.
- `Entitlements`: DLC và quyền sở hữu từ cửa hàng nền tảng.

Mỗi xe có loadout:

- Một pháo chính.
- Một vũ khí phụ.
- Hai ô thiết bị chủ động.
- Ba ô nâng cấp bị động.
- Một skin.
- Tối đa ba decal.

### 9.6. Luồng mua hàng

#### Mua bằng tài nguyên trong game

1. Chọn vật phẩm.
2. Xem mô tả, chỉ số và điều kiện mở khóa.
3. Xác nhận giá.
4. Trừ tài nguyên trong một transaction nguyên tử.
5. Thêm vật phẩm vào inventory.
6. Cho phép trang bị ngay hoặc để sau.

Nếu bước thêm inventory thất bại, giao dịch phải rollback và hoàn lại toàn bộ tài nguyên.

#### Mua bằng tiền thật

1. Tải catalog sản phẩm hợp lệ cho nền tảng hiện tại.
2. Người chơi chọn sản phẩm và xem giá do store cung cấp.
3. Chuyển giao dịch cho Google Play hoặc App Store.
4. Xác thực receipt hoặc purchase token ở backend.
5. Backend cấp entitlement theo transaction id duy nhất.
6. Ứng dụng đồng bộ inventory và hiển thị vật phẩm.
7. Giao dịch có thể được khôi phục trên thiết bị mới.

Không ghi giá tiền thật cố định trong source hoặc file nhiệm vụ. Giá và trạng thái khả dụng phải lấy từ store catalog.

### 9.7. Nguyên tắc cân bằng và trải nghiệm

- Người chơi hoàn thành chiến dịch mà không phải mua tiền thật.
- Không hiển thị quảng cáo hoặc popup cửa hàng giữa đoạn chiến đấu.
- Không dùng đồng hồ đếm ngược giả để tạo khan hiếm.
- Mọi vật phẩm phải có preview và mô tả chính xác.
- Vật phẩm ảnh hưởng gameplay chỉ dùng tài nguyên kiếm được trong game.
- Vật phẩm mua lại phải bị chặn trước khi gửi giao dịch.
- Có chức năng khôi phục giao dịch, xử lý pending và hoàn tiền.

### 9.8. Save và đồng bộ

- Tài nguyên gameplay có thể lưu cục bộ trong bản offline đầu tiên.
- Entitlement mua bằng tiền thật phải dựa trên store hoặc backend, không chỉ dựa vào local save.
- Inventory lưu version schema để hỗ trợ migration.
- Mỗi transaction có id duy nhất để tránh cấp vật phẩm hai lần.
- Khi offline, người chơi vẫn dùng được entitlement đã xác nhận trước đó.

---

## 10. Giao diện

### HUD trong trận

- Góc trên trái: máu và trạng thái mô-đun.
- Trên giữa: nhiệm vụ hiện tại và khoảng cách.
- Góc trên phải: minimap, hướng và mức cảnh báo.
- Góc dưới trái: joystick.
- Góc dưới phải: bắn, đổi đạn, kỹ năng và khóa mục tiêu.
- Tâm màn hình: reticle với thời gian nạp và dự đoán xuyên giáp.

### Màn hình ngoài trận

- Main menu.
- Tiếp tục chiến dịch.
- Bản đồ chiến lược.
- Garage.
- Nâng cấp.
- Kho Tiếp Vận và cửa hàng vật phẩm.
- Inventory và loadout.
- Nhật ký nhiệm vụ.
- Thiết lập đồ họa, điều khiển và ngôn ngữ.

### Hỗ trợ Tiếng Việt và Tiếng Anh

- Toàn bộ menu, HUD, tutorial, mục tiêu, hội thoại, phụ đề, nhật ký nhiệm vụ, mô tả vật phẩm và thông báo hệ thống hỗ trợ cả Tiếng Việt lẫn Tiếng Anh.
- Lần chạy đầu chọn ngôn ngữ theo ngôn ngữ thiết bị: dùng Tiếng Việt nếu locale là `vi`, nếu không dùng Tiếng Anh.
- Người chơi có thể đổi ngôn ngữ bất kỳ lúc nào trong Settings mà không cần kết nối mạng hoặc khởi động lại game.
- Tên game hiển thị theo locale: `IRON GORGE: ARES OVERRIDE` cho English và `KHE SẮT: CHỈ THỊ ZERO` cho Tiếng Việt.
- Tiếng Việt là ngôn ngữ gốc của cốt truyện; bản Tiếng Anh phải giữ đúng tên riêng như ARES, T-99 Bão Thép, Khe Sắt và Chỉ thị Zero theo glossary của dự án.
- MVP hỗ trợ text và phụ đề song ngữ. Lồng tiếng Tiếng Anh là nội dung tùy chọn sau vertical slice; không phải yêu cầu MVP.
- Font phải hiển thị đầy đủ dấu Tiếng Việt, ký tự Latin, số và ký hiệu HUD.
- UI phải chịu được câu Tiếng Anh dài hơn mà không cắt chữ, che nút hoặc tràn khỏi màn hình.
- Không hard-code chuỗi hiển thị trực tiếp trong widget, mission hoặc gameplay component.

---

## 11. Phong cách hình ảnh và âm thanh

### 11.1. Hình ảnh

- 3D low-poly bán hiện thực.
- Hình khối rõ, dễ đọc trên màn hình điện thoại.
- Texture atlas để giảm draw call.
- Màu từng vùng khác nhau nhưng không quá rực.
- Ban ngày là mặc định; một số nhiệm vụ có hoàng hôn, đêm hoặc bão.

### 11.2. Hiệu ứng

- Bụi từ xích xe.
- Đất bắn lên khi đạn chạm mặt đường.
- Tia lửa khi đạn không xuyên.
- Lửa và khói theo mức hư hại.
- Camera shake có giới hạn và có tùy chọn tắt.

### 11.3. Âm thanh

- Âm động cơ thay đổi theo vòng tua.
- Tiếng xích riêng cho đất, bùn, bê tông và kim loại.
- Tiếng pháo có lớp âm gần, tiếng vọng và âm trầm.
- Âm thanh cảnh báo khóa mục tiêu phải dễ nhận biết.

---

## 12. Định hướng kỹ thuật Flutter

### 12.1. Stack đề xuất

- Flutter dùng cho menu, HUD, garage, settings và navigation.
- Flame dùng cho game loop, component lifecycle, input và audio integration.
- Flame 3D dùng cho world, camera, mesh, model và GPU rendering.
- Asset 3D dùng định dạng được pipeline của Flame 3D hỗ trợ tại thời điểm triển khai; cần spike kỹ thuật trước khi khóa toàn bộ pipeline art.

**Lưu ý quan trọng:** Flame 3D hiện được nhà phát hành mô tả là hỗ trợ 3D thử nghiệm. Vì vậy không được bắt đầu sản xuất toàn bộ map 16 × 16 km trước khi vertical slice chứng minh được rendering, model loading, input, collision và hiệu năng trên máy Android tầm trung.

### 12.2. Kiến trúc cấp cao

```text
Flutter App
├── Navigation và menu
├── Settings / Save / Profile
├── Mission, Garage, Shop và Inventory UI
├── ProductCatalog / Wallet / Entitlements
└── Game Screen
    └── FlameGame3D
        ├── WorldStreamSystem
        ├── TankControllerSystem
        ├── WeaponSystem
        ├── ProjectileSystem
        ├── DamageSystem
        ├── AISystem
        ├── MissionSystem
        ├── SpawnSystem
        ├── AudioSystem
        ├── EffectsSystem
        └── SaveCheckpointSystem
```

### 12.3. Cấu trúc thư mục dự kiến

```text
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme.dart
├── game/
│   ├── iron_gorge_game.dart
│   ├── camera/
│   ├── components/
│   │   ├── tanks/
│   │   ├── weapons/
│   │   ├── projectiles/
│   │   ├── world/
│   │   └── effects/
│   ├── systems/
│   │   ├── ai/
│   │   ├── combat/
│   │   ├── mission/
│   │   ├── streaming/
│   │   └── save/
│   └── data/
├── features/
│   ├── main_menu/
│   ├── garage/
│   ├── shop/
│   ├── inventory/
│   ├── map/
│   ├── mission_log/
│   └── settings/
└── shared/
    ├── audio/
    ├── commerce/
    │   ├── purchase_service.dart
    │   ├── receipt_validator.dart
    │   └── entitlement_repository.dart
    ├── persistence/
    └── widgets/

assets/
├── config/
│   ├── product_catalog.json
│   └── economy_balance.json
├── maps/
├── models/
├── textures/
├── audio/
└── shaders/
```

---

## 13. World streaming cho map 16 × 16 km

### 13.1. Chia sector

- Bản đồ logic gồm 32 × 32 sector.
- Mỗi sector 500 × 500 m.
- Mỗi sector có file dữ liệu riêng mô tả địa hình, vật thể, spawn và trigger.
- Chỉ sector gần người chơi mới tạo đối tượng 3D đầy đủ.

### 13.2. Vòng tải đề xuất

- Vòng 0–500 m: model đầy đủ, collision đầy đủ, AI cập nhật liên tục.
- Vòng 500–1.000 m: model LOD thấp, AI cập nhật chậm.
- Vòng 1.000–2.000 m: chỉ landmark và mô phỏng chiến lược.
- Ngoài 2.000 m: không render; chỉ lưu trạng thái logic tối thiểu.

### 13.3. Quy tắc tải và dỡ

- Preload sector theo hướng di chuyển của xe.
- Dỡ sector sau lưng với độ trễ để tránh load/unload liên tục.
- Asset dùng chung được giữ trong cache.
- Không spawn mọi cây, đá và nhà thành component độc lập nếu có thể gộp mesh.
- Dùng object pool cho đạn, khói, vết đạn và xe AI thường gặp.

### 13.4. Floating origin

Với bản đồ 16 km, nên dùng floating origin:

- Tọa độ thế giới logic lưu bằng số liệu toàn cục.
- Khi người chơi đi quá xa gốc render, dịch toàn bộ scene về gần `(0, 0, 0)`.
- Mission, save và AI chiến lược vẫn dùng tọa độ toàn cục.
- Render và physics dùng tọa độ cục bộ để tránh sai số số thực.

---

## 14. Dữ liệu hướng cấu hình

Không hard-code nhiệm vụ và chỉ số xe trực tiếp trong component.

### 14.1. Ví dụ định nghĩa xe

```json
{
  "id": "t99_storm",
  "class": "medium",
  "maxHealth": 1800,
  "maxSpeed": 16.0,
  "reverseSpeed": 6.5,
  "hullTurnRate": 0.65,
  "turretTurnRate": 0.85,
  "armor": {
    "front": 180,
    "side": 95,
    "rear": 55,
    "top": 35
  },
  "weaponIds": ["cannon_125mm", "mg_coaxial"]
}
```

### 14.2. Ví dụ định nghĩa sector

```json
{
  "id": "sector_18_07",
  "biome": "black_forest",
  "bounds": {
    "x": 9000,
    "z": 3500,
    "width": 500,
    "height": 500
  },
  "landmarkIds": ["relay_west_02"],
  "spawnGroupIds": ["patrol_light_03"],
  "missionTriggerIds": ["rescue_engineers"],
  "neighborIds": ["sector_17_07", "sector_19_07", "sector_18_06", "sector_18_08"]
}
```

### 14.3. Ví dụ định nghĩa nhiệm vụ

```json
{
  "id": "main_06_black_current",
  "title": "Dòng điện đen",
  "startTrigger": "enter_dam_control_zone",
  "objectives": [
    {"type": "destroy", "targetGroup": "dam_turrets", "count": 4},
    {"type": "reach", "target": "dam_control_room"},
    {"type": "choice", "options": ["capture_dam", "disable_dam", "destroy_dam"]}
  ],
  "rewards": {
    "parts": 800,
    "resistanceReputation": 150
  }
}
```

### 14.4. Ví dụ định nghĩa sản phẩm

```json
{
  "id": "field_repair_kit",
  "type": "consumable",
  "title": "Bộ sửa chữa dã chiến",
  "description": "Hồi 25% máu và sửa một mô-đun bị hỏng.",
  "price": {
    "currency": "parts",
    "amount": 150
  },
  "unlockConditionId": "shop_tutorial_complete",
  "maxOwned": 10,
  "maxEquipped": 2,
  "isRealMoneyProduct": false
}
```

### 14.5. Interface thương mại cần cô lập

```dart
abstract interface class ShopService {
  Future<List<Product>> loadCatalog();
  Future<PurchaseResult> buyWithGameCurrency(String productId);
}

abstract interface class PurchaseService {
  Future<List<StoreProduct>> loadStoreProducts();
  Future<PurchaseResult> purchase(String storeProductId);
  Future<void> restorePurchases();
}

abstract interface class InventoryRepository {
  Future<Inventory> load();
  Future<void> grant(OwnedItem item, String transactionId);
  Future<void> equip(String vehicleId, String itemId, String slotId);
}
```

Gameplay chỉ đọc inventory và loadout. Gameplay không được gọi API thanh toán trực tiếp.

---

## 15. Ngân sách hiệu năng

### Mục tiêu thiết bị

- Android tầm trung, RAM 6 GB.
- iPhone tương đương về GPU và bộ nhớ.

### Mục tiêu khung hình

- 60 FPS ở thiết lập thấp và trung bình nếu thiết bị đáp ứng.
- 30 FPS ổn định ở thiết lập cao hoặc thiết bị yếu hơn.
- Không để gameplay thường xuyên xuống dưới 30 FPS.

### Ngân sách ban đầu cần đo bằng profiler

- Tối đa khoảng 15–25 xe có logic chiến đấu đầy đủ trong vùng gần.
- Tối đa khoảng 80 đơn vị logic đơn giản ở vùng xa.
- Particle phải có giới hạn tổng và tái sử dụng qua pool.
- Texture dùng atlas và nhiều mức phân giải.
- Shadow chỉ bật cho vật thể quan trọng ở khoảng cách gần.
- Số draw call, triangle và bộ nhớ texture phải được đo trên thiết bị thật; không chốt bằng cảm giác khi chạy desktop.

---

## 16. MVP và phạm vi bản đầy đủ

### 16.1. MVP bắt buộc

Không làm ngay toàn bộ 256 km². MVP chỉ gồm:

- Một map 1 × 1 km.
- Một xe người chơi.
- Hai loại xe địch.
- Di chuyển thân xe và xoay tháp pháo độc lập.
- Một loại đạn AP và một loại đạn HE.
- Va chạm, bắn, xuyên giáp cơ bản và phá hủy.
- Một nhiệm vụ chiếm điểm dài 8–10 phút.
- Một garage đơn giản.
- Một shop thử nghiệm chỉ mua vật phẩm bằng Phụ tùng.
- Save và load tiến trình.
- Toàn bộ UI, HUD, tutorial, objective và phụ đề của nhiệm vụ MVP có bản Tiếng Việt và Tiếng Anh.
- Chạy ổn định trên ít nhất một máy Android tầm trung.

### 16.2. Vertical slice

Sau MVP, tạo một lát cắt 2 × 2 km đại diện chất lượng game cuối:

- Một làng.
- Một khu rừng.
- Một con sông và cầu.
- Một căn cứ địch.
- Một boss.
- Thời tiết động.
- World streaming giữa 16 sector nhỏ.
- Âm thanh và hiệu ứng gần chất lượng phát hành.

### 16.3. Bản đầy đủ

Chỉ mở rộng lên 16 × 16 km khi vertical slice đạt:

- FPS mục tiêu trên thiết bị thật.
- Không có giật lớn khi chuyển sector.
- Pipeline tạo sector đủ nhanh.
- Save/load trạng thái thế giới đáng tin cậy.
- AI xa và AI gần chuyển đổi không gây lỗi.

---

## 17. Lộ trình implementation

### Giai đoạn 0 — Technical spike

- Tạo scene Flame 3D tối thiểu.
- Render mặt đất, một model xe và camera thứ ba.
- Kiểm tra model import, ánh sáng, texture và shader.
- Đo FPS trên Android thật.
- Quyết định tiếp tục Flame 3D hay thay lớp render trước khi viết gameplay lớn.

**Điều kiện hoàn thành:** xe xuất hiện đúng, camera ổn định, input cảm ứng hoạt động và scene giữ FPS mục tiêu.

### Giai đoạn 1 — Tank controller

- Di chuyển thân xe.
- Xoay tháp pháo.
- Camera follow.
- Giới hạn địa hình và độ dốc.
- Joystick và input cảm ứng.

### Giai đoạn 2 — Combat core

- Bắn projectile.
- Va chạm.
- Nạp đạn.
- Giáp và góc va chạm.
- Damage mô-đun.
- Hiệu ứng bắn và trúng đạn.

### Giai đoạn 3 — Enemy AI

- Patrol.
- Phát hiện người chơi.
- Ngắm và bắn.
- Tìm vị trí che chắn đơn giản.
- Đánh vòng theo waypoint.

### Giai đoạn 4 — Mission framework

- Objective graph.
- Trigger vùng.
- Spawn group.
- Hội thoại.
- Reward.
- Fail, retry và checkpoint.

### Giai đoạn 5 — MVP map

- Dựng 1 × 1 km.
- Một làng, một đồi và một căn cứ.
- Nhiệm vụ hoàn chỉnh 8–10 phút.
- Profiling và tối ưu vòng đầu.

### Giai đoạn 6 — World streaming

- Sector loader.
- Asset cache.
- AI simulation tiers.
- Object pool.
- Floating origin.
- Save trạng thái sector.

### Giai đoạn 7 — Vertical slice

- Map 2 × 2 km.
- Chất lượng art mục tiêu.
- Boss.
- Thời tiết.
- Garage và nâng cấp.
- Shop trong game, inventory và preview skin.
- Một sản phẩm test cho luồng mua/khôi phục trên sandbox của nền tảng.
- Kiểm thử thiết bị thật.

### Giai đoạn 8 — Production thế giới

- Dựng tám vùng lớn.
- Viết và tích hợp 12 nhiệm vụ chính.
- Thêm nhiệm vụ phụ và sự kiện thế giới.
- Thêm xe, vũ khí và nâng cấp.
- Hoàn thiện catalog, shop tiền tuyến, cosmetic và economy balance.

### Giai đoạn 8.5 — Commerce và entitlement

- Tích hợp sản phẩm nền tảng sau khi gameplay và retention đã được kiểm chứng.
- Product catalog theo Android và iOS.
- Purchase state machine: pending, purchased, restored, canceled và failed.
- Backend xác thực giao dịch và cấp entitlement idempotent.
- Khôi phục giao dịch trên thiết bị mới.
- Xử lý refund và revoke entitlement khi phù hợp.
- Kiểm thử sandbox trên cả hai nền tảng.

### Giai đoạn 9 — Tối ưu và phát hành

- Thiết lập đồ họa thấp, trung bình, cao.
- Kiểm tra nhiệt độ, pin và memory leak.
- Kiểm tra save migration.
- Accessibility và remap control.
- Crash reporting, analytics và store release.

---

## 18. Thứ tự ticket nên tạo đầu tiên

1. Spike render một model xe trong Flame 3D.
2. Camera thứ ba bám theo thân xe.
3. Joystick điều khiển tiến, lùi và xoay.
4. Vuốt màn hình điều khiển tháp pháo.
5. Projectile và raycast va chạm.
6. Dummy target có máu.
7. Tính giáp trước, hông và sau.
8. Enemy AI đứng yên ngắm và bắn.
9. Enemy AI tuần tra bằng waypoint.
10. HUD máu, đạn và thời gian nạp.
11. Map thử nghiệm 1 × 1 km.
12. Mission chiếm căn cứ.
13. Save/load checkpoint.
14. Profiling trên Android thật.
15. Quyết định có tiếp tục pipeline 3D hiện tại hay không.
16. Wallet và inventory local.
17. Product catalog data-driven.
18. Shop mua bằng Phụ tùng.
19. Loadout và trang bị vật phẩm.
20. Preview skin trong garage.
21. PurchaseService giả lập để test UI.
22. Tích hợp sandbox store sau vertical slice.
23. Backend xác thực và entitlement.

---

## 19. Rủi ro và cách giảm thiểu

### Rủi ro: Flame 3D còn thử nghiệm

**Giảm thiểu:** technical spike trước, cô lập renderer sau một lớp interface, không để mission và combat phụ thuộc sâu vào API render.

### Rủi ro: map 16 × 16 km vượt khả năng thiết bị

**Giảm thiểu:** sector streaming, LOD, object pooling, AI nhiều tầng và giới hạn content hoạt động quanh người chơi.

### Rủi ro: quá nhiều nội dung thủ công

**Giảm thiểu:** bộ prefab theo biome, road spline, scatter rule cho cây/đá, mission data-driven và tái sử dụng layout chiến đấu có biến thể.

### Rủi ro: điều khiển xe tăng khó trên cảm ứng

**Giảm thiểu:** aim assist nhẹ, tùy chỉnh độ nhạy, khóa mục tiêu tùy chọn, HUD có thể đổi vị trí và tutorial ngắn.

### Rủi ro: scope vượt khả năng nhóm nhỏ

**Giảm thiểu:** coi map 16 × 16 km là mục tiêu dài hạn. MVP 1 × 1 km và vertical slice 2 × 2 km phải đứng độc lập như một game nhỏ chơi được.

### Rủi ro: shop làm hỏng cân bằng hoặc tạo cảm giác pay-to-win

**Giảm thiểu:** chỉ bán trực tiếp cosmetic và expansion; mọi trang bị ảnh hưởng chiến đấu phải mở bằng gameplay và được cân bằng bằng dữ liệu chơi thử.

### Rủi ro: cấp vật phẩm hai lần hoặc mất giao dịch

**Giảm thiểu:** entitlement phía server, transaction id duy nhất, thao tác idempotent, trạng thái pending rõ ràng và chức năng khôi phục giao dịch.

---

## 20. Definition of Done cho vertical slice

Vertical slice chỉ được coi là đạt khi:

- Có thể chơi từ menu đến kết thúc nhiệm vụ mà không dùng công cụ debug.
- Xe điều khiển tốt bằng cảm ứng.
- Thân xe, tháp pháo, đạn và camera hoạt động độc lập đúng thiết kế.
- Có ít nhất ba kiểu giao chiến: tầm xa, phục kích trong làng và boss.
- Chuyển sector không gây đứng hình dễ nhận thấy.
- Save/load không làm mất trạng thái nhiệm vụ.
- Có thể đổi Tiếng Việt/Tiếng Anh trong Settings; không thiếu key, lỗi font hoặc tràn chữ nghiêm trọng ở cả hai ngôn ngữ.
- Chạy 30 phút liên tục không crash hoặc tăng bộ nhớ mất kiểm soát.
- Đạt tối thiểu 30 FPS ổn định trên thiết bị Android mục tiêu.
- Người chơi thử hiểu mục tiêu mà không cần người phát triển giải thích trực tiếp.

---

## 21. Quyết định cần khóa trước khi bắt đầu production

1. **Đã khóa:** gameplay offline hoàn toàn; chỉ kết nối store khi người chơi chủ động dùng IAP/Restore Purchases.
2. Chỉ điều khiển một T-99 hay cho phép đổi nhiều xe?
3. Art low-poly hay bán hiện thực?
4. Mức mô phỏng xuyên giáp đơn giản hay chi tiết?
5. Môi trường có phá hủy được hay chỉ một số prefab đặc biệt?
6. Có bộ binh hay chỉ có phương tiện và drone?
7. 30 FPS hay 60 FPS là chuẩn bắt buộc?
8. Dung lượng cài đặt tối đa bao nhiêu?
9. Đội ngũ có công cụ dựng map riêng hay dùng dữ liệu từ Blender?
10. Phạm vi bản phát hành đầu là MVP, vertical slice hay toàn chiến dịch?

---

## 22. Khuyến nghị thực tế

Tầm nhìn 16 × 16 km phù hợp cho game hoàn chỉnh, nhưng không phù hợp làm điểm bắt đầu. Hãy xây chính xác một trận đánh chất lượng cao trên map 1 × 1 km trước. Nếu cảm giác lái, bắn và AI chưa vui trong một kilomet vuông, mở rộng lên 256 kilomet vuông chỉ nhân số lượng vấn đề.

Thứ tự ưu tiên đúng là:

**Cảm giác lái → cảm giác bắn → AI → nhiệm vụ → streaming → mở rộng thế giới.**

---

## 23. Tài liệu kỹ thuật tham khảo

- [Flutter Games Cookbook](https://docs.flutter.dev/cookbook/games)
- [Flutter Casual Games Toolkit](https://docs.flutter.dev/resources/games-toolkit)
- [Flame package](https://pub.dev/packages/flame)
- [Flame 3D package](https://pub.dev/packages/flame_3d)
- [Flame 3D API](https://pub.dev/documentation/flame_3d/latest/)
