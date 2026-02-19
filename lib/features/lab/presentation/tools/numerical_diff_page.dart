import 'package:flutter/material.dart';

class NumericalDiffPage extends StatefulWidget {
  const NumericalDiffPage({super.key});

  @override
  State<NumericalDiffPage> createState() => _NumericalDiffPageState();
}

class _NumericalDiffPageState extends State<NumericalDiffPage> {
  final _formKey = GlobalKey<FormState>();

  final _aCtrl = TextEditingController(text: "1");
  final _bCtrl = TextEditingController(text: "0");
  final _cCtrl = TextEditingController(text: "-2");

  final _xCtrl = TextEditingController(text: "1.4");
  final _hCtrl = TextEditingController(text: "0.01");

  _Result? _result;

  double _f(double x, double a, double b, double c) => a * x * x + b * x + c;
  double _dfExact(double x, double a, double b) => 2 * a * x + b;

  void _compute() {
    if (!_formKey.currentState!.validate()) return;

    final a = double.parse(_aCtrl.text.trim());
    final b = double.parse(_bCtrl.text.trim());
    final c = double.parse(_cCtrl.text.trim());
    final x = double.parse(_xCtrl.text.trim());
    final h = double.parse(_hCtrl.text.trim());

    final fx = _f(x, a, b, c);
    final fxh = _f(x + h, a, b, c);
    final fxmh = _f(x - h, a, b, c);

    final forward = (fxh - fx) / h;
    final backward = (fx - fxmh) / h;
    final central = (fxh - fxmh) / (2 * h);

    final exact = _dfExact(x, a, b);

    setState(() {
      _result = _Result(
        fx: fx,
        fxh: fxh,
        fxmh: fxmh,
        forward: forward,
        backward: backward,
        central: central,
        exact: exact,
      );
    });
  }

  void _reset() {
    _formKey.currentState?.reset();

    _aCtrl.text = "1";
    _bCtrl.text = "0";
    _cCtrl.text = "-2";
    _xCtrl.text = "1.4";
    _hCtrl.text = "0.01";

    setState(() {
      _result = null;
    });
  }

  @override
  void dispose() {
    _aCtrl.dispose();
    _bCtrl.dispose();
    _cCtrl.dispose();
    _xCtrl.dispose();
    _hCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Numerical Differentiation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Function: f(x) = ax² + bx + c",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(child: _numField(_aCtrl, label: "a")),
                        const SizedBox(width: 12),
                        Expanded(child: _numField(_bCtrl, label: "b")),
                        const SizedBox(width: 12),
                        Expanded(child: _numField(_cCtrl, label: "c")),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(child: _numField(_xCtrl, label: "x")),
                        const SizedBox(width: 12),
                        Expanded(child: _numField(_hCtrl, label: "h")),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _compute,
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text("Compute"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _reset,
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text("Reset"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          if (_result != null) ...[
            Text(
              "Results",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _ResultRow(
                      label: "Exact f'(x)",
                      value: _fmt(_result!.exact),
                      strong: true,
                    ),
                    const Divider(),
                    _ResultRow(label: "Forward", value: _fmt(_result!.forward)),
                    _ResultRow(
                      label: "Backward",
                      value: _fmt(_result!.backward),
                    ),
                    _ResultRow(label: "Central", value: _fmt(_result!.central)),
                    const Divider(),
                    _ResultRow(
                      label: "Error (Forward)",
                      value: _fmt((_result!.forward - _result!.exact).abs()),
                      color: cs.primary,
                    ),
                    _ResultRow(
                      label: "Error (Backward)",
                      value: _fmt((_result!.backward - _result!.exact).abs()),
                      color: cs.primary,
                    ),
                    _ResultRow(
                      label: "Error (Central)",
                      value: _fmt((_result!.central - _result!.exact).abs()),
                      color: cs.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _fmt(double v) => v.toStringAsFixed(8);

  Widget _numField(TextEditingController c, {required String label}) {
    return TextFormField(
      controller: c,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (v) {
        final s = (v ?? '').trim();
        if (s.isEmpty) return 'Required';
        final x = double.tryParse(s);
        if (x == null || x.isNaN || x.isInfinite) return 'Invalid';
        if (label == "h" && x == 0) return 'h cannot be 0';
        return null;
      },
    );
  }
}

class _Result {
  final double fx;
  final double fxh;
  final double fxmh;
  final double forward;
  final double backward;
  final double central;
  final double exact;

  _Result({
    required this.fx,
    required this.fxh,
    required this.fxmh,
    required this.forward,
    required this.backward,
    required this.central,
    required this.exact,
  });
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final bool strong;
  final Color? color;

  const _ResultRow({
    required this.label,
    required this.value,
    this.strong = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final style = strong
        ? Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)
        : Theme.of(context).textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style?.copyWith(color: color)),
        ],
      ),
    );
  }
}
