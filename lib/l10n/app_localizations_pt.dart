// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get month_january => 'Janeiro';

  @override
  String get month_february => 'Fevereiro';

  @override
  String get month_march => 'Março';

  @override
  String get month_april => 'Abril';

  @override
  String get month_may => 'Maio';

  @override
  String get month_june => 'Junho';

  @override
  String get month_july => 'Julho';

  @override
  String get month_august => 'Agosto';

  @override
  String get month_september => 'Setembro';

  @override
  String get month_october => 'Outubro';

  @override
  String get month_november => 'Novembro';

  @override
  String get month_december => 'Dezembro';

  @override
  String get common_filters => 'Filtros';

  @override
  String get common_filters_upper => 'FILTROS';

  @override
  String get common_all_banks => 'Todos os bancos';

  @override
  String get common_all_status => 'Todos os status';

  @override
  String get common_all_months => 'Todos os meses';

  @override
  String get common_all_years => 'Todos os anos';

  @override
  String get common_bank => 'Banco';

  @override
  String get common_status => 'Status';

  @override
  String get common_start_date => 'Data inicial';

  @override
  String get common_end_date => 'Data final';

  @override
  String get common_month => 'Mês';

  @override
  String get common_year => 'Ano';

  @override
  String get common_clear_filters => 'Limpar filtros';

  @override
  String get common_loading => 'Carregando...';

  @override
  String get common_apply_filters => 'Aplicar filtros';

  @override
  String get common_load_more => 'Carregar mais';

  @override
  String get common_no_results_found => 'Nenhum resultado encontrado';

  @override
  String get common_search_hint => 'Buscar...';

  @override
  String get common_actions => 'Ações';

  @override
  String get common_edit => 'Editar';

  @override
  String get auth_login_email_label => 'E-mail';

  @override
  String get auth_login_password_label => 'Senha';

  @override
  String get auth_login_forgot_password => 'Esqueceu a senha?';

  @override
  String get auth_login_submit => 'Entrar';

  @override
  String get auth_login_error_invalid_email => 'Informe um e-mail válido';

  @override
  String get auth_login_error_required_password => 'Informe a senha';

  @override
  String get auth_error_generic => 'Ocorreu um erro interno no sistema, informe ao administrador do sistema';

  @override
  String get auth_recovery_request_title => 'Digite o e-mail associado à sua conta e enviaremos um e-mail com uma senha temporária.';

  @override
  String get auth_recovery_request_loading => 'Solicitando senha temporária';

  @override
  String get auth_recovery_request_submit => 'Enviar';

  @override
  String get auth_recovery_request_email_required => 'E-mail é obrigatório';

  @override
  String get auth_recovery_change_title => 'Defina uma nova senha';

  @override
  String get auth_recovery_change_description => 'Crie uma nova senha. Certifique-se de que seja diferente de anteriores para segurança';

  @override
  String get auth_recovery_old_password_label => 'Senha anterior';

  @override
  String get auth_recovery_new_password_label => 'Nova senha';

  @override
  String get auth_recovery_change_error_old_password_required => 'Informe a senha antiga';

  @override
  String get auth_recovery_change_error_new_password_required => 'Informe a nova senha';

  @override
  String get auth_recovery_change_error_min_length => 'A senha deve ter no mínimo 8 caracteres';

  @override
  String get auth_recovery_change_error_lowercase => 'A senha deve ter no mínimo uma letra minúscula';

  @override
  String get auth_recovery_change_error_uppercase => 'A senha deve ter no mínimo uma letra maiúscula';

  @override
  String get auth_recovery_change_error_number => 'A senha deve ter no mínimo um número';

  @override
  String get auth_recovery_success_title => 'Verifique seu e-mail';

  @override
  String auth_recovery_success_body(String email) {
    return 'Enviamos uma senha temporaria no e-mail $email se não encontrar verifique a caixa de spam.  Se recebeu o e-mail, clique no botāo abaxio.';
  }

  @override
  String get auth_recovery_success_continue => 'Continuar';

  @override
  String get auth_recovery_success_resend => 'Ainda não recebeu o e-mail? Reenviar e-mail';

  @override
  String get auth_recovery_success_resend_ok => 'E-mail reenviado com sucesso';

  @override
  String get auth_recovery_success_resend_error => 'Erro ao reenviar e-mail';

  @override
  String get auth_recovery_back_to_login => 'Voltar para fazer login';

  @override
  String get auth_policies_title => 'Antes de continuar, revise e aceite as políticas do Glória Finance';

  @override
  String get auth_policies_info_title => 'Informações importantes:';

  @override
  String get auth_policies_info_body => '• A igreja e o Glória Finance tratam dados pessoais e dados sensíveis para o funcionamento do sistema.\n\n• Em conformidade com a Lei Geral de Proteção de Dados (LGPD), é necessário que você aceite as políticas abaixo para continuar utilizando a plataforma.\n\n• Clique nos links para ler os textos completos antes de aceitar.';

  @override
  String get auth_policies_privacy => 'Política de Privacidade';

  @override
  String get auth_policies_sensitive => 'Política de Tratamento de Dados Sensíveis';

  @override
  String get auth_policies_accept_and_continue => 'Aceitar e Continuar';

  @override
  String auth_policies_link_error(String url) {
    return 'Não foi possível abrir o link: $url';
  }

  @override
  String get auth_policies_checkbox_prefix => 'Li e concordo com a ';

  @override
  String get auth_layout_version_loading => 'Carregando...';

  @override
  String auth_layout_footer(int year) {
    return '© $year Jaspesoft CNPJ 43.716.343/0001-60 ';
  }

  @override
  String get erp_menu_settings => 'Configuraçōes';

  @override
  String get erp_menu_settings_security => 'Security Settings';

  @override
  String get erp_menu_settings_users_access => 'Usuários e acesso';

  @override
  String get erp_menu_settings_roles_permissions => 'Papéis e permissões';

  @override
  String get erp_menu_settings_members => 'Membros';

  @override
  String get erp_menu_settings_financial_periods => 'Períodos Financeiros';

  @override
  String get erp_menu_settings_availability_accounts => 'Contas de disponibilidade';

  @override
  String get erp_menu_settings_banks => 'Bancos';

  @override
  String get erp_menu_settings_cost_centers => 'Centros de custo';

  @override
  String get erp_menu_settings_suppliers => 'Fornecedores';

  @override
  String get erp_menu_settings_financial_concepts => 'Conceitos financeiros';

  @override
  String get erp_menu_finance => 'Finanzas';

  @override
  String get erp_menu_finance_contributions => 'Contribuiçōes';

  @override
  String get erp_menu_finance_records => 'Registro financeiros';

  @override
  String get erp_menu_finance_bank_reconciliation => 'Conciliação bancária';

  @override
  String get erp_menu_finance_accounts_receivable => 'Contas a receber';

  @override
  String get erp_menu_finance_accounts_payable => 'Contas a pagar';

  @override
  String get erp_menu_finance_purchases => 'Compras';

  @override
  String get erp_menu_assets => 'Patrimônio';

  @override
  String get erp_menu_assets_items => 'Bens patrimoniais';

  @override
  String get erp_menu_reports => 'Relatórios';

  @override
  String get erp_menu_reports_monthly_tithes => 'Dízimos mensais';

  @override
  String get erp_menu_reports_income_statement => 'Estado de Ingresos';

  @override
  String get erp_menu_reports_dre => 'DRE';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_retry => 'Recarregar';

  @override
  String get common_processing => 'Processando...';

  @override
  String get patrimony_assets_list_title => 'Patrimônio';

  @override
  String get patrimony_assets_list_new => 'Registrar bem';

  @override
  String get patrimony_assets_filter_category => 'Categoria';

  @override
  String get patrimony_assets_table_error_loading => 'Não foi possível carregar os bens. Tente novamente.';

  @override
  String get patrimony_assets_table_empty => 'Nenhum bem encontrado com os filtros selecionados.';

  @override
  String get patrimony_assets_table_header_code => 'Código';

  @override
  String get patrimony_assets_table_header_name => 'Nome';

  @override
  String get patrimony_assets_table_header_category => 'Categoria';

  @override
  String get patrimony_assets_table_header_value => 'Valor';

  @override
  String get patrimony_assets_table_header_acquisition => 'Aquisição';

  @override
  String get patrimony_assets_table_header_location => 'Localização';

  @override
  String get patrimony_inventory_import_file_label => 'Arquivo CSV preenchido';

  @override
  String patrimony_inventory_import_file_size(int size) {
    return 'Tamanho: $size KB';
  }

  @override
  String get patrimony_inventory_import_description_title => 'Envie o checklist físico preenchido para atualizar os bens.';

  @override
  String get patrimony_inventory_import_description_body => 'Certifique-se de manter as colunas \"ID do ativo\", \"Código inventário\" e \"Quantidade inventário\" preenchidas. Campos opcionais como status e observações também serão processados, quando informados.';

  @override
  String get patrimony_inventory_import_button_loading => 'Importando...';

  @override
  String get patrimony_inventory_import_button_submit => 'Importar checklist';

  @override
  String get patrimony_inventory_import_error_no_file => 'Selecione o arquivo exportado antes de importar.';

  @override
  String get patrimony_inventory_import_error_read_file => 'Não foi possível ler o arquivo selecionado.';

  @override
  String get patrimony_inventory_import_error_generic => 'Não foi possível importar o checklist. Tente novamente.';

  @override
  String get patrimony_asset_detail_tab_details => 'Detalhes';

  @override
  String get patrimony_asset_detail_tab_history => 'Histórico';

  @override
  String get patrimony_asset_detail_category => 'Categoria';

  @override
  String get patrimony_asset_detail_quantity => 'Quantidade';

  @override
  String get patrimony_asset_detail_acquisition_date => 'Data de aquisição';

  @override
  String get patrimony_asset_detail_location => 'Localização';

  @override
  String get patrimony_asset_detail_responsible => 'Responsável';

  @override
  String get patrimony_asset_detail_pending_documents => 'Documentos pendentes';

  @override
  String get patrimony_asset_detail_notes => 'Observações';

  @override
  String patrimony_asset_detail_quantity_badge(int quantity) {
    return 'Qtd: $quantity';
  }

  @override
  String patrimony_asset_detail_updated_at(String date) {
    return 'Atualizado em $date';
  }

  @override
  String get patrimony_asset_detail_inventory_register => 'Registrar inventário';

  @override
  String get patrimony_asset_detail_inventory_update => 'Atualizar inventário';

  @override
  String get patrimony_asset_detail_inventory_modal_title => 'Registrar inventário físico';

  @override
  String get patrimony_asset_detail_inventory_success => 'Inventário registrado com sucesso.';

  @override
  String get patrimony_asset_detail_disposal_register => 'Registrar baixa';

  @override
  String get patrimony_asset_detail_disposal_modal_title => 'Registrar baixa';

  @override
  String get patrimony_asset_detail_disposal_success => 'Baixa registrada';

  @override
  String get patrimony_asset_detail_disposal_error => 'Erro ao registrar baixa';

  @override
  String get patrimony_asset_detail_disposal_status => 'Status';

  @override
  String get patrimony_asset_detail_disposal_reason => 'Motivo';

  @override
  String get patrimony_asset_detail_disposal_date => 'Data da baixa';

  @override
  String get patrimony_asset_detail_disposal_performed_by => 'Registrado por';

  @override
  String get patrimony_asset_detail_disposal_value => 'Valor da baixa';

  @override
  String get patrimony_asset_detail_inventory_result => 'Resultado';

  @override
  String get patrimony_asset_detail_inventory_checked_at => 'Data da conferência';

  @override
  String get patrimony_asset_detail_inventory_checked_by => 'Conferido por';

  @override
  String get patrimony_asset_detail_inventory_title => 'Inventário físico';

  @override
  String get patrimony_asset_detail_attachments_empty => 'Nenhum anexo disponível.';

  @override
  String get patrimony_asset_detail_attachments_title => 'Anexos';

  @override
  String get patrimony_asset_detail_attachment_view_pdf => 'Ver PDF';

  @override
  String get patrimony_asset_detail_attachment_open => 'Abrir';

  @override
  String get patrimony_asset_detail_history_empty => 'Sem histórico de alterações.';

  @override
  String get patrimony_asset_detail_history_title => 'Histórico de movimentações';

  @override
  String get patrimony_asset_detail_history_changes_title => 'Alterações registradas';

  @override
  String get patrimony_asset_detail_yes => 'Sim';

  @override
  String get patrimony_asset_detail_no => 'Não';

  @override
  String get erp_header_change_password => 'Trocar senha';

  @override
  String get erp_header_logout => 'Sair';

  @override
  String get auth_policies_submit_error_null => 'Não foi possível registrar o aceite. Tente novamente.';

  @override
  String get auth_policies_submit_error_generic => 'Ocorreu um erro ao registrar o aceite. Tente novamente.';

  @override
  String get auth_recovery_step_title_request => 'Enviar senha temporaria';

  @override
  String get auth_recovery_step_title_confirm => 'Confirmaçāo do recevimento da senha temporaria';

  @override
  String get auth_recovery_step_title_new_password => 'Definir nova senha';

  @override
  String get erp_home_welcome_member => 'Seja bem-vindo ao Church Finance!\\n\\n';

  @override
  String get erp_home_no_availability_accounts => 'Nenhuma conta de disponibilidade encontrada';

  @override
  String get erp_home_availability_summary_title => 'Resumo de contas de disponibilidade';

  @override
  String get erp_home_availability_swipe_hint => 'Deslize para ver todas as contas';

  @override
  String get erp_home_header_title => 'Dashboard';

  @override
  String get settings_banks_title => 'Bancos';

  @override
  String get settings_banks_new_bank => 'Novo banco';

  @override
  String get settings_banks_form_title_create => 'Novo banco';

  @override
  String get settings_banks_form_title_edit => 'Editar banco';

  @override
  String get settings_banks_field_name => 'Nome';

  @override
  String get settings_banks_field_holder_name => 'Nome do titular';

  @override
  String get settings_banks_field_document_id => 'Documento';

  @override
  String get settings_banks_field_tag => 'Tag';

  @override
  String get settings_banks_field_account_type => 'Tipo de conta';

  @override
  String get settings_banks_field_pix_key => 'Chave PIX';

  @override
  String get settings_banks_field_bank_code => 'Código do banco';

  @override
  String get settings_banks_field_agency => 'Agência';

  @override
  String get settings_banks_field_account => 'Conta';

  @override
  String get settings_banks_field_active => 'Ativo';

  @override
  String get settings_banks_error_required => 'Campo obrigatório';

  @override
  String get settings_banks_error_invalid_number => 'Digite um número válido';

  @override
  String get settings_banks_error_select_account_type => 'Selecione o tipo de conta';

  @override
  String get settings_banks_save => 'Salvar';

  @override
  String get settings_banks_toast_saved => 'Registro salvo com sucesso';

  @override
  String get settings_availability_list_title => 'Listagem de contas';

  @override
  String get settings_availability_new_account => 'Conta disponiblidade';

  @override
  String get settings_availability_form_title => 'Cadastro de conta de desponibilidade';

  @override
  String get settings_availability_save => 'Salvar';

  @override
  String get settings_availability_toast_saved => 'Registro salvo com sucesso';

  @override
  String get settings_availability_table_header_name => 'Nome da conta';

  @override
  String get settings_availability_table_header_type => 'Tipo de conta';

  @override
  String get settings_availability_table_header_balance => 'Saldo';

  @override
  String get settings_availability_table_header_status => 'Status';

  @override
  String settings_availability_view_title(String id) {
    return 'Conta de disponibilidade #$id';
  }

  @override
  String get settings_availability_field_name => 'Nome';

  @override
  String get settings_availability_field_balance => 'Saldo';

  @override
  String get settings_availability_field_type => 'Tipo';

  @override
  String get settings_availability_field_active => 'Ativa';

  @override
  String get settings_availability_field_bank => 'Banco';

  @override
  String get settings_availability_field_currency => 'Moeda';

  @override
  String get settings_availability_bank_details_title => 'Dados do banco';

  @override
  String get settings_availability_account_type_bank => 'Banco';

  @override
  String get settings_availability_account_type_cash => 'Dinheiro';

  @override
  String get settings_availability_account_type_wallet => 'Carteira digital';

  @override
  String get settings_availability_account_type_investment => 'Investimento';

  @override
  String get settings_cost_center_title => 'Centros de custo';

  @override
  String get settings_cost_center_new => 'Novo centro de custo';

  @override
  String get settings_cost_center_field_code => 'Código';

  @override
  String get settings_cost_center_field_name => 'Nome';

  @override
  String get settings_cost_center_field_category => 'Categoria';

  @override
  String get settings_cost_center_field_responsible => 'Responsável';

  @override
  String get settings_cost_center_field_description => 'Descrição';

  @override
  String get settings_cost_center_field_active => 'Ativo';

  @override
  String get settings_cost_center_category_special_project => 'Projetos especiais';

  @override
  String get settings_cost_center_category_ministries => 'Ministérios';

  @override
  String get settings_cost_center_category_operations => 'Operações';

  @override
  String get settings_cost_center_error_required => 'Campo obrigatório';

  @override
  String get settings_cost_center_error_select_category => 'Selecione a categoria';

  @override
  String get settings_cost_center_error_select_responsible => 'Selecione o responsável';

  @override
  String settings_cost_center_help_code(int maxLength) {
    return 'Use um código fácil de lembrar com até $maxLength caracteres.';
  }

  @override
  String get settings_cost_center_help_description => 'Descreva de forma objetiva como este centro de custo será utilizado.';

  @override
  String get settings_cost_center_save => 'Salvar';

  @override
  String get settings_cost_center_update => 'Atualizar';

  @override
  String get settings_cost_center_toast_saved => 'Registro salvo com sucesso';

  @override
  String get settings_cost_center_toast_updated => 'Registro atualizado com sucesso';

  @override
  String get settings_financial_concept_title => 'Conceitos financeiros';

  @override
  String get settings_financial_concept_new => 'Novo conceito';

  @override
  String get settings_financial_concept_filter_all => 'Todos';

  @override
  String get settings_financial_concept_filter_by_type => 'Filtrar por tipo';

  @override
  String get settings_financial_concept_field_name => 'Nome';

  @override
  String get settings_financial_concept_field_description => 'Descrição';

  @override
  String get settings_financial_concept_field_type => 'Tipo de conceito';

  @override
  String get settings_financial_concept_field_statement_category => 'Categoria do demonstrativo';

  @override
  String get settings_financial_concept_field_active => 'Ativo';

  @override
  String get settings_financial_concept_indicators_title => 'Indicadores contábeis';

  @override
  String get settings_financial_concept_indicator_cash_flow => 'Impacta fluxo de caixa';

  @override
  String get settings_financial_concept_indicator_result => 'Impacta o resultado (DRE)';

  @override
  String get settings_financial_concept_indicator_balance => 'Impacta o balanço patrimonial';

  @override
  String get settings_financial_concept_indicator_operational => 'Evento operacional recorrente';

  @override
  String get settings_financial_concept_error_required => 'Campo obrigatório';

  @override
  String get settings_financial_concept_error_select_type => 'Selecione o tipo';

  @override
  String get settings_financial_concept_error_select_category => 'Selecione a categoria';

  @override
  String get settings_financial_concept_help_statement_categories => 'Entenda as categorias';

  @override
  String get settings_financial_concept_help_indicators => 'Entenda os indicadores';

  @override
  String get settings_financial_concept_save => 'Salvar';

  @override
  String get settings_financial_concept_toast_saved => 'Registro salvo com sucesso';

  @override
  String get settings_financial_concept_help_statement_title => 'Categorias do demonstrativo';

  @override
  String get settings_financial_concept_help_indicator_intro => 'Esses indicadores determinam como o conceito será refletido nos relatórios financeiros. Eles podem ser ajustados conforme necessário para casos específicos.';

  @override
  String get settings_financial_concept_help_indicator_cash_flow_title => 'Impacta fluxo de caixa';

  @override
  String get settings_financial_concept_help_indicator_cash_flow_desc => 'Marque quando o lançamento altera o saldo disponível após o pagamento ou recebimento.';

  @override
  String get settings_financial_concept_help_indicator_result_title => 'Impacta o resultado (DRE)';

  @override
  String get settings_financial_concept_help_indicator_result_desc => 'Use quando o valor deve compor a Demonstração do Resultado, afetando lucro ou prejuízo.';

  @override
  String get settings_financial_concept_help_indicator_balance_title => 'Impacta o balanço patrimonial';

  @override
  String get settings_financial_concept_help_indicator_balance_desc => 'Selecione para eventos que criam ou liquidam ativos e passivos diretamente no balanço.';

  @override
  String get settings_financial_concept_help_indicator_operational_title => 'Evento operacional recorrente';

  @override
  String get settings_financial_concept_help_indicator_operational_desc => 'Habilite para compromissos rotineiros do dia a dia da igreja, ligados às operações principais.';

  @override
  String get settings_financial_concept_help_understood => 'Entendi';

  @override
  String get bankStatements_empty_title => 'Nenhum extrato importado ainda.';

  @override
  String get bankStatements_empty_subtitle => 'Importe um arquivo CSV para iniciar a conciliação bancária.';

  @override
  String get bankStatements_header_date => 'Data';

  @override
  String get bankStatements_header_bank => 'Banco';

  @override
  String get bankStatements_header_description => 'Descrição';

  @override
  String get bankStatements_header_amount => 'Valor';

  @override
  String get bankStatements_header_direction => 'Direção';

  @override
  String get bankStatements_header_status => 'Status';

  @override
  String get bankStatements_action_details => 'Detalhes';

  @override
  String get bankStatements_action_retry => 'Reprocessar';

  @override
  String get bankStatements_action_link => 'Vincular';

  @override
  String get bankStatements_action_linking => 'Vinculando...';

  @override
  String get bankStatements_toast_auto_reconciled => 'Extrato conciliado automaticamente.';

  @override
  String get bankStatements_toast_no_match => 'Nenhum lançamento correspondente encontrado.';

  @override
  String get bankStatements_details_title => 'Detalhes do extrato bancário';

  @override
  String get bankStatements_toast_link_success => 'Extrato vinculado com sucesso.';

  @override
  String get settings_financial_months_empty => 'Nenhum mês financeiro encontrado.';

  @override
  String get settings_financial_months_header_month => 'Mês';

  @override
  String get settings_financial_months_header_year => 'Ano';

  @override
  String get settings_financial_months_header_status => 'Status';

  @override
  String get settings_financial_months_action_reopen => 'Reabrir';

  @override
  String get settings_financial_months_action_close => 'Fechar';

  @override
  String get settings_financial_months_modal_close_title => 'Fechar Mês';

  @override
  String get settings_financial_months_modal_reopen_title => 'Reabrir Mês';

  @override
  String get accountsReceivable_list_title => 'Lista de contas a receber';

  @override
  String get accountsReceivable_list_title_mobile => 'Contas a receber';

  @override
  String get accountsReceivable_list_new => 'Registrar conta a receber';

  @override
  String get accountsReceivable_table_empty => 'Nenhuma conta a receber encontrada';

  @override
  String get accountsReceivable_table_header_debtor => 'Devedor';

  @override
  String get accountsReceivable_table_header_description => 'Descrição';

  @override
  String get accountsReceivable_table_header_type => 'Tipo';

  @override
  String get accountsReceivable_table_header_installments => 'Nro. parcelas';

  @override
  String get accountsReceivable_table_header_received => 'Recebido';

  @override
  String get accountsReceivable_table_header_pending => 'Pendente';

  @override
  String get accountsReceivable_table_header_total => 'Total a receber';

  @override
  String get accountsReceivable_table_header_status => 'Status';

  @override
  String get accountsReceivable_table_action_view => 'Visualizar';

  @override
  String get accountsReceivable_register_title => 'Registro de contas a receber';

  @override
  String get accountsReceivable_view_title => 'Detalhe da conta a receber';

  @override
  String get accountsReceivable_form_field_financial_concept => 'Conceito financeiro';

  @override
  String get accountsReceivable_form_field_debtor_dni => 'CNPJ/CPJ do devedor';

  @override
  String get accountsReceivable_form_field_debtor_phone => 'Telefone do devedor';

  @override
  String get accountsReceivable_form_field_debtor_name => 'Nome do devedor';

  @override
  String get accountsReceivable_form_field_debtor_email => 'E-mail do devedor';

  @override
  String get accountsReceivable_form_field_debtor_address => 'Endereço do devedor';

  @override
  String get accountsReceivable_form_field_member => 'Selecione o membro';

  @override
  String get accountsReceivable_form_field_single_due_date => 'Data de vencimento';

  @override
  String get accountsReceivable_form_field_automatic_installments => 'Quantidade de parcelas';

  @override
  String get accountsReceivable_form_field_automatic_amount => 'Valor por parcela';

  @override
  String get accountsReceivable_form_error_member_required => 'Selecione um membro';

  @override
  String get accountsReceivable_form_error_description_required => 'Descrição é obrigatória';

  @override
  String get accountsReceivable_form_error_financial_concept_required => 'Selecione um conceito financeiro';

  @override
  String get accountsReceivable_form_error_debtor_name_required => 'Nome do devedor é obrigatório';

  @override
  String get accountsReceivable_form_error_debtor_dni_required => 'Identificador do devedor é obrigatório';

  @override
  String get accountsReceivable_form_error_debtor_phone_required => 'Telefone do devedor é obrigatório';

  @override
  String get accountsReceivable_form_error_debtor_email_required => 'E-mail do devedor é obrigatório';

  @override
  String get accountsReceivable_form_error_total_amount_required => 'Informe o valor total';

  @override
  String get accountsReceivable_form_error_single_due_date_required => 'Informe a data de vencimento';

  @override
  String get accountsReceivable_form_error_installments_required => 'Gere as parcelas para continuar';

  @override
  String get accountsReceivable_form_error_installments_invalid => 'Preencha valor e vencimento de cada parcela';

  @override
  String get accountsReceivable_form_error_automatic_installments_required => 'Informe a quantidade de parcelas';

  @override
  String get accountsReceivable_form_error_automatic_amount_required => 'Informe o valor por parcela';

  @override
  String get accountsReceivable_form_error_automatic_first_due_date_required => 'Informe a data da primeira parcela';

  @override
  String get accountsReceivable_form_error_installments_count_mismatch => 'A quantidade de parcelas geradas deve corresponder ao total informado';

  @override
  String get accountsReceivable_form_debtor_type_title => 'Tipo de devedor';

  @override
  String get accountsReceivable_form_debtor_type_member => 'Membro da igreja';

  @override
  String get accountsReceivable_form_debtor_type_external => 'Externo';

  @override
  String get accountsReceivable_form_installments_single_empty_message => 'Informe o valor e a data de vencimento para visualizar o resumo.';

  @override
  String get accountsReceivable_form_installments_automatic_empty_message => 'Informe os dados e clique em \"Gerar parcelas\" para visualizar o cronograma.';

  @override
  String get accountsReceivable_form_installments_summary_title => 'Resumo das parcelas';

  @override
  String accountsReceivable_form_installment_item_title(int index) {
    return 'Parcela $index';
  }

  @override
  String accountsReceivable_form_installment_item_due_date(String date) {
    return 'Vencimento: $date';
  }

  @override
  String accountsReceivable_form_installments_summary_total(String amount) {
    return 'Total: $amount';
  }

  @override
  String get accountsReceivable_form_save => 'Salvar';

  @override
  String get accountsReceivable_form_toast_saved_success => 'Conta a receber registrada com sucesso!';

  @override
  String get accountsReceivable_form_toast_saved_error => 'Erro ao registrar conta a receber';

  @override
  String get accountsReceivable_view_debtor_section => 'Informações do devedor';

  @override
  String get accountsReceivable_view_debtor_name => 'Nome';

  @override
  String get accountsReceivable_view_debtor_dni => 'CPF/CNPJ';

  @override
  String get accountsReceivable_view_debtor_type => 'Tipo de devedor';

  @override
  String get accountsReceivable_view_installments_title => 'Listagem de parcelas';

  @override
  String get accountsReceivable_view_register_payment => 'Registrar pagamento';

  @override
  String get accountsReceivable_view_general_section => 'Informações gerais';

  @override
  String get accountsReceivable_view_general_created => 'Criado';

  @override
  String get accountsReceivable_view_general_updated => 'Atualizado';

  @override
  String get accountsReceivable_view_general_description => 'Descrição';

  @override
  String get accountsReceivable_view_general_type => 'Tipo';

  @override
  String get accountsReceivable_view_general_total => 'Valor total';

  @override
  String get accountsReceivable_view_general_paid => 'Valor pago';

  @override
  String get accountsReceivable_view_general_pending => 'Valor pendente';

  @override
  String get accountsReceivable_payment_total_label => 'Valor total que deve ser pago';

  @override
  String get accountsReceivable_payment_submit => 'Enviar pagamento';

  @override
  String get accountsReceivable_payment_receipt_label => 'Comprovante da transferência';

  @override
  String get accountsReceivable_payment_availability_account_label => 'Conta de disponibilidade';

  @override
  String get accountsReceivable_payment_amount_label => 'Valor do pagamento';

  @override
  String get accountsReceivable_payment_toast_success => 'Pagamento registrado com sucesso';

  @override
  String get accountsReceivable_payment_error_amount_required => 'Informe o valor do pagamento';

  @override
  String get accountsReceivable_payment_error_availability_account_required => 'Selecione uma conta de disponibilidade';

  @override
  String get accountsReceivable_form_field_automatic_first_due_date => 'Primeiro vencimento';

  @override
  String get accountsReceivable_form_generate_installments => 'Gerar parcelas';

  @override
  String get accountsReceivable_form_error_generate_installments_fill_data => 'Preencha os dados para gerar as parcelas.';

  @override
  String get accountsReceivable_form_toast_generate_installments_success => 'Parcelas geradas automaticamente.';

  @override
  String get accountsPayable_list_title => 'Contas a pagar';

  @override
  String get accountsPayable_list_new => 'Registrar Contas a pagar';

  @override
  String get accountsPayable_table_empty => 'Nāo ha contas a pagar para mostrar';

  @override
  String get accountsPayable_table_header_supplier => 'Fornecedor';

  @override
  String get accountsPayable_table_header_description => 'Descricao';

  @override
  String get accountsPayable_table_header_installments => 'Nro. parcelas';

  @override
  String get accountsPayable_table_header_paid => 'Pago';

  @override
  String get accountsPayable_table_header_pending => 'Pendente';

  @override
  String get accountsPayable_table_header_total => 'Total a pagar';

  @override
  String get accountsPayable_table_header_status => 'Status';

  @override
  String get accountsPayable_table_action_view => 'Visualizar';

  @override
  String get accountsPayable_register_title => 'Registrar Conta a Pagar';

  @override
  String get accountsPayable_view_title => 'Detalhe da Contas a pagar';

  @override
  String get accountsPayable_view_installments_title => 'Listagem de Parcelas';

  @override
  String get accountsPayable_view_register_payment => 'Registrar Pagamento';

  @override
  String get accountsPayable_view_provider_section => 'Informações do Fornecedor';

  @override
  String get accountsPayable_view_provider_name => 'Nome';

  @override
  String get accountsPayable_view_provider_dni => 'CNPJ/CPF';

  @override
  String get accountsPayable_view_provider_phone => 'Phone';

  @override
  String get accountsPayable_view_provider_email => 'E-mail';

  @override
  String get accountsPayable_view_provider_type => 'Tipo de fornecedor';

  @override
  String get accountsPayable_view_general_section => 'Informações Gerais';

  @override
  String get accountsPayable_view_general_created => 'Criado';

  @override
  String get accountsPayable_view_general_updated => 'Atualizado';

  @override
  String get accountsPayable_view_general_description => 'Descrição';

  @override
  String get accountsPayable_view_general_total => 'Valor Total';

  @override
  String get accountsPayable_view_general_paid => 'Valor Pago';

  @override
  String get accountsPayable_view_general_pending => 'Valor Pendente';

  @override
  String get accountsPayable_payment_total_label => 'Valor total que deve ser pago';

  @override
  String get accountsPayable_payment_submit => 'Enviar Pagamento';

  @override
  String get accountsPayable_payment_receipt_label => 'Comprovante da transferência';

  @override
  String get accountsPayable_payment_cost_center_label => 'Centro de custo';

  @override
  String get accountsPayable_payment_availability_account_label => 'Conta de disponibilidade';

  @override
  String get accountsPayable_payment_amount_label => 'Valor do Pagamento';

  @override
  String get accountsPayable_payment_toast_success => 'Pagamento registrado com sucesso';

  @override
  String get accountsPayable_form_section_basic_title => 'Informações básicas';

  @override
  String get accountsPayable_form_section_basic_subtitle => 'Escolha o fornecedor e descreva a conta a pagar.';

  @override
  String get accountsPayable_form_section_document_title => 'Documento fiscal';

  @override
  String get accountsPayable_form_section_document_subtitle => 'Informe o documento fiscal associado ao pagamento.';

  @override
  String get accountsPayable_form_section_tax_title => 'Tributação da nota fiscal';

  @override
  String get accountsPayable_form_section_tax_subtitle => 'Classifique a nota e informe os impostos destacados.';

  @override
  String get accountsPayable_form_section_payment_title => 'Configuração do pagamento';

  @override
  String get accountsPayable_form_section_payment_subtitle => 'Defina como essa conta será quitada e revise o cronograma de parcelas.';

  @override
  String get accountsPayable_form_field_supplier => 'Fornecedor';

  @override
  String get accountsPayable_form_field_description => 'Descrição';

  @override
  String get accountsPayable_form_field_document_type => 'Tipo de documento';

  @override
  String get accountsPayable_form_field_document_number => 'Número do documento';

  @override
  String get accountsPayable_form_field_document_date => 'Data do documento';

  @override
  String get accountsPayable_form_field_tax_exempt_switch => 'Nota fiscal isenta de impostos';

  @override
  String get accountsPayable_form_field_tax_exemption_reason => 'Motivo da isenção';

  @override
  String get accountsPayable_form_field_tax_observation => 'Observações';

  @override
  String get accountsPayable_form_field_tax_cst => 'Código CST';

  @override
  String get accountsPayable_form_field_tax_cfop => 'CFOP';

  @override
  String get accountsPayable_form_section_payment_mode_help_cst => 'Ajuda rápida sobre CST';

  @override
  String get accountsPayable_form_section_payment_mode_help_cfop => 'Ajuda rápida sobre CFOP';

  @override
  String get accountsPayable_form_error_supplier_required => 'O fornecedor é obrigatório';

  @override
  String get accountsPayable_form_error_description_required => 'A descrição é obrigatória';

  @override
  String get accountsPayable_form_error_document_type_required => 'Selecione o tipo de documento';

  @override
  String get accountsPayable_form_error_document_number_required => 'Informe o número do documento';

  @override
  String get accountsPayable_form_error_document_date_required => 'Informe a data do documento';

  @override
  String get accountsPayable_form_error_total_amount_required => 'Informe um valor maior que zero';

  @override
  String get accountsPayable_form_error_single_due_date_required => 'Informe a data de vencimento';

  @override
  String get accountsPayable_form_error_installments_required => 'Gere ou adicione ao menos uma parcela';

  @override
  String get accountsPayable_form_error_installments_contents => 'Preencha valor e vencimento de cada parcela';

  @override
  String get accountsPayable_form_error_automatic_installments_required => 'Informe a quantidade de parcelas';

  @override
  String get accountsPayable_form_error_automatic_amount_required => 'Informe o valor por parcela';

  @override
  String get accountsPayable_form_error_automatic_first_due_date_required => 'Informe a data da primeira parcela';

  @override
  String get accountsPayable_form_error_installments_count_mismatch => 'A quantidade de parcelas geradas deve corresponder ao total informado';

  @override
  String get accountsPayable_form_error_taxes_required => 'Adicione os impostos retidos quando a nota não for isenta';

  @override
  String get accountsPayable_form_error_taxes_invalid => 'Informe tipo, percentual e valor para cada imposto';

  @override
  String get accountsPayable_form_error_tax_exemption_reason_required => 'Informe o motivo da isenção da nota fiscal';

  @override
  String get accountsPayable_form_error_installments_add_one => 'Adicione pelo menos uma parcela';

  @override
  String get accountsPayable_form_error_tax_exempt_must_not_have_taxes => 'Notas isentas não devem possuir impostos retidos';

  @override
  String get accountsPayable_form_error_tax_status_mismatch => 'Atualize a situação tributária conforme os impostos destacados';

  @override
  String get accountsPayable_form_installments_single_empty_message => 'Informe o valor e a data de vencimento para visualizar o resumo.';

  @override
  String get accountsPayable_form_installments_automatic_empty_message => 'Informe os dados e clique em \"Gerar parcelas\" para visualizar o cronograma.';

  @override
  String get accountsPayable_form_field_total_amount => 'Valor total';

  @override
  String get accountsPayable_form_field_single_due_date => 'Data de vencimento';

  @override
  String get accountsPayable_form_field_automatic_installments => 'Quantidade de parcelas';

  @override
  String get accountsPayable_form_field_automatic_amount => 'Valor por parcela';

  @override
  String get accountsPayable_form_field_automatic_first_due_date => 'Primeiro vencimento';

  @override
  String get accountsPayable_form_generate_installments => 'Gerar parcelas';

  @override
  String get accountsPayable_form_error_generate_installments_fill_data => 'Preencha os dados para gerar as parcelas.';

  @override
  String get accountsPayable_form_toast_generate_installments_success => 'Parcelas geradas com sucesso.';

  @override
  String get accountsPayable_form_installments_summary_title => 'Resumo das parcelas';

  @override
  String accountsPayable_form_installment_item_title(int index) {
    return 'Parcela $index';
  }

  @override
  String accountsPayable_form_installment_item_due_date(String date) {
    return 'Vencimento: $date';
  }

  @override
  String accountsPayable_form_installments_summary_total(String amount) {
    return 'Total: $amount';
  }

  @override
  String get accountsPayable_form_toast_saved_success => 'Conta a pagar registrada com sucesso!';

  @override
  String get accountsPayable_form_toast_saved_error => 'Erro ao registrar conta a pagar';

  @override
  String get accountsPayable_form_save => 'Salvar';

  @override
  String get reports_income_download_pdf => 'Baixar PDF';

  @override
  String get reports_income_download_success => 'PDF baixado com sucesso';

  @override
  String get reports_income_download_error => 'Não foi possível baixar o PDF';

  @override
  String get reports_income_download_error_generic => 'Erro ao baixar o PDF';

  @override
  String get reports_income_statement_monthly_title => 'Relatório financeiro mensal';

  @override
  String get reports_income_summary_net_revenue_title => 'Receita líquida';

  @override
  String get reports_income_summary_net_revenue_desc => 'Entradas provenientes das atividades regulares.';

  @override
  String get reports_income_summary_operating_expenses_title => 'Despesas operacionais';

  @override
  String get reports_income_summary_operating_expenses_desc => 'Custos necessários para manter a igreja ativa.';

  @override
  String get reports_income_summary_operating_income_title => 'Resultado operacional';

  @override
  String get reports_income_summary_operating_income_desc => 'Receitas menos despesas operacionais.';

  @override
  String get reports_income_summary_net_income_title => 'Resultado líquido';

  @override
  String get reports_income_summary_net_income_desc => 'Saldo final após itens extraordinários.';

  @override
  String get reports_income_category_revenue_title => 'Receitas';

  @override
  String get reports_income_category_revenue_desc => 'Entradas operacionais e doações recorrentes.';

  @override
  String get reports_income_category_cogs_title => 'Custos diretos';

  @override
  String get reports_income_category_cogs_desc => 'Custos diretos para entregar serviços ou projetos.';

  @override
  String get reports_income_category_opex_title => 'Despesas operacionais';

  @override
  String get reports_income_category_opex_desc => 'Despesas necessárias para manter a igreja ativa.';

  @override
  String get reports_income_category_capex_title => 'Investimentos de capital';

  @override
  String get reports_income_category_capex_desc => 'Investimentos e gastos de capital de longo prazo.';

  @override
  String get reports_income_category_other_title => 'Outras receitas/despesas';

  @override
  String get reports_income_category_other_desc => 'Receitas ou despesas extraordinárias.';

  @override
  String get reports_income_category_ministry_transfers_title => 'Repasses e contribuições ministeriais';

  @override
  String get reports_income_category_ministry_transfers_desc => 'Repasses de valores para ministérios ou departamentos da diretoria.';

  @override
  String get reports_income_category_unknown_title => 'Categoria';

  @override
  String get reports_income_category_help_revenue_body => 'Aqui entram os valores que a igreja recebe no período, como dízimos, ofertas e doações.\n\nEm termos simples: é o dinheiro que entrou.\n\nExemplo: contribuição mensal dos membros.';

  @override
  String get reports_income_category_help_cogs_body => 'São gastos diretamente ligados a uma ação, projeto ou evento específico.\n\nEm termos simples: sem esse gasto, aquela atividade não acontece.\n\nExemplo: compra de materiais para um evento social.';

  @override
  String get reports_income_category_help_opex_body => 'São os gastos do funcionamento normal da igreja no dia a dia.\n\nEm termos simples: custos para manter tudo em operação.\n\nExemplo: água, luz, internet, limpeza e equipe administrativa.';

  @override
  String get reports_income_category_help_ministry_transfers_body => 'Valores direcionados para ministérios, departamentos ou frentes específicas.\n\nEm termos simples: dinheiro que sai para sustentar áreas internas da igreja.\n\nExemplo: repasse mensal para ministério infantil ou música.';

  @override
  String get reports_income_category_help_capex_body => 'Gastos para melhorar ou adquirir bens de uso duradouro.\n\nEm termos simples: investimento de longo prazo, não gasto do dia a dia.\n\nExemplo: reforma, compra de equipamento de som ou projetor.';

  @override
  String get reports_income_category_help_other_body => 'Movimentos fora da rotina principal, que não se encaixam nas categorias anteriores.\n\nEm termos simples: casos pontuais.\n\nExemplo: venda de um bem antigo ou recebimento de reembolso.';

  @override
  String get reports_income_category_help_unknown_body => 'Esta linha representa um lançamento sem classificação detalhada.\n\nEm termos simples: existe movimento financeiro, mas a categoria não foi identificada.';

  @override
  String get reports_dre_download_pdf => 'Baixar PDF';

  @override
  String get reports_dre_download_success => 'PDF baixado com sucesso';

  @override
  String get reports_dre_download_error => 'Não foi possível baixar o PDF';

  @override
  String get reports_dre_download_error_generic => 'Erro ao baixar o PDF';

  @override
  String get reports_income_breakdown_title => 'Receitas e despesas por categoria';

  @override
  String get reports_income_breakdown_empty => 'Não há dados de receita e despesa para o período.';

  @override
  String get reports_income_breakdown_header_category => 'Categoria';

  @override
  String get reports_income_breakdown_header_income => 'Entradas';

  @override
  String get reports_income_breakdown_header_expenses => 'Saídas';

  @override
  String get reports_income_breakdown_header_balance => 'Saldo';

  @override
  String get reports_income_view_mode_cards => 'Cartões';

  @override
  String get reports_income_view_mode_table => 'Tabela';

  @override
  String reports_income_currency_badge(String symbols, String count) {
    return 'Moedas: $symbols ($count)';
  }

  @override
  String get reports_income_multi_currency_disclaimer => 'Valores exibidos por moeda. Totais não são somados entre moedas.';

  @override
  String get reports_income_empty_selected_period => 'Nenhum dado para o período selecionado.';

  @override
  String get reports_income_cashflow_title => 'Fluxo de caixa por conta de disponibilidade';

  @override
  String reports_income_cashflow_summary(String income, String expenses, String total) {
    return 'Entradas totais: $income | Saídas totais: $expenses | Saldo consolidado: $total';
  }

  @override
  String get reports_income_cashflow_empty => 'Nenhuma movimentação de contas de disponibilidade neste período.';

  @override
  String get reports_income_cashflow_header_account => 'Conta';

  @override
  String get reports_income_cashflow_header_income => 'Entradas';

  @override
  String get reports_income_cashflow_header_expenses => 'Saídas';

  @override
  String get reports_income_cashflow_header_balance => 'Saldo do período';

  @override
  String get reports_income_cost_centers_title => 'Uso dos centros de custo';

  @override
  String reports_income_cost_centers_total_applied(String total) {
    return 'Total aplicado: $total';
  }

  @override
  String get reports_income_cost_centers_empty => 'Nenhum centro de custo movimentado neste período.';

  @override
  String get reports_income_cost_centers_header_name => 'Centro de custo';

  @override
  String get reports_income_cost_centers_header_total => 'Total aplicado';

  @override
  String get reports_income_cost_centers_header_last_move => 'Último movimento';

  @override
  String get trends_header_title => 'Composição de Receitas, Despesas e Resultado';

  @override
  String trends_header_comparison(String currentMonthYear, String previousMonthYear) {
    return 'Comparativo: $currentMonthYear vs $previousMonthYear';
  }

  @override
  String get trends_list_revenue => 'Receita';

  @override
  String get trends_list_opex => 'Despesas operacionais';

  @override
  String get trends_list_transfers => 'Repasses ministeriais';

  @override
  String get trends_list_capex => 'Investimentos';

  @override
  String get trends_list_net_income => 'Resultado líquido';

  @override
  String get trends_summary_revenue => 'Receita';

  @override
  String get trends_summary_opex => 'Operacionais';

  @override
  String get trends_summary_transfers => 'Repasses';

  @override
  String get trends_summary_capex => 'Investimentos';

  @override
  String get trends_summary_net_income => 'Resultado';

  @override
  String get reports_dre_screen_title => 'DRE - Demonstração do Resultado do Exercício';

  @override
  String get reports_dre_header_title => 'Demonstração do Resultado do Exercício';

  @override
  String get reports_dre_header_subtitle => 'Entenda como sua igreja recebeu e utilizou os recursos no período';

  @override
  String get reports_dre_footer_note => 'Nota: Este relatório considera apenas lançamentos confirmados e reconciliados que afetam o resultado contábil.';

  @override
  String get reports_dre_summary_by_currency_title => 'Resumo por moeda';

  @override
  String get reports_dre_primary_currency_badge => 'Moeda principal';

  @override
  String reports_dre_summary_chip_gross_revenue(String value) {
    return 'Receita bruta: $value';
  }

  @override
  String reports_dre_summary_chip_net_result(String value) {
    return 'Resultado líquido: $value';
  }

  @override
  String reports_dre_section_title_by_symbol(String symbol) {
    return '$symbol - Indicadores do período';
  }

  @override
  String get reports_dre_section_subtitle => 'Resumo do resultado nesta moeda.';

  @override
  String get reports_dre_main_indicators_title => 'Indicadores principais';

  @override
  String get reports_dre_card_gross_revenue_title => 'Receita bruta';

  @override
  String get reports_dre_card_gross_revenue_description => 'Total de dízimos, ofertas e doações recebidas';

  @override
  String get reports_dre_card_operational_result_title => 'Resultado operacional';

  @override
  String get reports_dre_card_operational_result_description => 'Resultado bruto menos despesas operacionais';

  @override
  String get reports_dre_card_net_result_title => 'Resultado líquido';

  @override
  String get reports_dre_card_net_result_description => 'Resultado final do período (superávit ou déficit)';

  @override
  String get reports_dre_detail_section_title => 'Detalhamento';

  @override
  String get reports_dre_detail_by_category => 'Detalhe por categoria';

  @override
  String get reports_dre_toggle_hide_zero => 'Ocultar linhas com valor zerado';

  @override
  String get reports_dre_group_revenue => 'Receitas';

  @override
  String get reports_dre_group_costs => 'Custos';

  @override
  String get reports_dre_group_results => 'Resultado';

  @override
  String get reports_dre_item_net_revenue_title => 'Receita líquida';

  @override
  String get reports_dre_item_net_revenue_description => 'Receita bruta menos devoluções e ajustes';

  @override
  String get reports_dre_item_direct_costs_title => 'Custos diretos';

  @override
  String get reports_dre_item_direct_costs_description => 'Gastos de eventos, materiais e atividades específicas';

  @override
  String get reports_dre_item_gross_profit_title => 'Resultado bruto';

  @override
  String get reports_dre_item_gross_profit_description => 'Receita líquida menos custos diretos';

  @override
  String get reports_dre_item_operational_expenses_title => 'Despesas operacionais';

  @override
  String get reports_dre_item_operational_expenses_description => 'Gastos do dia a dia: energia, água, salários, limpeza';

  @override
  String get reports_dre_item_ministry_transfers_title => 'Repasses ministeriais';

  @override
  String get reports_dre_item_ministry_transfers_description => 'Transferências para ministérios, missões ou para a diretoria';

  @override
  String get reports_dre_item_capex_title => 'Investimentos CAPEX';

  @override
  String get reports_dre_item_capex_description => 'Aquisição ou melhoria de ativos e infraestrutura';

  @override
  String get reports_dre_item_extraordinary_title => 'Resultados extraordinários';

  @override
  String get reports_dre_item_extraordinary_description => 'Ingressos ou gastos eventuais fora da rotina';

  @override
  String reports_dre_help_dialog_title(String title) {
    return 'Ajuda: $title';
  }

  @override
  String get reports_dre_help_what_means => 'O que significa?';

  @override
  String get reports_dre_help_example => 'Exemplo';

  @override
  String get reports_dre_help_understood => 'Entendi';

  @override
  String get reports_dre_help_gross_revenue_meaning => 'Total de entradas recebidas no período, como dízimos, ofertas e doações.';

  @override
  String get reports_dre_help_gross_revenue_example => 'Se entraram R\\\$ 5.000 no mês, esta linha mostra R\\\$ 5.000.';

  @override
  String get reports_dre_help_net_revenue_meaning => 'Receita bruta após devoluções e ajustes. Em muitos casos será igual à receita bruta.';

  @override
  String get reports_dre_help_net_revenue_example => 'Sem devoluções, receita líquida = receita bruta.';

  @override
  String get reports_dre_help_direct_costs_meaning => 'Gastos diretamente ligados a ações ou projetos específicos.';

  @override
  String get reports_dre_help_direct_costs_example => 'Compra de materiais para um evento social.';

  @override
  String get reports_dre_help_gross_profit_meaning => 'Valor que sobra após descontar os custos diretos da receita líquida.';

  @override
  String get reports_dre_help_gross_profit_example => 'Receita líquida R\\\$ 10.000 e custos diretos R\\\$ 2.000 resultam em R\\\$ 8.000.';

  @override
  String get reports_dre_help_operational_expenses_meaning => 'Despesas do funcionamento diário da igreja.';

  @override
  String get reports_dre_help_operational_expenses_example => 'Água, energia, limpeza e equipe administrativa.';

  @override
  String get reports_dre_help_ministry_transfers_meaning => 'Valores repassados para ministérios, missões ou frentes específicas.';

  @override
  String get reports_dre_help_ministry_transfers_example => 'Repasse mensal para ministério infantil ou música.';

  @override
  String get reports_dre_help_capex_meaning => 'Investimentos em bens duráveis e infraestrutura.';

  @override
  String get reports_dre_help_capex_example => 'Compra de equipamento de som ou reforma estrutural.';

  @override
  String get reports_dre_help_extraordinary_meaning => 'Ingressos ou gastos fora da rotina normal.';

  @override
  String get reports_dre_help_extraordinary_example => 'Venda de um equipamento antigo ou recebimento de reembolso.';

  @override
  String get reports_dre_help_operational_result_meaning => 'Resultado da operação normal após custos diretos, despesas operacionais e repasses.';

  @override
  String get reports_dre_help_operational_result_example => 'Mostra se a operação do período fechou com sobra ou déficit.';

  @override
  String get reports_dre_help_net_result_meaning => 'Resultado final do período após considerar todos os componentes do DRE.';

  @override
  String get reports_dre_help_net_result_example => 'Se positivo, há superávit; se negativo, há déficit.';

  @override
  String reports_dre_currency_badge(String symbols, String count) {
    return 'Moedas: $symbols ($count)';
  }

  @override
  String get reports_dre_multi_currency_disclaimer => 'Valores exibidos por moeda. Totais não são somados entre moedas.';

  @override
  String get reports_dre_empty_selected_period => 'Nenhum dado para o período selecionado.';

  @override
  String get reports_monthly_tithes_title => 'Relatório de dízimos mensais';

  @override
  String get reports_monthly_tithes_empty => 'Não há dízimos mensais para mostrar';

  @override
  String get reports_monthly_tithes_header_date => 'Data';

  @override
  String get reports_monthly_tithes_header_amount => 'Valor';

  @override
  String get reports_monthly_tithes_header_account => 'Conta de disponibilidade';

  @override
  String get reports_monthly_tithes_header_account_type => 'Tipo de conta';

  @override
  String get reports_monthly_tithes_total_title => 'Total de dízimos';

  @override
  String get reports_monthly_tithes_section_title => 'Relatório mensal de dízimos';

  @override
  String reports_monthly_tithes_currency_badge(String symbols, String count) {
    return 'Moedas: $symbols ($count)';
  }

  @override
  String get reports_monthly_tithes_multi_currency_disclaimer => 'Valores exibidos por moeda. Totais não são somados entre moedas.';

  @override
  String get reports_monthly_tithes_empty_selected_period => 'Nenhum dado para o período selecionado.';

  @override
  String get reports_monthly_tithes_tithes_of_tithes => 'Dízimos de dízimos';

  @override
  String get finance_records_filter_concept_type => 'Tipo de conceito';

  @override
  String get finance_records_filter_concept => 'Conceito';

  @override
  String get finance_records_filter_availability_account => 'Conta de disponibilidade';

  @override
  String get finance_records_table_empty => 'Não há dados financeiros para mostrar';

  @override
  String get finance_records_table_header_date => 'Data';

  @override
  String get finance_records_table_header_amount => 'Valor';

  @override
  String get finance_records_table_header_type => 'Tipo de movimento';

  @override
  String get finance_records_table_header_concept => 'Conceito';

  @override
  String get finance_records_table_header_availability_account => 'Conta de disponibilidade';

  @override
  String get finance_records_table_header_status => 'Status';

  @override
  String get finance_records_table_action_void => 'Anular';

  @override
  String get finance_records_table_confirm_void => 'Deseja anular este movimento financeiro?';

  @override
  String get finance_records_table_modal_title => 'Movimento financeiro';

  @override
  String get finance_records_form_title => 'Registro financeiro';

  @override
  String get finance_records_form_field_description => 'Descrição';

  @override
  String get finance_records_form_field_date => 'Data';

  @override
  String get finance_records_form_field_receipt => 'Comprovante do movimento bancário';

  @override
  String get finance_records_form_field_cost_center => 'Centro de custo';

  @override
  String get finance_records_form_save => 'Salvar';

  @override
  String get finance_records_form_toast_purchase_in_construction => 'Registro de compras em construção';

  @override
  String get finance_records_form_toast_saved_success => 'Registro salvo com sucesso';

  @override
  String get common_view => 'Visualizar';

  @override
  String get contributions_status_processed => 'Processada';

  @override
  String get contributions_status_pending_verification => 'Verificação pendente';

  @override
  String get contributions_status_rejected => 'Rejeitada';

  @override
  String get contributions_list_title => 'Lista de contribuições';

  @override
  String get contributions_list_new => 'Registrar contribuição';

  @override
  String get contributions_table_empty => 'Nenhuma contribuição encontrada';

  @override
  String get contributions_table_header_member => 'Nome';

  @override
  String get contributions_table_header_amount => 'Valor';

  @override
  String get contributions_table_header_type => 'Tipo de contribuição';

  @override
  String get contributions_table_header_status => 'Status';

  @override
  String get contributions_table_header_date => 'Data';

  @override
  String contributions_table_modal_title(String id) {
    return 'Contribuição #$id';
  }

  @override
  String get contributions_view_field_amount => 'Valor';

  @override
  String get contributions_view_field_status => 'Status';

  @override
  String get contributions_view_field_date => 'Data';

  @override
  String get contributions_view_field_account => 'Conta';

  @override
  String get contributions_view_section_member => 'Membro';

  @override
  String get contributions_view_section_financial_concept => 'Conceito financeiro';

  @override
  String get contributions_view_section_receipt => 'Comprovante da transferência';

  @override
  String get contributions_view_action_approve => 'Aprovar';

  @override
  String get contributions_view_action_reject => 'Rejeitar';

  @override
  String get accountsReceivable_form_section_payment_title => 'Configuração do recebimento';

  @override
  String get accountsReceivable_form_section_payment_subtitle => 'Defina como essa conta será cobrada e revise o cronograma de parcelas.';

  @override
  String get accountsReceivable_form_field_type => 'Tipo de conta';

  @override
  String get accountsReceivable_type_help_title => 'Como classificar o tipo da conta';

  @override
  String get accountsReceivable_type_help_intro => 'Escolha o tipo que melhor descreve a origem do valor a receber.';

  @override
  String get accountsReceivable_type_contribution_title => 'Contribuição';

  @override
  String get accountsReceivable_type_contribution_description => 'Compromissos voluntários assumidos por membros ou grupos.';

  @override
  String get accountsReceivable_type_contribution_example => 'Ex.: campanhas de missões, ofertas recorrentes, doações especiais.';

  @override
  String get accountsReceivable_type_service_title => 'Serviço';

  @override
  String get accountsReceivable_type_service_description => 'Cobranças por atividades ou serviços prestados pela igreja.';

  @override
  String get accountsReceivable_type_service_example => 'Ex.: cursos de música, conferências, aluguel de buffet do evento.';

  @override
  String get accountsReceivable_type_interinstitutional_title => 'Interinstitucional';

  @override
  String get accountsReceivable_type_interinstitutional_description => 'Valores decorrentes de parcerias com outras instituições.';

  @override
  String get accountsReceivable_type_interinstitutional_example => 'Ex.: apoio em eventos conjuntos, convênios com outra igreja.';

  @override
  String get accountsReceivable_type_rental_title => 'Locação';

  @override
  String get accountsReceivable_type_rental_description => 'Empréstimo remunerado de espaços, veículos ou equipamentos.';

  @override
  String get accountsReceivable_type_rental_example => 'Ex.: aluguel do auditório, locação de instrumentos ou cadeiras.';

  @override
  String get accountsReceivable_type_loan_title => 'Empréstimo';

  @override
  String get accountsReceivable_type_loan_description => 'Recursos concedidos pela igreja que devem ser devolvidos.';

  @override
  String get accountsReceivable_type_loan_example => 'Ex.: adiantamento a ministérios, apoio financeiro temporário.';

  @override
  String get accountsReceivable_type_financial_title => 'Financeiro';

  @override
  String get accountsReceivable_type_financial_description => 'Movimentos bancários que ainda aguardam compensação.';

  @override
  String get accountsReceivable_type_financial_example => 'Ex.: cheques em processamento, adquirência de cartão, devoluções.';

  @override
  String get accountsReceivable_type_legal_title => 'Jurídico';

  @override
  String get accountsReceivable_type_legal_description => 'Cobranças relacionadas a ações judiciais, seguros ou indenizações.';

  @override
  String get accountsReceivable_type_legal_example => 'Ex.: cumprimento de sentença, sinistros cobertos por seguradora.';

  @override
  String get common_see_all => 'Ver todos';

  @override
  String get member_home_placeholder => 'Experiência do membro';

  @override
  String get member_home_generosity_title => 'Minha jornada de generosidade';

  @override
  String get member_home_generosity_year_label => 'Contribuído este ano';

  @override
  String get member_home_generosity_month_label => 'Contribuído este mês';

  @override
  String get member_home_generosity_commitments_label => 'Compromissos em andamento';

  @override
  String get member_home_generosity_commitments_hint => 'Toque para ver detalhes';

  @override
  String get member_home_upcoming_events_title => 'Próximos eventos';

  @override
  String get member_home_upcoming_events_empty => 'Nenhum evento nos próximos dias.';

  @override
  String get member_schedule_detail_information_title => 'Informações';

  @override
  String get member_schedule_detail_details_title => 'Detalhes';

  @override
  String get member_schedule_detail_optional_label => '(opcional)';

  @override
  String get member_schedule_detail_no_extra_info => 'Nenhum detalhe adicional disponível.';

  @override
  String get member_contribution_history_title => 'Histórico de contribuições';

  @override
  String get member_contribution_new_button => 'Nova contribuição';

  @override
  String get member_contribution_filter_type_label => 'Tipo';

  @override
  String get member_contribution_filter_type_all => 'Todas';

  @override
  String get member_contribution_type_tithe => 'Dízimo';

  @override
  String get member_contribution_type_offering => 'Oferta';

  @override
  String get member_contribution_destination_label => 'Destino da contribuição';

  @override
  String get member_contribution_search_account_hint => 'Buscar conta...';

  @override
  String get member_contribution_offering_concept_label => 'Oferta';

  @override
  String get member_contribution_search_concept_hint => 'Buscar conceito...';

  @override
  String get member_contribution_value_label => 'Valor da contribuição';

  @override
  String get member_contribution_amount_other => 'Outro valor';

  @override
  String get member_contribution_receipt_label => 'Envie o comprovante do pagamento';

  @override
  String get member_contribution_receipt_payment_date_label => 'Data do pagamento';

  @override
  String get member_contribution_receipt_help_text => 'Esse comprovante será analisado pela tesouraria da sua igreja. É obrigatório anexar.';

  @override
  String get member_contribution_message_label => 'Mensagem (opcional)';

  @override
  String get member_contribution_continue_button => 'Continuar';

  @override
  String get member_contribution_payment_method_question => 'Como você quer registrar o pagamento?';

  @override
  String get member_contribution_payment_method_boleto_title => 'Gerar boleto para pagar depois';

  @override
  String get member_contribution_payment_method_manual_title => 'Já contribui, quero enviar o comprovante';

  @override
  String get member_contribution_payment_method_pix_description => 'Pagar agora via PIX. Gere o QR Code ou o código copia e cola para pagar no app do seu banco.';

  @override
  String get member_contribution_payment_method_boleto_description => 'Gere um boleto para pagar depois no internet banking ou aplicativo.';

  @override
  String get member_contribution_payment_method_manual_description => 'Deposite, transfira ou use outro método. Depois, envie o comprovante aqui.';

  @override
  String get member_contribution_history_empty_title => 'Você ainda não possui contribuições';

  @override
  String get member_contribution_history_empty_subtitle => 'Quando você realizar uma contribuição, ela aparecerá aqui.';

  @override
  String get member_contribution_history_item_default_title => 'Contribuição';

  @override
  String get member_contribution_history_item_receipt_submitted => 'Comprovante enviado';

  @override
  String get member_contribution_pix_title => 'Pague com PIX';

  @override
  String member_contribution_pix_recipient(String recipient) {
    return 'Destinatário: $recipient';
  }

  @override
  String get member_contribution_pix_qr_hint => 'Escaneie este QR Code no app do seu banco.';

  @override
  String get member_contribution_pix_code_label => 'Código PIX copia e cola';

  @override
  String get member_contribution_copy_code => 'Copiar código';

  @override
  String get member_contribution_pix_footer => 'Após realizar o pagamento, você poderá acompanhar a confirmação no seu histórico de contribuições.';

  @override
  String get member_contribution_back_to_home => 'Voltar ao início';

  @override
  String get member_contribution_pix_copy_success => 'Código PIX copiado!';

  @override
  String get member_contribution_boleto_title => 'Pague com boleto';

  @override
  String get member_contribution_boleto_due_date_label => 'Vencimento:';

  @override
  String get member_contribution_boleto_instruction => 'Use o código abaixo para pagar no seu internet banking ou aplicativo.';

  @override
  String get member_contribution_boleto_line_label => 'Linha digitável';

  @override
  String get member_contribution_boleto_download_pdf => 'Baixar boleto em PDF';

  @override
  String get member_contribution_boleto_footer => 'Após realizar o pagamento, a confirmação aparecerá no seu histórico de contribuições. Guarde o comprovante.';

  @override
  String get member_contribution_boleto_copy_success => 'Linha digitável copiada!';

  @override
  String get member_contribution_boleto_pdf_error => 'Não foi possível abrir o PDF';

  @override
  String get member_contribution_result_success_title => 'Contribuição realizada\ncom sucesso!';

  @override
  String get member_contribution_result_success_subtitle => 'Obrigado pela sua generosidade.';

  @override
  String member_contribution_result_date(String date) {
    return 'Data: $date';
  }

  @override
  String get member_contribution_result_info => 'O seu comprovante será conferido pela tesouraria.';

  @override
  String get member_contribution_view_history => 'Ver histórico';

  @override
  String get member_contribution_result_error_title => 'Não foi possível\nprocessar o pagamento';

  @override
  String get member_contribution_result_error_message => 'Verifique os dados do cartão ou tente outro método de pagamento.';

  @override
  String get member_contribution_try_again => 'Tentar novamente';

  @override
  String get member_contribution_form_required_fields_error => 'Por favor, preencha todos os campos obrigatórios';

  @override
  String get member_contribution_form_receipt_required_error => 'O comprovante é obrigatório.';

  @override
  String member_contribution_form_submission_error(String error) {
    return 'Erro ao processar contribuição: $error';
  }

  @override
  String get member_contribution_validator_amount_required => 'Informe o valor';

  @override
  String get member_contribution_validator_financial_concept_required => 'Selecione um conceito financeiro';

  @override
  String get member_contribution_validator_account_required => 'Selecione a conta de disponibilidade';

  @override
  String get member_contribution_validator_month_required => 'Selecione um mês';

  @override
  String get member_drawer_greeting => 'Membro Exemplo';

  @override
  String get member_drawer_view_profile => 'Ver meu perfil';

  @override
  String get member_drawer_notifications => 'Notificações';

  @override
  String get member_drawer_profile => 'Meu Perfil';

  @override
  String get member_drawer_settings => 'Configurações';

  @override
  String get member_drawer_legal_section => 'Legal';

  @override
  String get member_drawer_privacy_policy => 'Política de Privacidade';

  @override
  String get member_drawer_sensitive_data => 'Tratamento de Dados';

  @override
  String get member_drawer_terms => 'Termos de Uso';

  @override
  String get member_drawer_logout => 'Sair';

  @override
  String member_drawer_version(String version) {
    return 'Versão $version';
  }

  @override
  String get member_shell_nav_home => 'Início';

  @override
  String get member_shell_nav_contribute => 'Contribuir';

  @override
  String get member_shell_nav_commitments => 'Compromissos';

  @override
  String get member_shell_nav_statements => 'Extratos';

  @override
  String get member_shell_header_tagline => 'IGREJA';

  @override
  String get member_shell_header_default_church => 'Glória Finance';

  @override
  String get member_commitments_title => 'Meus compromissos';

  @override
  String get member_commitments_empty_title => 'Você ainda não possui compromissos de contribuição';

  @override
  String get member_commitments_empty_subtitle => 'Quando a tesouraria registrar um compromisso para você, ele aparecerá aqui.';

  @override
  String get member_commitments_total_label => 'Valor total';

  @override
  String get member_commitments_paid_label => 'Já contribuído';

  @override
  String get member_commitments_balance_label => 'Saldo';

  @override
  String get member_commitments_progress_label => 'Concluído';

  @override
  String get member_commitments_button_view_details => 'Ver detalhes & pagar';

  @override
  String get member_commitments_status_pending => 'Em andamento';

  @override
  String get member_commitments_status_paid => 'Concluído';

  @override
  String get member_commitments_status_pending_acceptance => 'Pendente de aceite';

  @override
  String get member_commitments_status_denied => 'Negado';

  @override
  String get member_commitments_detail_title => 'Detalhes do compromisso';

  @override
  String get member_commitments_detail_subtitle => 'Acompanhe o progresso e escolha como pagar suas parcelas.';

  @override
  String get member_commitments_detail_next_installment => 'Próxima parcela';

  @override
  String get member_profile_personal_data_title => 'Dados pessoais';

  @override
  String get member_profile_security_title => 'Segurança';

  @override
  String get member_profile_notifications_title => 'Notificações';

  @override
  String get member_profile_full_name_label => 'Nome completo';

  @override
  String get member_profile_email_label => 'Email';

  @override
  String get member_profile_phone_label => 'Telefone';

  @override
  String get member_profile_dni_label => 'CPF';

  @override
  String member_profile_member_since(String date) {
    return 'Membro desde $date';
  }

  @override
  String get member_profile_change_password_title => 'Alterar senha';

  @override
  String get member_profile_change_password_subtitle => 'Atualize sua senha de acesso';

  @override
  String get member_profile_notifications_settings_title => 'Configurações de notificações';

  @override
  String get member_profile_notifications_settings_subtitle => 'Escolha como deseja ser avisado pela igreja';

  @override
  String get member_change_password_header_title => 'Mantenha sua conta segura';

  @override
  String get member_change_password_header_subtitle => 'Use uma senha forte e não compartilhe seus dados de acesso.';

  @override
  String get member_change_password_current_label => 'Senha atual';

  @override
  String get member_change_password_new_label => 'Nova senha';

  @override
  String get member_change_password_confirm_label => 'Confirmar nova senha';

  @override
  String get member_change_password_rule_length => 'Pelo menos 8 caracteres';

  @override
  String get member_change_password_rule_uppercase => '1 letra maiúscula';

  @override
  String get member_change_password_rule_number => '1 número';

  @override
  String get member_change_password_error_current => 'Senha atual incorreta.';

  @override
  String get member_change_password_error_match => 'As senhas não coincidem.';

  @override
  String get member_change_password_success_title => 'Sucesso!';

  @override
  String get member_change_password_success_message => 'Sua senha foi alterada com sucesso.';

  @override
  String get member_change_password_btn_save => 'Salvar nova senha';

  @override
  String get member_change_password_btn_cancel => 'Cancelar';

  @override
  String get member_change_password_btn_back => 'Voltar ao perfil';

  @override
  String get member_commitments_installments_section_title => 'Parcelas';

  @override
  String get member_commitments_payment_modal_title => 'Registrar pagamento';

  @override
  String get member_commitments_payment_title => 'Registrar pagamento';

  @override
  String get member_commitments_payment_installment_label => 'Parcela';

  @override
  String get member_commitments_payment_account_label => 'Conta de disponibilidade';

  @override
  String get member_commitments_payment_amount_label => 'Valor pago';

  @override
  String get member_commitments_payment_paid_at_label => 'Data do pagamento';

  @override
  String get member_commitments_payment_voucher_label => 'Comprovante de pagamento';

  @override
  String get member_commitments_payment_observation_label => 'Observação (opcional)';

  @override
  String get member_commitments_payment_submit => 'Enviar comprovante';

  @override
  String get member_commitments_payment_success => 'Pagamento registrado com sucesso! A tesouraria irá verificar o comprovante.';

  @override
  String get member_commitments_payment_required_fields_error => 'Informe a parcela, valor, data e anexe o comprovante.';

  @override
  String get member_commitments_payment_methods_title => 'Como deseja pagar?';

  @override
  String get member_commitments_payment_methods_pix => 'Pagar com PIX';

  @override
  String get member_commitments_payment_methods_boleto => 'Gerar boleto';

  @override
  String get member_commitments_payment_methods_manual => 'Já paguei, enviar comprovante';

  @override
  String get member_commitments_payment_methods_manual_hint => 'Use esta opção quando fizer uma transferência e precisar enviar o comprovante.';

  @override
  String member_commitments_installment_paid_on(String date) {
    return 'Pago em: $date';
  }

  @override
  String get member_commitments_installment_status_paid => 'Paga';

  @override
  String get member_commitments_installment_status_pending => 'Em aberto';

  @override
  String get member_commitments_installment_status_in_review => 'Em revisão';

  @override
  String get member_commitments_installment_status_partial => 'Pagamento parcial';

  @override
  String get member_commitments_installment_status_overdue => 'Vencida';

  @override
  String get member_commitments_action_pay_installment => 'Pagar parcela';

  @override
  String get member_commitments_action_pay_this_installment => 'Pagar esta parcela';

  @override
  String get member_commitments_payment_missing_account => 'Conta de disponibilidade não informada. Entre em contato com a igreja.';

  @override
  String get member_register_name_label => 'Nome completo';

  @override
  String get member_register_email_label => 'Email';

  @override
  String get member_register_phone_label => 'Telefone';

  @override
  String get member_register_dni_label => 'CPF';

  @override
  String get member_register_conversion_date_label => 'Data de conversão';

  @override
  String get member_register_baptism_date_label => 'Data de batismo';

  @override
  String get member_register_birthdate_label => 'Data de nascimento';

  @override
  String get member_register_active_label => 'Ativo?';

  @override
  String get member_register_yes => 'Sim';

  @override
  String get member_register_no => 'Não';

  @override
  String get validation_required => 'O campo é obrigatório';

  @override
  String get validation_invalid_email => 'Email inválido';

  @override
  String get validation_invalid_phone => 'Formato de telefone inválido';

  @override
  String get validation_invalid_cpf => 'CPF inválido';

  @override
  String get member_list_title => 'Listagem de membros';

  @override
  String get member_list_action_register => 'Registrar novo membro';

  @override
  String get member_list_empty => 'Não há membros cadastrados.';

  @override
  String get member_list_header_name => 'Nome';

  @override
  String get member_list_header_email => 'Email';

  @override
  String get member_list_header_phone => 'Telefone';

  @override
  String get member_list_header_birthdate => 'Data de nascimento';

  @override
  String get member_list_header_active => 'Ativo?';

  @override
  String get member_list_action_edit => 'Editar';

  @override
  String get member_list_status_yes => 'Sim';

  @override
  String get member_list_status_no => 'Não';

  @override
  String get trends_main_card_revenue_title => 'Receita Bruta';

  @override
  String get trends_main_card_revenue_subtitle => 'RECEITA';

  @override
  String get trends_main_card_opex_title => 'Despesas Operacionais';

  @override
  String get trends_main_card_opex_subtitle => 'DESPESAS';

  @override
  String get trends_main_card_net_income_title => 'Resultado do Período';

  @override
  String get trends_main_card_net_income_subtitle => 'RESULTADO';

  @override
  String get member_settings_title => 'Configurações';

  @override
  String get member_settings_subtitle => 'Personalize sua experiência na Glória Finance - Membros.';

  @override
  String get member_settings_language_title => 'Idioma da interface';

  @override
  String get member_settings_language_description => 'Escolha o idioma que prefere usar no app.';

  @override
  String get member_settings_language_default_tag => 'Padrão';

  @override
  String get member_settings_notifications_title => 'Notificações';

  @override
  String get member_settings_notifications_description => 'Escolha o que você deseja receber como aviso.';

  @override
  String get member_settings_notification_church_events_title => 'Novos eventos da igreja';

  @override
  String get member_settings_notification_church_events_desc => 'Receber lembretes de cultos, conferências e atividades especiais.';

  @override
  String get member_settings_notification_payments_title => 'Compromissos de pagamento';

  @override
  String get member_settings_notification_payments_desc => 'Avisos sobre parcelas e vencimentos dos seus compromissos.';

  @override
  String get member_settings_notification_contributions_status_title => 'Status das contribuições';

  @override
  String get member_settings_notification_contributions_status_desc => 'Notificações quando um dízimo ou oferta muda de status (registrado, confirmado, etc.).';

  @override
  String get member_settings_footer_coming_soon => 'Em breve: mais opções para personalizar sua experiência.';

  @override
  String get schedule_type_service => 'Culto';

  @override
  String get schedule_type_cell => 'Célula';

  @override
  String get schedule_type_ministry_meeting => 'Reunião de ministério';

  @override
  String get schedule_type_regular_event => 'Evento regular';

  @override
  String get schedule_type_other => 'Outro';

  @override
  String get schedule_visibility_public => 'Público';

  @override
  String get schedule_visibility_internal_leaders => 'Somente líderes';

  @override
  String get schedule_day_sunday => 'Domingo';

  @override
  String get schedule_day_monday => 'Segunda-feira';

  @override
  String get schedule_day_tuesday => 'Terça-feira';

  @override
  String get schedule_day_wednesday => 'Quarta-feira';

  @override
  String get schedule_day_thursday => 'Quinta-feira';

  @override
  String get schedule_day_friday => 'Sexta-feira';

  @override
  String get schedule_day_saturday => 'Sábado';

  @override
  String get schedule_list_title => 'Agenda de eventos';

  @override
  String get schedule_list_new_button => 'Novo evento';

  @override
  String get schedule_filters_title => 'Filtros';

  @override
  String get schedule_filters_search => 'Buscar por título';

  @override
  String get schedule_filters_type => 'Tipo de evento';

  @override
  String get schedule_filters_visibility => 'Visibilidade';

  @override
  String get schedule_filters_status => 'Status';

  @override
  String get schedule_filters_clear => 'Limpar filtros';

  @override
  String get schedule_status_active => 'Ativo';

  @override
  String get schedule_status_inactive => 'Inativo';

  @override
  String get schedule_status_all => 'Todos';

  @override
  String get schedule_table_empty => 'Nenhum evento encontrado';

  @override
  String get schedule_table_header_title => 'Título';

  @override
  String get schedule_table_header_type => 'Tipo';

  @override
  String get schedule_table_header_day => 'Dia';

  @override
  String get schedule_table_header_time => 'Horário';

  @override
  String get schedule_table_header_location => 'Local';

  @override
  String get schedule_table_header_director => 'Dirigente';

  @override
  String get schedule_action_reactivate => 'Reativar';

  @override
  String get schedule_action_deactivate => 'Desativar';

  @override
  String get schedule_delete_confirm_title => 'Confirmar desativação';

  @override
  String get schedule_delete_confirm_message => 'Tem certeza de que deseja desativar este evento?';

  @override
  String get schedule_reactivate_confirm_title => 'Confirmar reativação';

  @override
  String get schedule_reactivate_confirm_message => 'Tem certeza que deseja reativar este evento?';

  @override
  String get common_confirm => 'Confirmar';

  @override
  String get schedule_detail_basic_info => 'Informações básicas';

  @override
  String get schedule_detail_title => 'Título';

  @override
  String get schedule_detail_type => 'Tipo de evento';

  @override
  String get schedule_detail_description => 'Descrição';

  @override
  String get schedule_detail_visibility => 'Visibilidade';

  @override
  String get schedule_detail_schedule_info => 'Informações de horário';

  @override
  String get schedule_detail_day => 'Dia da semana';

  @override
  String get schedule_detail_time => 'Horário';

  @override
  String get schedule_detail_duration => 'Duração';

  @override
  String get schedule_detail_minutes => 'minutos';

  @override
  String get schedule_detail_start_date => 'Data de início';

  @override
  String get schedule_detail_end_date => 'Data de término';

  @override
  String get schedule_detail_location_info => 'Local';

  @override
  String get schedule_detail_location => 'Nome do local';

  @override
  String get schedule_detail_address => 'Endereço';

  @override
  String get schedule_detail_responsibility => 'Responsabilidades';

  @override
  String get schedule_detail_director => 'Dirigente';

  @override
  String get schedule_detail_preacher => 'Pregador';

  @override
  String get schedule_detail_observations => 'Observações';

  @override
  String get schedule_detail_summary => 'Resumo';

  @override
  String get schedule_detail_when => 'Quando';

  @override
  String get schedule_detail_timezone => 'Fuso';

  @override
  String get schedule_detail_start => 'Início';

  @override
  String get schedule_detail_end => 'Término';

  @override
  String get schedule_detail_no_end_date => 'Sem data de término';

  @override
  String get schedule_detail_created_at => 'Criado em';

  @override
  String get schedule_form_title_new => 'Novo evento';

  @override
  String get schedule_form_title_edit => 'Editar evento';

  @override
  String get schedule_form_section_basic => 'Informações básicas';

  @override
  String get schedule_form_section_location => 'Local';

  @override
  String get schedule_form_section_recurrence => 'Recorrência';

  @override
  String get schedule_form_section_visibility => 'Visibilidade';

  @override
  String get schedule_form_section_responsibility => 'Responsáveis';

  @override
  String get schedule_form_field_type => 'Tipo de evento';

  @override
  String get schedule_form_field_title => 'Título';

  @override
  String get schedule_form_field_description => 'Descrição (opcional)';

  @override
  String get schedule_form_field_location_name => 'Local';

  @override
  String get schedule_form_field_location_address => 'Endereço (opcional)';

  @override
  String get schedule_form_field_day_of_week => 'Dia da semana';

  @override
  String get schedule_form_field_time => 'Horário';

  @override
  String get schedule_form_field_duration => 'Duração (minutos)';

  @override
  String get schedule_form_field_start_date => 'Data de início';

  @override
  String get schedule_form_field_has_end_date => 'Definir data de término';

  @override
  String get schedule_form_field_end_date => 'End date';

  @override
  String get schedule_form_field_visibility => 'Quem pode ver';

  @override
  String get schedule_form_field_director => 'Dirigente';

  @override
  String get schedule_form_field_preacher => 'Pregador (opcional)';

  @override
  String get schedule_form_field_observations => 'Observações (opcional)';

  @override
  String get schedule_form_save => 'Salvar';

  @override
  String get schedule_form_cancel => 'Cancelar';

  @override
  String get schedule_form_title => 'Título';

  @override
  String get schedule_form_description => 'Descrição';

  @override
  String get schedule_form_type => 'Tipo';

  @override
  String get schedule_form_visibility => 'Visibilidade';

  @override
  String get schedule_form_start_time => 'Horário de início';

  @override
  String get schedule_form_end_time => 'Horário de término';

  @override
  String get schedule_form_recurrence => 'Recorrência';

  @override
  String get schedule_form_weekly_recurrence => 'Recorrência semanal';

  @override
  String get schedule_day_abbr_sunday => 'Dom';

  @override
  String get schedule_day_abbr_monday => 'Seg';

  @override
  String get schedule_day_abbr_tuesday => 'Ter';

  @override
  String get schedule_day_abbr_wednesday => 'Qua';

  @override
  String get schedule_day_abbr_thursday => 'Qui';

  @override
  String get schedule_day_abbr_friday => 'Sex';

  @override
  String get schedule_day_abbr_saturday => 'Sáb';

  @override
  String get schedule_form_is_active => 'Ativo';

  @override
  String get schedule_form_error_required => 'Este campo é obrigatório';

  @override
  String get schedule_form_error_type_required => 'Selecione um tipo';

  @override
  String get schedule_form_error_visibility_required => 'Selecione a visibilidade';

  @override
  String get schedule_form_error_day_required => 'Selecione o dia da semana';

  @override
  String get schedule_form_error_invalid_time => 'Formato inválido. Use HH:MM';

  @override
  String get schedule_form_error_invalid_number => 'Digite um número válido';

  @override
  String get schedule_form_toast_saved => 'Evento salvo com sucesso!';

  @override
  String get schedule_form_error_title_required => 'O título é obrigatório';

  @override
  String get schedule_form_error_location_name_required => 'O nome do local é obrigatório';

  @override
  String get schedule_form_error_director_required => 'O dirigente é obrigatório';

  @override
  String get schedule_form_error_duration_invalid => 'A duração deve ser maior que zero';

  @override
  String get schedule_form_error_end_date_before_start => 'A data de término deve ser posterior à data de início';

  @override
  String get schedule_form_toast_saved_success => 'Evento salvo com sucesso!';

  @override
  String get schedule_form_toast_saved_error => 'Erro ao salvar evento';

  @override
  String get schedule_recurrence_none => 'Sem recorrência';

  @override
  String get erp_menu_schedule => 'Agenda';

  @override
  String get erp_menu_schedule_events => 'Eventos e Horários';

  @override
  String get schedule_duplicate_title => 'Duplicar evento';

  @override
  String schedule_duplicate_subtitle(String originalTitle) {
    return 'Criar um novo evento baseado em: $originalTitle';
  }

  @override
  String get schedule_duplicate_summary_title => 'Resumo do evento original';

  @override
  String get schedule_duplicate_adjustments_title => 'Ajustes antes de criar';

  @override
  String get schedule_duplicate_open_edit => 'Abrir edição completa após criar';

  @override
  String get schedule_duplicate_action_create => 'Criar cópia';

  @override
  String get schedule_duplicate_toast_success => 'Evento duplicado com sucesso!';

  @override
  String get schedule_duplicate_toast_error => 'Erro ao duplicar evento';

  @override
  String get accountsPayable_help_cst_title => 'Código de Situação Tributária (CST)';

  @override
  String get accountsPayable_help_cst_description => 'O CST mostra como o imposto se aplica à operação.';

  @override
  String get accountsPayable_help_cst_00 => 'Tributação integral (ICMS normal)';

  @override
  String get accountsPayable_help_cst_10 => 'Tributada com ICMS por substituição';

  @override
  String get accountsPayable_help_cst_20 => 'Com redução de base de cálculo';

  @override
  String get accountsPayable_help_cst_40 => 'Isenta ou não tributada';

  @override
  String get accountsPayable_help_cst_60 => 'ICMS cobrado anteriormente por ST';

  @override
  String get accountsPayable_help_cst_90 => 'Outras situações específicas';

  @override
  String get accountsPayable_help_cfop_title => 'Código Fiscal de Operações (CFOP)';

  @override
  String get accountsPayable_help_cfop_description => 'O CFOP descreve o tipo de operação (compra, venda, serviço).';

  @override
  String get accountsPayable_help_cfop_digit_info => 'Primeiro dígito indica a origem/destino:';

  @override
  String get accountsPayable_help_cfop_1xxx => 'Entradas dentro do estado';

  @override
  String get accountsPayable_help_cfop_2xxx => 'Entradas de outro estado';

  @override
  String get accountsPayable_help_cfop_5xxx => 'Saídas dentro do estado';

  @override
  String get accountsPayable_help_cfop_6xxx => 'Saídas para outro estado';

  @override
  String get accountsPayable_help_cfop_7xxx => 'Operações com o exterior';

  @override
  String get accountsPayable_help_cfop_examples_title => 'Exemplos úteis:';

  @override
  String get accountsPayable_help_cfop_1101 => 'Compra para industrialização';

  @override
  String get accountsPayable_help_cfop_1556 => 'Compra para uso ou consumo interno';

  @override
  String get accountsPayable_help_cfop_5405 => 'Venda sujeita à substituição tributária';

  @override
  String get accountsPayable_help_cfop_6102 => 'Venda para comercialização fora do estado';

  @override
  String get common_understood => 'Entendi';

  @override
  String get bankStatements_link_dialog_title => 'Vincular lançamento financeiro';

  @override
  String get bankStatements_link_dialog_id_label => 'ID do lançamento financeiro';

  @override
  String get bankStatements_link_dialog_id_error => 'Informe o identificador do lançamento.';

  @override
  String get bankStatements_link_dialog_suggestions_title => 'Sugestões automáticas';

  @override
  String get bankStatements_link_dialog_suggestions_error => 'Não foi possível carregar sugestões. Tente novamente mais tarde.';

  @override
  String get bankStatements_link_dialog_suggestions_empty => 'Nenhum lançamento corresponde ao valor e data informados.';

  @override
  String get bankStatements_link_dialog_use_id => 'Usar ID';

  @override
  String get bankStatements_link_dialog_no_concept => 'Sem conceito';

  @override
  String get bankStatements_link_dialog_saving => 'Salvando...';

  @override
  String get bankStatements_link_dialog_link_button => 'Vincular';

  @override
  String get bankStatements_link_dialog_link_error => 'Não foi possível vincular. Verifique o identificador informado.';

  @override
  String get tax_form_title_add => 'Adicionar imposto';

  @override
  String get tax_form_title_edit => 'Editar imposto';

  @override
  String get tax_form_type_label => 'Tipo do imposto';

  @override
  String get tax_form_type_error => 'Informe o tipo do imposto';

  @override
  String get tax_form_percentage_label => 'Percentual (%)';

  @override
  String get tax_form_percentage_error => 'Informe um percentual válido';

  @override
  String get tax_form_amount_label => 'Valor retido';

  @override
  String get tax_form_amount_error => 'Informe um valor maior que zero';

  @override
  String get tax_form_status_label => 'Situação';

  @override
  String get tax_form_status_taxed => 'Tributada';

  @override
  String get tax_form_status_substitution => 'Substituição tributária';

  @override
  String get tax_form_empty_list => 'Nenhum imposto adicionado até o momento.';

  @override
  String get common_save => 'Salvar';
}
