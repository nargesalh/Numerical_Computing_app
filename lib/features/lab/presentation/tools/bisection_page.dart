import 'dart:math' as math;
import 'package:flutter/material.dart';

class BisectionPage extends StatefulWidget {
  const BisectionPage({super.key});

  @override
  State<BisectionPage> createState() => _BisectionPageState();
}

class _BisectionPageState extends State<BisectionPage> {
  final _formKey = GlobalKey<FormState>();

  final _aCtrl = TextEditingController(text: "1");
  final _bCtrl = TextEditingController(text: "0");
  final _cCtrl = TextEditingController(text: "-2");

  final _leftCtrl = TextEditingController(text: "1");
  final _rightCtrl = TextEditingController(text: "2");

  final _tolCtrl = TextEditingController(text: "0.0001");
  final _maxIterCtrl = TextEditingController(text: "50");

  String? _error;
  List<_BisectionRow> _rows = [];

  double _f(double x, double a, double b, double c) => a * x * x + b * x + c;

  void _compute() {
    setState(() {
      _error = null;
      _rows = [];
    });

    if (!_formKey.currentState!.validate()) return;

    final a = double.parse(_aCtrl.text.trim());
    final b = double.parse(_bCtrl.text.trim());
    final c = double.parse(_cCtrl.text.trim());
    var left = double.parse(_leftCtrl.text.trim());
    var right = double.parse(_rightCtrl.text.trim());
    final tol = double.parse(_tolCtrl.text.trim());
    final maxIter = int.parse(_maxIterCtrl.text.trim());

    final fL = _f(left, a, b, c);
    final fR = _f(right, a, b, c);

    if (fL == 0) {
      setState(() {
        _rows = [
          _BisectionRow(
            iter: 0,
            left: left,
            right: right,
            mid: left,
            fMid: 0,
            absRightLeft: (right - left).abs(),
          ),
        ];
      });
      return;
    }

    if (fR == 0) {
      setState(() {
        _rows = [
          _BisectionRow(
            iter: 0,
            left: left,
            right: right,
            mid: right,
            fMid: 0,
            absRightLeft: (right - left).abs(),
          ),
        ];
      });
      return;
    }

    if (fL * fR > 0) {
      setState(() {
        _error =
            "f(a) and f(b) must have opposite signs. Try another interval.";
      });
      return;
    }

    double prevMid = double.nan;

    for (int i = 1; i <= maxIter; i++) {
      final mid = (left + right) / 2.0;
      final fMid = _f(mid, a, b, c);
      final width = (right - left).abs();
      final err = prevMid.isNaN ? double.nan : (mid - prevMid).abs();

      _rows.add(
        _BisectionRow(
          iter: i,
          left: left,
          right: right,
          mid: mid,
          fMid: fMid,
          absRightLeft: width,
          absMidPrev: err,
        ),
      );

      if (fMid == 0) break;
      if (width / 2.0 < tol) break;
      if (!err.isNaN && err < tol) break;

      if (_f(left, a, b, c) * fMid < 0) {
        right = mid;
      } else {
        left = mid;
      }

      prevMid = mid;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _aCtrl.dispose();
    _bCtrl.dispose();
    _cCtrl.dispose();
    _leftCtrl.dispose();
    _rightCtrl.dispose();
    _tolCtrl.dispose();
    _maxIterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Bisection Method')),
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
                          child: _numField(_leftCtrl, label: "Left (a)"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _numField(_rightCtrl, label: "Right (b)"),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _numField(_tolCtrl, label: "Tolerance"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _intField(
                            _maxIterCtrl,
                            label: "Max Iterations",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _compute,
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text("Compute"),
                      ),
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
                    DataColumn(label: Text('Left')),
                    DataColumn(label: Text('Right')),
                    DataColumn(label: Text('Mid')),
                    DataColumn(label: Text('f(Mid)')),
                    DataColumn(label: Text('|b-a|')),
                    DataColumn(label: Text('|mid-prev|')),
                  ],
                  rows: _rows.map((r) {
                    String fmt(double v) =>
                        v.isNaN ? '-' : v.toStringAsFixed(6);

                    return DataRow(
                      cells: [
                        DataCell(Text(r.iter.toString())),
                        DataCell(Text(fmt(r.left))),
                        DataCell(Text(fmt(r.right))),
                        DataCell(Text(fmt(r.mid))),
                        DataCell(Text(fmt(r.fMid))),
                        DataCell(Text(fmt(r.absRightLeft))),
                        DataCell(Text(fmt(r.absMidPrev))),
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

class _BisectionRow {
  final int iter;
  final double left;
  final double right;
  final double mid;
  final double fMid;
  final double absRightLeft;
  final double absMidPrev;

  _BisectionRow({
    required this.iter,
    required this.left,
    required this.right,
    required this.mid,
    required this.fMid,
    required this.absRightLeft,
    this.absMidPrev = double.nan,
  });
}
