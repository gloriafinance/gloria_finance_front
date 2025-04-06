import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/settings/members/store/member_all_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../settings/members/models/member_model.dart'
    show MemberModel;
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecione o Membro',
          style: TextStyle(
            color: AppColors.purple,
            fontFamily: AppFonts.fontTitle,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 8),
        _buildMemberDropdown(memberAllStore),
      ],
    );
  }

  Widget _buildMemberDropdown(MemberAllStore memberAllStore) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyMiddle),
        borderRadius: BorderRadius.circular(18),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text('Selecione um membro'),
          value: _selectedMemberId,
          items: memberAllStore.getMembers().map((member) {
            return DropdownMenuItem<String>(
              value: member.memberId,
              child: Text(
                member.name,
                style: TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                ),
              ),
            );
          }).toList(),
          onChanged: (memberId) {
            if (memberId != null) {
              setState(() {
                _selectedMemberId = memberId;
              });

              final member = memberAllStore.getMembers().firstWhere(
                    (m) => m.memberId == memberId,
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

              widget.formStore.setMember(member.dni, member.name);
            }
          },
        ),
      ),
    );
  }
}
