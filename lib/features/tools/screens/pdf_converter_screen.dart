import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:xml/xml.dart';

class PdfConverterScreen extends StatefulWidget {
  const PdfConverterScreen({super.key});

  @override
  State<PdfConverterScreen> createState() => _PdfConverterScreenState();
}

class _PdfConverterScreenState extends State<PdfConverterScreen> {
  static const _color = Color(0xFFC62828);

  int _mode = 0; // 0 = text→PDF, 1 = DOCX→PDF, 2 = image→PDF
  final _textCtrl = TextEditingController();
  String? _fileName;
  Uint8List? _fileBytes;
  bool _loading = false;
  bool _done = false;
  String? _outputPath;

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result;
    if (_mode == 1) {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['docx', 'doc'],
        withData: true,
      );
    } else {
      result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );
    }
    if (result == null || result.files.isEmpty) return;
    setState(() {
      _fileName = result!.files.first.name;
      _fileBytes = result.files.first.bytes;
      _done = false;
    });
  }

  String _extractDocxText(Uint8List bytes) {
    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      final docFile = archive.findFile('word/document.xml');
      if (docFile == null) return '(Não foi possível ler o documento)';
      final xmlStr = String.fromCharCodes(docFile.content as List<int>);
      final doc = XmlDocument.parse(xmlStr);
      final buffer = StringBuffer();
      for (final p in doc.findAllElements('w:p')) {
        final texts = p.findAllElements('w:t').map((e) => e.innerText).join();
        if (texts.isNotEmpty) {
          buffer.writeln(texts);
        }
      }
      return buffer.isEmpty ? '(Documento vazio)' : buffer.toString();
    } catch (e) {
      return '(Erro ao ler DOCX: $e)';
    }
  }

  Future<void> _convert() async {
    setState(() { _loading = true; _done = false; });
    try {
      final pdf = pw.Document();

      if (_mode == 0) {
        // Text → PDF
        final text = _textCtrl.text.trim();
        if (text.isEmpty) {
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Digite algum texto')));
          return;
        }
        pdf.addPage(pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (ctx) => [pw.Text(text, style: const pw.TextStyle(fontSize: 12))],
        ));
      } else if (_mode == 1) {
        // DOCX → PDF
        if (_fileBytes == null) return;
        final text = _extractDocxText(_fileBytes!);
        pdf.addPage(pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (ctx) => [
            pw.Header(level: 2, child: pw.Text(_fileName ?? 'Documento')),
            pw.SizedBox(height: 10),
            pw.Text(text, style: const pw.TextStyle(fontSize: 11)),
          ],
        ));
      } else {
        // Image → PDF
        if (_fileBytes == null) return;
        final image = pw.MemoryImage(_fileBytes!);
        pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          build: (ctx) => pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
        ));
      }

      final bytes = await pdf.save();
      final dir = await getTemporaryDirectory();
      final baseName = _mode == 0
          ? 'texto_convertido'
          : (_fileName?.split('.').first ?? 'arquivo');
      final path = '${dir.path}/$baseName.pdf';
      await File(path).writeAsBytes(bytes);
      setState(() { _outputPath = path; _done = true; });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _share() async {
    if (_outputPath == null) return;
    await Share.shareXFiles([XFile(_outputPath!)], text: 'PDF gerado com Converte Tudo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: Text('Conversor PDF', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        backgroundColor: _color,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Mode selector
            _Card(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('O que deseja converter?', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 12),
                Row(children: [
                  _ModeChip(label: 'Texto → PDF', icon: Icons.text_fields_rounded, selected: _mode == 0,
                    onTap: () => setState(() { _mode = 0; _done = false; _fileBytes = null; })),
                  const SizedBox(width: 8),
                  _ModeChip(label: 'Word → PDF', icon: Icons.description_rounded, selected: _mode == 1,
                    onTap: () => setState(() { _mode = 1; _done = false; _textCtrl.clear(); })),
                  const SizedBox(width: 8),
                  _ModeChip(label: 'Imagem → PDF', icon: Icons.image_rounded, selected: _mode == 2,
                    onTap: () => setState(() { _mode = 2; _done = false; _textCtrl.clear(); })),
                ]),
              ],
            )),
            const SizedBox(height: 16),
            // Input area
            _Card(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_mode == 0) ...[
                  Text('Texto', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _textCtrl,
                    maxLines: 10,
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Cole ou digite seu texto aqui...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: _color, width: 2),
                      ),
                    ),
                  ),
                ] else ...[
                  if (_fileName != null) ...[
                    Row(children: [
                      Icon(_mode == 1 ? Icons.description_rounded : Icons.image_rounded, color: _color),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_fileName!, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
                          overflow: TextOverflow.ellipsis)),
                      IconButton(icon: const Icon(Icons.close_rounded, size: 18), onPressed: () {
                        setState(() { _fileBytes = null; _fileName = null; _done = false; });
                      }),
                    ]),
                    const SizedBox(height: 8),
                    if (_mode == 2 && _fileBytes != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(_fileBytes!, height: 150, fit: BoxFit.contain),
                      ),
                  ],
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.upload_file_rounded),
                      label: Text(_fileName == null ? 'Escolher Arquivo' : 'Trocar Arquivo'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _color,
                        side: BorderSide(color: _color),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ],
            )),
            const SizedBox(height: 20),
            // Convert button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: !_loading && (_mode == 0 || _fileBytes != null) ? _convert : null,
                icon: _loading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.picture_as_pdf_rounded),
                label: Text(_loading ? 'Gerando PDF...' : 'Gerar PDF',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            if (_done) ...[
              const SizedBox(height: 20),
              _Card(child: Column(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.green, size: 48),
                  const SizedBox(height: 8),
                  Text('PDF gerado com sucesso!', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16)),
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
              )),
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

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _ModeChip({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFC62828) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? const Color(0xFFC62828) : Colors.grey[300]!),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? Colors.white : Colors.grey[600], size: 22),
              const SizedBox(height: 4),
              Text(label, style: GoogleFonts.inter(
                fontSize: 11, fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.grey[600],
              ), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
