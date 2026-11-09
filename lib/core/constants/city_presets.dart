class CityPreset {
  final String name;
  final String province;
  final double latitude;
  final double longitude;
  final double timezone;

  const CityPreset({
    required this.name,
    required this.province,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });
}

class CityPresets {
  CityPresets._();

  static const List<CityPreset> cities = [
    CityPreset(
      name: 'Jakarta',
      province: 'DKI Jakarta',
      latitude: -6.2088,
      longitude: 106.8456,
      timezone: 7.0,
    ),
    CityPreset(
      name: 'Indramayu',
      province: 'Jawa Barat',
      latitude: -6.3275,
      longitude: 108.3249,
      timezone: 7.0,
    ),
    CityPreset(
      name: 'Bandung',
      province: 'Jawa Barat',
      latitude: -6.9175,
      longitude: 107.6191,
      timezone: 7.0,
    ),
    CityPreset(
      name: 'Surabaya',
      province: 'Jawa Timur',
      latitude: -7.2575,
      longitude: 112.7521,
      timezone: 7.0,
    ),
    CityPreset(
      name: 'Semarang',
      province: 'Jawa Tengah',
      latitude: -6.9667,
      longitude: 110.4167,
      timezone: 7.0,
    ),
    CityPreset(
      name: 'Yogyakarta',
      province: 'DI Yogyakarta',
      latitude: -7.7956,
      longitude: 110.3695,
      timezone: 7.0,
    ),
    CityPreset(
      name: 'Medan',
      province: 'Sumatera Utara',
      latitude: 3.5952,
      longitude: 98.6722,
      timezone: 7.0,
    ),
    CityPreset(
      name: 'Palembang',
      province: 'Sumatera Selatan',
      latitude: -2.9909,
      longitude: 104.7565,
      timezone: 7.0,
    ),
    CityPreset(
      name: 'Padang',
      province: 'Sumatera Barat',
      latitude: -0.9471,
      longitude: 100.4172,
      timezone: 7.0,
    ),
    CityPreset(
      name: 'Banda Aceh',
      province: 'Aceh',
      latitude: 5.5483,
      longitude: 95.3238,
      timezone: 7.0,
    ),
    CityPreset(
      name: 'Makassar',
      province: 'Sulawesi Selatan',
      latitude: -5.1477,
      longitude: 119.4327,
      timezone: 8.0,
    ),
    CityPreset(
      name: 'Denpasar',
      province: 'Bali',
      latitude: -8.6705,
      longitude: 115.2126,
      timezone: 8.0,
    ),
    CityPreset(
      name: 'Banjarmasin',
      province: 'Kalimantan Selatan',
      latitude: -3.3194,
      longitude: 114.5908,
      timezone: 8.0,
    ),
    CityPreset(
      name: 'Balikpapan',
      province: 'Kalimantan Timur',
      latitude: -1.2379,
      longitude: 116.8529,
      timezone: 8.0,
    ),
    CityPreset(
      name: 'Pontianak',
      province: 'Kalimantan Barat',
      latitude: -0.0263,
      longitude: 109.3425,
      timezone: 7.0,
    ),
    CityPreset(
      name: 'Manado',
      province: 'Sulawesi Utara',
      latitude: 1.4748,
      longitude: 124.8428,
      timezone: 8.0,
    ),
    CityPreset(
      name: 'Mataram',
      province: 'Nusa Tenggara Barat',
      latitude: -8.5769,
      longitude: 116.1009,
      timezone: 8.0,
    ),
    CityPreset(
      name: 'Kupang',
      province: 'Nusa Tenggara Timur',
      latitude: -10.1772,
      longitude: 123.6070,
      timezone: 8.0,
    ),
    CityPreset(
      name: 'Ambon',
      province: 'Maluku',
      latitude: -3.6547,
      longitude: 128.1906,
      timezone: 9.0,
    ),
    CityPreset(
      name: 'Jayapura',
      province: 'Papua',
      latitude: -2.5916,
      longitude: 140.6690,
      timezone: 9.0,
    ),
  ];
}
