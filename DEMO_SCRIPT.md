# Kịch bản Demo Flutter Training

## Giới thiệu tổng quan (2 phút)

**Slide mở đầu:**
- Chào mừng mọi người đến với buổi demo Flutter Training
- Hôm nay chúng ta sẽ khám phá 8 feature chính được xây dựng trong ứng dụng Flutter
- Mỗi feature thể hiện một khía cạnh quan trọng trong phát triển ứng dụng Flutter

**Các feature sẽ demo:**
1. Animation Training - Hiểu về animation trong Flutter
2. Painting and Custom Drawing - Vẽ và tùy chỉnh giao diện
3. Rich Text Editor - Editor văn bản phong phú
4. Sliver Training - Layout nâng cao với Sliver
5. Debug Superpowers - Công cụ debug và performance
6. Attendance (Offline First) - Kiến trúc offline-first
7. Crash Analytics - Theo dõi lỗi với Firebase Crashlytics
8. Home Widget - Widget trên màn hình chính

---

## 1. ANIMATION TRAINING (8 phút)

### Mở màn hình Animation
**Nói:** "Bắt đầu với Animation - một trong những điểm mạnh của Flutter"

### 1.1 Implicit Animation
**Demo:**
- Click vào "Implicit Animation"
- Tap vào box để thấy animation
- Giải thích: "Implicit Animation là cách đơn giản nhất để tạo animation"

**Key Technical Points:**
- ✅ **AnimatedContainer**: Tự động animate khi properties thay đổi
- ✅ **Duration & Curve**: Kiểm soát tốc độ và easing
- ✅ **TweenAnimationBuilder**: Cho animation phức tạp hơn
- ✅ **No AnimationController needed**: Flutter quản lý tự động
- ✅ **Performance**: Optimized, chỉ rebuild khi cần

**Các Implicit Animation Widgets:**
- `AnimatedContainer` - Animate size, color, decoration
- `AnimatedOpacity` - Animate opacity
- `AnimatedPositioned` - Animate position
- `AnimatedPadding` - Animate padding
- `AnimatedAlign` - Animate alignment
- `TweenAnimationBuilder` - Custom tween animations

**Khi nào dùng:**
- Animation đơn giản (size, color, position)
- Không cần kiểm soát chi tiết
- Muốn code ngắn gọn

**Technical Details:**

```dart
// Chỉ cần thay đổi giá trị trong setState()
AnimatedContainer(
  duration: const Duration(milliseconds: 1200),
  curve: Curves.easeInOut,
  width: _big ? 200 : 100,  // Flutter tự động animate
  height: _big ? 200 : 100,
  decoration: BoxDecoration(
    color: _big ? Colors.orange : Colors.blue,
    borderRadius: BorderRadius.circular(_big ? 24 : 8),
  ),
)
```

### 1.2 Explicit Animation
**Demo:**
- Click vào "Explicit Animation"
- Giải thích: "Explicit Animation cho phép kiểm soát chi tiết hơn"
- Animation tự động loop (forward → reverse)

**Key Technical Points:**
- ✅ **AnimationController**: Điều khiển animation (play, pause, reverse, repeat)
- ✅ **SingleTickerProviderStateMixin**: Cung cấp vsync cho controller
- ✅ **Tween**: Định nghĩa range của animation (begin → end)
- ✅ **CurvedAnimation**: Thêm easing curves
- ✅ **AnimatedBuilder**: Rebuild widget khi animation value thay đổi
- ✅ **AnimationStatus**: completed, dismissed, forward, reverse
- ✅ **Memory Management**: Phải dispose controller

**Khi nào dùng:**
- Cần kiểm soát animation (pause, reverse, repeat)
- Animation phức tạp với nhiều properties
- Cần sync nhiều animations
- Custom animation sequences

**Technical Details:**

```dart
// Cần SingleTickerProviderStateMixin
class _AnimationWidgetState extends State<AnimationWidget>
    with SingleTickerProviderStateMixin {
  
  late final AnimationController _controller;
  late final Animation<double> _sizeAnim;
  late final Animation<Color?> _colorAnim;
  late final Animation<double> _curveAnim;

  @override
  void initState() {
    super.initState();
    // 1. Tạo AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,  // Cần vsync để sync với screen refresh
    );

    // 2. Tạo CurvedAnimation cho easing
    _curveAnim = CurvedAnimation(
      parent: _controller, 
      curve: Curves.easeInOut
    );

    // 3. Tạo Tween cho các properties
    _sizeAnim = Tween<double>(begin: 50, end: 200)
        .animate(_curveAnim);
    
    _colorAnim = ColorTween(
      begin: Colors.blue,
      end: Colors.deepOrange,
    ).animate(_curveAnim);

    // 4. Listen status để loop
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,  // Listen to controller
      builder: (context, child) {
        return Container(
          width: _sizeAnim.value,    // Get animated value
          height: _sizeAnim.value,
          color: _colorAnim.value,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();  // QUAN TRỌNG: Phải dispose
    super.dispose();
  }
}
```

### 1.3 Animated Card List
**Demo:**
- Click vào "Card List animated"
- Thêm items (click + icon)
- Xóa items (select → click - icon)
- Giải thích: "AnimatedList cho phép animate khi thêm/xóa items"

**Key Technical Points:**
- ✅ **AnimatedList**: Widget cho animated list
- ✅ **GlobalKey<AnimatedListState>**: Để control list từ bên ngoài
- ✅ **insertItem()**: Trigger insert animation
- ✅ **removeItem()**: Trigger remove animation với builder
- ✅ **Animation parameter**: Tự động inject vào builder
- ✅ **SizeTransition**: Widget để animate size (height)
- ✅ **ListModel pattern**: Wrapper để sync data với AnimatedList

**Technical Details:**

```dart
class _AnimatedListSampleState extends State<AnimatedListSample> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  late ListModel<int> _list;  // Custom wrapper

  @override
  void initState() {
    super.initState();
    _list = ListModel<int>(
      listKey: _listKey,
      initialItems: <int>[0, 1, 2],
      removedItemBuilder: _buildRemovedItem,  // Widget khi remove
    );
  }

  // Widget builder cho items
  Widget _buildItem(BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      animation: animation,  // Animation được inject tự động
      item: _list[index],
    );
  }

  // Widget builder cho removed items (để animate out)
  Widget _buildRemovedItem(int item, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
    );
  }

  void _insert() {
    _list.insert(index, _nextItem);  // Insert vào model
    // AnimatedList tự động animate
  }

  void _remove() {
    _list.removeAt(index);  // Remove từ model
    // AnimatedList tự động animate
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _list.length,
      itemBuilder: _buildItem,  // Build function
    );
  }
}

// Custom ListModel để sync với AnimatedList
class ListModel<E> {
  final GlobalKey<AnimatedListState> listKey;
  final List<E> _items;

  void insert(int index, E item) {
    _items.insert(index, item);
    listKey.currentState!.insertItem(index);  // Trigger animation
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    listKey.currentState!.removeItem(
      index,
      (context, animation) => removedItemBuilder(removedItem, context, animation),
    );
    return removedItem;
  }
}
```

---

## 2. PAINTING AND CUSTOM DRAWING (8 phút)

### Mở màn hình Painting and Custom Drawing
**Nói:** "Tiếp theo là Painting - khi bạn cần vẽ custom UI không có sẵn"

### 2.1 Painting Bear
**Demo:**
- Click vào "Painting Bear"
- Di chuyển mouse/pointer → mắt con gấu theo dõi
- Toggle password visibility → mắt nhắm lại
- Giải thích: "Sử dụng CustomPainter để vẽ hình con gấu"

**Key Technical Points:**
- ✅ **CustomPainter**: Abstract class để implement custom drawing
- ✅ **Canvas API**: 
  - `drawCircle()` - Vẽ hình tròn
  - `drawOval()` - Vẽ hình oval
  - `drawRect()` - Vẽ hình chữ nhật
  - `drawPath()` - Vẽ path phức tạp
  - `drawLine()` - Vẽ đường thẳng
- ✅ **Paint object**: Định nghĩa style (color, strokeWidth, isAntiAlias)
- ✅ **Coordinate system**: Offset(x, y) cho vị trí
- ✅ **shouldRepaint()**: Optimize - chỉ repaint khi cần
- ✅ **globalToLocal()**: Convert coordinates từ global sang local
- ✅ **RenderBox**: Access layout information

**Canvas API Methods:**
```dart
canvas.drawCircle(center, radius, paint);
canvas.drawOval(rect, paint);
canvas.drawRect(rect, paint);
canvas.drawPath(path, paint);
canvas.drawLine(start, end, paint);
canvas.drawImage(image, offset, paint);
canvas.clipRect(rect);  // Clip drawing area
```


**Technical Details:**

```dart
// 1. Sử dụng CustomPaint widget
CustomPaint(
  painter: _BearPainter(),  // Custom painter
  size: Size(400, 400),
)

// 2. Implement CustomPainter
class _BearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true  // Smooth edges
      ..color = const Color(0xFF8B5A2B);
    
    final center = Offset(size.width / 2, size.height / 2);
    final faceRadius = min(size.width, size.height) * 0.36;
    
    // Vẽ face (circle)
    canvas.drawCircle(center, faceRadius, paint);
    
    // Vẽ snout (oval)
    paint.color = const Color(0xFFD7B899);
    final snoutCenter = Offset(center.dx, center.dy + faceRadius * 0.25);
    canvas.drawOval(
      Rect.fromCenter(
        center: snoutCenter,
        width: faceRadius * 1.2,
        height: faceRadius * 0.7,
      ),
      paint,
    );
    
    // Vẽ nose
    paint.color = Colors.black;
    canvas.drawOval(/* ... */, paint);
    
    // Vẽ ears (2 circles)
    canvas.drawCircle(/* left ear */, paint);
    canvas.drawCircle(/* right ear */, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 3. Eye tracking với coordinate conversion
class _BearFaceState extends State<BearFace> {
  final GlobalKey _widgetKey = GlobalKey();
  Offset _localPointer = Offset.zero;

  void _convertGlobalToLocal() {
    final RenderBox? box = 
        _widgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      // Convert global coordinates to local
      final localPos = box.globalToLocal(widget.globalPointerPos);
      setState(() => _localPointer = localPos);
    }
  }

  // 4. Eye widget với TweenAnimationBuilder
  TweenAnimationBuilder<Offset>(
    tween: Tween(begin: eyeCenter, end: targetCenter),
    duration: const Duration(milliseconds: 90),
    curve: Curves.easeOut,
    builder: (_, animatedCenter, __) {
      // Draw pupil at animated position
    },
  )
}
```

### 2.2 Drag Drop
**Demo:**
- Click vào "Drag Drop"
- Kéo các circle màu vào target box
- Giải thích: "Sử dụng Draggable và DragTarget để tạo drag & drop"

**Key Technical Points:**
- ✅ **Draggable<T>**: Generic type cho type safety
- ✅ **data property**: Data được truyền khi drop
- ✅ **feedback**: Widget hiển thị khi đang drag (thường lớn hơn)
- ✅ **childWhenDragging**: Widget thay thế ở vị trí gốc
- ✅ **maxSimultaneousDrags**: Giới hạn số lượng drag cùng lúc
- ✅ **DragTarget<T>**: Target nhận drop, phải match type
- ✅ **onWillAcceptWithDetails**: Validate trước khi accept
- ✅ **onAcceptWithDetails**: Callback khi accept thành công
- ✅ **candidateData**: List items đang hover (có thể accept)
- ✅ **rejectedData**: List items bị reject

**Use Cases:**
- Reorder items
- Drag to delete
- Drag to categorize
- Drag to upload files

**Technical Details:**

```dart
// 1. Draggable widget - item có thể kéo
Draggable<ColorType>(
  data: type,  // Data được truyền khi drop
  maxSimultaneousDrags: isDimmed ? 0 : 1,  // Disable khi đã accepted
  feedback: _Circle(color: getColor(type), size: 60),  // Widget khi đang drag
  childWhenDragging: _Circle(  // Widget thay thế khi đang drag
    color: getColor(type).withValues(alpha: 0.3),
    size: 50,
  ),
  child: _Circle(  // Widget bình thường
    color: isDimmed ? getColor(type).withValues(alpha: 0.3) : getColor(type),
    size: 50,
  ),
)

// 2. DragTarget widget - nơi nhận drop
DragTarget<ColorType>(
  onWillAcceptWithDetails: (details) {
    // Validate trước khi accept
    return details.data == type;  // Chỉ accept đúng type
  },
  onAcceptWithDetails: (details) {
    // Callback khi drop thành công
    onAccept();
  },
  builder: (context, candidateData, rejectedData) {
    // candidateData: List items đang hover (có thể accept)
    // rejectedData: List items bị reject
    return Container(
      decoration: BoxDecoration(
        color: isAccepted ? getColor(type) : Colors.grey[300],
        border: Border.all(
          color: candidateData.isNotEmpty 
              ? Colors.black  // Highlight khi có item hover
              : Colors.transparent,
          width: 2,
        ),
      ),
    );
  },
)
```

### 2.3 Reorder List
**Demo:**
- Click vào "Reorder List"
- Long press và kéo items để sắp xếp lại
- Giải thích: "ReorderableListView widget có sẵn trong Flutter"

**Key Technical Points:**
- ✅ **ReorderableListView**: Built-in widget
- ✅ **onReorder callback**: (oldIndex, newIndex) → handle reorder
- ✅ **Key requirement**: Mỗi child phải có unique key
- ✅ **Index adjustment**: newIndex cần adjust khi move down
- ✅ **Automatic animation**: Flutter tự động animate
- ✅ **Long press gesture**: Tự động handle

**Kết luận Painting:**
"CustomPainter cho phép vẽ bất kỳ thứ gì với Canvas API. Draggable/DragTarget cho drag & drop interactions. ReorderableListView cho reorder list dễ dàng."

**Technical Details:**

```dart
ReorderableListView(
  onReorder: (oldIndex, newIndex) {
    // Handle reorder logic
    if (newIndex > oldIndex) {
      newIndex -= 1;  // Adjust index
    }
    setState(() {
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
  },
  children: items.map((item) => ListTile(
    key: ValueKey(item.id),  // QUAN TRỌNG: Mỗi item phải có unique key
    title: Text(item.title),
  )).toList(),
)
```
---

## 3. RICH TEXT EDITOR (4 phút)

### Mở màn hình Rich Text Editor
**Nói:** "Rich Text Editor sử dụng flutter_quill - một editor mạnh mẽ"

### Demo:
- Click vào "Rich Text Editor Training"
- Thử các tính năng:
  - Format text (bold, italic, underline)
  - Thêm heading
  - Tạo list (bullet, numbered)
  - Chèn link
  - Undo/Redo
- Click Save → Load để xem JSON serialization

**Key Technical Points:**
- ✅ **flutter_quill package**: Rich text editor library
- ✅ **QuillController**: Quản lý document và selection
- ✅ **Document**: Delta format (operational transform)
- ✅ **Delta format**: JSON representation của document
- ✅ **QuillEditor**: Widget hiển thị editor
- ✅ **QuillSimpleToolbar**: Toolbar với các formatting buttons
- ✅ **toDelta()**: Convert document sang Delta
- ✅ **fromDelta()**: Convert Delta về Document
- ✅ **toPlainText()**: Extract plain text (cho search, indexing)

**Delta Format Example:**
```json
[
  {"insert": "Hello "},
  {"insert": "World", "attributes": {"bold": true}},
  {"insert": "\n"}
]
```

**Kết luận:**
"flutter_quill sử dụng Delta format (operational transform) để quản lý document. Dễ serialize/deserialize, phù hợp cho note apps, comment systems."

**Technical Details:**

```dart
class _RichTextEditorPageState extends State<RichTextEditorPage> {
  late QuillController _controller;
  final FocusNode _focusNode = FocusNode();
  String? _savedJson;  // Store as JSON

  @override
  void initState() {
    super.initState();
    // 1. Tạo Document (Delta format)
    final doc = Document();
    _controller = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  // 2. Save document to JSON
  void _saveDocument() {
    final delta = _controller.document.toDelta();
    final json = jsonEncode(delta.toJson());
    setState(() {
      _savedJson = json;
    });
  }

  // 3. Load document from JSON
  void _loadDocument() {
    final List<dynamic> decoded = jsonDecode(_savedJson!);
    final Delta delta = Delta.fromJson(decoded);
    final doc = Document.fromDelta(delta);
    setState(() {
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    });
  }

  // 4. Convert to plain text
  String _toPlainText() => _controller.document.toPlainText();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Toolbar
          QuillSimpleToolbar(
            controller: _controller,
            config: const QuillSimpleToolbarConfig(
              multiRowsDisplay: true,  // Toolbar nhiều hàng
            ),
          ),
          // Editor
          Expanded(
            child: QuillEditor(
              controller: _controller,
              focusNode: _focusNode,
              config: const QuillEditorConfig(
                placeholder: 'Hello! This is a RichText editor demo.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 4. SLIVER TRAINING (5 phút)

### Mở màn hình Sliver Training
**Nói:** "Sliver là cách để tạo scrollable layout phức tạp và hiệu quả"

### Demo các loại Sliver:
- Scroll để thấy SliverAppBar collapse
- SliverGrid với 3 columns
- SliverList với nhiều items
- SliverPersistentHeader pinned

**Key Technical Points:**
- ✅ **CustomScrollView**: Container cho slivers
- ✅ **SliverAppBar**: Collapsible app bar
  - `expandedHeight`: Height khi expanded
  - `pinned`: Pin ở top khi scroll
  - `floating`: Float khi scroll up
  - `snap`: Snap animation
- ✅ **SliverList**: List với lazy loading
- ✅ **SliverGrid**: Grid với lazy loading
- ✅ **SliverPersistentHeader**: Custom header có thể pin
- ✅ **SliverChildBuilderDelegate**: Build children lazily
- ✅ **Lazy loading**: Chỉ build widgets khi visible
- ✅ **Performance**: Tốt với danh sách lớn (1000+ items)

**Sliver Widgets:**
- `SliverAppBar` - Collapsible app bar
- `SliverList` - Lazy list
- `SliverGrid` - Lazy grid
- `SliverToBoxAdapter` - Wrap regular widget
- `SliverFillRemaining` - Fill remaining space
- `SliverPersistentHeader` - Persistent header

**Use Cases:**
- Google Play Store style
- Instagram feed
- Complex scrollable layouts
- Large lists (performance)

**Kết luận:**
"Sliver widgets lazy load children, chỉ build khi visible. Tạo layout phức tạp với performance tốt. SliverAppBar cho collapsible header effect."

**Technical Details:**

```dart
CustomScrollView(
  slivers: [
    // 1. SliverAppBar - Collapsible app bar
    SliverAppBar(
      expandedHeight: 180,  // Height khi expanded
      pinned: true,         // Pin ở top khi scroll
      floating: true,       // Float khi scroll up
      snap: true,          // Snap khi scroll
      flexibleSpace: FlexibleSpaceBar(
        title: const Text("Sliver Demo"),
        background: Container(color: Colors.blue.shade300),
      ),
    ),

    // 2. SliverPersistentHeader - Custom header
    SliverPersistentHeader(
      pinned: true,  // Pin header
      delegate: _Header("Sliver Grid"),  // Custom delegate
    ),

    // 3. SliverGrid - Grid layout
    SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,  // 3 columns
      ),
      delegate: SliverChildBuilderDelegate(
        (context, i) => Container(
          color: Colors.blue.shade100,
          child: Center(child: Text("Item $i")),
        ),
        childCount: 9,
      ),
    ),

    // 4. SliverList - List layout
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) => ListTile(title: Text("List Item $i")),
        childCount: 20,
      ),
    ),
  ],
)

// Custom SliverPersistentHeaderDelegate
class _Header extends SliverPersistentHeaderDelegate {
  final String title;

  @override
  Widget build(context, shrinkOffset, overlaps) {
    // shrinkOffset: How much header has shrunk
    // overlaps: Whether header overlaps content
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Text(title),
    );
  }

  @override
  double get maxExtent => 50;  // Max height
  @override
  double get minExtent => 50;  // Min height
  @override
  bool shouldRebuild(_) => false;
}
```

---

## 5. ATTENDANCE - OFFLINE FIRST ARCHITECTURE (12 phút) ⭐ QUAN TRỌNG NHẤT

### Mở màn hình Attendance
**Nói:** "Đây là feature quan trọng nhất - Offline First Architecture"

### Giải thích kiến trúc:
1. **Local Database (Drift/SQLite):**
   - Lưu dữ liệu offline
   - Hoạt động ngay cả khi không có internet

2. **Repository Pattern:**
   - Tách biệt data source (local vs remote)
   - Xử lý sync logic
   - Single source of truth

3. **State Management (BLoC/Cubit):**
   - Quản lý state của attendance
   - Xử lý network state
   - Reactive updates

### Demo:
1. **Check-in khi có internet:**
   - Click nút check-in (icon login)
   - Dữ liệu lưu local và sync lên server ngay
   - Icon cloud_done xuất hiện

2. **Check-in khi offline:**
   - Tắt internet (airplane mode)
   - Click check-in
   - Dữ liệu vẫn lưu local
   - Icon cloud_off xuất hiện
   - Network banner hiển thị "Offline"

3. **Sync khi online lại:**
   - Bật internet lại
   - Dữ liệu tự động sync (listen connectivity)
   - Icon chuyển thành cloud_done

**Technical Details - Architecture:**

```
┌─────────────────────────────────────┐
│ UI Layer (Widgets)                  │
│ - OfflineFirstArchitectureScreen    │
│ - NetworkBanner                     │
└──────────────┬──────────────────────┘
               │ BlocBuilder / context.read
               ↓
┌─────────────────────────────────────┐
│ State Management (BLoC/Cubit)       │
│ - AttendanceCubit                   │
│ - NetworkBloc                        │
└──────────────┬──────────────────────┘
               │
               ↓
┌─────────────────────────────────────┐
│ Repository (Business Logic)         │
│ - AttendanceRepository              │
│   - checkIn()                       │
│   - getToday()                      │
│   - sync()                          │
└──────────────┬──────────────────────┘
               │
       ┌───────┴────────┐
       ↓                ↓
┌──────────────┐  ┌──────────────┐
│ Local DB     │  │ Remote API   │
│ (Drift)      │  │ (HTTP)       │
│ - SQLite     │  │ - REST API   │
└──────────────┘  └──────────────┘
```

**1. Database Layer - Drift (SQLite):**

```dart
// attendance_drift_db.dart
import 'package:drift/drift.dart';

// 1. Define Table
class AttendanceTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get time => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {id};
}

// 2. Database class
@DriftDatabase(tables: [AttendanceTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // 3. CRUD operations
  Future<void> insertAttendance(AttendanceTableCompanion data) async {
    await into(attendanceTable).insert(data);
  }

  Future<List<AttendanceTableData>> getToday() async {
    final now = DateTime.now();
    return (select(attendanceTable)..where(
      (t) =>
          t.time.year.equals(now.year) &
          t.time.month.equals(now.month) &
          t.time.day.equals(now.day),
    )).get();
  }

  Future<List<AttendanceTableData>> getUnsynced() async {
    return (select(attendanceTable)
      ..where((t) => t.synced.equals(false))).get();
  }

  Future<void> markSynced(List<String> ids) async {
    await (update(attendanceTable)..where(
      (t) => t.id.isIn(ids),
    )).write(const AttendanceTableCompanion(synced: Value(true)));
  }
}

// 4. Database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'attendance.sqlite'));
    return NativeDatabase(file);
  });
}
```

**Key Technical Points - Drift:**
- ✅ **Type-safe**: Code generation từ table definition
- ✅ **SQLite**: Native database, fast và reliable
- ✅ **Stream queries**: Reactive updates với Stream
- ✅ **Migrations**: Schema versioning
- ✅ **Companion objects**: For inserts/updates
- ✅ **Query builder**: Type-safe queries

**2. Repository Layer:**

```dart
// attendance_repository.dart
class AttendanceRepository {
  final AppDatabase db;
  final RemoteApi remote;

  AttendanceRepository({required this.db, required this.remote});

  // 1. Check-in: Luôn lưu local trước
  Future<void> checkIn() async {
    final id = const Uuid().v4();  // Generate unique ID
    await db.insertAttendance(
      AttendanceTableCompanion(
        id: Value(id),
        time: Value(DateTime.now()),
        synced: Value(false),  // Chưa sync
      ),
    );
  }

  // 2. Get today's records
  Future<List<AttendanceTableData>> getToday() => db.getToday();

  // 3. Sync: Upload unsynced records
  Future<void> sync() async {
    final unsynced = await db.getUnsynced();
    if (unsynced.isEmpty) return;  // Nothing to sync

    // Upload to server
    await remote.upload(unsynced);
    
    // Mark as synced
    await db.markSynced(unsynced.map((e) => e.id).toList());
  }
}
```

**Key Technical Points - Repository:**
- ✅ **Single source of truth**: Repository quyết định lấy từ đâu
- ✅ **Always write local first**: Đảm bảo không mất dữ liệu
- ✅ **Sync strategy**: Upload unsynced, mark synced
- ✅ **Separation of concerns**: UI không biết local/remote

**3. State Management - Cubit:**

```dart
// attendance_cubit.dart
class AttendanceCubit extends Cubit<List<AttendanceTableData>> {
  AttendanceCubit(this.repo, {required Connectivity connectivity})
    : _connectivity = connectivity,
      super([]) {
    _init();
  }

  final AttendanceRepository repo;
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _isOnline = false;

  Future<void> _init() async {
    // 1. Check initial connectivity
    _isOnline = _hasConnection(await _connectivity.checkConnectivity());

    // 2. Sync nếu online
    if (_isOnline) {
      await repo.sync();
    }

    // 3. Load data
    await loadToday();

    // 4. Listen connectivity changes
    _connectivitySub = _connectivity.onConnectivityChanged.listen((results) async {
      final hasConnection = _hasConnection(results);
      final wentOnline = !_isOnline && hasConnection;
      _isOnline = hasConnection;

      // 5. Auto-sync khi online lại
      if (wentOnline) {
        await sync();
      }
    });
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any(
      (result) =>
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.ethernet,
    );
  }

  Future<void> loadToday() async {
    final list = await repo.getToday();
    emit(list);  // Emit state
  }

  Future<void> checkIn() async {
    // 1. Luôn lưu local trước
    await repo.checkIn();
    
    // 2. Sync ngay nếu online
    if (_isOnline) {
      await repo.sync();
    }
    
    // 3. Reload để update UI
    await loadToday();
  }

  Future<void> sync() async {
    await repo.sync();
    await loadToday();
  }

  @override
  Future<void> close() {
    _connectivitySub?.cancel();  // Cleanup
    return super.close();
  }
}
```

**Key Technical Points - Cubit:**
- ✅ **Cubit**: Simpler version của BLoC, dùng methods thay vì events
- ✅ **emit()**: Emit new state
- ✅ **Connectivity stream**: Listen network changes
- ✅ **Auto-sync**: Tự động sync khi online lại
- ✅ **Cleanup**: Cancel subscriptions trong close()

**4. Network Bloc:**

```dart
// network_bloc.dart
class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc({required this.connectivity})
    : super(NetworkState(connectivity: connectivity)) {
    on<NetworkStatusChanged>(_onStatusChanged);

    // Listen connectivity changes
    _subscription = connectivity.onConnectivityChanged.listen((result) {
      final isConnected = result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.ethernet) ||
          result.contains(ConnectivityResult.mobile);
      add(NetworkStatusChanged(isConnected));
    });
  }

  Future<void> _onStatusChanged(
    NetworkStatusChanged event,
    Emitter<NetworkState> emit,
  ) async {
    if (!event.isConnected) {
      emit(state.copyWith(
        status: NetworkStatus.disconnected,
        isShowBanner: true,
      ));
      return;
    }

    emit(state.copyWith(
      status: NetworkStatus.connected,
      isShowBanner: true,  // Show banner khi reconnect
    ));

    // Hide banner sau 3 giây
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(isShowBanner: false));
  }
}
```

**5. UI Layer:**

```dart
// offline_first_architecture_screen.dart
class OfflineFirstArchitectureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => context.read<AttendanceCubit>().checkIn(),
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      body: Column(
        children: [
          // Network banner
          const NetworkBanner(),
          
          // List
          Expanded(
            child: BlocBuilder<AttendanceCubit, List>(
              builder: (context, list) {
                if (list.isEmpty) {
                  return const Center(child: Text('No records'));
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return ListTile(
                      title: Text(item.time.toLocal().toString()),
                      trailing: Icon(
                        item.synced 
                            ? Icons.cloud_done   // Synced
                            : Icons.cloud_off,   // Not synced
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

**Key Technical Points - UI:**
- ✅ **BlocBuilder**: Rebuild khi state thay đổi
- ✅ **context.read()**: Access Cubit để call methods
- ✅ **Visual feedback**: Icons để show sync status
- ✅ **NetworkBanner**: Show network status

**Best Practices:**
1. ✅ **Always write local first** - Đảm bảo không mất dữ liệu
2. ✅ **Sync strategy** - Upload unsynced, mark synced
3. ✅ **Auto-sync** - Listen connectivity, sync khi online
4. ✅ **Repository pattern** - Tách biệt data source
5. ✅ **State management** - Reactive updates với BLoC/Cubit
6. ✅ **Error handling** - Handle network errors gracefully
7. ✅ **Cleanup** - Cancel subscriptions

**Kết luận:**
"Offline First Architecture đảm bảo app luôn hoạt động. Repository pattern tách biệt concerns. Drift cho type-safe database. BLoC/Cubit cho reactive state management."

---

## 6. CRASH ANALYTICS (5 phút)

### Mở màn hình Crash Analytics
**Nói:** "Firebase Crashlytics giúp theo dõi và fix bugs trong production"

### Demo các tính năng:

1. **Set User Info & Custom Keys:**
   - Click button
   - Giải thích: "Gắn thông tin user và custom keys để debug dễ hơn"
   - Khi crash xảy ra, có thể filter theo user

2. **Trigger Non-Fatal Error:**
   - Click button
   - Giải thích: "Ghi lại error không làm crash app"
   - Vẫn có thể xem trong Crashlytics dashboard

3. **Trigger Fatal Crash:**
   - ⚠️ Cảnh báo: "Button này sẽ crash app!"
   - Giải thích: "Fatal crash sẽ đóng app"
   - Crash được gửi lên Firebase
   - Có thể xem stack trace trong dashboard

**Key Technical Points:**
- ✅ **Firebase.initializeApp()**: Initialize Firebase trước khi dùng
- ✅ **FlutterError.onError**: Catch Flutter framework errors
- ✅ **PlatformDispatcher.onError**: Catch async errors (Future, Stream)
- ✅ **kDebugMode check**: Chỉ enable trong production
- ✅ **setUserIdentifier()**: Gắn user ID để filter crashes
- ✅ **setCustomKey()**: Custom key-value pairs để filter/debug
- ✅ **log()**: Log messages (không phải error)
- ✅ **recordError()**: Record non-fatal errors
- ✅ **crash()**: Force crash app (testing only)
- ✅ **Stack trace**: Tự động capture stack trace

**Crashlytics API:**
```dart
// User identification
FirebaseCrashlytics.instance.setUserIdentifier("user_123");

// Custom keys
FirebaseCrashlytics.instance.setCustomKey("key", "value");
FirebaseCrashlytics.instance.setCustomKey("number", 42);
FirebaseCrashlytics.instance.setCustomKey("bool", true);

// Logging
FirebaseCrashlytics.instance.log("User did something");

// Record errors
FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);

// Force crash (testing)
FirebaseCrashlytics.instance.crash();
```

**Best Practices:**
1. ✅ **Only in production**: Không enable trong debug mode
2. ✅ **Set user info**: Để filter crashes theo user
3. ✅ **Custom keys**: Thêm context (screen, action, etc.)
4. ✅ **Log important events**: Track user actions
5. ✅ **Non-fatal errors**: Record errors không crash app
6. ✅ **Test crashes**: Test với test devices

**Technical Details:**

```dart
// main.dart - Setup Crashlytics
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // 1. Chỉ enable trong production
  if (!kDebugMode) {
    // 2. Catch Flutter framework errors
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    
    // 3. Catch async errors (Future, Stream)
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;  // Prevent default error handling
    };
  }
  
  runApp(MyApp());
}

// crash_analytics_page.dart
class CrashDemoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. Set User Info & Custom Keys
          ElevatedButton(
            onPressed: () async {
              // Set user identifier
              await FirebaseCrashlytics.instance.setUserIdentifier("user_1");
              
              // Set custom keys (key-value pairs)
              await FirebaseCrashlytics.instance.setCustomKey(
                "debug_mode",
                true,
              );
              await FirebaseCrashlytics.instance.setCustomKey(
                "screen",
                "crashlytics-demo",
              );
              
              // Log message
              FirebaseCrashlytics.instance.log(
                "User info + custom keys added",
              );
            },
            child: const Text("Set User Info & Custom Keys"),
          ),
          
          // 2. Non-Fatal Error
          ElevatedButton(
            onPressed: () {
              FirebaseCrashlytics.instance.log(
                "User tapped record non-fatal error button",
              );
              
              try {
                throw Exception("This is a non-fatal crash example");
              } catch (e, s) {
                // Record error nhưng không crash app
                FirebaseCrashlytics.instance.recordError(e, s);
              }
            },
            child: const Text("Trigger Non-Fatal Error"),
          ),
          
          // 3. Fatal Crash
          ElevatedButton(
            onPressed: () {
              FirebaseCrashlytics.instance.log(
                "User triggered a fatal crash",
              );
              FirebaseCrashlytics.instance.setCustomKey(
                "screen",
                "crashlytics-demo",
              );
              
              // Option 1: Throw exception (sẽ crash)
              // throw StateError("This is a *fatal* crash example");
              
              // Option 2: Force crash
              FirebaseCrashlytics.instance.crash();
            },
            child: const Text("Trigger Fatal Crash (App will close)"),
          ),
        ],
      ),
    );
  }
}
```


**Kết luận:**
"Firebase Crashlytics cung cấp stack trace đầy đủ, custom keys để filter, user identification. Essential cho production monitoring."

---

## 7. HOME WIDGET (3 phút)

### Giải thích Home Widget
**Nói:** "Home Widget cho phép hiển thị thông tin trên màn hình chính"

### Tính năng:
- Widget trên home screen (Android/iOS)
- Hiển thị thông tin nhanh không cần mở app
- Ví dụ: Calendar widget, weather widget, attendance widget

**Technical Details:**

```dart
// home_widget.dart
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

class CalendarWidgetService {
  Future<void> updateCalendarWidget() async {
    final now = DateTime.now();

    // 1. Format data
    final day = DateFormat('dd').format(now);
    final weekday = DateFormat('EEEE').format(now); // Monday, Tuesday…
    final month = DateFormat('MMMM').format(now); // January…

    // 2. Save data to shared storage
    await HomeWidget.saveWidgetData<String>('day', day);
    await HomeWidget.saveWidgetData<String>('weekday', weekday);
    await HomeWidget.saveWidgetData<String>('month', month);

    // 3. Update widget (triggers native widget update)
    await HomeWidget.updateWidget(
      qualifiedAndroidName: 
          'com.example.flutter_training_2025_11_05.CalendarWidgetProvider',
    );
  }
}

// main.dart - Update widget on app start
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await CalendarWidgetService().updateCalendarWidget();
  }
  // ...
}
```

**Key Technical Points:**
- ✅ **home_widget package**: Package để update native widgets
- ✅ **saveWidgetData()**: Save data to shared storage (UserDefaults/SharedPreferences)
- ✅ **updateWidget()**: Trigger native widget update
- ✅ **qualifiedAndroidName**: Android widget provider class name
- ✅ **Native implementation**: Cần implement native code (Android/iOS)
- ✅ **Data types**: String, int, bool, double supported

**Android Implementation (Kotlin):**
```kotlin
// CalendarWidgetProvider.kt
class CalendarWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // Read data from SharedPreferences
        val prefs = context.getSharedPreferences("HomeWidget", Context.MODE_PRIVATE)
        val day = prefs.getString("day", "")
        val weekday = prefs.getString("weekday", "")
        val month = prefs.getString("month", "")
        
        // Update widget UI
        // ...
    }
}
```

**iOS Implementation (Swift):**
```swift
// CalendarWidget.swift
struct CalendarWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "CalendarWidget") { entry in
            CalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Calendar")
        .description("Shows current date")
    }
}
```

**Use Cases:**
- Calendar widget
- Weather widget
- Attendance widget
- Task/Reminder widget
- Stats widget

**Điểm chính:**
- ✅ Tăng engagement với user
- ✅ Hiển thị thông tin quan trọng
- ✅ Native widget trên home screen
- ✅ Update từ Flutter app
- ✅ Cần native code implementation

**Kết luận:**
"Home Widget giúp app có mặt trên home screen, tăng khả năng user quay lại sử dụng app. Cần implement native code cho Android/iOS."

---

## 8. DEBUG SUPERPOWERS (5 phút)

### Mở màn hình Debug Superpowers
**Nói:** "Debug tools giúp chúng ta phát triển và tối ưu hiệu năng"

### Demo:
- Scroll qua danh sách posts
- Giải thích: "Đây là demo về performance optimization"
- Chỉ ra các kỹ thuật:
  - Image optimization với device pixel ratio
  - Lazy loading
  - Efficient widget rebuilds
  - Scroll performance

**Technical Details:**

```dart
// debug_page.dart
class DebugScreen extends StatefulWidget {
  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  late final ScrollController _scrollController;
  final DebugMockApi _api = const DebugMockApi();
  late final Future<List<int>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _itemsFuture = _api.fetchItems();  // Load data
  }

  void _scrollListener() {
    setState(() {
      _showScrollingToTopButton = _scrollController.offset > 100;
    });
  }

  // 1. Image URL optimization với device pixel ratio
  String getImageUrl({required BuildContext context, required int index}) {
    final deviceWidth = MediaQuery.sizeOf(context).width;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final realWidth = (deviceWidth * dpr).round();
    
    // Request image với size phù hợp với device
    return 'https://picsum.photos/seed/$index/$realWidth';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<int>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const UltraOptimizedShimmer();  // Loading state
          }

          final items = snapshot.data ?? const <int>[];

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: items.map((e) => FacebookSingleImagePost(
                avatarUrl: getAvatarUrl(index: e),
                userName: "Ragnar Lothbrok",
                timeAgo: "1 hours ago",
                caption: "beautiful day $e",
                imageUrl: getImageUrl(context: context, index: e),
                likeCount: 120,
                commentCount: 30,
                shareCount: 8,
              )).toList(),
            ),
          );
        },
      ),
      floatingActionButton: _showScrollingToTopButton
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(
                  0.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
              child: const Icon(Icons.arrow_upward),
            )
          : const SizedBox.shrink(),
    );
  }
}
```

**Key Technical Points:**

**1. Image Optimization:**
```dart
// Device Pixel Ratio (DPR) optimization
final deviceWidth = MediaQuery.sizeOf(context).width;
final dpr = MediaQuery.devicePixelRatioOf(context);
final realWidth = (deviceWidth * dpr).round();

// Request image với size phù hợp
// iPhone 14 Pro: 393px width * 3 DPR = 1179px
// Request 1200px image thay vì 4000px → Tiết kiệm bandwidth
return 'https://picsum.photos/seed/$index/$realWidth';
```

**2. Performance Optimization Techniques:**
- ✅ **Device Pixel Ratio**: Request image size phù hợp với screen
- ✅ **Lazy loading**: Chỉ load images khi visible
- ✅ **FutureBuilder**: Async data loading
- ✅ **ScrollController**: Efficient scroll handling
- ✅ **Conditional rendering**: Chỉ render khi cần
- ✅ **const constructors**: Reduce rebuilds

**3. Flutter DevTools:**
```dart
// Enable performance overlay trong main.dart
MaterialApp(
  showPerformanceOverlay: true,  // Show FPS overlay
  // ...
)
```

**DevTools Features:**
- **Performance**: Profile app performance
- **Memory**: Track memory usage
- **Network**: Monitor network requests
- **Widget Inspector**: Inspect widget tree
- **Timeline**: View frame rendering

**4. Debug vs Release Mode:**
```dart
// Debug mode
if (kDebugMode) {
  print("Debug info");
  // Enable debug features
}

// Release mode
if (kReleaseMode) {
  // Production code
  FirebaseCrashlytics.instance.recordError(...);
}
```

**Performance Best Practices:**
1. ✅ **Image optimization**: Request size phù hợp với DPR
2. ✅ **Lazy loading**: Chỉ load khi cần
3. ✅ **const widgets**: Reduce rebuilds
4. ✅ **Efficient rebuilds**: Chỉ rebuild phần cần thiết
5. ✅ **ListView.builder**: Lazy list rendering
6. ✅ **Avoid setState in build**: Prevent rebuild loops
7. ✅ **Use keys**: Optimize widget updates

**Kết luận:**
"Performance optimization quan trọng cho UX. Image optimization với DPR tiết kiệm bandwidth. DevTools để profile và debug. Best practices để app mượt mà."

---

## TỔNG KẾT (5 phút)

### Các điểm chính đã học:

1. **Animation:**
   - **Implicit**: AnimatedContainer, TweenAnimationBuilder - Dễ dùng
   - **Explicit**: AnimationController, Tween, AnimatedBuilder - Kiểm soát chi tiết
   - **AnimatedList**: Animate list insert/remove

2. **Custom Drawing:**
   - **CustomPainter**: Canvas API (drawCircle, drawOval, drawPath)
   - **Draggable/DragTarget**: Drag & drop interactions
   - **ReorderableListView**: Built-in reorder list

3. **Rich Text Editor:**
   - **flutter_quill**: Delta format (operational transform)
   - **QuillController**: Quản lý document
   - **JSON serialization**: Save/load documents

4. **Sliver Layout:**
   - **CustomScrollView**: Container cho slivers
   - **SliverAppBar**: Collapsible app bar
   - **SliverList/SliverGrid**: Lazy loading lists
   - **Performance**: Chỉ build widgets khi visible

5. **Debug & Performance:**
   - **Device Pixel Ratio**: Image optimization
   - **Flutter DevTools**: Profile app
   - **Performance overlay**: FPS monitoring
   - **Best practices**: const widgets, efficient rebuilds

6. **Offline First Architecture:** ⭐ QUAN TRỌNG NHẤT
   - **Repository Pattern**: Tách biệt data source
   - **Drift (SQLite)**: Type-safe local database
   - **BLoC/Cubit**: Reactive state management
   - **Auto-sync**: Listen connectivity, sync khi online
   - **Always write local first**: Đảm bảo không mất dữ liệu

7. **Crash Analytics:**
   - **Firebase Crashlytics**: Production monitoring
   - **Stack trace**: Tự động capture
   - **Custom keys**: Filter và debug
   - **User identification**: Track crashes theo user

8. **Home Widget:**
   - **home_widget package**: Update native widgets
   - **Shared storage**: UserDefaults/SharedPreferences
   - **Native implementation**: Cần Android/iOS code

### Technical Stack Summary:

**Packages chính:**
```yaml
dependencies:
  # State Management
  flutter_bloc: ^8.1.3
  
  # Local Database
  drift: ^2.14.0
  
  # Rich Text Editor
  flutter_quill: ^10.0.0
  
  # Firebase
  firebase_core: ^2.24.0
  firebase_crashlytics: ^3.4.9
  
  # Network
  connectivity_plus: ^5.0.2
  
  # Home Widget
  home_widget: ^0.5.1
```

### Architecture Patterns:

**1. Repository Pattern:**
```
Repository
  ├── Local Data Source (Drift)
  └── Remote Data Source (API)
```

**2. BLoC/Cubit Pattern:**
```
Event/Method → Bloc/Cubit → State → UI
```

**3. Offline First:**
```
Write Local First → Sync When Online
```

### Best Practices:

✅ **State Management:** 
- BLoC/Cubit pattern cho complex state
- Provider/Consumer cho simple state

✅ **Architecture:** 
- Repository pattern - separation of concerns
- Single source of truth
- Dependency injection

✅ **Local Storage:** 
- Drift (SQLite) cho structured data
- SharedPreferences cho simple key-value
- Hive cho NoSQL

✅ **Error Handling:** 
- Firebase Crashlytics cho production
- Try-catch cho expected errors
- Error boundaries cho unexpected errors

✅ **Performance:** 
- Lazy loading (ListView.builder, SliverList)
- Image optimization với DPR
- const widgets để reduce rebuilds
- Efficient rebuilds với keys

✅ **UX:** 
- Animation cho smooth transitions
- Loading states
- Error states
- Empty states

### Code Quality:

✅ **Type Safety:** 
- Strong typing với Dart
- Code generation với Drift
- Null safety

✅ **Testing:**
- Unit tests cho business logic
- Widget tests cho UI
- Integration tests cho flows

✅ **Documentation:**
- Code comments
- README files
- API documentation

### Câu hỏi & Thảo luận

**Q: Khi nào dùng Implicit vs Explicit animation?**
A: Implicit cho animation đơn giản (size, color, position). Explicit khi cần control (pause, reverse, complex sequences).

**Q: Làm sao implement offline-first?**
A: Repository pattern với local DB (Drift). Always write local first. Auto-sync khi online với connectivity listener.

**Q: Drift vs Hive vs SharedPreferences?**
A: Drift cho structured data (SQL). Hive cho NoSQL. SharedPreferences cho simple key-value.

**Q: BLoC vs Cubit?**
A: BLoC cho complex với events. Cubit đơn giản hơn với methods. Cubit đủ cho hầu hết use cases.

**Q: Làm sao optimize performance?**
A: Lazy loading, image optimization với DPR, const widgets, efficient rebuilds, profile với DevTools.

---

## PHỤ LỤC: Hướng dẫn Demo

### Chuẩn bị trước khi demo:

1. **Kiểm tra kết nối:**
   - Internet connection cho Attendance sync
   - Firebase project setup cho Crashlytics

2. **Test các tính năng:**
   - Animation hoạt động mượt
   - Offline mode (airplane mode)
   - Crashlytics có thể trigger

3. **Chuẩn bị câu hỏi thường gặp:**
   - "Làm sao implement offline-first?"
   - "Khi nào dùng implicit vs explicit animation?"
   - "Làm sao optimize performance?"
   - "Setup Crashlytics như thế nào?"

### Tips khi demo:

- ✅ Demo từ đơn giản đến phức tạp
- ✅ Giải thích "tại sao" chứ không chỉ "làm sao"
- ✅ Chỉ ra code examples khi cần
- ✅ So sánh với các approach khác
- ✅ Nhấn mạnh best practices

### Thời gian đề xuất:

- Tổng: ~35-40 phút
- Q&A: 10-15 phút
- **Tổng cộng: 45-55 phút**

---

## NOTES CHO NGƯỜI DEMO

### Điểm nhấn quan trọng:

1. **Offline First Architecture** là feature quan trọng nhất - dành nhiều thời gian giải thích
2. **Animation** - dễ hiểu, demo trước để tạo hứng thú
3. **Crashlytics** - quan trọng cho production, nhưng ít người biết
4. **Sliver** - advanced topic, giải thích khi nào cần dùng

### Code locations:

- Animation: `lib/animation/`
- Painting: `lib/painting_and_custom_drawing/`
- Rich Text: `lib/rich_text_editor/`
- Sliver: `lib/custom_layout/`
- Debug: `lib/debug/`
- Offline First: `lib/offline_first_architecture/`
- Crashlytics: `lib/crash_analytics/`
- Home Widget: `lib/home_widget/`

### Các package chính:

- `flutter_bloc` - State management
- `drift` - Local database
- `flutter_quill` - Rich text editor
- `firebase_crashlytics` - Crash reporting
- `home_widget` - Home screen widget
- `connectivity_plus` - Network status

---

**Chúc bạn demo thành công! 🚀**

