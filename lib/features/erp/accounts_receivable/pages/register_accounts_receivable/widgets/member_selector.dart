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
  Widget build(BuildContext context) {
    final memberAllStore = Provider.of<MemberAllStore>(context);
    final members = memberAllStore.getMembers();
    final memberIds =
        members.map((member) => member.memberId).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Dropdown(
          label: context.l10n.accountsReceivable_form_field_member,
          items: memberIds,
          initialValue:
              memberIds.contains(_selectedMemberId) ? _selectedMemberId : null,
          itemLabelBuilder: (memberId) {
            final member = members.cast<MemberModel?>().firstWhere(
              (m) => m?.memberId == memberId,
              orElse: () => null,
            );

            return member?.name ?? '';
          },
          onChanged: (selectedMemberId) {
            final member = members.firstWhere(
              (m) => m.memberId == selectedMemberId,
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
