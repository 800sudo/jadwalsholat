import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/indonesia_cities_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_image_helper.dart';
import '../../../../core/utils/audio/beep_sound_helper.dart';
import '../../../../core/utils/local_file_picker_helper.dart';
import '../../../prayer/domain/entities/prayer_schedule.dart';
import '../../domain/entities/app_settings.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';

class SettingsDialog extends StatefulWidget {
  final AppSettings currentSettings;
  final ValueChanged<TVDisplayMode>? onPreviewMode;

  const SettingsDialog({
    super.key,
    required this.currentSettings,
    this.onPreviewMode,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _runningTextController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _citySearchController;
  late double _selectedTimezone;
  late int _selectedIhtiyat;
  late int _selectedSubuhIqomah;
  late int _selectedDzuhurIqomah;
  late int _selectedAsharIqomah;
  late int _selectedMaghribIqomah;
  late int _selectedIsyaIqomah;
  late int _selectedHijriAdj;
  late int _selectedFridayKhutbahMinutes;
  late bool _disableFridayIqomah;
  late bool _enableBeepSound;
  late final TextEditingController _fridayKhotibController;
  late final TextEditingController _fridayImamController;
  late final TextEditingController _fridayMuadzinController;
  late final TextEditingController _fridayBilalController;
  late List<Map<String, String>> _editableSlides;
  String _cityName = '';
  String _selectedProvinceFilter = 'Semua Provinsi';
  List<IndonesiaCity> _searchedCities = [];
  bool _isSearchingCity = false;

  @override
  void initState() {
    super.initState();
    final s = widget.currentSettings;
    _nameController = TextEditingController(text: s.mosqueName);
    _addressController = TextEditingController(text: s.mosqueAddress);
    _runningTextController = TextEditingController(text: s.runningText);
    _latitudeController = TextEditingController(text: s.latitude.toString());
    _longitudeController = TextEditingController(text: s.longitude.toString());
    _citySearchController = TextEditingController();
    _selectedFridayKhutbahMinutes = s.fridayKhutbahMinutes;
    _disableFridayIqomah = s.disableFridayIqomah;
    _enableBeepSound = s.enableBeepSound;
    _fridayKhotibController = TextEditingController(text: s.fridayKhotib);
    _fridayImamController = TextEditingController(text: s.fridayImam);
    _fridayMuadzinController = TextEditingController(text: s.fridayMuadzin);
    _fridayBilalController = TextEditingController(text: s.fridayBilal);
    _cityName = s.cityName;
    _selectedTimezone = s.timezone;
    _selectedIhtiyat = s.ihtiyatMinutes;
    _selectedSubuhIqomah = s.iqomahSubuhMinutes;
    _selectedDzuhurIqomah = s.iqomahDzuhurMinutes;
    _selectedAsharIqomah = s.iqomahAsharMinutes;
    _selectedMaghribIqomah = s.iqomahMaghribMinutes;
    _selectedIsyaIqomah = s.iqomahIsyaMinutes;
    _selectedHijriAdj = s.hijriAdjustmentDays;
    _editableSlides =
        (s.slides.isNotEmpty ? s.slides : AppConstants.defaultSlides)
            .map((slide) => Map<String, String>.from(slide))
            .toList();
    _searchedCities = IndonesiaCitiesData.searchCities('Indramayu');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _runningTextController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _citySearchController.dispose();
    _fridayKhotibController.dispose();
    _fridayImamController.dispose();
    _fridayMuadzinController.dispose();
    _fridayBilalController.dispose();
    super.dispose();
  }

  void _onCitySearchChanged(String query) {
    setState(() {
      _searchedCities = IndonesiaCitiesData.searchCities(
        query,
        provinceFilter: _selectedProvinceFilter,
      );
      _isSearchingCity = true;
    });
  }

  void _onProvinceFilterChanged(String? newProvince) {
    if (newProvince == null) return;
    setState(() {
      _selectedProvinceFilter = newProvince;
      _searchedCities = IndonesiaCitiesData.searchCities(
        _citySearchController.text,
        provinceFilter: _selectedProvinceFilter,
      );
      _isSearchingCity = true;
    });
  }

  void _selectCity(IndonesiaCity city) {
    setState(() {
      _cityName = city.shortName;
      _latitudeController.text = city.latitude.toString();
      _longitudeController.text = city.longitude.toString();
      _selectedTimezone = city.timezone;
      _citySearchController.text = '${city.type} ${city.name}';
      _isSearchingCity = false;
    });
    FocusScope.of(context).unfocus();
  }

  void _addNewSlide() {
    setState(() {
      _editableSlides.add({
        'title': 'Pengumuman Baru',
        'subtitle': 'Tuliskan isi hadits atau maklumat masjid di sini.',
        'badge': 'INFO MASJID',
        'imageUrl': 'assets/images/masjid_nabawi.png',
        'imageFit': 'fill',
      });
    });
  }

  void _removeSlide(int index) {
    if (_editableSlides.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimal harus ada 1 slide informasi.')),
      );
      return;
    }
    setState(() {
      _editableSlides.removeAt(index);
    });
  }

  void _resetSlidesToDefault() {
    setState(() {
      _editableSlides = AppConstants.defaultSlides
          .map((slide) => Map<String, String>.from(slide))
          .toList();
    });
  }

  void _showEditSlideDialog(int index) {
    final slide = _editableSlides[index];
    final titleCtrl = TextEditingController(text: slide['title'] ?? '');
    final subtitleCtrl = TextEditingController(text: slide['subtitle'] ?? '');
    final badgeCtrl = TextEditingController(
      text: slide['badge'] ?? 'INFO MASJID',
    );
    final imageCtrl = TextEditingController(text: slide['imageUrl'] ?? '');
    String currentImage = slide['imageUrl'] ?? '';
    String currentFit = slide['imageFit'] ?? 'fill';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final hasImage = currentImage.trim().isNotEmpty;
          BoxFit previewFit = BoxFit.fill;
          if (currentFit == 'contain') previewFit = BoxFit.contain;
          if (currentFit == 'cover') previewFit = BoxFit.cover;

          return AlertDialog(
            backgroundColor: AppColors.surfaceCard,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.goldPrimary, width: 1.2),
            ),
            title: Row(
              children: [
                const Icon(Icons.edit_note, color: AppColors.goldPrimary),
                const SizedBox(width: 8),
                Text(
                  'Edit Slide #${index + 1}',
                  style: const TextStyle(
                    color: AppColors.goldLight,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 540,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: badgeCtrl,
                      label: 'Kategori / Badge (Contoh: HADITS, AGENDA)',
                      icon: Icons.label,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: titleCtrl,
                      label:
                          'Judul Slide (Bisa Dikosongkan jika Gambar Poster)',
                      icon: Icons.title,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: subtitleCtrl,
                      label: 'Isi Pesan / Hadits (Bisa Dikosongkan jika Gambar Poster)',
                      icon: Icons.notes,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Opsi Input Gambar (Lokal atau URL)
                    const Text(
                      'Pilihan Gambar Latar (Flashdisk / Lokal / URL):',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldLight,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Preview Gambar jika ada
                    if (hasImage) ...[
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.bgDarkStart,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.goldPrimary),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            AppImageHelper.buildImage(
                              imageSource: currentImage,
                              fit: previewFit,
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: IconButton.filled(
                                icon: const Icon(Icons.close, size: 16),
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.alertRed,
                                ),
                                tooltip: 'Hapus Gambar',
                                onPressed: () {
                                  setDialogState(() {
                                    currentImage = '';
                                    imageCtrl.text = '';
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Mode Tampilan Gambar pada Kotak Layout
                    const Text(
                      'Mode Tampilan Gambar pada Layout:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '🔲 Penuh Layout (Fill)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Pas penuh, tanpa terpotong',
                                    style: TextStyle(fontSize: 9),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            selected: currentFit == 'fill',
                            onSelected: (val) {
                              if (val) {
                                setDialogState(() => currentFit = 'fill');
                              }
                            },
                            selectedColor: AppColors.goldPrimary,
                            backgroundColor: AppColors.bgDarkStart,
                            labelStyle: TextStyle(
                              color: currentFit == 'fill'
                                  ? AppColors.textDark
                                  : AppColors.textLight,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '🖼️ Utuh (Contain)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '100% utuh + latar blur',
                                    style: TextStyle(fontSize: 9),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            selected: currentFit == 'contain',
                            onSelected: (val) {
                              if (val) {
                                setDialogState(() => currentFit = 'contain');
                              }
                            },
                            selectedColor: AppColors.goldPrimary,
                            backgroundColor: AppColors.bgDarkStart,
                            labelStyle: TextStyle(
                              color: currentFit == 'contain'
                                  ? AppColors.textDark
                                  : AppColors.textLight,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '🔍 Zoom (Cover)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    'Potong sisi / crop',
                                    style: TextStyle(fontSize: 9),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            selected: currentFit == 'cover',
                            onSelected: (val) {
                              if (val) {
                                setDialogState(() => currentFit = 'cover');
                              }
                            },
                            selectedColor: AppColors.goldPrimary,
                            backgroundColor: AppColors.bgDarkStart,
                            labelStyle: TextStyle(
                              color: currentFit == 'cover'
                                  ? AppColors.textDark
                                  : AppColors.textLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Tombol Upload dari Flashdisk / Lokal
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              try {
                                final base64Uri =
                                    await LocalFilePickerHelper.pickImageAsBase64();
                                if (base64Uri != null && base64Uri.isNotEmpty) {
                                  setDialogState(() {
                                    currentImage = base64Uri;
                                    imageCtrl.text = base64Uri;
                                  });
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Gagal memilih gambar: $e'),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.folder_open,
                              color: AppColors.textDark,
                              size: 18,
                            ),
                            label: const Text(
                              'Pilih dari Flashdisk / File Lokal',
                              style: TextStyle(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.goldLight,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Galeri Cepat Bawaan Masjid
                    const Text(
                      'Atau Pilih dari Galeri Foto Masjid Bawaan:',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children:
                          [
                            {
                              'label': '🕌 Masjid Nabawi',
                              'path': 'assets/images/masjid_nabawi.png',
                            },
                            {
                              'label': '🕋 Masjidil Haram',
                              'path': 'assets/images/masjidil_haram.png',
                            },
                            {
                              'label': '🕌 Baiturrahman',
                              'path': 'assets/images/masjid_baiturrahman.png',
                            },
                            {
                              'label': '✨ Kaligrafi Emas',
                              'path': 'assets/images/kaligrafi_emas.png',
                            },
                          ].map((preset) {
                            return ActionChip(
                              avatar: const Icon(
                                Icons.photo,
                                size: 14,
                                color: AppColors.goldPrimary,
                              ),
                              label: Text(
                                preset['label']!,
                                style: const TextStyle(fontSize: 11),
                              ),
                              backgroundColor: AppColors.bgDarkStart,
                              side: const BorderSide(
                                color: AppColors.surfaceCardBorder,
                              ),
                              onPressed: () {
                                setDialogState(() {
                                  currentImage = preset['path']!;
                                  imageCtrl.text = preset['path']!;
                                });
                              },
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 10),

                    // Atau Masukkan URL Web
                    _buildTextField(
                      controller: imageCtrl,
                      label: 'Atau Masukkan URL Gambar (https://...)',
                      icon: Icons.link,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text(
                  'Batal',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldPrimary,
                ),
                onPressed: () {
                  final finalImg = imageCtrl.text.trim().isNotEmpty
                      ? imageCtrl.text.trim()
                      : currentImage;

                  setState(() {
                    _editableSlides[index] = {
                      'title': titleCtrl.text.trim(),
                      'subtitle': subtitleCtrl.text.trim(),
                      'badge': badgeCtrl.text.trim(),
                      'imageUrl': finalImg,
                      'imageFit': currentFit,
                    };
                  });
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  'Simpan Slide',
                  style: TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _saveSettings() {
    final lat =
        double.tryParse(_latitudeController.text) ??
        widget.currentSettings.latitude;
    final lng =
        double.tryParse(_longitudeController.text) ??
        widget.currentSettings.longitude;

    final updated = widget.currentSettings.copyWith(
      mosqueName: _nameController.text.trim(),
      mosqueAddress: _addressController.text.trim(),
      cityName: _cityName,
      latitude: lat,
      longitude: lng,
      timezone: _selectedTimezone,
      ihtiyatMinutes: _selectedIhtiyat,
      runningText: _runningTextController.text.trim(),
      iqomahSubuhMinutes: _selectedSubuhIqomah,
      iqomahDzuhurMinutes: _selectedDzuhurIqomah,
      iqomahAsharMinutes: _selectedAsharIqomah,
      iqomahMaghribMinutes: _selectedMaghribIqomah,
      iqomahIsyaMinutes: _selectedIsyaIqomah,
      hijriAdjustmentDays: _selectedHijriAdj,
      slides: _editableSlides,
      fridayKhutbahMinutes: _selectedFridayKhutbahMinutes,
      disableFridayIqomah: _disableFridayIqomah,
      fridayKhotib: _fridayKhotibController.text.trim(),
      fridayImam: _fridayImamController.text.trim(),
      fridayMuadzin: _fridayMuadzinController.text.trim(),
      fridayBilal: _fridayBilalController.text.trim(),
      enableBeepSound: _enableBeepSound,
    );

    context.read<SettingsBloc>().add(UpdateSettingsEvent(updated));
    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.goldPrimary, width: 1.5),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 880, maxHeight: 680),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.tune, color: AppColors.goldPrimary, size: 28),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PENGATURAN JADWAL SHOLAT TV',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.goldLight,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Support Ke 089660626800',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.goldPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(color: AppColors.surfaceCardBorder, height: 24),

            // Form Body
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Identitas Masjid
                    _buildSectionHeader('Identitas Masjid'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _nameController,
                            label: 'Nama Masjid',
                            icon: Icons.mosque,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _addressController,
                            label: 'Alamat Singkat',
                            icon: Icons.location_on,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Lokasi & Hisab Astronomi Kemenag RI
                    _buildSectionHeader(
                      'Lokasi & Hisab Astronomi Kemenag RI (Seluruh Indonesia)',
                    ),
                    const SizedBox(height: 10),

                    // Card Lokasi Terpilih Saat Ini
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.emeraldDark.withAlpha(120),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.goldPrimary.withAlpha(160),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppColors.goldPrimary,
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Lokasi Terpilih Saat Ini:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _cityName.isNotEmpty
                                      ? _cityName
                                      : 'Indramayu (Jawa Barat)',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.goldLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.bgDarkStart,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.surfaceCardBorder,
                              ),
                            ),
                            child: Text(
                              _selectedTimezone == 9.0
                                  ? 'WIT (UTC+9)'
                                  : (_selectedTimezone == 8.0
                                        ? 'WITA (UTC+8)'
                                        : 'WIB (UTC+7)'),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.goldPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Baris Filter Provinsi & Kotak Pencarian Kota (Listbox)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filter Provinsi (Provinsi -> Kabupaten)
                        Expanded(
                          flex: 4,
                          child: _buildDropdown<String>(
                            label: 'Filter Provinsi (38 Provinsi)',
                            value: _selectedProvinceFilter,
                            items: [
                              const DropdownMenuItem(
                                value: 'Semua Provinsi',
                                child: Text('🇮🇩 Semua Provinsi'),
                              ),
                              ...IndonesiaCitiesData.allProvinces.map((prov) {
                                return DropdownMenuItem(
                                  value: prov,
                                  child: Text(
                                    prov,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }),
                            ],
                            onChanged: _onProvinceFilterChanged,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Input Box Pencarian (Ketik misal "IN" -> muncul Indramayu, Indragiri...)
                        Expanded(
                          flex: 6,
                          child: TextField(
                            controller: _citySearchController,
                            style: const TextStyle(
                              color: AppColors.textLight,
                              fontSize: 14,
                            ),
                            onChanged: _onCitySearchChanged,
                            onTap: () {
                              setState(() {
                                _isSearchingCity = true;
                                if (_searchedCities.isEmpty) {
                                  _searchedCities =
                                      IndonesiaCitiesData.searchCities(
                                        _citySearchController.text,
                                        provinceFilter: _selectedProvinceFilter,
                                      );
                                }
                              });
                            },
                            decoration: InputDecoration(
                              labelText:
                                  'Cari Kota / Kabupaten Seluruh Indonesia',
                              hintText: 'Ketik nama kota (misal: IN -> Indramayu, Indragiri...)',
                              hintStyle: TextStyle(
                                color: AppColors.textMuted.withAlpha(120),
                                fontSize: 12,
                              ),
                              labelStyle: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.goldPrimary,
                                size: 20,
                              ),
                              suffixIcon: _citySearchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 18),
                                      color: AppColors.textMuted,
                                      onPressed: () {
                                        _citySearchController.clear();
                                        _onCitySearchChanged('');
                                      },
                                    )
                                  : null,
                              filled: true,
                              fillColor: AppColors.bgDarkStart,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.surfaceCardBorder,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.goldPrimary,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // LISTBOX HASIL PENCARIAN (Bentuk Listbox Interaktif)
                    if (_isSearchingCity) ...[
                      Container(
                        constraints: const BoxConstraints(maxHeight: 220),
                        decoration: BoxDecoration(
                          color: AppColors.bgDarkStart,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.goldPrimary.withAlpha(180),
                            width: 1.2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _searchedCities.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: Text(
                                    'Tidak ditemukan kota/kabupaten yang sesuai.\nAnda dapat memasukkan koordinat manual di bawah.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                itemCount: _searchedCities.length,
                                separatorBuilder: (context, i) => const Divider(
                                  color: AppColors.surfaceCardBorder,
                                  height: 1,
                                ),
                                itemBuilder: (context, index) {
                                  final city = _searchedCities[index];
                                  final isCurrent =
                                      _cityName.toLowerCase() ==
                                          city.name.toLowerCase() ||
                                      _cityName.toLowerCase() ==
                                          city.shortName.toLowerCase();
                                  final tzLabel = city.timezone == 9.0
                                      ? 'WIT'
                                      : (city.timezone == 8.0 ? 'WITA' : 'WIB');

                                  return InkWell(
                                    onTap: () => _selectCity(city),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      color: isCurrent
                                          ? AppColors.goldPrimary.withAlpha(40)
                                          : Colors.transparent,
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: city.type == 'Kota'
                                                  ? AppColors.emeraldPrimary
                                                  : AppColors.bgDarkEnd,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: city.type == 'Kota'
                                                    ? AppColors.emeraldLight
                                                    : AppColors.textMuted,
                                                width: 0.8,
                                              ),
                                            ),
                                            child: Text(
                                              city.type == 'Kota'
                                                  ? 'KOTA'
                                                  : 'KAB',
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: city.type == 'Kota'
                                                    ? Colors.white
                                                    : AppColors.goldLight,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  city.name,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.textLight,
                                                  ),
                                                ),
                                                Text(
                                                  '${city.province} • $tzLabel • Lat: ${city.latitude}, Lng: ${city.longitude}',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: AppColors.textMuted,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Icon(
                                            Icons.touch_app,
                                            size: 16,
                                            color: AppColors.goldPrimary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Preset Kota Cepat (Indramayu Default di Posisi Pertama)
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children:
                          [
                            'Indramayu',
                            'Jakarta Pusat',
                            'Bandung',
                            'Surabaya',
                            'Semarang',
                            'Yogyakarta',
                            'Medan',
                            'Makassar',
                          ].map((cityName) {
                            final city = IndonesiaCitiesData.allCities
                                .firstWhere(
                                  (c) =>
                                      c.name.toLowerCase() ==
                                      cityName.toLowerCase(),
                                  orElse: () =>
                                      IndonesiaCitiesData.allCities.first,
                                );
                            final isSel = _cityName.toLowerCase().contains(
                              cityName.toLowerCase(),
                            );
                            return ActionChip(
                              avatar: isSel
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: AppColors.textDark,
                                    )
                                  : null,
                              label: Text(
                                cityName == 'Indramayu'
                                    ? '📍 Indramayu (Default)'
                                    : (cityName == 'Jakarta Pusat'
                                          ? 'Jakarta'
                                          : cityName),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSel
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSel
                                      ? AppColors.textDark
                                      : AppColors.textLight,
                                ),
                              ),
                              backgroundColor: isSel
                                  ? AppColors.goldPrimary
                                  : AppColors.bgDarkStart,
                              side: const BorderSide(
                                color: AppColors.surfaceCardBorder,
                              ),
                              onPressed: () => _selectCity(city),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 14),

                    // Custom Coordinates & Timezone
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _latitudeController,
                            label: 'Latitude (Lintang)',
                            icon: Icons.my_location,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _longitudeController,
                            label: 'Longitude (Bujur)',
                            icon: Icons.my_location,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                              signed: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdown<double>(
                            label: 'Zona Waktu',
                            value: _selectedTimezone,
                            items: const [
                              DropdownMenuItem(
                                value: 7.0,
                                child: Text('WIB (UTC+7)'),
                              ),
                              DropdownMenuItem(
                                value: 8.0,
                                child: Text('WITA (UTC+8)'),
                              ),
                              DropdownMenuItem(
                                value: 9.0,
                                child: Text('WIT (UTC+9)'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedTimezone = val);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdown<int>(
                            label: 'Koreksi Ihtiyat',
                            value: _selectedIhtiyat,
                            items: const [
                              DropdownMenuItem(
                                value: 1,
                                child: Text('+1 Menit'),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text('+2 Menit (Standar)'),
                              ),
                              DropdownMenuItem(
                                value: 3,
                                child: Text('+3 Menit'),
                              ),
                              DropdownMenuItem(
                                value: 4,
                                child: Text('+4 Menit'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedIhtiyat = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Jeda Waktu Iqomah (Menit)
                    _buildSectionHeader(
                      'Waktu Jeda Hitung Mundur Iqomah (Menit)',
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildIqomahCounter(
                            'Subuh',
                            _selectedSubuhIqomah,
                            (val) => setState(() => _selectedSubuhIqomah = val),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildIqomahCounter(
                            'Dzuhur',
                            _selectedDzuhurIqomah,
                            (val) =>
                                setState(() => _selectedDzuhurIqomah = val),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildIqomahCounter(
                            'Ashar',
                            _selectedAsharIqomah,
                            (val) => setState(() => _selectedAsharIqomah = val),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildIqomahCounter(
                            'Maghrib',
                            _selectedMaghribIqomah,
                            (val) =>
                                setState(() => _selectedMaghribIqomah = val),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildIqomahCounter(
                            'Isya\'',
                            _selectedIsyaIqomah,
                            (val) => setState(() => _selectedIsyaIqomah = val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Switch Suara Beep
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgDarkStart,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.surfaceCardBorder),
                      ),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        activeThumbColor: AppColors.goldPrimary,
                        title: const Text(
                          'Suara Beep Peringatan (Mau Adzan & Mau Sholat)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textLight,
                          ),
                        ),
                        subtitle: const Text(
                          'Membunyikan nada beep panjang (4x 2 detik + 1x penutup 4 detik) saat masuk waktu adzan dan saat iqomah habis. Khusus sholat Jum\'at otomatis dinonaktifkan.',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                        value: _enableBeepSound,
                        onChanged: (val) =>
                            setState(() => _enableBeepSound = val),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Pengaturan Khusus Hari Jum'at
                    _buildSectionHeader('Pengaturan Khusus Hari Jum\'at'),
                    const SizedBox(height: 10),
                    _buildFridaySettings(),
                    const SizedBox(height: 20),

                    // Running Text & Kalender Hijriyah
                    _buildSectionHeader(
                      'Teks Berjalan & Koreksi Kalender Hijriyah',
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _runningTextController,
                      label: 'Isi Pesan Teks Berjalan (Marquee Bawah)',
                      icon: Icons.subtitles,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          'Koreksi Kalender Hijriyah:',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 14),
                        ...[-1, 0, 1].map((adj) {
                          final isSel = _selectedHijriAdj == adj;
                          final label = adj == 0
                              ? 'Normal (0)'
                              : (adj > 0 ? '+$adj Hari' : '$adj Hari');
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(label),
                              selected: isSel,
                              onSelected: (_) =>
                                  setState(() => _selectedHijriAdj = adj),
                              selectedColor: AppColors.emeraldPrimary,
                              backgroundColor: AppColors.bgDarkStart,
                              labelStyle: TextStyle(
                                color: isSel
                                    ? AppColors.textLight
                                    : AppColors.textMuted,
                                fontWeight: isSel
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Pengaturan Gambar & Konten Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionHeader(
                          'Pengaturan Konten & Gambar Slider Poster',
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: _resetSlidesToDefault,
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text(
                                'Reset Default',
                                style: TextStyle(fontSize: 12),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: _addNewSlide,
                              icon: const Icon(
                                Icons.add,
                                size: 16,
                                color: AppColors.textDark,
                              ),
                              label: const Text(
                                'Tambah Slide',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.goldPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _editableSlides.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final slide = _editableSlides[index];
                        final hasImg =
                            slide['imageUrl'] != null &&
                            slide['imageUrl']!.isNotEmpty;

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.bgDarkStart,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.surfaceCardBorder,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.emeraldDark.withAlpha(140),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.goldLight,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.emeraldDark,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            slide['badge'] ?? 'INFO',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.goldLight,
                                            ),
                                          ),
                                        ),
                                        if (hasImg) ...[
                                          const SizedBox(width: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.image,
                                                size: 14,
                                                color: AppColors.goldPrimary,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                slide['imageFit'] == 'fill'
                                                    ? 'Gambar (Penuh Layout)'
                                                    : (slide['imageFit'] ==
                                                              'cover'
                                                          ? 'Gambar (Zoom/Cover)'
                                                          : 'Gambar (Utuh/Contain)'),
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors.goldLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      slide['title'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                    Text(
                                      slide['subtitle'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textMuted,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: AppColors.goldPrimary,
                                  size: 20,
                                ),
                                tooltip: 'Edit Konten & Gambar Slide',
                                onPressed: () => _showEditSlideDialog(index),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: AppColors.alertRed,
                                  size: 20,
                                ),
                                tooltip: 'Hapus Slide',
                                onPressed: () => _removeSlide(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Simulasi Layar Peringatan Full Screen
                    _buildSectionHeader(
                      'Simulasi & Uji Coba Tampilan Layar Penuh',
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Klik salah satu tombol di bawah untuk melihat simulasi tampilan penuh di layar TV Anda:',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textLight.withAlpha(200),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.onPreviewMode?.call(
                              TVDisplayMode.adzanAlert,
                            );
                          },
                          icon: const Icon(Icons.volume_up, size: 18),
                          label: const Text('🔔 Uji Layar Adzan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.alertOrange,
                            foregroundColor: AppColors.textDark,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.onPreviewMode?.call(
                              TVDisplayMode.iqomahCountdown,
                            );
                          },
                          icon: const Icon(Icons.hourglass_bottom, size: 18),
                          label: const Text('⏳ Uji Layar Iqomah'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.goldPrimary,
                            foregroundColor: AppColors.textDark,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.onPreviewMode?.call(
                              TVDisplayMode.prayingTime,
                            );
                          },
                          icon: const Icon(Icons.phonelink_erase, size: 18),
                          label: const Text('📵 Uji Layar Luruskan Shaf'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.emeraldPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.onPreviewMode?.call(TVDisplayMode.khutbah);
                          },
                          icon: const Icon(Icons.mosque, size: 18),
                          label: const Text('🕌 Uji Layar Khutbah Jum\'at'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F766E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            BeepSoundHelper.playTripleBeep();
                          },
                          icon: const Icon(Icons.volume_up, size: 18),
                          label: const Text('🔊 Uji Suara Beep (4x 2s + 1x 4s)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Divider(color: AppColors.surfaceCardBorder, height: 24),

            // Action Buttons & Support Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Support Contact Info
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.bgDarkStart,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.surfaceCardBorder),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.headset_mic_outlined,
                        size: 16,
                        color: AppColors.goldPrimary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Support Ke 089660626800',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.goldLight,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _saveSettings,
                      icon: const Icon(
                        Icons.check_circle,
                        color: AppColors.textDark,
                      ),
                      label: const Text(
                        'Simpan Pengaturan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.goldPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.goldPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.goldLight,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textLight, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.emeraldLight, size: 20),
        filled: true,
        fillColor: AppColors.bgDarkStart,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.surfaceCardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.goldPrimary,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        filled: true,
        fillColor: AppColors.bgDarkStart,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.surfaceCardBorder),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          dropdownColor: AppColors.bgDarkStart,
          style: const TextStyle(color: AppColors.textLight, fontSize: 13),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildFridaySettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgDarkStart,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.emeraldLight.withAlpha(60),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Switch Matikan Iqomah Jum'at
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.goldPrimary,
            title: const Text(
              'Ganti Iqomah dengan Layar Khutbah Jum\'at',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
            subtitle: const Text(
              'Jika aktif, waktu Dzuhur di hari Jum\'at akan langsung beralih ke mode Standby Khutbah (Layar Tenang & Matikan HP) tanpa hitung mundur iqomah biasa.',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
            value: _disableFridayIqomah,
            onChanged: (val) => setState(() => _disableFridayIqomah = val),
          ),
          const Divider(color: AppColors.surfaceCardBorder, height: 20),

          // Durasi Khutbah
          Row(
            children: [
              const Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Perkiraan Durasi Khutbah Jum\'at',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Durasi layar tenang khutbah sebelum masuk waktu sholat berjamaah',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _buildIqomahCounter(
                  'Durasi Khutbah',
                  _selectedFridayKhutbahMinutes,
                  (val) => setState(() => _selectedFridayKhutbahMinutes = val),
                  minValue: 10,
                  maxValue: 90,
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.surfaceCardBorder, height: 24),

          // Petugas Sholat Jum'at Pekan Ini
          const Row(
            children: [
              Icon(Icons.badge, color: AppColors.goldPrimary, size: 18),
              SizedBox(width: 8),
              Text(
                'Jadwal Petugas Sholat Jum\'at Pekan Ini',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.goldLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _fridayKhotibController,
                  label: 'Khotib Jum\'at',
                  icon: Icons.record_voice_over,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _fridayImamController,
                  label: 'Imam Jum\'at',
                  icon: Icons.person,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _fridayMuadzinController,
                  label: 'Muadzin',
                  icon: Icons.volume_up,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _fridayBilalController,
                  label: 'Bilal / Muraqqi',
                  icon: Icons.notifications_active,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIqomahCounter(
    String label,
    int value,
    ValueChanged<int> onChanged, {
    int minValue = 1,
    int maxValue = 30,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.bgDarkStart,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.surfaceCardBorder),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: value > minValue ? () => onChanged(value - 1) : null,
                child: const Icon(
                  Icons.remove_circle_outline,
                  size: 20,
                  color: AppColors.goldPrimary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '$value m',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.goldLight,
                  ),
                ),
              ),
              InkWell(
                onTap: value < maxValue ? () => onChanged(value + 1) : null,
                child: const Icon(
                  Icons.add_circle_outline,
                  size: 20,
                  color: AppColors.goldPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
