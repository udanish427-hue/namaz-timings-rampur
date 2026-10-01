import '../database.dart';

class SliderPhotosTable extends SupabaseTable<SliderPhotosRow> {
  @override
  String get tableName => 'slider_photos';

  @override
  SliderPhotosRow createRow(Map<String, dynamic> data) => SliderPhotosRow(data);
}

class SliderPhotosRow extends SupabaseDataRow {
  SliderPhotosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SliderPhotosTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  String get photoUrl => getField<String>('photo_url')!;
  set photoUrl(String value) => setField<String>('photo_url', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
