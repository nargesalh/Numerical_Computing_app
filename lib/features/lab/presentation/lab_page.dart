import 'package:flutter/material.dart';
import '../data/methods_repository.dart';
import 'tools/bisection_page.dart';
import 'tools/newton_page.dart';

class LabPage extends StatelessWidget {
  const LabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final methods = MethodsRepository.methods;

    return Scaffold(
      appBar: AppBar(title: const Text('Numerical Lab')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: methods.length,
        itemBuilder: (context, index) {
          final method = methods[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                title: Text(
                  method.title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(method.description),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  if (method.id == 'bisection') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BisectionPage()),
                    );
                    return;
                  }
                  if (method.id == 'newton') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NewtonPage()),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${method.title} coming soon')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
