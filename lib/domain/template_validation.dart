import 'models.dart';

enum TemplateError { nameLength, target, step, repeat }

abstract final class TemplateValidation {
  static const int nameMin = 1;
  static const int nameMax = 20;

  /// Name length counted in Unicode code points after trimming, so one
  /// Chinese character counts as one.
  static int nameLength(String name) => name.trim().runes.length;

  static Set<TemplateError> validate({
    required String name,
    required int? target,
    required int? step,
    required RepeatRule repeat,
  }) {
    final errors = <TemplateError>{};
    final len = nameLength(name);
    if (len < nameMin || len > nameMax) errors.add(TemplateError.nameLength);
    if (target == null || target < 1) errors.add(TemplateError.target);
    if (step == null || step < 1 || (target != null && step > target)) {
      errors.add(TemplateError.step);
    }
    if (repeat.isEmpty) errors.add(TemplateError.repeat);
    return errors;
  }

  static Set<TemplateError> validateTemplate(TaskTemplate t) =>
      validate(name: t.name, target: t.target, step: t.step, repeat: t.repeat);
}

class TemplateValidationException implements Exception {
  const TemplateValidationException(this.errors);

  final Set<TemplateError> errors;

  @override
  String toString() => 'TemplateValidationException($errors)';
}
