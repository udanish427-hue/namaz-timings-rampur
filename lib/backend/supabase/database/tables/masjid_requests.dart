import '../database.dart';

class MasjidRequestsTable extends SupabaseTable<MasjidRequestsRow> {
  @override
  String get tableName => 'masjid_requests';

  @override
  MasjidRequestsRow createRow(Map<String, dynamic> data) =>
      MasjidRequestsRow(data);
}

class MasjidRequestsRow extends SupabaseDataRow {
  MasjidRequestsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MasjidRequestsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get email => getField<String>('email')!;
  set email(String value) => setField<String>('email', value);

  String get phone => getField<String>('phone')!;
  set phone(String value) => setField<String>('phone', value);

  String get masjidName => getField<String>('masjid_name')!;
  set masjidName(String value) => setField<String>('masjid_name', value);

  String get address => getField<String>('address')!;
  set address(String value) => setField<String>('address', value);
}
