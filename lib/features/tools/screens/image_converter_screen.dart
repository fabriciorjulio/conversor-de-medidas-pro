import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import '../../../core/utils/file_saver.dart';

class ImageConverterScreen extends StatefulWidget {
  const ImageConverterScreen({super.key});

  @override
  State<ImageConverterScreen> createState() => _ImageConverterScreenState();
}

class _ImageConverterScreenState extends State<ImageConverterScreen> {
  Uint8List? _sourceBytes;
  String? _sourceName;
  String? _sourceFormat;
  String _outputFormat = 'PNG';
  Uint8List? _convertedBytes;
  bool _loading = false;

  final _formats = ['PNG', 'JPG', 'WEBP', 'BMP', 'GIF', 'TIFF'];

  static const _color = Color(0xFF7B1FA2);

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    final ext = file.extension?.toUpperCase() ?? '';
    setState(() {
      _sourceBytes = file.bytes;
      _sourceName = file.name;
      _sourceFormat = ext;
      _convertedBytes = null;
      if (ext == _outputFormat) {
        _outputFormat = _formats.firstWhere((f) => f != ext, orElse: () => 'PNG');
      }
    });
  }

  Future<void> _convert() async {
    if (_sourceBytes == null) return;
    setState(() => _loading = true);
    try {
      final decoded = img.decodeImage(_sourceBytes!);
      if (decoded == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Formato de imagem não suportado')),
          );
        }
        return;
      }
      Uint8List output;
      switch (_outputFormat) {
        case 'PNG':
          output = Uint8List.fromList(img.encodePng(decoded));
          break;
        case 'JPG':
          output = Uint8List.fromList(img.encodeJpg(decoded, quality: 92));
          break;
        case 'WEBP':
          // image package doesn't support webp encoding natively, use PNG fallback
          output = Uint8List.fromList(img.encodePng(decoded));
          break;
        case 'BMP':
          output = Uint8List.fromList(img.encodeBmp(decoded));
          break;
        case 'GIF':
          output = Uint8List.fromList(img.encodeGif(decoded));
          break;
        case 'TIFF':
          output = Uint8List.fromList(img.encodeTiff(decoded));
          break;
        default:
          output = Uint8List.fromList(img.encodePng(decoded));
      }
      setState(() => _convertedBytes = output);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _share() async {
    if (_convertedBytes == null) return;
    final baseName = _sourceName?.split('.').first ?? 'imagem';
    final ext = _outputFormat.toLowerCase();
    await saveAndShareFile(_convertedBytes!, '${baseName}_convertido.$ext', 'Convertido com Converte Tudo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: Text('Conversor de Imagens', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        backgroundColor: _color,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Pick image card
            _Card(
              child: Column(
                children: [
                  if (_sourceBytes != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(_sourceBytes!, height: 200, fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$_sourceName ($_sourceFormat)',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
                    ),
                    Text(
                      '${(_sourceBytes!.length / 1024).toStringAsFixed(1)} KB',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 16),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image_rounded),
                      label: Text(_sourceBytes == null ? 'Escolher Imagem' : 'Trocar Imagem'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _color,
                        side: const BorderSide(color: _color),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Format selection
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Converter para:', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _formats.map((f) {
                      final selected = f == _outputFormat;
                      final disabled = f == _sourceFormat;
                      return ChoiceChip(
                        label: Text(f, style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: disabled ? Colors.grey[400] : selected ? Colors.white : _color,
                        )),
                        selected: selected,
                        onSelected: disabled ? null : (_) => setState(() => _outputFormat = f),
                        selectedColor: _color,
                        backgroundColor: Colors.white,
                        side: BorderSide(color: disabled ? Colors.grey[300]! : _color.withValues(alpha:0.3)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Convert button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _sourceBytes != null && !_loading ? _convert : null,
                icon: _loading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.transform_rounded),
                label: Text(_loading ? 'Convertendo...' : 'Converter',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
              ),
            ),
            // Result
            if (_convertedBytes != null) ...[
              const SizedBox(height: 20),
              _Card(
                child: Column(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.green, size: 48),
                    const SizedBox(height: 8),
                    Text('Conversão concluída!', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16)),
                    Text(
                      '$_outputFormat · ${(_convertedBytes!.length / 1024).toStringAsFixed(1)} KB',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _share,
                        icon: const Icon(Icons.share_rounded),
                        label: Text('Compartilhar / Salvar', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: child,
    );
  }
}
