import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/features/auth/pages/login/store/auth_session_store.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/church_model.dart';
import '../services/church_service.dart';
import '../store/church_store.dart';
import 'widgets/church_profile_address_card.dart';
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

class _ChurchProfileContentState extends State<_ChurchProfileContent> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _openerDate = '';
  String _status = '';
  String _email = '';
  String _cep = '';
  String _street = '';
  String _number = '';
  String _city = '';
  String _state = '';

  @override
  void initState() {
    super.initState();
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
  }

  Future<void> _launchMetaSignup() async {
    final Map<String, String> queryParameters = {
      'client_id': "25820028151023925",
      'redirect_uri':
          kReleaseMode
              ? "https://devpto-dev--preview-chore-webhook-whatsaap-1k94yli1.web.app/church-profile"
              : "http://localhost:3000/church-profile",
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
                const ChurchProfileHeader(),
                const SizedBox(height: 48),
                if (isDesktop)
                  _buildDesktopLayout(store)
                else
                  _buildMobileLayout(store),
              ],
            ),
          ),
        );
      },
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

  Widget _buildWhatsAppCard(ChurchStore store) {
    return ChurchProfileWhatsAppCard(
      church: store.church,
      onConnect: _launchMetaSignup,
    );
  }
}
