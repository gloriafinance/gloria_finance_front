import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';

import '../../models/church_model.dart';
import 'church_profile_card.dart';

class ChurchProfileDoctrinalBasesCard extends StatelessWidget {
  final List<ChurchDoctrinalBaseModel> doctrinalBases;
  final ValueChanged<List<ChurchDoctrinalBaseModel>> onChanged;

  const ChurchProfileDoctrinalBasesCard({
    super.key,
    required this.doctrinalBases,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ChurchProfileCard(
      title: 'Bases doutrinárias',
      icon: Icons.menu_book,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cadastre e mantenha as bases doutrinárias da igreja para uso institucional.',
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              color: Colors.black54,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          if (doctrinalBases.isEmpty) _emptyState(),
          if (doctrinalBases.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: doctrinalBases.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = doctrinalBases[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.greyMiddle),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Base ${index + 1}',
                              style: const TextStyle(
                                fontFamily: AppFonts.fontTitle,
                                color: AppColors.purple,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _removeAt(index),
                            icon: const Icon(Icons.delete_outline),
                            color: Colors.red,
                          ),
                        ],
                      ),
                      Input(
                        label: 'Título',
                        initialValue: item.title,
                        maxLines: 3,
                        onChanged: (value) {
                          _updateAt(index, item.copyWith(title: value));
                        },
                      ),
                      Input(
                        label: 'Base bíblica',
                        initialValue: item.scripture,
                        maxLines: 2,
                        onChanged: (value) {
                          _updateAt(index, item.copyWith(scripture: value));
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          const SizedBox(height: 16),
          ButtonActionTable(
            color: AppColors.mustard,
            text: 'Adicionar base',
            icon: Icons.add_box_outlined,
            onPressed: _addBase,
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyMiddle),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Text(
        'Nenhuma base doutrinária cadastrada.',
        style: TextStyle(
          fontFamily: AppFonts.fontSubTitle,
          color: AppColors.grey,
        ),
      ),
    );
  }

  void _addBase() {
    final updated = List<ChurchDoctrinalBaseModel>.from(doctrinalBases)
      ..add(const ChurchDoctrinalBaseModel(title: '', scripture: ''));
    onChanged(updated);
  }

  void _removeAt(int index) {
    final updated = List<ChurchDoctrinalBaseModel>.from(doctrinalBases)
      ..removeAt(index);
    onChanged(updated);
  }

  void _updateAt(int index, ChurchDoctrinalBaseModel value) {
    final updated = List<ChurchDoctrinalBaseModel>.from(doctrinalBases);
    updated[index] = value;
    onChanged(updated);
  }
}
