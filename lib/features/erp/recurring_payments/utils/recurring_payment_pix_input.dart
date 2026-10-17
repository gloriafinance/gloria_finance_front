import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../models/recurring_payment_model.dart';

/// Máscara de digitação da chave PIX conforme o tipo escolhido.
///
/// O tipo é escolhido antes da chave justamente porque ele define o formato:
/// CPF, CNPJ e telefone têm máscara; e-mail e chave aleatória (EVP) são texto
/// livre, porque mascarar um UUID ou um e-mail só atrapalharia a digitação.
List<TextInputFormatter> pixKeyInputFormatters(PixKeyType type) {
  switch (type) {
    case PixKeyType.CPF:
      return [MaskedInputFormatter('###.###.###-##')];
    case PixKeyType.CNPJ:
      return [MaskedInputFormatter('##.###.###/####-##')];
    case PixKeyType.PHONE:
      return [MaskedInputFormatter('(##) #####-####')];
    case PixKeyType.EMAIL:
    case PixKeyType.EVP:
      return const [];
  }
}

/// Teclado adequado ao tipo de chave.
TextInputType pixKeyKeyboardType(PixKeyType type) {
  switch (type) {
    case PixKeyType.CPF:
    case PixKeyType.CNPJ:
    case PixKeyType.PHONE:
      return TextInputType.number;
    case PixKeyType.EMAIL:
      return TextInputType.emailAddress;
    case PixKeyType.EVP:
      return TextInputType.text;
  }
}
