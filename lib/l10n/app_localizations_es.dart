// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get month_january => 'Enero';

  @override
  String get month_february => 'Febrero';

  @override
  String get month_march => 'Marzo';

  @override
  String get month_april => 'Abril';

  @override
  String get month_may => 'Mayo';

  @override
  String get month_june => 'Junio';

  @override
  String get month_july => 'Julio';

  @override
  String get month_august => 'Agosto';

  @override
  String get month_september => 'Septiembre';

  @override
  String get month_october => 'Octubre';

  @override
  String get month_november => 'Noviembre';

  @override
  String get month_december => 'Diciembre';

  @override
  String get common_filters => 'Filtros';

  @override
  String get common_filters_upper => 'FILTROS';

  @override
  String get common_all_banks => 'Todos los bancos';

  @override
  String get common_all_status => 'Todos los estados';

  @override
  String get common_all_months => 'Todos los meses';

  @override
  String get common_all_years => 'Todos los años';

  @override
  String get common_bank => 'Banco';

  @override
  String get common_status => 'Estado';

  @override
  String get common_start_date => 'Fecha inicial';

  @override
  String get common_end_date => 'Fecha final';

  @override
  String get common_month => 'Mes';

  @override
  String get common_year => 'Año';

  @override
  String get common_clear_filters => 'Limpiar filtros';

  @override
  String get common_loading => 'Cargando...';

  @override
  String get common_apply_filters => 'Aplicar filtros';

  @override
  String get common_load_more => 'Cargar más';

  @override
  String get common_no_results_found => 'No se encontraron resultados';

  @override
  String get common_search_hint => 'Buscar...';

  @override
  String get common_actions => 'Acciones';

  @override
  String get common_edit => 'Editar';

  @override
  String get auth_login_email_label => 'Correo electrónico';

  @override
  String get auth_login_password_label => 'Contraseña';

  @override
  String get auth_login_forgot_password => '¿Olvidaste tu contraseña?';

  @override
  String get auth_login_submit => 'Iniciar sesión';

  @override
  String get auth_login_error_invalid_email => 'Introduce un correo electrónico válido';

  @override
  String get auth_login_error_required_password => 'Introduce la contraseña';

  @override
  String get auth_error_generic => 'Ocurrió un error interno en el sistema, informa al administrador del sistema';

  @override
  String get auth_recovery_request_title => 'Introduce el correo asociado a tu cuenta y te enviaremos una contraseña temporal.';

  @override
  String get auth_recovery_request_loading => 'Solicitando contraseña temporal';

  @override
  String get auth_recovery_request_submit => 'Enviar';

  @override
  String get auth_recovery_request_email_required => 'El correo electrónico es obligatorio';

  @override
  String get auth_recovery_change_title => 'Define una nueva contraseña';

  @override
  String get auth_recovery_change_description => 'Crea una nueva contraseña. Asegúrate de que sea diferente de anteriores por seguridad';

  @override
  String get auth_recovery_old_password_label => 'Contraseña anterior';

  @override
  String get auth_recovery_new_password_label => 'Nueva contraseña';

  @override
  String get auth_recovery_change_error_old_password_required => 'Introduce la contraseña anterior';

  @override
  String get auth_recovery_change_error_new_password_required => 'Introduce la nueva contraseña';

  @override
  String get auth_recovery_change_error_min_length => 'La contraseña debe tener al menos 8 caracteres';

  @override
  String get auth_recovery_change_error_lowercase => 'La contraseña debe tener al menos una letra minúscula';

  @override
  String get auth_recovery_change_error_uppercase => 'La contraseña debe tener al menos una letra mayúscula';

  @override
  String get auth_recovery_change_error_number => 'La contraseña debe tener al menos un número';

  @override
  String get auth_recovery_success_title => 'Revisa tu correo electrónico';

  @override
  String auth_recovery_success_body(String email) {
    return 'Enviamos una contraseña temporal al correo $email. Si no la encuentras, revisa la carpeta de spam. Si ya la recibiste, haz clic en el botón de abajo.';
  }

  @override
  String get auth_recovery_success_continue => 'Continuar';

  @override
  String get auth_recovery_success_resend => '¿Aún no recibiste el correo? Reenviar correo';

  @override
  String get auth_recovery_success_resend_ok => 'Correo reenviado con éxito';

  @override
  String get auth_recovery_success_resend_error => 'Error al reenviar el correo';

  @override
  String get auth_recovery_back_to_login => 'Volver para iniciar sesión';

  @override
  String get auth_policies_title => 'Antes de continuar, revisa y acepta las políticas de Glória Finance';

  @override
  String get auth_policies_info_title => 'Información importante:';

  @override
  String get auth_policies_info_body => '• La iglesia y Glória Finance tratan datos personales y sensibles para el funcionamiento del sistema.\n\n• En conformidad con la Ley General de Protección de Datos (LGPD), es necesario que aceptes las políticas a continuación para seguir utilizando la plataforma.\n\n• Haz clic en los enlaces para leer los textos completos antes de aceptar.';

  @override
  String get auth_policies_privacy => 'Política de Privacidad';

  @override
  String get auth_policies_sensitive => 'Política de Tratamiento de Datos Sensibles';

  @override
  String get auth_policies_accept_and_continue => 'Aceptar y continuar';

  @override
  String auth_policies_link_error(String url) {
    return 'No fue posible abrir el enlace: $url';
  }

  @override
  String get auth_policies_checkbox_prefix => 'He leído y estoy de acuerdo con la ';

  @override
  String get auth_layout_version_loading => 'Cargando...';

  @override
  String auth_layout_footer(int year) {
    return '© $year Jaspesoft CNPJ 43.716.343/0001-60 ';
  }

  @override
  String get erp_menu_settings => 'Configuración Financiera';

  @override
  String get erp_menu_settings_security => 'Configuración de seguridad';

  @override
  String get erp_menu_settings_users_access => 'Usuarios y acceso';

  @override
  String get erp_menu_settings_roles_permissions => 'Roles y permisos';

  @override
  String get erp_menu_settings_members => 'Miembros';

  @override
  String get erp_menu_settings_financial_periods => 'Períodos financieros';

  @override
  String get erp_menu_settings_availability_accounts => 'Cuentas de disponibilidad';

  @override
  String get erp_menu_settings_banks => 'Bancos';

  @override
  String get erp_menu_settings_cost_centers => 'Centros de costo';

  @override
  String get erp_menu_settings_suppliers => 'Proveedores';

  @override
  String get erp_menu_settings_financial_concepts => 'Conceptos financieros';

  @override
  String get erp_menu_finance => 'Finanzas';

  @override
  String get erp_menu_finance_contributions => 'Contribuciones';

  @override
  String get erp_menu_finance_records => 'Registros financieros';

  @override
  String get erp_menu_finance_bank_reconciliation => 'Conciliación bancaria';

  @override
  String get erp_menu_finance_accounts_receivable => 'Cuentas por cobrar';

  @override
  String get erp_menu_finance_accounts_payable => 'Cuentas por pagar';

  @override
  String get erp_menu_finance_purchases => 'Compras';

  @override
  String get erp_menu_assets => 'Patrimonio';

  @override
  String get erp_menu_assets_items => 'Bienes patrimoniales';

  @override
  String get erp_menu_reports => 'Reportes';

  @override
  String get erp_menu_reports_monthly_tithes => 'Diezmos mensuales';

  @override
  String get erp_menu_reports_income_statement => 'Estado de resultados';

  @override
  String get erp_menu_reports_dre => 'DRE';

  @override
  String get common_cancel => 'Cancelar';

  @override
  String get common_retry => 'Reintentar';

  @override
  String get common_processing => 'Procesando...';

  @override
  String get patrimony_assets_list_title => 'Patrimonio';

  @override
  String get patrimony_assets_list_new => 'Registrar bien';

  @override
  String get patrimony_assets_filter_category => 'Categoría';

  @override
  String get patrimony_assets_table_error_loading => 'No fue posible cargar los bienes. Intenta nuevamente.';

  @override
  String get patrimony_assets_table_empty => 'No se encontró ningún bien con los filtros seleccionados.';

  @override
  String get patrimony_assets_table_header_code => 'Código';

  @override
  String get patrimony_assets_table_header_name => 'Nombre';

  @override
  String get patrimony_assets_table_header_category => 'Categoría';

  @override
  String get patrimony_assets_table_header_value => 'Valor';

  @override
  String get patrimony_assets_table_header_acquisition => 'Adquisición';

  @override
  String get patrimony_assets_table_header_location => 'Ubicación';

  @override
  String get patrimony_inventory_import_file_label => 'Archivo CSV completado';

  @override
  String patrimony_inventory_import_file_size(int size) {
    return 'Tamaño: $size KB';
  }

  @override
  String get patrimony_inventory_import_description_title => 'Envía el checklist físico completado para actualizar los bienes.';

  @override
  String get patrimony_inventory_import_description_body => 'Asegúrate de mantener completas las columnas \"ID del activo\", \"Código de inventario\" y \"Cantidad de inventario\". Campos opcionales como estado y observaciones también se procesarán cuando se informen.';

  @override
  String get patrimony_inventory_import_button_loading => 'Importando...';

  @override
  String get patrimony_inventory_import_button_submit => 'Importar checklist';

  @override
  String get patrimony_inventory_import_error_no_file => 'Selecciona el archivo exportado antes de importar.';

  @override
  String get patrimony_inventory_import_error_read_file => 'No fue posible leer el archivo seleccionado.';

  @override
  String get patrimony_inventory_import_error_generic => 'No fue posible importar el checklist. Intenta nuevamente.';

  @override
  String get patrimony_asset_detail_tab_details => 'Detalles';

  @override
  String get patrimony_asset_detail_tab_history => 'Historial';

  @override
  String get patrimony_asset_detail_category => 'Categoría';

  @override
  String get patrimony_asset_detail_quantity => 'Cantidad';

  @override
  String get patrimony_asset_detail_acquisition_date => 'Fecha de adquisición';

  @override
  String get patrimony_asset_detail_location => 'Ubicación';

  @override
  String get patrimony_asset_detail_responsible => 'Responsable';

  @override
  String get patrimony_asset_detail_pending_documents => 'Documentos pendientes';

  @override
  String get patrimony_asset_detail_notes => 'Observaciones';

  @override
  String patrimony_asset_detail_quantity_badge(int quantity) {
    return 'Cant.: $quantity';
  }

  @override
  String patrimony_asset_detail_updated_at(String date) {
    return 'Actualizado el $date';
  }

  @override
  String get patrimony_asset_detail_inventory_register => 'Registrar inventario';

  @override
  String get patrimony_asset_detail_inventory_update => 'Actualizar inventario';

  @override
  String get patrimony_asset_detail_inventory_modal_title => 'Registrar inventario físico';

  @override
  String get patrimony_asset_detail_inventory_success => 'Inventario registrado con éxito.';

  @override
  String get patrimony_asset_detail_disposal_register => 'Registrar baja';

  @override
  String get patrimony_asset_detail_disposal_modal_title => 'Registrar baja';

  @override
  String get patrimony_asset_detail_disposal_success => 'Baja registrada';

  @override
  String get patrimony_asset_detail_disposal_error => 'Error al registrar la baja';

  @override
  String get patrimony_asset_detail_disposal_status => 'Estado';

  @override
  String get patrimony_asset_detail_disposal_reason => 'Motivo';

  @override
  String get patrimony_asset_detail_disposal_date => 'Fecha de baja';

  @override
  String get patrimony_asset_detail_disposal_performed_by => 'Registrado por';

  @override
  String get patrimony_asset_detail_disposal_value => 'Valor de la baja';

  @override
  String get patrimony_asset_detail_inventory_result => 'Resultado';

  @override
  String get patrimony_asset_detail_inventory_checked_at => 'Fecha de la comprobación';

  @override
  String get patrimony_asset_detail_inventory_checked_by => 'Comprobado por';

  @override
  String get patrimony_asset_detail_inventory_title => 'Inventario físico';

  @override
  String get patrimony_asset_detail_attachments_empty => 'No hay anexos disponibles.';

  @override
  String get patrimony_asset_detail_attachments_title => 'Anexos';

  @override
  String get patrimony_asset_detail_attachment_view_pdf => 'Ver PDF';

  @override
  String get patrimony_asset_detail_attachment_open => 'Abrir';

  @override
  String get patrimony_asset_detail_history_empty => 'Sin historial de cambios.';

  @override
  String get patrimony_asset_detail_history_title => 'Historial de movimientos';

  @override
  String get patrimony_asset_detail_history_changes_title => 'Cambios registrados';

  @override
  String get patrimony_asset_detail_yes => 'Sí';

  @override
  String get patrimony_asset_detail_no => 'No';

  @override
  String get erp_header_change_password => 'Cambiar contraseña';

  @override
  String get erp_header_logout => 'Salir';

  @override
  String get auth_policies_submit_error_null => 'No fue posible registrar la aceptación. Intenta nuevamente.';

  @override
  String get auth_policies_submit_error_generic => 'Ocurrió un error al registrar la aceptación. Intenta nuevamente.';

  @override
  String get auth_recovery_step_title_request => 'Enviar contraseña temporal';

  @override
  String get auth_recovery_step_title_confirm => 'Confirmación de recepción de la contraseña temporal';

  @override
  String get auth_recovery_step_title_new_password => 'Definir nueva contraseña';

  @override
  String get erp_home_welcome_member => '¡Bienvenido a Church Finance!\\n\\n';

  @override
  String get erp_home_no_availability_accounts => 'No se encontró ninguna cuenta de disponibilidad';

  @override
  String get erp_home_availability_summary_title => 'Resumen de cuentas de disponibilidad';

  @override
  String get erp_home_availability_swipe_hint => 'Desliza para ver todas las cuentas';

  @override
  String get erp_home_header_title => 'Dashboard';

  @override
  String get settings_banks_title => 'Bancos';

  @override
  String get settings_banks_new_bank => 'Nuevo banco';

  @override
  String get settings_banks_form_title_create => 'Nuevo banco';

  @override
  String get settings_banks_form_title_edit => 'Editar banco';

  @override
  String get settings_banks_field_name => 'Nombre';

  @override
  String get settings_banks_field_holder_name => 'Nombre del titular';

  @override
  String get settings_banks_field_document_id => 'Documento de identificación';

  @override
  String get settings_banks_field_tag => 'Tag';

  @override
  String get settings_banks_field_account_type => 'Tipo de cuenta';

  @override
  String get settings_banks_field_pix_key => 'Clave PIX';

  @override
  String get settings_banks_field_bank_code => 'Código del banco';

  @override
  String get settings_banks_field_agency => 'Agencia';

  @override
  String get settings_banks_field_account => 'Cuenta';

  @override
  String get settings_banks_field_active => 'Activo';

  @override
  String get settings_banks_error_required => 'Campo obligatorio';

  @override
  String get settings_banks_error_invalid_number => 'Ingrese un número válido';

  @override
  String get settings_banks_error_select_account_type => 'Selecciona el tipo de cuenta';

  @override
  String get settings_banks_save => 'Guardar';

  @override
  String get settings_banks_toast_saved => 'Registro guardado con éxito';

  @override
  String get settings_availability_list_title => 'Listado de cuentas';

  @override
  String get settings_availability_new_account => 'Cuenta de disponibilidad';

  @override
  String get settings_availability_form_title => 'Registro de cuenta de disponibilidad';

  @override
  String get settings_availability_save => 'Guardar';

  @override
  String get settings_availability_toast_saved => 'Registro guardado con éxito';

  @override
  String get settings_availability_table_header_name => 'Nombre de la cuenta';

  @override
  String get settings_availability_table_header_type => 'Tipo de cuenta';

  @override
  String get settings_availability_table_header_balance => 'Saldo';

  @override
  String get settings_availability_table_header_status => 'Estado';

  @override
  String settings_availability_view_title(String id) {
    return 'Cuenta de disponibilidad #$id';
  }

  @override
  String get settings_availability_field_name => 'Nombre';

  @override
  String get settings_availability_field_balance => 'Saldo';

  @override
  String get settings_availability_field_type => 'Tipo';

  @override
  String get settings_availability_field_active => 'Activa';

  @override
  String get settings_availability_bank_details_title => 'Datos del banco';

  @override
  String get settings_availability_account_type_bank => 'Banco';

  @override
  String get settings_availability_account_type_cash => 'Efectivo';

  @override
  String get settings_availability_account_type_wallet => 'Billetera digital';

  @override
  String get settings_availability_account_type_investment => 'Inversión';

  @override
  String get settings_cost_center_title => 'Centros de costo';

  @override
  String get settings_cost_center_new => 'Nuevo centro de costo';

  @override
  String get settings_cost_center_field_code => 'Código';

  @override
  String get settings_cost_center_field_name => 'Nombre';

  @override
  String get settings_cost_center_field_category => 'Categoría';

  @override
  String get settings_cost_center_field_responsible => 'Responsable';

  @override
  String get settings_cost_center_field_description => 'Descripción';

  @override
  String get settings_cost_center_field_active => 'Activo';

  @override
  String get settings_cost_center_error_required => 'Campo obligatorio';

  @override
  String get settings_cost_center_error_select_category => 'Selecciona la categoría';

  @override
  String get settings_cost_center_error_select_responsible => 'Selecciona el responsable';

  @override
  String settings_cost_center_help_code(int maxLength) {
    return 'Usa un código fácil de recordar de hasta $maxLength caracteres.';
  }

  @override
  String get settings_cost_center_help_description => 'Describe de forma objetiva cómo se utilizará este centro de costo.';

  @override
  String get settings_cost_center_save => 'Guardar';

  @override
  String get settings_cost_center_update => 'Actualizar';

  @override
  String get settings_cost_center_toast_saved => 'Registro guardado con éxito';

  @override
  String get settings_cost_center_toast_updated => 'Registro actualizado con éxito';

  @override
  String get settings_financial_concept_title => 'Conceptos financieros';

  @override
  String get settings_financial_concept_new => 'Nuevo concepto';

  @override
  String get settings_financial_concept_filter_all => 'Todos';

  @override
  String get settings_financial_concept_filter_by_type => 'Filtrar por tipo';

  @override
  String get settings_financial_concept_field_name => 'Nombre';

  @override
  String get settings_financial_concept_field_description => 'Descripción';

  @override
  String get settings_financial_concept_field_type => 'Tipo de concepto';

  @override
  String get settings_financial_concept_field_statement_category => 'Categoría del estado';

  @override
  String get settings_financial_concept_field_active => 'Activo';

  @override
  String get settings_financial_concept_indicators_title => 'Indicadores contables';

  @override
  String get settings_financial_concept_indicator_cash_flow => 'Impacta flujo de caja';

  @override
  String get settings_financial_concept_indicator_result => 'Impacta el resultado (DRE)';

  @override
  String get settings_financial_concept_indicator_balance => 'Impacta el balance general';

  @override
  String get settings_financial_concept_indicator_operational => 'Evento operacional recurrente';

  @override
  String get settings_financial_concept_error_required => 'Campo obligatorio';

  @override
  String get settings_financial_concept_error_select_type => 'Selecciona el tipo';

  @override
  String get settings_financial_concept_error_select_category => 'Selecciona la categoría';

  @override
  String get settings_financial_concept_help_statement_categories => 'Entender las categorías';

  @override
  String get settings_financial_concept_help_indicators => 'Entender los indicadores';

  @override
  String get settings_financial_concept_save => 'Guardar';

  @override
  String get settings_financial_concept_toast_saved => 'Registro guardado con éxito';

  @override
  String get settings_financial_concept_help_statement_title => 'Categorías del estado';

  @override
  String get settings_financial_concept_help_indicator_intro => 'Estos indicadores determinan cómo se reflejará el concepto en los informes financieros. Pueden ajustarse según sea necesario para casos específicos.';

  @override
  String get settings_financial_concept_help_indicator_cash_flow_title => 'Impacta flujo de caja';

  @override
  String get settings_financial_concept_help_indicator_cash_flow_desc => 'Márquelo cuando el movimiento cambie el saldo disponible después del pago o cobro.';

  @override
  String get settings_financial_concept_help_indicator_result_title => 'Impacta el resultado (DRE)';

  @override
  String get settings_financial_concept_help_indicator_result_desc => 'Úsalo cuando el valor deba componer el estado de resultados, afectando ganancias o pérdidas.';

  @override
  String get settings_financial_concept_help_indicator_balance_title => 'Impacta el balance general';

  @override
  String get settings_financial_concept_help_indicator_balance_desc => 'Selecciona para eventos que crean o liquidan activos y pasivos directamente en el balance.';

  @override
  String get settings_financial_concept_help_indicator_operational_title => 'Evento operacional recurrente';

  @override
  String get settings_financial_concept_help_indicator_operational_desc => 'Habilítalo para compromisos rutinarios del día a día de la iglesia, ligados a las operaciones principales.';

  @override
  String get settings_financial_concept_help_understood => 'Entendido';

  @override
  String get bankStatements_empty_title => 'Aún no hay extractos importados.';

  @override
  String get bankStatements_empty_subtitle => 'Importa un archivo CSV para iniciar la conciliación bancaria.';

  @override
  String get bankStatements_header_date => 'Fecha';

  @override
  String get bankStatements_header_bank => 'Banco';

  @override
  String get bankStatements_header_description => 'Descripción';

  @override
  String get bankStatements_header_amount => 'Importe';

  @override
  String get bankStatements_header_direction => 'Dirección';

  @override
  String get bankStatements_header_status => 'Estado';

  @override
  String get bankStatements_action_details => 'Detalles';

  @override
  String get bankStatements_action_retry => 'Reprocesar';

  @override
  String get bankStatements_action_link => 'Vincular';

  @override
  String get bankStatements_action_linking => 'Vinculando...';

  @override
  String get bankStatements_toast_auto_reconciled => 'Extracto conciliado automáticamente.';

  @override
  String get bankStatements_toast_no_match => 'No se encontró ningún movimiento correspondiente.';

  @override
  String get bankStatements_details_title => 'Detalles del extracto bancario';

  @override
  String get bankStatements_toast_link_success => 'Extracto vinculado con éxito.';

  @override
  String get settings_financial_months_empty => 'No se encontró ningún mes financiero.';

  @override
  String get settings_financial_months_header_month => 'Mes';

  @override
  String get settings_financial_months_header_year => 'Año';

  @override
  String get settings_financial_months_header_status => 'Estado';

  @override
  String get settings_financial_months_action_reopen => 'Reabrir';

  @override
  String get settings_financial_months_action_close => 'Cerrar';

  @override
  String get settings_financial_months_modal_close_title => 'Cerrar mes';

  @override
  String get settings_financial_months_modal_reopen_title => 'Reabrir mes';

  @override
  String get accountsReceivable_list_title => 'Lista de cuentas por cobrar';

  @override
  String get accountsReceivable_list_title_mobile => 'Cuentas por cobrar';

  @override
  String get accountsReceivable_list_new => 'Registrar cuenta por cobrar';

  @override
  String get accountsReceivable_table_empty => 'No hay cuentas por cobrar para mostrar';

  @override
  String get accountsReceivable_table_header_debtor => 'Deudor';

  @override
  String get accountsReceivable_table_header_description => 'Descripción';

  @override
  String get accountsReceivable_table_header_type => 'Tipo';

  @override
  String get accountsReceivable_table_header_installments => 'Nº de cuotas';

  @override
  String get accountsReceivable_table_header_received => 'Recibido';

  @override
  String get accountsReceivable_table_header_pending => 'Pendiente';

  @override
  String get accountsReceivable_table_header_total => 'Total a recibir';

  @override
  String get accountsReceivable_table_header_status => 'Estado';

  @override
  String get accountsReceivable_table_action_view => 'Ver';

  @override
  String get accountsReceivable_register_title => 'Registro de cuenta por cobrar';

  @override
  String get accountsReceivable_view_title => 'Detalle de la cuenta por cobrar';

  @override
  String get accountsReceivable_form_field_financial_concept => 'Concepto financiero';

  @override
  String get accountsReceivable_form_field_debtor_dni => 'CIF/NIF del deudor';

  @override
  String get accountsReceivable_form_field_debtor_phone => 'Teléfono del deudor';

  @override
  String get accountsReceivable_form_field_debtor_name => 'Nombre del deudor';

  @override
  String get accountsReceivable_form_field_debtor_email => 'Correo del deudor';

  @override
  String get accountsReceivable_form_field_debtor_address => 'Dirección del deudor';

  @override
  String get accountsReceivable_form_field_member => 'Selecciona el miembro';

  @override
  String get accountsReceivable_form_field_single_due_date => 'Fecha de vencimiento';

  @override
  String get accountsReceivable_form_field_automatic_installments => 'Cantidad de cuotas';

  @override
  String get accountsReceivable_form_field_automatic_amount => 'Valor por cuota';

  @override
  String get accountsReceivable_form_error_member_required => 'Selecciona un miembro';

  @override
  String get accountsReceivable_form_error_description_required => 'La descripción es obligatoria';

  @override
  String get accountsReceivable_form_error_financial_concept_required => 'Selecciona un concepto financiero';

  @override
  String get accountsReceivable_form_error_debtor_name_required => 'El nombre del deudor es obligatorio';

  @override
  String get accountsReceivable_form_error_debtor_dni_required => 'El identificador del deudor es obligatorio';

  @override
  String get accountsReceivable_form_error_debtor_phone_required => 'El teléfono del deudor es obligatorio';

  @override
  String get accountsReceivable_form_error_debtor_email_required => 'El correo del deudor es obligatorio';

  @override
  String get accountsReceivable_form_error_total_amount_required => 'Introduce el valor total';

  @override
  String get accountsReceivable_form_error_single_due_date_required => 'Introduce la fecha de vencimiento';

  @override
  String get accountsReceivable_form_error_installments_required => 'Genera las cuotas para continuar';

  @override
  String get accountsReceivable_form_error_installments_invalid => 'Rellena importe y vencimiento de cada cuota';

  @override
  String get accountsReceivable_form_error_automatic_installments_required => 'Introduce la cantidad de cuotas';

  @override
  String get accountsReceivable_form_error_automatic_amount_required => 'Introduce el valor por cuota';

  @override
  String get accountsReceivable_form_error_automatic_first_due_date_required => 'Introduce la fecha de la primera cuota';

  @override
  String get accountsReceivable_form_error_installments_count_mismatch => 'La cantidad de cuotas generadas debe corresponder al total informado';

  @override
  String get accountsReceivable_form_debtor_type_title => 'Tipo de deudor';

  @override
  String get accountsReceivable_form_debtor_type_member => 'Miembro de la iglesia';

  @override
  String get accountsReceivable_form_debtor_type_external => 'Externo';

  @override
  String get accountsReceivable_form_installments_single_empty_message => 'Introduce el valor y la fecha de vencimiento para ver el resumen.';

  @override
  String get accountsReceivable_form_installments_automatic_empty_message => 'Introduce los datos y haz clic en \"Generar cuotas\" para ver el cronograma.';

  @override
  String get accountsReceivable_form_installments_summary_title => 'Resumen de cuotas';

  @override
  String accountsReceivable_form_installment_item_title(int index) {
    return 'Cuota $index';
  }

  @override
  String accountsReceivable_form_installment_item_due_date(String date) {
    return 'Vencimiento: $date';
  }

  @override
  String accountsReceivable_form_installments_summary_total(String amount) {
    return 'Total: $amount';
  }

  @override
  String get accountsReceivable_form_save => 'Guardar';

  @override
  String get accountsReceivable_form_toast_saved_success => 'Cuenta por cobrar registrada con éxito';

  @override
  String get accountsReceivable_form_toast_saved_error => 'Error al registrar la cuenta por cobrar';

  @override
  String get accountsReceivable_view_debtor_section => 'Información del deudor';

  @override
  String get accountsReceivable_view_debtor_name => 'Nombre';

  @override
  String get accountsReceivable_view_debtor_dni => 'CIF/NIF';

  @override
  String get accountsReceivable_view_debtor_type => 'Tipo de deudor';

  @override
  String get accountsReceivable_view_installments_title => 'Listado de cuotas';

  @override
  String get accountsReceivable_view_register_payment => 'Registrar pago';

  @override
  String get accountsReceivable_view_general_section => 'Información general';

  @override
  String get accountsReceivable_view_general_created => 'Creado';

  @override
  String get accountsReceivable_view_general_updated => 'Actualizado';

  @override
  String get accountsReceivable_view_general_description => 'Descripción';

  @override
  String get accountsReceivable_view_general_type => 'Tipo';

  @override
  String get accountsReceivable_view_general_total => 'Importe total';

  @override
  String get accountsReceivable_view_general_paid => 'Importe pagado';

  @override
  String get accountsReceivable_view_general_pending => 'Importe pendiente';

  @override
  String get accountsReceivable_payment_total_label => 'Importe total que debe pagarse';

  @override
  String get accountsReceivable_payment_submit => 'Enviar pago';

  @override
  String get accountsReceivable_payment_receipt_label => 'Comprobante de la transferencia';

  @override
  String get accountsReceivable_payment_availability_account_label => 'Cuenta de disponibilidad';

  @override
  String get accountsReceivable_payment_amount_label => 'Importe del pago';

  @override
  String get accountsReceivable_payment_toast_success => 'Pago registrado con éxito';

  @override
  String get accountsReceivable_payment_error_amount_required => 'Introduce el importe del pago';

  @override
  String get accountsReceivable_payment_error_availability_account_required => 'Selecciona una cuenta de disponibilidad';

  @override
  String get accountsReceivable_form_field_automatic_first_due_date => 'Primer vencimiento';

  @override
  String get accountsReceivable_form_generate_installments => 'Generar cuotas';

  @override
  String get accountsReceivable_form_error_generate_installments_fill_data => 'Completa los datos para generar las cuotas.';

  @override
  String get accountsReceivable_form_toast_generate_installments_success => 'Cuotas generadas automáticamente.';

  @override
  String get accountsPayable_list_title => 'Cuentas por pagar';

  @override
  String get accountsPayable_list_new => 'Registrar cuentas por pagar';

  @override
  String get accountsPayable_table_empty => 'No hay cuentas por pagar para mostrar';

  @override
  String get accountsPayable_table_header_supplier => 'Proveedor';

  @override
  String get accountsPayable_table_header_description => 'Descripción';

  @override
  String get accountsPayable_table_header_installments => 'Nº de cuotas';

  @override
  String get accountsPayable_table_header_paid => 'Pagado';

  @override
  String get accountsPayable_table_header_pending => 'Pendiente';

  @override
  String get accountsPayable_table_header_total => 'Total a pagar';

  @override
  String get accountsPayable_table_header_status => 'Estado';

  @override
  String get accountsPayable_table_action_view => 'Ver';

  @override
  String get accountsPayable_register_title => 'Registrar cuenta por pagar';

  @override
  String get accountsPayable_view_title => 'Detalle de la cuenta por pagar';

  @override
  String get accountsPayable_view_installments_title => 'Listado de cuotas';

  @override
  String get accountsPayable_view_register_payment => 'Registrar pago';

  @override
  String get accountsPayable_view_provider_section => 'Información del proveedor';

  @override
  String get accountsPayable_view_provider_name => 'Nombre';

  @override
  String get accountsPayable_view_provider_dni => 'CIF/NIF';

  @override
  String get accountsPayable_view_provider_phone => 'Teléfono';

  @override
  String get accountsPayable_view_provider_email => 'Correo electrónico';

  @override
  String get accountsPayable_view_provider_type => 'Tipo de proveedor';

  @override
  String get accountsPayable_view_general_section => 'Información general';

  @override
  String get accountsPayable_view_general_created => 'Creado';

  @override
  String get accountsPayable_view_general_updated => 'Actualizado';

  @override
  String get accountsPayable_view_general_description => 'Descripción';

  @override
  String get accountsPayable_view_general_total => 'Importe total';

  @override
  String get accountsPayable_view_general_paid => 'Importe pagado';

  @override
  String get accountsPayable_view_general_pending => 'Importe pendiente';

  @override
  String get accountsPayable_payment_total_label => 'Importe total que debe pagarse';

  @override
  String get accountsPayable_payment_submit => 'Enviar pago';

  @override
  String get accountsPayable_payment_receipt_label => 'Comprobante de la transferencia';

  @override
  String get accountsPayable_payment_cost_center_label => 'Centro de costo';

  @override
  String get accountsPayable_payment_availability_account_label => 'Cuenta de disponibilidad';

  @override
  String get accountsPayable_payment_amount_label => 'Importe del pago';

  @override
  String get accountsPayable_payment_toast_success => 'Pago registrado con éxito';

  @override
  String get accountsPayable_form_section_basic_title => 'Información básica';

  @override
  String get accountsPayable_form_section_basic_subtitle => 'Elige el proveedor y describe la cuenta por pagar.';

  @override
  String get accountsPayable_form_section_document_title => 'Documento fiscal';

  @override
  String get accountsPayable_form_section_document_subtitle => 'Indica el documento fiscal asociado al pago.';

  @override
  String get accountsPayable_form_section_tax_title => 'Tributación de la factura';

  @override
  String get accountsPayable_form_section_tax_subtitle => 'Clasifica la factura e indica los impuestos destacados.';

  @override
  String get accountsPayable_form_section_payment_title => 'Configuración del pago';

  @override
  String get accountsPayable_form_section_payment_subtitle => 'Define cómo se cancelará esta cuenta y revisa el cronograma de cuotas.';

  @override
  String get accountsPayable_form_field_supplier => 'Proveedor';

  @override
  String get accountsPayable_form_field_description => 'Descripción';

  @override
  String get accountsPayable_form_field_document_type => 'Tipo de documento';

  @override
  String get accountsPayable_form_field_document_number => 'Número del documento';

  @override
  String get accountsPayable_form_field_document_date => 'Fecha del documento';

  @override
  String get accountsPayable_form_field_tax_exempt_switch => 'Factura exenta de impuestos';

  @override
  String get accountsPayable_form_field_tax_exemption_reason => 'Motivo de la exención';

  @override
  String get accountsPayable_form_field_tax_observation => 'Observaciones';

  @override
  String get accountsPayable_form_field_tax_cst => 'Código CST';

  @override
  String get accountsPayable_form_field_tax_cfop => 'CFOP';

  @override
  String get accountsPayable_form_section_payment_mode_help_cst => 'Ayuda rápida sobre CST';

  @override
  String get accountsPayable_form_section_payment_mode_help_cfop => 'Ayuda rápida sobre CFOP';

  @override
  String get accountsPayable_form_error_supplier_required => 'El proveedor es obligatorio';

  @override
  String get accountsPayable_form_error_description_required => 'La descripción es obligatoria';

  @override
  String get accountsPayable_form_error_document_type_required => 'Selecciona el tipo de documento';

  @override
  String get accountsPayable_form_error_document_number_required => 'Introduce el número del documento';

  @override
  String get accountsPayable_form_error_document_date_required => 'Introduce la fecha del documento';

  @override
  String get accountsPayable_form_error_total_amount_required => 'Introduce un importe mayor que cero';

  @override
  String get accountsPayable_form_error_single_due_date_required => 'Introduce la fecha de vencimiento';

  @override
  String get accountsPayable_form_error_installments_required => 'Genera o añade al menos una cuota';

  @override
  String get accountsPayable_form_error_installments_contents => 'Rellena importe y vencimiento de cada cuota';

  @override
  String get accountsPayable_form_error_automatic_installments_required => 'Introduce la cantidad de cuotas';

  @override
  String get accountsPayable_form_error_automatic_amount_required => 'Introduce el importe por cuota';

  @override
  String get accountsPayable_form_error_automatic_first_due_date_required => 'Introduce la fecha de la primera cuota';

  @override
  String get accountsPayable_form_error_installments_count_mismatch => 'La cantidad de cuotas generadas debe corresponder al total informado';

  @override
  String get accountsPayable_form_error_taxes_required => 'Añade los impuestos retenidos cuando la factura no sea exenta';

  @override
  String get accountsPayable_form_error_taxes_invalid => 'Indica tipo, porcentaje e importe para cada impuesto';

  @override
  String get accountsPayable_form_error_tax_exemption_reason_required => 'Indica el motivo de la exención de la factura';

  @override
  String get accountsPayable_form_error_installments_add_one => 'Añade al menos una cuota';

  @override
  String get accountsPayable_form_error_tax_exempt_must_not_have_taxes => 'Las facturas exentas no deben tener impuestos retenidos';

  @override
  String get accountsPayable_form_error_tax_status_mismatch => 'Actualiza la situación tributaria según los impuestos destacados';

  @override
  String get accountsPayable_form_installments_single_empty_message => 'Introduce el valor y la fecha de vencimiento para ver el resumen.';

  @override
  String get accountsPayable_form_installments_automatic_empty_message => 'Introduce los datos y haz clic en \"Generar cuotas\" para ver el cronograma.';

  @override
  String get accountsPayable_form_field_total_amount => 'Valor total';

  @override
  String get accountsPayable_form_field_single_due_date => 'Fecha de vencimiento';

  @override
  String get accountsPayable_form_field_automatic_installments => 'Cantidad de cuotas';

  @override
  String get accountsPayable_form_field_automatic_amount => 'Valor por cuota';

  @override
  String get accountsPayable_form_field_automatic_first_due_date => 'Primer vencimiento';

  @override
  String get accountsPayable_form_generate_installments => 'Generar cuotas';

  @override
  String get accountsPayable_form_error_generate_installments_fill_data => 'Completa los datos para generar las cuotas.';

  @override
  String get accountsPayable_form_toast_generate_installments_success => 'Cuotas generadas con éxito.';

  @override
  String get accountsPayable_form_installments_summary_title => 'Resumen de cuotas';

  @override
  String accountsPayable_form_installment_item_title(int index) {
    return 'Cuota $index';
  }

  @override
  String accountsPayable_form_installment_item_due_date(String date) {
    return 'Vencimiento: $date';
  }

  @override
  String accountsPayable_form_installments_summary_total(String amount) {
    return 'Total: $amount';
  }

  @override
  String get accountsPayable_form_toast_saved_success => 'Cuenta por pagar registrada con éxito';

  @override
  String get accountsPayable_form_toast_saved_error => 'Error al registrar la cuenta por pagar';

  @override
  String get accountsPayable_form_save => 'Guardar';

  @override
  String get reports_income_download_pdf => 'Descargar PDF';

  @override
  String get reports_income_download_success => 'PDF descargado con éxito';

  @override
  String get reports_income_download_error => 'No fue posible descargar el PDF';

  @override
  String get reports_income_download_error_generic => 'Error al descargar el PDF';

  @override
  String get reports_dre_download_pdf => 'Descargar PDF';

  @override
  String get reports_dre_download_success => 'PDF descargado con éxito';

  @override
  String get reports_dre_download_error => 'No fue posible descargar el PDF';

  @override
  String get reports_dre_download_error_generic => 'Error al descargar el PDF';

  @override
  String get reports_income_breakdown_title => 'Ingresos y gastos por categoría';

  @override
  String get reports_income_breakdown_empty => 'No hay datos de ingresos y gastos para el período.';

  @override
  String get reports_income_breakdown_header_category => 'Categoría';

  @override
  String get reports_income_breakdown_header_income => 'Entradas';

  @override
  String get reports_income_breakdown_header_expenses => 'Salidas';

  @override
  String get reports_income_breakdown_header_balance => 'Saldo';

  @override
  String get reports_income_cashflow_title => 'Flujo de caja por cuenta de disponibilidad';

  @override
  String reports_income_cashflow_summary(String income, String expenses, String total) {
    return 'Entradas totales: $income | Salidas totales: $expenses | Saldo consolidado: $total';
  }

  @override
  String get reports_income_cashflow_empty => 'No hay movimientos en cuentas de disponibilidad en este período.';

  @override
  String get reports_income_cashflow_header_account => 'Cuenta';

  @override
  String get reports_income_cashflow_header_income => 'Entradas';

  @override
  String get reports_income_cashflow_header_expenses => 'Salidas';

  @override
  String get reports_income_cashflow_header_balance => 'Saldo del período';

  @override
  String get reports_income_cost_centers_title => 'Uso de centros de costo';

  @override
  String reports_income_cost_centers_total_applied(String total) {
    return 'Total aplicado: $total';
  }

  @override
  String get reports_income_cost_centers_empty => 'Ningún centro de costo con movimientos en este período.';

  @override
  String get reports_income_cost_centers_header_name => 'Centro de costo';

  @override
  String get reports_income_cost_centers_header_total => 'Total aplicado';

  @override
  String get reports_income_cost_centers_header_last_move => 'Último movimiento';

  @override
  String get trends_header_title => 'Composición de ingresos, gastos y resultado';

  @override
  String trends_header_comparison(String currentMonthYear, String previousMonthYear) {
    return 'Comparativo: $currentMonthYear vs $previousMonthYear';
  }

  @override
  String get trends_list_revenue => 'Ingresos';

  @override
  String get trends_list_opex => 'Gastos operativos';

  @override
  String get trends_list_transfers => 'Transferencias ministeriales';

  @override
  String get trends_list_capex => 'Inversiones';

  @override
  String get trends_list_net_income => 'Resultado neto';

  @override
  String get trends_summary_revenue => 'Ingresos';

  @override
  String get trends_summary_opex => 'Operativos';

  @override
  String get trends_summary_transfers => 'Transferencias';

  @override
  String get trends_summary_capex => 'Inversiones';

  @override
  String get trends_summary_net_income => 'Resultado';

  @override
  String get reports_dre_screen_title => 'DRE - Estado de Resultados del Ejercicio';

  @override
  String get reports_dre_header_title => 'Estado de Resultados del Ejercicio';

  @override
  String get reports_dre_header_subtitle => 'Entiende cómo tu iglesia recibió y utilizó los recursos en el período';

  @override
  String get reports_dre_footer_note => 'Nota: Este informe considera solo los registros confirmados y conciliados que afectan el resultado contable.';

  @override
  String get reports_dre_main_indicators_title => 'Indicadores principales';

  @override
  String get reports_dre_card_gross_revenue_title => 'Ingresos brutos';

  @override
  String get reports_dre_card_gross_revenue_description => 'Total de diezmos, ofrendas y donaciones recibidas';

  @override
  String get reports_dre_card_operational_result_title => 'Resultado operativo';

  @override
  String get reports_dre_card_operational_result_description => 'Resultado bruto menos gastos operativos';

  @override
  String get reports_dre_card_net_result_title => 'Resultado neto';

  @override
  String get reports_dre_card_net_result_description => 'Resultado final del período (superávit o déficit)';

  @override
  String get reports_dre_detail_section_title => 'Detalle';

  @override
  String get reports_dre_item_net_revenue_title => 'Ingresos netos';

  @override
  String get reports_dre_item_net_revenue_description => 'Ingresos brutos menos devoluciones y ajustes';

  @override
  String get reports_dre_item_direct_costs_title => 'Costos directos';

  @override
  String get reports_dre_item_direct_costs_description => 'Gastos de eventos, materiales y actividades específicas';

  @override
  String get reports_dre_item_gross_profit_title => 'Resultado bruto';

  @override
  String get reports_dre_item_gross_profit_description => 'Ingresos netos menos costos directos';

  @override
  String get reports_dre_item_operational_expenses_title => 'Gastos operativos';

  @override
  String get reports_dre_item_operational_expenses_description => 'Gastos del día a día: energía, agua, salarios, limpieza';

  @override
  String get reports_dre_item_ministry_transfers_title => 'Transferencias ministeriales';

  @override
  String get reports_dre_item_ministry_transfers_description => 'Transferencias a ministerios, misiones o a la directiva';

  @override
  String get reports_monthly_tithes_title => 'Informe de diezmos mensuales';

  @override
  String get reports_monthly_tithes_empty => 'No hay diezmos mensuales para mostrar';

  @override
  String get reports_monthly_tithes_header_date => 'Fecha';

  @override
  String get reports_monthly_tithes_header_amount => 'Importe';

  @override
  String get reports_monthly_tithes_header_account => 'Cuenta de disponibilidad';

  @override
  String get reports_monthly_tithes_header_account_type => 'Tipo de cuenta';

  @override
  String get finance_records_filter_concept_type => 'Tipo de concepto';

  @override
  String get finance_records_filter_concept => 'Concepto';

  @override
  String get finance_records_filter_availability_account => 'Cuenta de disponibilidad';

  @override
  String get finance_records_table_empty => 'No hay datos financieros para mostrar';

  @override
  String get finance_records_table_header_date => 'Fecha';

  @override
  String get finance_records_table_header_amount => 'Importe';

  @override
  String get finance_records_table_header_type => 'Tipo de movimiento';

  @override
  String get finance_records_table_header_concept => 'Concepto';

  @override
  String get finance_records_table_header_availability_account => 'Cuenta de disponibilidad';

  @override
  String get finance_records_table_header_status => 'Estado';

  @override
  String get finance_records_table_action_void => 'Anular';

  @override
  String get finance_records_table_confirm_void => '¿Deseas anular este movimiento financiero?';

  @override
  String get finance_records_table_modal_title => 'Movimiento financiero';

  @override
  String get finance_records_form_title => 'Registro financiero';

  @override
  String get finance_records_form_field_description => 'Descripción';

  @override
  String get finance_records_form_field_date => 'Fecha';

  @override
  String get finance_records_form_field_receipt => 'Comprobante del movimiento bancario';

  @override
  String get finance_records_form_field_cost_center => 'Centro de costo';

  @override
  String get finance_records_form_save => 'Guardar';

  @override
  String get finance_records_form_toast_purchase_in_construction => 'Registro de compras en construcción';

  @override
  String get finance_records_form_toast_saved_success => 'Registro guardado con éxito';

  @override
  String get common_view => 'Ver';

  @override
  String get contributions_status_processed => 'Procesada';

  @override
  String get contributions_status_pending_verification => 'Pendiente de verificación';

  @override
  String get contributions_status_rejected => 'Rechazada';

  @override
  String get contributions_list_title => 'Lista de contribuciones';

  @override
  String get contributions_list_new => 'Registrar contribución';

  @override
  String get contributions_table_empty => 'No se encontró ninguna contribución';

  @override
  String get contributions_table_header_member => 'Nombre';

  @override
  String get contributions_table_header_amount => 'Importe';

  @override
  String get contributions_table_header_type => 'Tipo de contribución';

  @override
  String get contributions_table_header_status => 'Estado';

  @override
  String get contributions_table_header_date => 'Fecha';

  @override
  String contributions_table_modal_title(String id) {
    return 'Contribución #$id';
  }

  @override
  String get contributions_view_field_amount => 'Importe';

  @override
  String get contributions_view_field_status => 'Estado';

  @override
  String get contributions_view_field_date => 'Fecha';

  @override
  String get contributions_view_field_account => 'Cuenta';

  @override
  String get contributions_view_section_member => 'Miembro';

  @override
  String get contributions_view_section_financial_concept => 'Concepto financiero';

  @override
  String get contributions_view_section_receipt => 'Comprobante de la transferencia';

  @override
  String get contributions_view_action_approve => 'Aprobar';

  @override
  String get contributions_view_action_reject => 'Rechazar';

  @override
  String get accountsReceivable_form_section_payment_title => 'Configuración del cobro';

  @override
  String get accountsReceivable_form_section_payment_subtitle => 'Define cómo se cobrará esta cuenta y revisa el cronograma de cuotas.';

  @override
  String get accountsReceivable_form_field_type => 'Tipo de cuenta';

  @override
  String get accountsReceivable_type_help_title => 'Cómo clasificar el tipo de cuenta';

  @override
  String get accountsReceivable_type_help_intro => 'Elige el tipo que mejor describe el origen del valor a cobrar.';

  @override
  String get accountsReceivable_type_contribution_title => 'Contribución';

  @override
  String get accountsReceivable_type_contribution_description => 'Compromisos voluntarios asumidos por miembros o grupos.';

  @override
  String get accountsReceivable_type_contribution_example => 'Ej.: campañas de misiones, ofrendas recurrentes, donaciones especiales.';

  @override
  String get accountsReceivable_type_service_title => 'Servicio';

  @override
  String get accountsReceivable_type_service_description => 'Cobros por actividades o servicios prestados por la iglesia.';

  @override
  String get accountsReceivable_type_service_example => 'Ej.: cursos de música, conferencias, alquiler de buffet del evento.';

  @override
  String get accountsReceivable_type_interinstitutional_title => 'Interinstitucional';

  @override
  String get accountsReceivable_type_interinstitutional_description => 'Valores derivados de asociaciones con otras instituciones.';

  @override
  String get accountsReceivable_type_interinstitutional_example => 'Ej.: apoyo en eventos conjuntos, convenios con otra iglesia.';

  @override
  String get accountsReceivable_type_rental_title => 'Alquiler';

  @override
  String get accountsReceivable_type_rental_description => 'Préstamo remunerado de espacios, vehículos o equipos.';

  @override
  String get accountsReceivable_type_rental_example => 'Ej.: alquiler del auditorio, alquiler de instrumentos o sillas.';

  @override
  String get accountsReceivable_type_loan_title => 'Préstamo';

  @override
  String get accountsReceivable_type_loan_description => 'Recursos concedidos por la iglesia que deben devolverse.';

  @override
  String get accountsReceivable_type_loan_example => 'Ej.: adelantos a ministerios, apoyo financiero temporal.';

  @override
  String get accountsReceivable_type_financial_title => 'Financiero';

  @override
  String get accountsReceivable_type_financial_description => 'Movimientos bancarios que aún están pendientes de compensación.';

  @override
  String get accountsReceivable_type_financial_example => 'Ej.: cheques en procesamiento, adquirencia de tarjeta, devoluciones.';

  @override
  String get accountsReceivable_type_legal_title => 'Jurídico';

  @override
  String get accountsReceivable_type_legal_description => 'Cobros relacionados con acciones judiciales, seguros o indemnizaciones.';

  @override
  String get accountsReceivable_type_legal_example => 'Ej.: cumplimiento de sentencia, siniestros cubiertos por aseguradora.';

  @override
  String get common_see_all => 'Ver todos';

  @override
  String get member_home_placeholder => 'Experiencia del miembro';

  @override
  String get member_home_upcoming_events_title => 'Próximos eventos';

  @override
  String get member_home_upcoming_events_empty => 'No hay próximos eventos en los próximos días.';

  @override
  String get member_schedule_detail_information_title => 'Información';

  @override
  String get member_schedule_detail_details_title => 'Detalles';

  @override
  String get member_schedule_detail_optional_label => '(opcional)';

  @override
  String get member_schedule_detail_no_extra_info => 'No hay detalles adicionales disponibles.';

  @override
  String get member_contribution_history_title => 'Historial de contribuciones';

  @override
  String get member_contribution_new_button => 'Nueva contribución';

  @override
  String get member_contribution_filter_type_label => 'Tipo';

  @override
  String get member_contribution_filter_type_all => 'Todas';

  @override
  String get member_contribution_type_tithe => 'Diezmo';

  @override
  String get member_contribution_type_offering => 'Ofrenda';

  @override
  String get member_contribution_destination_label => 'Destino de la contribución';

  @override
  String get member_contribution_search_account_hint => 'Buscar cuenta...';

  @override
  String get member_contribution_offering_concept_label => 'Ofrenda';

  @override
  String get member_contribution_search_concept_hint => 'Buscar concepto...';

  @override
  String get member_contribution_value_label => 'Valor de la contribución';

  @override
  String get member_contribution_amount_other => 'Otro monto';

  @override
  String get member_contribution_receipt_label => 'Envía el comprobante del pago';

  @override
  String get member_contribution_receipt_payment_date_label => 'Fecha del pago';

  @override
  String get member_contribution_receipt_help_text => 'Tesorería de tu iglesia analizará este comprobante. Es obligatorio adjuntarlo.';

  @override
  String get member_contribution_message_label => 'Mensaje (opcional)';

  @override
  String get member_contribution_continue_button => 'Continuar';

  @override
  String get member_contribution_payment_method_question => '¿Cómo quieres registrar el pago?';

  @override
  String get member_contribution_payment_method_boleto_title => 'Generar boleto para pagar después';

  @override
  String get member_contribution_payment_method_manual_title => 'Ya contribuí, quiero enviar el comprobante';

  @override
  String get member_contribution_payment_method_pix_description => 'Paga ahora vía PIX. Genera el código QR o copia y pega el código para pagar en tu banco.';

  @override
  String get member_contribution_payment_method_boleto_description => 'Genera un boleto para pagar después en tu banca en línea o app.';

  @override
  String get member_contribution_payment_method_manual_description => 'Deposita, transfiere o usa otro método. Luego, sube el comprobante aquí.';

  @override
  String get member_contribution_history_empty_title => 'Aún no tienes contribuciones';

  @override
  String get member_contribution_history_empty_subtitle => 'Cuando realices una contribución, aparecerá aquí.';

  @override
  String get member_contribution_history_item_default_title => 'Contribución';

  @override
  String get member_contribution_history_item_receipt_submitted => 'Comprobante enviado';

  @override
  String get member_contribution_pix_title => 'Paga con PIX';

  @override
  String member_contribution_pix_recipient(String recipient) {
    return 'Destinatario: $recipient';
  }

  @override
  String get member_contribution_pix_qr_hint => 'Escanea este código QR en la app de tu banco.';

  @override
  String get member_contribution_pix_code_label => 'Código PIX copiar y pegar';

  @override
  String get member_contribution_copy_code => 'Copiar código';

  @override
  String get member_contribution_pix_footer => 'Después de realizar el pago, podrás seguir la confirmación en tu historial de contribuciones.';

  @override
  String get member_contribution_back_to_home => 'Volver al inicio';

  @override
  String get member_contribution_pix_copy_success => '¡Código PIX copiado!';

  @override
  String get member_contribution_boleto_title => 'Paga con boleto';

  @override
  String get member_contribution_boleto_due_date_label => 'Vencimiento:';

  @override
  String get member_contribution_boleto_instruction => 'Usa el código de abajo para pagar en tu banca en línea o app.';

  @override
  String get member_contribution_boleto_line_label => 'Línea digitável';

  @override
  String get member_contribution_boleto_download_pdf => 'Descargar boleto en PDF';

  @override
  String get member_contribution_boleto_footer => 'Después de pagar, la confirmación aparecerá en tu historial de contribuciones. Guarda el comprobante.';

  @override
  String get member_contribution_boleto_copy_success => '¡Línea digitável copiada!';

  @override
  String get member_contribution_boleto_pdf_error => 'No fue posible abrir el PDF';

  @override
  String get member_contribution_result_success_title => '¡Contribución realizada\ncon éxito!';

  @override
  String get member_contribution_result_success_subtitle => 'Gracias por tu generosidad.';

  @override
  String member_contribution_result_date(String date) {
    return 'Fecha: $date';
  }

  @override
  String get member_contribution_result_info => 'Tesorería revisará tu comprobante.';

  @override
  String get member_contribution_view_history => 'Ver historial';

  @override
  String get member_contribution_result_error_title => 'No fue posible\nprocesar el pago';

  @override
  String get member_contribution_result_error_message => 'Verifica los datos del pago o intenta con otro método.';

  @override
  String get member_contribution_try_again => 'Intentar nuevamente';

  @override
  String get member_contribution_form_required_fields_error => 'Completa todos los campos obligatorios';

  @override
  String get member_contribution_form_receipt_required_error => 'El comprobante es obligatorio.';

  @override
  String member_contribution_form_submission_error(String error) {
    return 'Error al procesar la contribución: $error';
  }

  @override
  String get member_contribution_validator_amount_required => 'Informe el valor';

  @override
  String get member_contribution_validator_financial_concept_required => 'Selecciona un concepto financiero';

  @override
  String get member_contribution_validator_account_required => 'Selecciona la cuenta de disponibilidad';

  @override
  String get member_contribution_validator_month_required => 'Selecciona un mes';

  @override
  String get member_drawer_greeting => 'Miembro de ejemplo';

  @override
  String get member_drawer_view_profile => 'Ver mi perfil';

  @override
  String get member_drawer_notifications => 'Notificaciones';

  @override
  String get member_drawer_profile => 'Mi perfil';

  @override
  String get member_drawer_settings => 'Configuraciones';

  @override
  String get member_drawer_legal_section => 'Legal';

  @override
  String get member_drawer_privacy_policy => 'Política de privacidad';

  @override
  String get member_drawer_sensitive_data => 'Tratamiento de datos';

  @override
  String get member_drawer_terms => 'Términos de uso';

  @override
  String get member_drawer_logout => 'Salir';

  @override
  String member_drawer_version(String version) {
    return 'Versión $version';
  }

  @override
  String get member_shell_nav_home => 'Inicio';

  @override
  String get member_shell_nav_contribute => 'Contribuir';

  @override
  String get member_shell_nav_commitments => 'Compromisos';

  @override
  String get member_shell_nav_statements => 'Estados';

  @override
  String get member_shell_header_tagline => 'IGLESIA';

  @override
  String get member_shell_header_default_church => 'Gloria Finance';

  @override
  String get member_commitments_title => 'Mis compromisos';

  @override
  String get member_commitments_empty_title => 'Aún no tienes compromisos de contribución';

  @override
  String get member_commitments_empty_subtitle => 'Cuando tesorería registre un compromiso para ti, aparecerá aquí.';

  @override
  String get member_commitments_total_label => 'Valor total';

  @override
  String get member_commitments_paid_label => 'Ya contribuido';

  @override
  String get member_commitments_balance_label => 'Saldo';

  @override
  String get member_commitments_progress_label => 'Completado';

  @override
  String get member_commitments_button_view_details => 'Ver detalles y pagar';

  @override
  String get member_commitments_status_pending => 'En progreso';

  @override
  String get member_commitments_status_paid => 'Concluido';

  @override
  String get member_commitments_status_pending_acceptance => 'Pendiente de aceptación';

  @override
  String get member_commitments_status_denied => 'Rechazado';

  @override
  String get member_commitments_detail_title => 'Detalles del compromiso';

  @override
  String get member_commitments_detail_subtitle => 'Revisa el progreso y elige cómo pagar tus cuotas.';

  @override
  String get member_commitments_detail_next_installment => 'Próxima cuota';

  @override
  String get member_profile_personal_data_title => 'Datos personales';

  @override
  String get member_profile_security_title => 'Seguridad';

  @override
  String get member_profile_notifications_title => 'Notificaciones';

  @override
  String get member_profile_full_name_label => 'Nombre completo';

  @override
  String get member_profile_email_label => 'Correo electrónico';

  @override
  String get member_profile_phone_label => 'Teléfono';

  @override
  String get member_profile_dni_label => 'DNI/NIF';

  @override
  String member_profile_member_since(String date) {
    return 'Miembro desde $date';
  }

  @override
  String get member_profile_change_password_title => 'Cambiar contraseña';

  @override
  String get member_profile_change_password_subtitle => 'Actualiza tu contraseña de acceso';

  @override
  String get member_profile_notifications_settings_title => 'Configuración de notificaciones';

  @override
  String get member_profile_notifications_settings_subtitle => 'Elige cómo deseas ser avisado por la iglesia';

  @override
  String get member_change_password_header_title => 'Mantén tu cuenta segura';

  @override
  String get member_change_password_header_subtitle => 'Usa una contraseña segura y no compartas tus datos de acceso.';

  @override
  String get member_change_password_current_label => 'Contraseña actual';

  @override
  String get member_change_password_new_label => 'Nueva contraseña';

  @override
  String get member_change_password_confirm_label => 'Confirmar nueva contraseña';

  @override
  String get member_change_password_rule_length => 'Al menos 8 caracteres';

  @override
  String get member_change_password_rule_uppercase => '1 letra mayúscula';

  @override
  String get member_change_password_rule_number => '1 número';

  @override
  String get member_change_password_error_current => 'Contraseña actual incorrecta.';

  @override
  String get member_change_password_error_match => 'Las contraseñas no coinciden.';

  @override
  String get member_change_password_success_title => '¡Éxito!';

  @override
  String get member_change_password_success_message => 'Tu contraseña ha sido cambiada con éxito.';

  @override
  String get member_change_password_btn_save => 'Guardar nueva contraseña';

  @override
  String get member_change_password_btn_cancel => 'Cancelar';

  @override
  String get member_change_password_btn_back => 'Volver al perfil';

  @override
  String get member_commitments_installments_section_title => 'Cuotas';

  @override
  String get member_commitments_payment_modal_title => 'Registrar pago';

  @override
  String get member_commitments_payment_title => 'Registrar pago';

  @override
  String get member_commitments_payment_installment_label => 'Cuota';

  @override
  String get member_commitments_payment_account_label => 'Cuenta de disponibilidad';

  @override
  String get member_commitments_payment_amount_label => 'Monto pagado';

  @override
  String get member_commitments_payment_paid_at_label => 'Fecha del pago';

  @override
  String get member_commitments_payment_voucher_label => 'Comprobante de pago';

  @override
  String get member_commitments_payment_observation_label => 'Observación (opcional)';

  @override
  String get member_commitments_payment_submit => 'Enviar comprobante';

  @override
  String get member_commitments_payment_success => '¡Pago registrado! Tesorería verificará el comprobante.';

  @override
  String get member_commitments_payment_required_fields_error => 'Indica la cuota, monto, fecha y adjunta el comprobante.';

  @override
  String get member_commitments_payment_methods_title => '¿Cómo quieres pagar?';

  @override
  String get member_commitments_payment_methods_pix => 'Pagar con PIX';

  @override
  String get member_commitments_payment_methods_boleto => 'Generar boleto';

  @override
  String get member_commitments_payment_methods_manual => 'Ya pagué, enviar comprobante';

  @override
  String get member_commitments_payment_methods_manual_hint => 'Usa esta opción cuando transferiste y necesitas enviar el comprobante.';

  @override
  String member_commitments_installment_paid_on(String date) {
    return 'Pagado el: $date';
  }

  @override
  String get member_commitments_installment_status_paid => 'Pagada';

  @override
  String get member_commitments_installment_status_pending => 'Pendiente';

  @override
  String get member_commitments_installment_status_in_review => 'En revisión';

  @override
  String get member_commitments_installment_status_partial => 'Pago parcial';

  @override
  String get member_commitments_installment_status_overdue => 'Vencida';

  @override
  String get member_commitments_action_pay_installment => 'Pagar cuota';

  @override
  String get member_commitments_action_pay_this_installment => 'Pagar esta cuota';

  @override
  String get member_commitments_payment_missing_account => 'Cuenta de disponibilidad no informada. Contacta a tu iglesia.';

  @override
  String get member_register_name_label => 'Nombre completo';

  @override
  String get member_register_email_label => 'Correo electrónico';

  @override
  String get member_register_phone_label => 'Teléfono';

  @override
  String get member_register_dni_label => 'Documento de identidad';

  @override
  String get member_register_conversion_date_label => 'Fecha de conversión';

  @override
  String get member_register_baptism_date_label => 'Fecha de bautismo';

  @override
  String get member_register_birthdate_label => 'Fecha de nacimiento';

  @override
  String get member_register_active_label => '¿Activo?';

  @override
  String get member_register_yes => 'Sí';

  @override
  String get member_register_no => 'No';

  @override
  String get validation_required => 'Campo obligatorio';

  @override
  String get validation_invalid_email => 'Correo electrónico inválido';

  @override
  String get validation_invalid_phone => 'Formato de teléfono inválido';

  @override
  String get validation_invalid_cpf => 'Documento inválido';

  @override
  String get member_list_title => 'Listado de miembros';

  @override
  String get member_list_action_register => 'Registrar nuevo miembro';

  @override
  String get member_list_empty => 'No hay miembros registrados.';

  @override
  String get member_list_header_name => 'Nombre';

  @override
  String get member_list_header_email => 'Correo electrónico';

  @override
  String get member_list_header_phone => 'Teléfono';

  @override
  String get member_list_header_birthdate => 'Fecha de nacimiento';

  @override
  String get member_list_header_active => '¿Activo?';

  @override
  String get member_list_action_edit => 'Editar';

  @override
  String get member_list_status_yes => 'Sí';

  @override
  String get member_list_status_no => 'No';

  @override
  String get trends_main_card_revenue_title => 'Ingresos Brutos';

  @override
  String get trends_main_card_revenue_subtitle => 'INGRESOS';

  @override
  String get trends_main_card_opex_title => 'Gastos Operativos';

  @override
  String get trends_main_card_opex_subtitle => 'GASTOS';

  @override
  String get trends_main_card_net_income_title => 'Resultado del Período';

  @override
  String get trends_main_card_net_income_subtitle => 'RESULTADO';

  @override
  String get member_settings_title => 'Configuraciones';

  @override
  String get member_settings_subtitle => 'Personaliza tu experiencia en Glória Finance - Miembros.';

  @override
  String get member_settings_language_title => 'Idioma de la interfaz';

  @override
  String get member_settings_language_description => 'Elige el idioma que prefieres usar en la app.';

  @override
  String get member_settings_language_default_tag => 'Predeterminado';

  @override
  String get member_settings_notifications_title => 'Notificaciones';

  @override
  String get member_settings_notifications_description => 'Elige lo que deseas recibir como aviso.';

  @override
  String get member_settings_notification_church_events_title => 'Nuevos eventos de la iglesia';

  @override
  String get member_settings_notification_church_events_desc => 'Recibir recordatorios de cultos, conferencias y actividades especiales.';

  @override
  String get member_settings_notification_payments_title => 'Compromisos de pago';

  @override
  String get member_settings_notification_payments_desc => 'Avisos sobre cuotas y vencimientos de tus compromisos.';

  @override
  String get member_settings_notification_contributions_status_title => 'Estado de las contribuciones';

  @override
  String get member_settings_notification_contributions_status_desc => 'Notificaciones cuando un diezmo u ofrenda cambia de estado (registrado, confirmado, etc.).';

  @override
  String get member_settings_footer_coming_soon => 'Próximamente: más opciones para personalizar tu experiencia.';

  @override
  String get schedule_type_service => 'Culto';

  @override
  String get schedule_type_cell => 'Célula';

  @override
  String get schedule_type_ministry_meeting => 'Reunión de ministerio';

  @override
  String get schedule_type_regular_event => 'Evento regular';

  @override
  String get schedule_type_other => 'Otro';

  @override
  String get schedule_visibility_public => 'Público';

  @override
  String get schedule_visibility_internal_leaders => 'Solo líderes';

  @override
  String get schedule_day_sunday => 'Domingo';

  @override
  String get schedule_day_monday => 'Lunes';

  @override
  String get schedule_day_tuesday => 'Martes';

  @override
  String get schedule_day_wednesday => 'Miércoles';

  @override
  String get schedule_day_thursday => 'Jueves';

  @override
  String get schedule_day_friday => 'Viernes';

  @override
  String get schedule_day_saturday => 'Sábado';

  @override
  String get schedule_list_title => 'Agenda de eventos';

  @override
  String get schedule_list_new_button => 'Nuevo evento';

  @override
  String get schedule_filters_title => 'Filtros';

  @override
  String get schedule_filters_search => 'Buscar por título';

  @override
  String get schedule_filters_type => 'Tipo de evento';

  @override
  String get schedule_filters_visibility => 'Visibilidad';

  @override
  String get schedule_filters_status => 'Estado';

  @override
  String get schedule_filters_clear => 'Limpiar filtros';

  @override
  String get schedule_status_active => 'Activo';

  @override
  String get schedule_status_inactive => 'Inactivo';

  @override
  String get schedule_status_all => 'Todos';

  @override
  String get schedule_table_empty => 'No se encontró ningún evento';

  @override
  String get schedule_table_header_title => 'Título';

  @override
  String get schedule_table_header_type => 'Tipo';

  @override
  String get schedule_table_header_day => 'Día';

  @override
  String get schedule_table_header_time => 'Horario';

  @override
  String get schedule_table_header_location => 'Ubicación';

  @override
  String get schedule_table_header_director => 'Dirigente';

  @override
  String get schedule_action_reactivate => 'Reactivar';

  @override
  String get schedule_action_deactivate => 'Desactivar';

  @override
  String get schedule_delete_confirm_title => 'Confirmar desactivación';

  @override
  String get schedule_delete_confirm_message => '¿Estás seguro de que deseas desactivar este evento?';

  @override
  String get schedule_reactivate_confirm_title => 'Confirmar reactivación';

  @override
  String get schedule_reactivate_confirm_message => '¿Estás seguro de que deseas reactivar este evento?';

  @override
  String get common_confirm => 'Confirmar';

  @override
  String get schedule_detail_basic_info => 'Información básica';

  @override
  String get schedule_detail_title => 'Título';

  @override
  String get schedule_detail_type => 'Tipo de evento';

  @override
  String get schedule_detail_description => 'Descripción';

  @override
  String get schedule_detail_visibility => 'Visibilidad';

  @override
  String get schedule_detail_schedule_info => 'Información de horario';

  @override
  String get schedule_detail_day => 'Día de la semana';

  @override
  String get schedule_detail_time => 'Horario';

  @override
  String get schedule_detail_duration => 'Duración';

  @override
  String get schedule_detail_minutes => 'minutos';

  @override
  String get schedule_detail_start_date => 'Fecha de inicio';

  @override
  String get schedule_detail_end_date => 'Fecha de término';

  @override
  String get schedule_detail_location_info => 'Ubicación';

  @override
  String get schedule_detail_location => 'Nombre del local';

  @override
  String get schedule_detail_address => 'Dirección';

  @override
  String get schedule_detail_responsibility => 'Responsabilidades';

  @override
  String get schedule_detail_director => 'Dirigente';

  @override
  String get schedule_detail_preacher => 'Predicador';

  @override
  String get schedule_detail_observations => 'Observaciones';

  @override
  String get schedule_detail_summary => 'Resumen';

  @override
  String get schedule_detail_when => 'Cuándo';

  @override
  String get schedule_detail_timezone => 'Zona horaria';

  @override
  String get schedule_detail_start => 'Inicio';

  @override
  String get schedule_detail_end => 'Término';

  @override
  String get schedule_detail_no_end_date => 'Sin fecha de término';

  @override
  String get schedule_detail_created_at => 'Creado en';

  @override
  String get schedule_form_title_new => 'Nuevo evento';

  @override
  String get schedule_form_title_edit => 'Editar evento';

  @override
  String get schedule_form_section_basic => 'Información básica';

  @override
  String get schedule_form_section_location => 'Ubicación';

  @override
  String get schedule_form_section_recurrence => 'Recurrencia';

  @override
  String get schedule_form_section_visibility => 'Visibilidad';

  @override
  String get schedule_form_section_responsibility => 'Responsables';

  @override
  String get schedule_form_field_type => 'Tipo de evento';

  @override
  String get schedule_form_field_title => 'Título';

  @override
  String get schedule_form_field_description => 'Descripción (opcional)';

  @override
  String get schedule_form_field_location_name => 'Local';

  @override
  String get schedule_form_field_location_address => 'Dirección (opcional)';

  @override
  String get schedule_form_field_day_of_week => 'Día de la semana';

  @override
  String get schedule_form_field_time => 'Horario';

  @override
  String get schedule_form_field_duration => 'Duración (minutos)';

  @override
  String get schedule_form_field_start_date => 'Fecha de inicio';

  @override
  String get schedule_form_field_has_end_date => 'Definir fecha de término';

  @override
  String get schedule_form_field_end_date => 'Fecha de término';

  @override
  String get schedule_form_field_visibility => 'Quién puede ver';

  @override
  String get schedule_form_field_director => 'Dirigente';

  @override
  String get schedule_form_field_preacher => 'Predicador (opcional)';

  @override
  String get schedule_form_field_observations => 'Observaciones (opcional)';

  @override
  String get schedule_form_save => 'Guardar';

  @override
  String get schedule_form_cancel => 'Cancelar';

  @override
  String get schedule_form_title => 'Título';

  @override
  String get schedule_form_description => 'Descripción';

  @override
  String get schedule_form_type => 'Tipo';

  @override
  String get schedule_form_visibility => 'Visibilidad';

  @override
  String get schedule_form_start_time => 'Horario de inicio';

  @override
  String get schedule_form_end_time => 'Horario de finalización';

  @override
  String get schedule_form_recurrence => 'Recurrencia';

  @override
  String get schedule_form_weekly_recurrence => 'Recurrencia semanal';

  @override
  String get schedule_day_abbr_sunday => 'Dom';

  @override
  String get schedule_day_abbr_monday => 'Lun';

  @override
  String get schedule_day_abbr_tuesday => 'Mar';

  @override
  String get schedule_day_abbr_wednesday => 'Mié';

  @override
  String get schedule_day_abbr_thursday => 'Jue';

  @override
  String get schedule_day_abbr_friday => 'Vie';

  @override
  String get schedule_day_abbr_saturday => 'Sáb';

  @override
  String get schedule_form_is_active => 'Activo';

  @override
  String get schedule_form_error_required => 'Este campo es obligatorio';

  @override
  String get schedule_form_error_type_required => 'Seleccione un tipo';

  @override
  String get schedule_form_error_visibility_required => 'Seleccione la visibilidad';

  @override
  String get schedule_form_error_day_required => 'Seleccione el día de la semana';

  @override
  String get schedule_form_error_invalid_time => 'Formato inválido. Use HH:MM';

  @override
  String get schedule_form_error_invalid_number => 'Ingrese un número válido';

  @override
  String get schedule_form_toast_saved => '¡Evento guardado con éxito!';

  @override
  String get schedule_form_error_title_required => 'El título es obligatorio';

  @override
  String get schedule_form_error_location_name_required => 'El nombre de la ubicación es obligatorio';

  @override
  String get schedule_form_error_director_required => 'El dirigente es obligatorio';

  @override
  String get schedule_form_error_duration_invalid => 'La duración debe ser mayor que cero';

  @override
  String get schedule_form_error_end_date_before_start => 'La fecha de término debe ser posterior a la fecha de inicio';

  @override
  String get schedule_form_toast_saved_success => '¡Evento guardado con éxito!';

  @override
  String get schedule_form_toast_saved_error => 'Error al guardar evento';

  @override
  String get schedule_recurrence_none => 'Sin recurrencia';

  @override
  String get erp_menu_schedule => 'Agenda';

  @override
  String get erp_menu_schedule_events => 'Eventos y Horarios';

  @override
  String get schedule_duplicate_title => 'Duplicar evento';

  @override
  String schedule_duplicate_subtitle(String originalTitle) {
    return 'Crear un nuevo evento basado en: $originalTitle';
  }

  @override
  String get schedule_duplicate_summary_title => 'Resumen del evento original';

  @override
  String get schedule_duplicate_adjustments_title => 'Ajustes antes de crear';

  @override
  String get schedule_duplicate_open_edit => 'Abrir edición completa después de crear';

  @override
  String get schedule_duplicate_action_create => 'Crear copia';

  @override
  String get schedule_duplicate_toast_success => '¡Evento duplicado con éxito!';

  @override
  String get schedule_duplicate_toast_error => 'Error al duplicar evento';

  @override
  String get accountsPayable_help_cst_title => 'Código de Situación Tributaria (CST)';

  @override
  String get accountsPayable_help_cst_description => 'El CST muestra cómo se aplica el impuesto a la operación.';

  @override
  String get accountsPayable_help_cst_00 => 'Tributación integral (ICMS normal)';

  @override
  String get accountsPayable_help_cst_10 => 'Tributada con ICMS por sustitución';

  @override
  String get accountsPayable_help_cst_20 => 'Con reducción de base de cálculo';

  @override
  String get accountsPayable_help_cst_40 => 'Exenta o no tributada';

  @override
  String get accountsPayable_help_cst_60 => 'ICMS cobrado anteriormente por ST';

  @override
  String get accountsPayable_help_cst_90 => 'Otras situaciones específicas';

  @override
  String get accountsPayable_help_cfop_title => 'Código Fiscal de Operaciones (CFOP)';

  @override
  String get accountsPayable_help_cfop_description => 'El CFOP describe el tipo de operación (compra, venta, servicio).';

  @override
  String get accountsPayable_help_cfop_digit_info => 'El primer dígito indica el orígen/destino:';

  @override
  String get accountsPayable_help_cfop_1xxx => 'Entradas dentro del estado';

  @override
  String get accountsPayable_help_cfop_2xxx => 'Entradas de otro estado';

  @override
  String get accountsPayable_help_cfop_5xxx => 'Salidas dentro del estado';

  @override
  String get accountsPayable_help_cfop_6xxx => 'Salidas para otro estado';

  @override
  String get accountsPayable_help_cfop_7xxx => 'Operaciones con el exterior';

  @override
  String get accountsPayable_help_cfop_examples_title => 'Ejemplos útiles:';

  @override
  String get accountsPayable_help_cfop_1101 => 'Compra para industrialización';

  @override
  String get accountsPayable_help_cfop_1556 => 'Compra para uso o consumo interno';

  @override
  String get accountsPayable_help_cfop_5405 => 'Venta sujeta a sustitución tributaria';

  @override
  String get accountsPayable_help_cfop_6102 => 'Venta para comercialización fuera del estado';

  @override
  String get common_understood => 'Entendido';

  @override
  String get bankStatements_link_dialog_title => 'Vincular registro financiero';

  @override
  String get bankStatements_link_dialog_id_label => 'ID del registro financiero';

  @override
  String get bankStatements_link_dialog_id_error => 'Informe el identificador del registro.';

  @override
  String get bankStatements_link_dialog_suggestions_title => 'Sugerencias automáticas';

  @override
  String get bankStatements_link_dialog_suggestions_error => 'No fue posible cargar sugerencias. Intente nuevamente más tarde.';

  @override
  String get bankStatements_link_dialog_suggestions_empty => 'Ningún registro corresponde al valor y fecha informados.';

  @override
  String get bankStatements_link_dialog_use_id => 'Usar ID';

  @override
  String get bankStatements_link_dialog_no_concept => 'Sin concepto';

  @override
  String get bankStatements_link_dialog_saving => 'Guardando...';

  @override
  String get bankStatements_link_dialog_link_button => 'Vincular';

  @override
  String get bankStatements_link_dialog_link_error => 'No fue posible vincular. Verifique el identificador informado.';

  @override
  String get tax_form_title_add => 'Agregar impuesto';

  @override
  String get tax_form_title_edit => 'Editar impuesto';

  @override
  String get tax_form_type_label => 'Tipo de impuesto';

  @override
  String get tax_form_type_error => 'Informe el tipo de impuesto';

  @override
  String get tax_form_percentage_label => 'Porcentaje (%)';

  @override
  String get tax_form_percentage_error => 'Informe un porcentaje válido';

  @override
  String get tax_form_amount_label => 'Valor retenido';

  @override
  String get tax_form_amount_error => 'Informe un valor mayor que cero';

  @override
  String get tax_form_status_label => 'Situación';

  @override
  String get tax_form_status_taxed => 'Tributada';

  @override
  String get tax_form_status_substitution => 'Sustitución tributaria';

  @override
  String get tax_form_empty_list => 'Ningún impuesto agregado hasta el momento.';

  @override
  String get common_save => 'Guardar';
}
