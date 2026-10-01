import '../database.dart';

class MosquesTable extends SupabaseTable<MosquesRow> {
  @override
  String get tableName => 'mosques';

  @override
  MosquesRow createRow(Map<String, dynamic> data) => MosquesRow(data);
}

class MosquesRow extends SupabaseDataRow {
  MosquesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MosquesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get area => getField<String>('area');
  set area(String? value) => setField<String>('area', value);

  String? get fajr => getField<String>('fajr');
  set fajr(String? value) => setField<String>('fajr', value);

  String? get dhuhr => getField<String>('dhuhr');
  set dhuhr(String? value) => setField<String>('dhuhr', value);

  String? get asr => getField<String>('asr');
  set asr(String? value) => setField<String>('asr', value);

  String? get maghrib => getField<String>('maghrib');
  set maghrib(String? value) => setField<String>('maghrib', value);

  String? get isha => getField<String>('isha');
  set isha(String? value) => setField<String>('isha', value);

  String? get jummah => getField<String>('jummah');
  set jummah(String? value) => setField<String>('jummah', value);

  DateTime? get lastUpdated => getField<DateTime>('last_updated');
  set lastUpdated(DateTime? value) => setField<DateTime>('last_updated', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get address => getField<String>('address');
  set address(String? value) => setField<String>('address', value);

  String? get phoneNumber => getField<String>('phone_number');
  set phoneNumber(String? value) => setField<String>('phone_number', value);

  String? get mutawalliName => getField<String>('mutawalli_name');
  set mutawalliName(String? value) => setField<String>('mutawalli_name', value);

  String? get googleMapsLink => getField<String>('google_maps_link');
  set googleMapsLink(String? value) =>
      setField<String>('google_maps_link', value);

  List<String> get photos => getListField<String>('photos');
  set photos(List<String>? value) => setListField<String>('photos', value);

  String? get imamName => getField<String>('imamName');
  set imamName(String? value) => setField<String>('imamName', value);
}
