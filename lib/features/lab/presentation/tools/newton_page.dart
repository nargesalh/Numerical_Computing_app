import 'package:flutter/material.dart';

class NewtonPage extends StatefulWidget {
  const NewtonPage({super.key});

  @override
  State<NewtonPage> createState() => _NewtonPageState();
}

class _NewtonPageState extends State<NewtonPage> {
  final _formKey = GlobalKey<FormState>();

  final _aCtrl = TextEditingController(text: "1");
  final _bCtrl = TextEditingController(text: "0");
  final _cCtrl = TextEditingController(text: "-2");

  final _x0Ctrl = TextEditingController(text: "1");
  final _tolCtrl = TextEditingController(text: "0.0001");
  final _maxIterCtrl = TextEditingController(text: "30");

  String? _error;
  List<_NewtonRow> _rows = [];

  double _f(double x, double a, double b, double c) => a * x * x + b * x + c;
  double _df(double x, double a, double b) => 2 * a * x + b;

  void _compute() {
    setState(() {
      _error = null;
      _rows = [];
    });

    if (!_formKey.currentState!.validate()) return;

    final a = double.parse(_aCtrl.text.trim());
    final b = double.parse(_bCtrl.text.trim());
    final c = double.parse(_cCtrl.text.trim());

    var x = double.parse(_x0Ctrl.text.trim());
    final tol = double.parse(_tolCtrl.text.trim());
    final maxIter = int.parse(_maxIterCtrl.text.trim());

    for (int i = 1; i <= maxIter; i++) {
      final fx = _f(x, a, b, c);
      final dfx = _df(x, a, b);

      if (dfx == 0) {
        setState(() {
          _error =
              "Derivative is zero at x = ${x.toStringAsFixed(6)}. Try another initial guess.";
        });
        return;
      }

      final xNext = x - fx / dfx;
      final err = (xNext - x).abs();

      _rows.add(
        _NewtonRow(
          iter: i,
          x: x,
          fx: fx,
          dfx: dfx,
          xNext: xNext,
          absDelta: err,
        ),
      );

      x = xNext;

      if (err < tol) break;
      if (fx.abs() < tol) break;
    }

    setState(() {});
  }

  void _reset() {
    _formKey.currentState?.reset();

    _aCtrl.text = "1";
    _bCtrl.text = "0";
    _cCtrl.text = "-2";

    _x0Ctrl.text = "1";
    _tolCtrl.text = "0.0001";
    _maxIterCtrl.text = "30";

    setState(() {
      _rows = [];
      _error = null;
    });
  }

  @override
  void dispose() {
    _aCtrl.dispose();
    _bCtrl.dispose();
    _cCtrl.dispose();
    _x0Ctrl.dispose();
    _tolCtrl.dispose();
    _maxIterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Newton Method')),
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
                        Expanded(
                          child: _numField(
                            _x0Ctrl,
                            label: "Initial guess (x₀)",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _numField(_tolCtrl, label: "Tolerance"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _intField(_maxIterCtrl, label: "Max Iter"),
                        ),
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

                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cs.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _error!,
                          style: TextStyle(color: cs.onErrorContainer),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          if (_rows.isNotEmpty) ...[
            Text(
              "Iterations",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('x')),
                    DataColumn(label: Text('f(x)')),
                    DataColumn(label: Text("f'(x)")),
                    DataColumn(label: Text('x_next')),
                    DataColumn(label: Text('|Δx|')),
                  ],
                  rows: _rows.map((r) {
                    String fmt(double v) => v.toStringAsFixed(6);

                    return DataRow(
                      cells: [
                        DataCell(Text(r.iter.toString())),
                        DataCell(Text(fmt(r.x))),
                        DataCell(Text(fmt(r.fx))),
                        DataCell(Text(fmt(r.dfx))),
                        DataCell(Text(fmt(r.xNext))),
                        DataCell(Text(fmt(r.absDelta))),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

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
        if (x == null || x.isNaN || x.isInfinite) return 'Invalid number';
        return null;
      },
    );
  }

  Widget _intField(TextEditingController c, {required String label}) {
    return TextFormField(
      controller: c,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (v) {
        final s = (v ?? '').trim();
        if (s.isEmpty) return 'Required';
        final x = int.tryParse(s);
        if (x == null || x <= 0) return 'Invalid';
        return null;
      },
    );
  }
}

class _NewtonRow {
  final int iter;
  final double x;
  final double fx;
  final double dfx;
  final double xNext;
  final double absDelta;

  _NewtonRow({
    required this.iter,
    required this.x,
    required this.fx,
    required this.dfx,
    required this.xNext,
    required this.absDelta,
  });
}
