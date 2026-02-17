import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:gloria_finance/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/church_model.dart';
import '../services/church_service.dart';
import '../store/church_store.dart';
import 'widgets/church_profile_address_card.dart';
import 'widgets/church_profile_doctrinal_bases_card.dart';
import 'widgets/church_profile_general_info_card.dart';
import 'widgets/church_profile_header.dart';
import 'widgets/church_profile_logo_card.dart';
import 'widgets/church_profile_whatsapp_card.dart';

class ChurchProfileScreen extends StatelessWidget {
  const ChurchProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Toast.init(context);
    final authStore = context.read<AuthSessionStore>();
    final token = authStore.state.session.token;
    final churchId = authStore.state.session.churchId;

    return ChangeNotifierProvider(
      create:
          (_) =>
              ChurchStore(ChurchService(tokenAPI: token))..loadChurch(churchId),
      child: const _ChurchProfileContent(),
    );
  }
}

class _ChurchProfileContent extends StatefulWidget {
  const _ChurchProfileContent();

  @override
  State<_ChurchProfileContent> createState() => _ChurchProfileContentState();
}

class _ChurchProfileContentState extends State<_ChurchProfileContent>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TabController _tabController;

  String _name = '';
  String _openerDate = '';
  String _status = '';
  String _email = '';
  String _cep = '';
  String _street = '';
  String _number = '';
  String _city = '';
  String _state = '';
  List<ChurchDoctrinalBaseModel> _doctrinalBases = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _populateFields(ChurchModel church) {
    if (_name.isEmpty) _name = church.name;
    if (_openerDate.isEmpty && church.openingDate != null) {
      _openerDate =
          "${church.openingDate!.month.toString().padLeft(2, '0')}/${church.openingDate!.day.toString().padLeft(2, '0')}/${church.openingDate!.year}";
    }
    if (_status.isEmpty) _status = 'ACTIVE';
    if (_email.isEmpty) _email = church.email;
    if (_cep.isEmpty) _cep = church.postalCode;
    if (_street.isEmpty) _street = church.street;
    if (_number.isEmpty) _number = church.number;
    if (_city.isEmpty) _city = church.city;
    if (_doctrinalBases.isEmpty) {
      _doctrinalBases = List<ChurchDoctrinalBaseModel>.from(
        church.doctrinalBases,
      );
    }
  }

  Future<void> _launchMetaSignup() async {
    final Map<String, String> queryParameters = {
      'client_id': "25820028151023925",
      'redirect_uri':
          kReleaseMode
              ? "https://devpto-dev--preview-chore-webhook-whatsaap-1k94yli1.web.app/integrations/whatsapp/callback"
              : "http://localhost:3000/integrations/whatsapp/callback",
      'response_type': 'code',
      'scope': 'whatsapp_business_management,whatsapp_business_messaging',
      'extras': '{"setup":{"config_id":"2065801614266200"}}',
    };

    final Uri url = Uri.https(
      'www.facebook.com',
      '/v18.0/dialog/oauth',
      queryParameters,
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      Toast.showMessage('Could not launch Meta Signup', ToastType.error);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _openerDate =
            "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _saveProfile() async {
    final store = context.read<ChurchStore>();
    final church = store.church;
    if (church == null) {
      return;
    }

    final openingDate = _parseOpeningDate(_openerDate) ?? church.openingDate;
    if (openingDate == null) {
      Toast.showMessage('Invalid opening date', ToastType.warning);
      return;
    }

    final doctrinalBases =
        _doctrinalBases
            .where(
              (item) =>
                  item.title.trim().isNotEmpty &&
                  item.scripture.trim().isNotEmpty,
            )
            .toList();

    final updatedChurch = church.copyWith(
      name: _name.trim(),
      email: _email.trim(),
      city: _city.trim(),
      address: church.address,
      street: _street.trim(),
      number: _number.trim(),
      postalCode: _cep.trim(),
      openingDate: openingDate,
      doctrinalBases: doctrinalBases,
    );

    await store.updateChurch(updatedChurch);
    if (!mounted) return;

    if (store.errorMessage == null) {
      Toast.showMessage('Dados da igreja atualizados', ToastType.success);
    }
  }

  DateTime? _parseOpeningDate(String value) {
    final parts = value.split('/');
    if (parts.length != 3) {
      return null;
    }

    final month = int.tryParse(parts[0]);
    final day = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (month == null || day == null || year == null) {
      return null;
    }

    return DateTime(year, month, day);
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ChurchStore>();

    if (store.isLoading && store.church == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (store.errorMessage != null && store.church == null) {
      return Center(child: Text('Error: ${store.errorMessage}'));
    }

    if (store.church != null) {
      _populateFields(store.church!);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChurchProfileHeader(
                  onSave: _saveProfile,
                  isSaving: store.isLoading,
                ),
                const SizedBox(height: 32),
                _buildTabs(store, isDesktop),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabs(ChurchStore store, bool isDesktop) {
    final l10n = AppLocalizations.of(context)!;
    final profileContent =
        isDesktop ? _buildDesktopLayout(store) : _buildMobileLayout(store);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: _tabController,
            labelColor: AppColors.purple,
            unselectedLabelColor: AppColors.grey,
            indicator: BoxDecoration(
              color: AppColors.purple.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(text: l10n.settings_church_profile_title),
              const Tab(text: 'Bases doutrinárias'),
            ],
          ),
          const SizedBox(height: 24),
          AnimatedBuilder(
            animation: _tabController,
            builder: (context, _) {
              return IndexedStack(
                index: _tabController.index,
                children: [profileContent, _buildDoctrinalTabContent()],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(ChurchStore store) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildGeneralInfoCard(),
              const SizedBox(height: 24),
              _buildAddressCard(),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              const ChurchProfileLogoCard(),
              const SizedBox(height: 24),
              _buildWhatsAppCard(store),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(ChurchStore store) {
    return Column(
      children: [
        _buildGeneralInfoCard(),
        const SizedBox(height: 24),
        _buildAddressCard(),
        const SizedBox(height: 24),
        const ChurchProfileLogoCard(),
        const SizedBox(height: 24),
        _buildWhatsAppCard(store),
      ],
    );
  }

  Widget _buildDoctrinalTabContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildDoctrinalBasesCard()],
    );
  }

  Widget _buildGeneralInfoCard() {
    return ChurchProfileGeneralInfoCard(
      name: _name,
      openerDate: _openerDate,
      status: _status,
      email: _email,
      onNameChanged: (value) => _name = value,
      onEmailChanged: (value) => _email = value,
      onStatusChanged: (value) => _status = value,
      onDateTap: _selectDate,
    );
  }

  Widget _buildAddressCard() {
    return ChurchProfileAddressCard(
      cep: _cep,
      street: _street,
      number: _number,
      city: _city,
      state: _state,
      onCepChanged: (value) => _cep = value,
      onStreetChanged: (value) => _street = value,
      onNumberChanged: (value) => _number = value,
      onCityChanged: (value) => _city = value,
      onStateChanged: (value) => _state = value,
    );
  }

  Widget _buildDoctrinalBasesCard() {
    return ChurchProfileDoctrinalBasesCard(
      doctrinalBases: _doctrinalBases,
      onChanged: (value) {
        setState(() {
          _doctrinalBases = value;
        });
      },
    );
  }

  Widget _buildWhatsAppCard(ChurchStore store) {
    return ChurchProfileWhatsAppCard(
      church: store.church,
      onConnect: _launchMetaSignup,
    );
  }
}
