import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/financial_widgets.dart';

class PoupancaScreen extends StatefulWidget {
  const PoupancaScreen({super.key});

  @override
  State<PoupancaScreen> createState() => _PoupancaScreenState();
}

class _PoupancaScreenState extends State<PoupancaScreen> {
  static const Color _color = Color(0xFF2E7D32);

  final _valorCtrl = TextEditingController();
  final _selicCtrl = TextEditingController(text: '10.75');
  final _mesesCtrl = TextEditingController();

  double? _rendimentoMensal;
  double? _totalRendido;
  double? _saldoFinal;
  double? _rentabilidadeAnual;

  @override
  void dispose() {
    _valorCtrl.dispose();
    _selicCtrl.dispose();
    _mesesCtrl.dispose();
    super.dispose();
  }

  void _calcular() {
    final valor = double.tryParse(_valorCtrl.text.replaceAll(',', '.'));
    final selic = double.tryParse(_selicCtrl.text.replaceAll(',', '.'));
    final meses = double.tryParse(_mesesCtrl.text.replaceAll(',', '.'));

    if (valor == null || selic == null || meses == null ||
        valor <= 0 || selic <= 0 || meses <= 0) {
      setState(() {
        _saldoFinal = null;
      });
      return;
    }

    if (valor > 1e15 || meses > 1200) {
      setState(() => _saldoFinal = null);
      return;
    }

    // Brazilian savings rule (TR ≈ 0%)
    final double taxaMensal =
        selic > 8.5 ? 0.005 : (selic / 100) * 0.7 / 12;

    final saldoFinal = valor * pow(1 + taxaMensal, meses).toDouble();
    final totalRendido = saldoFinal - valor;
    final rentabilidadeAnual =
        (pow(1 + taxaMensal, 12).toDouble() - 1) * 100;

    setState(() {
      _rendimentoMensal = valor * taxaMensal;
      _totalRendido = totalRendido;
      _saldoFinal = saldoFinal;
      _rentabilidadeAnual = rentabilidadeAnual;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selic =
        double.tryParse(_selicCtrl.text.replaceAll(',', '.')) ?? 10.75;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: _color,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🐷', style: TextStyle(fontSize: 17)),
            SizedBox(width: 8),
            Text('Rendimento Poupança',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 3,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)]),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                children: [
                  CalcInputCard(
                    children: [
                      CalcInputField(
                        ctrl: _valorCtrl,
                        label: 'VALOR APLICADO',
                        hint: '5.000,00',
                        prefix: 'R\$',
                        onChanged: (_) => _calcular(),
                      ),
                      const SizedBox(height: 16),
                      CalcInputField(
                        ctrl: _selicCtrl,
                        label: 'SELIC ATUAL',
                        hint: '10,75',
                        suffix: '% a.a.',
                        onChanged: (_) => _calcular(),
                      ),
                      const SizedBox(height: 16),
                      CalcInputField(
                        ctrl: _mesesCtrl,
                        label: 'PERÍODO',
                        hint: '12',
                        suffix: 'meses',
                        onChanged: (_) => _calcular(),
                      ),
                    ],
                  ),

                  if (_saldoFinal != null) ...[
                    const SizedBox(height: 14),
                    CalcResultCard(
                      color: _color,
                      rows: [
                        CalcResultRow(
                          label: 'Saldo final',
                          value: fmtBrl(_saldoFinal!),
                          highlight: true,
                          color: _color,
                        ),
                        CalcResultRow(
                          label: 'Total rendido',
                          value: fmtBrl(_totalRendido!),
                          color: _color,
                        ),
                        CalcResultRow(
                          label: 'Rend. mensal (1º mês)',
                          value: fmtBrl(_rendimentoMensal!),
                          color: _color,
                        ),
                        CalcResultRow(
                          label: 'Rentabilidade anual',
                          value:
                              '${_rentabilidadeAnual!.toStringAsFixed(2)}% a.a.',
                          color: _color,
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 14),
                  CalcInfoChip(
                    icon: Icons.savings_outlined,
                    text: selic > 8.5
                        ? 'SELIC > 8,5%: poupança rende 0,5% a.m. + TR (TR ≈ 0%). '
                          'Taxa SELIC é valor de referência — edite para a taxa vigente.'
                        : 'SELIC ≤ 8,5%: poupança rende 70% da SELIC/12 + TR (TR ≈ 0%). '
                          'Taxa SELIC é valor de referência — edite para a taxa vigente.',
                    color: _color,
                  ),
                  const SizedBox(height: 10),
                  const CalcDisclaimer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
