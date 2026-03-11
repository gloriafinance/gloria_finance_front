import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';

import 'church_profile_card.dart';

class ChurchProfileAddressCard extends StatelessWidget {
  final String cep;
  final String street;
  final String number;
  final String city;
  final String state;
  final ValueChanged<String> onCepChanged;
  final ValueChanged<String> onStreetChanged;
  final ValueChanged<String> onNumberChanged;
  final ValueChanged<String> onCityChanged;
  final ValueChanged<String> onStateChanged;

  const ChurchProfileAddressCard({
    super.key,
    required this.cep,
    required this.street,
    required this.number,
    required this.city,
    required this.state,
    required this.onCepChanged,
    required this.onStreetChanged,
    required this.onNumberChanged,
    required this.onCityChanged,
    required this.onStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ChurchProfileCard(
      title: l10n.settings_church_profile_address,
      icon: Icons.location_on,
      child: isMobile(context) ? _layoutMobile(l10n) : _layoutDesktop(l10n),
    );
  }

  Widget _layoutDesktop(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(flex: 2, child: _cepInput(l10n)),
            const SizedBox(width: 12),
            Expanded(flex: 5, child: _streetInput(l10n)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(flex: 2, child: _numberInput(l10n)),
            const SizedBox(width: 12),
            Expanded(flex: 4, child: _cityInput(l10n)),
            const SizedBox(width: 12),
            Expanded(flex: 3, child: _stateInput(l10n)),
          ],
        ),
      ],
    );
  }

  Widget _layoutMobile(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _cepInput(l10n),
        const SizedBox(height: 8),
        _streetInput(l10n),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(flex: 2, child: _numberInput(l10n)),
            const SizedBox(width: 12),
            Expanded(flex: 3, child: _cityInput(l10n)),
          ],
        ),
        const SizedBox(height: 8),
        _stateInput(l10n),
      ],
    );
  }

  Widget _cepInput(AppLocalizations l10n) {
    return Input(
      label: l10n.settings_church_profile_cep,
      initialValue: cep,
      iconRight: const Icon(Icons.search, color: AppColors.purple),
      onChanged: onCepChanged,
      inputFormatters: [MaskedInputFormatter('#####-###')],
    );
  }

  Widget _streetInput(AppLocalizations l10n) {
    return Input(
      label: l10n.settings_church_profile_street,
      initialValue: street,
      onChanged: onStreetChanged,
    );
  }

  Widget _numberInput(AppLocalizations l10n) {
    return Input(
      label: l10n.settings_church_profile_number,
      initialValue: number,
      onChanged: onNumberChanged,
    );
  }

  Widget _cityInput(AppLocalizations l10n) {
    return Input(
      label: l10n.settings_church_profile_city,
      initialValue: city,
      onChanged: onCityChanged,
    );
  }

  Widget _stateInput(AppLocalizations l10n) {
    return Dropdown(
      label: l10n.settings_church_profile_state,
      searchHint: l10n.settings_church_profile_state_select,
      items: const [
        'São Paulo',
        'Rio de Janeiro',
        'Minas Gerais',
      ], // Add logic for states
      initialValue:
          state.isEmpty ? null : (state == 'SP' ? 'São Paulo' : state),
      onChanged: onStateChanged,
    );
  }
}
