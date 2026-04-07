import 'package:flutter/material.dart';
import '../widgets/financial_widgets.dart';

class FgtsScreen extends StatefulWidget {
  const FgtsScreen({super.key});

  @override
  State<FgtsScreen> createState() => _FgtsScreenState();
}

class _FgtsScreenState extends State<FgtsScreen> {
  static const Color _color = Color(0xFF37474F);

  final _salarioCtrl = TextEditingController();
  final _mesesCtrl = TextEditingController();

  double? _deposito;
  double? _totalDepositado;
  double? _saldoComJuros;
  double? _multaRescisoria;

  @override
  void dispose() {
    _salarioCtrl.dispose();
    _mesesCtrl.dispose();
    super.dispose();
  }

  void _calcular() {
    final salario = double.tryParse(_salarioCtrl.text.replaceAll(',', '.'));
    final meses = double.tryParse(_mesesCtrl.text.replaceAll(',', '.'));

    if (salario == null || meses == null || salario <= 0 || meses <= 0) {
      setState(() { _saldoComJuros = null; });
      return;
    }

    if (salario > 1e9 || meses > 600) {
      setState(() { _saldoComJuros = null; });
      return;
    }

    // FGTS: 8% do salário por mês
    final deposito = salario * 0.08;

    // FGTS rende TR + 3% a.a. → ~0.25% a.m. (TR ≈ 0%)
    const taxaMensal = 0.03 / 12;
    double saldo = 0.0;
    for (int i = 0; i < meses.round(); i++) {
      saldo = (saldo + deposito) * (1 + taxaMensal);
    }

    setState(() {
      _deposito = deposito;
      _totalDepositado = deposito * meses;
      _saldoComJuros = saldo;
      _multaRescisoria = saldo * 0.40;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Text('🏦', style: TextStyle(fontSize: 17)),
            SizedBox(width: 8),
            Text('Calculadora de FGTS',
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
                  colors: [Color(0xFF37474F), Color(0xFF78909C)]),
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
                        ctrl: _salarioCtrl,
                        label: 'SALÁRIO BRUTO',
                        hint: '3.000,00',
                        prefix: 'R\$',
                        onChanged: (_) => _calcular(),
                      ),
                      const SizedBox(height: 16),
                      CalcInputField(
                        ctrl: _mesesCtrl,
                        label: 'MESES TRABALHADOS',
                        hint: '24',
                        suffix: 'meses',
                        onChanged: (_) => _calcular(),
                      ),
                    ],
                  ),

                  if (_saldoComJuros != null) ...[
                    const SizedBox(height: 14),
                    CalcResultCard(
                      color: _color,
                      rows: [
                        CalcResultRow(
                          label: 'Saldo FGTS (c/ juros)',
                          value: fmtBrl(_saldoComJuros!),
                          highlight: true,
                          color: _color,
                        ),
                        CalcResultRow(
                          label: 'Depósito mensal',
                          value: fmtBrl(_deposito!),
                          color: _color,
                        ),
                        CalcResultRow(
                          label: 'Total depositado',
                          value: fmtBrl(_totalDepositado!),
                          color: _color,
                        ),
                        CalcResultRow(
                          label: 'Multa rescisória (40%)',
                          value: fmtBrl(_multaRescisoria!),
                          color: _color,
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 14),
                  const CalcInfoChip(
                    icon: Icons.account_balance_outlined,
                    text:
                        'FGTS: 8% do salário/mês depositado pelo empregador. '
                        'Rende TR + 3% a.a. Multa de 40% em demissão sem justa causa. '
                        '(Art. 15 Lei 8.036/1990)',
                    color: Color(0xFF37474F),
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
