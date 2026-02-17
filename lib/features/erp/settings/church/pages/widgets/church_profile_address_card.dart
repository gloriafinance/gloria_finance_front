import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Input(
                  label: l10n.settings_church_profile_cep,
                  initialValue: cep,
                  iconRight: const Icon(Icons.search, color: AppColors.purple),
                  onChanged: onCepChanged,
                  inputFormatters: [MaskedInputFormatter('#####-###')],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Input(
                  label: l10n.settings_church_profile_street,
                  initialValue: street,
                  onChanged: onStreetChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Input(
                  label: l10n.settings_church_profile_number,
                  initialValue: number,
                  onChanged: onNumberChanged,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Input(
                  label: l10n.settings_church_profile_city,
                  initialValue: city,
                  onChanged: onCityChanged,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Dropdown(
                  label: l10n.settings_church_profile_state,
                  searchHint: l10n.settings_church_profile_state_select,
                  items: const [
                    'São Paulo',
                    'Rio de Janeiro',
                    'Minas Gerais',
                  ], // Add logic for states
                  initialValue:
                      state.isEmpty
                          ? null
                          : (state == 'SP' ? 'São Paulo' : state),
                  onChanged: onStateChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
