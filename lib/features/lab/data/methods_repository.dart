import '../domain/models/numerical_method.dart';

class MethodsRepository {
  static const methods = [
    NumericalMethod(
      id: 'bisection',
      title: 'Bisection Method',
      description: 'Root finding using interval halving.',
    ),
    NumericalMethod(
      id: 'newton',
      title: 'Newton-Raphson Method',
      description: 'Root finding using derivative iteration.',
    ),
    NumericalMethod(
      id: 'numerical_diff',
      title: 'Numerical Differentiation',
      description: 'Approximate derivatives using finite differences.',
    ),
  ];
}
