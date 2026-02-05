import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/features/erp/settings/members/models/member_model.dart';
import 'package:gloria_finance/features/erp/settings/members/store/member_all_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/form_accounts_receivable_store.dart';

class MemberSelector extends StatefulWidget {
  final FormAccountsReceivableStore formStore;

  const MemberSelector({super.key, required this.formStore});

  @override
  State<MemberSelector> createState() => _MemberSelectorState();
}

class _MemberSelectorState extends State<MemberSelector> {
  String? _selectedMemberId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final memberAllStore = Provider.of<MemberAllStore>(context);

    // Convertir los miembros a un formato compatible con el widget Dropdown
    List<String> memberNames =
        memberAllStore.getMembers().map((member) => member.name).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Dropdown(
          label: context.l10n.accountsReceivable_form_field_member,
          items: memberNames,
          initialValue:
              _selectedMemberId != null
                  ? memberAllStore
                      .getMembers()
                      .firstWhere((m) => m.memberId == _selectedMemberId)
                      .name
                  : null,
          onChanged: (selectedName) {
            final member = memberAllStore.getMembers().firstWhere(
              (m) => m.name == selectedName,
              orElse:
                  () => MemberModel(
                    memberId: '',
                    name: '',
                    email: '',
                    phone: '',
                    dni: '',
                    conversionDate: '',
                    birthdate: '',
                    isMinister: false,
                    isTreasurer: false,
                    active: true,
                    address: '',
                  ),
            );

            setState(() {
              _selectedMemberId = member.memberId;
            });

            widget.formStore.setMember(member);
          },
          onValidator: (value) {
            if (value == null || value.isEmpty) {
              return context
                  .l10n.accountsReceivable_form_error_member_required;
            }
            return null;
          },
        ),
      ],
    );
  }
}
