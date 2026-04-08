import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class FipeScreen extends StatefulWidget {
  const FipeScreen({super.key});

  @override
  State<FipeScreen> createState() => _FipeScreenState();
}

class _FipeScreenState extends State<FipeScreen> {
  static const _color = Color(0xFFE65100);
  static const _baseUrl = 'https://parallelum.com.br/fipe/api/v1';

  String _tipo = 'carros';
  List<Map<String, dynamic>> _marcas = [];
  List<Map<String, dynamic>> _modelos = [];
  List<Map<String, dynamic>> _anos = [];

  String? _marcaId;
  String? _modeloId;
  String? _anoId;
  Map<String, dynamic>? _resultado;

  bool _loadingMarcas = false;
  bool _loadingModelos = false;
  bool _loadingAnos = false;
  bool _loadingResult = false;

  // Search by value
  final _budgetCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMarcas();
  }

  @override
  void dispose() {
    _budgetCtrl.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _fetch(String path) async {
    try {
      final resp = await http.get(Uri.parse('$_baseUrl/$path')).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        if (data is List) return data.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }

  Future<void> _fetchMarcas() async {
    setState(() { _loadingMarcas = true; _marcas = []; _modelos = []; _anos = []; _marcaId = null; _modeloId = null; _anoId = null; _resultado = null; });
    _marcas = await _fetch('$_tipo/marcas');
    if (mounted) setState(() => _loadingMarcas = false);
  }

  Future<void> _fetchModelos(String marcaId) async {
    setState(() { _loadingModelos = true; _modelos = []; _anos = []; _modeloId = null; _anoId = null; _resultado = null; _marcaId = marcaId; });
    try {
      final resp = await http.get(Uri.parse('$_baseUrl/$_tipo/marcas/$marcaId/modelos')).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        _modelos = (data['modelos'] as List).cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingModelos = false);
  }

  Future<void> _fetchAnos(String modeloId) async {
    setState(() { _loadingAnos = true; _anos = []; _anoId = null; _resultado = null; _modeloId = modeloId; });
    _anos = await _fetch('$_tipo/marcas/$_marcaId/modelos/$modeloId/anos');
    if (mounted) setState(() => _loadingAnos = false);
  }

  Future<void> _fetchResult(String anoId) async {
    setState(() { _loadingResult = true; _anoId = anoId; _resultado = null; });
    try {
      final resp = await http.get(Uri.parse('$_baseUrl/$_tipo/marcas/$_marcaId/modelos/$_modeloId/anos/$anoId')).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        _resultado = json.decode(resp.body);
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingResult = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: Text('Tabela FIPE', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        backgroundColor: _color,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tipo selection
            _Card(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tipo de veículo', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 12),
                Row(children: [
                  _TipoChip(label: 'Carro', icon: Icons.directions_car_rounded, selected: _tipo == 'carros',
                    onTap: () { _tipo = 'carros'; _fetchMarcas(); }),
                  const SizedBox(width: 8),
                  _TipoChip(label: 'Moto', icon: Icons.two_wheeler_rounded, selected: _tipo == 'motos',
                    onTap: () { _tipo = 'motos'; _fetchMarcas(); }),
                  const SizedBox(width: 8),
                  _TipoChip(label: 'Caminhão', icon: Icons.local_shipping_rounded, selected: _tipo == 'caminhoes',
                    onTap: () { _tipo = 'caminhoes'; _fetchMarcas(); }),
                ]),
              ],
            )),
            const SizedBox(height: 16),
            // Marca
            _Card(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Marca', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                _loadingMarcas
                    ? const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator(strokeWidth: 2)))
                    : _SearchableDropdown(
                        items: _marcas,
                        value: _marcaId,
                        hint: 'Selecione a marca',
                        onChanged: (id) => _fetchModelos(id),
                      ),
              ],
            )),
            // Modelo
            if (_marcaId != null) ...[
              const SizedBox(height: 16),
              _Card(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Modelo', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 8),
                  _loadingModelos
                      ? const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator(strokeWidth: 2)))
                      : _SearchableDropdown(
                          items: _modelos,
                          value: _modeloId,
                          hint: 'Selecione o modelo',
                          onChanged: (id) => _fetchAnos(id),
                        ),
                ],
              )),
            ],
            // Ano
            if (_modeloId != null) ...[
              const SizedBox(height: 16),
              _Card(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ano', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 8),
                  _loadingAnos
                      ? const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator(strokeWidth: 2)))
                      : Wrap(
                          spacing: 8, runSpacing: 8,
                          children: _anos.map((a) {
                            final sel = a['codigo'].toString() == _anoId;
                            return ChoiceChip(
                              label: Text(a['nome'] ?? '', style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600, fontSize: 13,
                                color: sel ? Colors.white : _color,
                              )),
                              selected: sel,
                              onSelected: (_) => _fetchResult(a['codigo'].toString()),
                              selectedColor: _color,
                              backgroundColor: Colors.white,
                              side: BorderSide(color: _color.withValues(alpha:0.3)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            );
                          }).toList(),
                        ),
                ],
              )),
            ],
            // Result
            if (_loadingResult)
              const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator()))
            else if (_resultado != null) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFE65100), Color(0xFFFF9800)]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: _color.withValues(alpha:0.3), blurRadius: 16, offset: const Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    Text(_resultado!['Marca'] ?? '', style: GoogleFonts.inter(fontSize: 13, color: Colors.white70)),
                    Text(_resultado!['Modelo'] ?? '', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)),
                    Text('${_resultado!['AnoModelo']} · ${_resultado!['Combustivel']}',
                        style: GoogleFonts.inter(fontSize: 13, color: Colors.white70)),
                    const SizedBox(height: 16),
                    Text(_resultado!['Valor'] ?? '', style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 32, color: Colors.white)),
                    const SizedBox(height: 8),
                    Text('Ref: ${_resultado!['MesReferencia']}', style: GoogleFonts.inter(fontSize: 12, color: Colors.white60)),
                    Text('FIPE: ${_resultado!['CodigoFipe']}', style: GoogleFonts.inter(fontSize: 12, color: Colors.white60)),
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

class _TipoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _TipoChip({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFE65100) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? const Color(0xFFE65100) : Colors.grey[300]!),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? Colors.white : Colors.grey[600], size: 24),
              const SizedBox(height: 4),
              Text(label, style: GoogleFonts.inter(
                fontSize: 12, fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.grey[600],
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchableDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String? value;
  final String hint;
  final ValueChanged<String> onChanged;
  const _SearchableDropdown({required this.items, this.value, required this.hint, required this.onChanged});

  @override
  State<_SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<_SearchableDropdown> {
  final _ctrl = TextEditingController();
  List<Map<String, dynamic>> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
  }

  @override
  void didUpdateWidget(covariant _SearchableDropdown old) {
    super.didUpdateWidget(old);
    if (old.items != widget.items) {
      _filtered = widget.items;
      _ctrl.clear();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _filter(String q) {
    setState(() {
      _filtered = widget.items.where((i) =>
        (i['nome'] ?? '').toString().toLowerCase().contains(q.toLowerCase())
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _ctrl,
          onChanged: _filter,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: const Icon(Icons.search_rounded, size: 20),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE65100), width: 2),
            ),
          ),
          style: GoogleFonts.inter(fontSize: 14),
        ),
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _filtered.length,
            itemBuilder: (_, i) {
              final item = _filtered[i];
              final id = item['codigo'].toString();
              final selected = id == widget.value;
              return ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                title: Text(item['nome'] ?? '', style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  color: selected ? const Color(0xFFE65100) : null,
                )),
                trailing: selected ? const Icon(Icons.check_rounded, color: Color(0xFFE65100), size: 18) : null,
                onTap: () => widget.onChanged(id),
              );
            },
          ),
        ),
      ],
    );
  }
}
