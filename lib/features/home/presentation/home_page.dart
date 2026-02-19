import 'package:flutter/material.dart';
import '../../chapters/presentation/chapters_page.dart';
import '../../lab/presentation/lab_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Numerical Computing'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeaderCard(colorScheme: cs),
          const SizedBox(height: 16),
          _FeatureCard(
            title: 'Chapters',
            subtitle: 'Browse the lecture notes (offline)',
            icon: Icons.menu_book_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChaptersPage()),
              );
            },
          ),
          const SizedBox(height: 12),
          _FeatureCard(
            title: 'Numerical Lab',
            subtitle: 'Solve problems step-by-step',
            icon: Icons.science_rounded,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LabPage()),
              );
            },
          ),
          const SizedBox(height: 18),
          Text(
            'Roadmap',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          const _RoadmapItem(text: 'Chapter viewer (notes) + bookmarks'),
          const _RoadmapItem(text: 'Bisection + Newton method (interactive tables)'),
          const _RoadmapItem(text: 'Numerical differentiation'),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final ColorScheme colorScheme;

  const _HeaderCard({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.functions_rounded,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interactive notebook',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Study chapters and practice methods with calculators.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cs.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: cs.onSecondaryContainer),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded, color: cs.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoadmapItem extends StatelessWidget {
  final String text;

  const _RoadmapItem({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(Icons.check_circle_rounded, size: 18, color: cs.primary),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
