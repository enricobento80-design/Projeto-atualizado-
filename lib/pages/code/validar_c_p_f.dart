import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/ff_builtin_enums.dart';

bool? validarCPF(String? cpf) {
  // 0. Tratar caso o valor venha nulo ou vazio
  if (cpf == null || cpf.isEmpty) {
    return false;
  }

  // 1. Remover caracteres não numéricos
  String cpfLimpo = cpf.replaceAll(RegExp(r'[^\d]'), '');

  // 2. Verificar se tem exatamente 11 dígitos
  if (cpfLimpo.length != 11) {
    return false;
  }

  // 3. Verificar se todos os dígitos são iguais (ex: 111.111.111-11)
  if (RegExp(r'^(\d)\1{10}$').hasMatch(cpfLimpo)) {
    return false;
  }

  // 4. Calcular o primeiro dígito verificador
  int sum = 0;
  for (int i = 0; i < 9; i++) {
    sum += int.parse(cpfLimpo[i]) * (10 - i);
  }
  int firstCheckDigit = 11 - (sum % 11);
  if (firstCheckDigit >= 10) {
    firstCheckDigit = 0;
  }

  // 5. Calcular o segundo dígito verificador
  sum = 0;
  for (int i = 0; i < 10; i++) {
    sum += int.parse(cpfLimpo[i]) * (11 - i);
  }
  int secondCheckDigit = 11 - (sum % 11);
  if (secondCheckDigit >= 10) {
    secondCheckDigit = 0;
  }

  // 6. Retorno final de confirmação
  return (int.parse(cpfLimpo[9]) == firstCheckDigit) &&
      (int.parse(cpfLimpo[10]) == secondCheckDigit);
}
