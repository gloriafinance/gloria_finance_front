import 'package:church_finance_bk/core/widgets/form_controls.dart'; // Añadido este import
import 'package:church_finance_bk/settings/members/models/member_model.dart';
import 'package:church_finance_bk/settings/members/store/member_all_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/form_accounts_receivable_store.dart';

class MemberSelector extends StatefulWidget {
  final FormAccountsReceivableStore formStore;

  const MemberSelector({
    super.key,
    required this.formStore,
  });

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
          label: 'Selecione o Membro',
          items: memberNames,
          initialValue: _selectedMemberId != null
              ? memberAllStore
                  .getMembers()
                  .firstWhere((m) => m.memberId == _selectedMemberId)
                  .name
              : null,
          onChanged: (selectedName) {
            final member = memberAllStore.getMembers().firstWhere(
                  (m) => m.name == selectedName,
                  orElse: () => MemberModel(
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
                  ),
                );

            setState(() {
              _selectedMemberId = member.memberId;
            });

            widget.formStore.setMember(member.dni, member.name);
          },
          onValidator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor seleccione un miembro';
            }
            return null;
          },
        ),
      ],
    );
  }
}
