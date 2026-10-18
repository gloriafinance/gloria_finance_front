# Pagamentos Recorrentes — Entregável UI/UX (listagem + formulário)

Documento de diseño y handoff del primer entregable de la feature **Pagamentos Recorrentes**
de Glória Finance (ERP, Flutter).

- **Alcance:** listado de recurrencias + formulario de creación/edición.
- **Fuera de alcance:** ejecución de pago, PIX/Boleto en la ejecución, línea digitável,
  cámara, webhook, comprobantes, estados PROCESSING/BLOCKED/FAILED, detalle de competencia,
  modal de pagar, registro manual del pago.
- **Contrato de backend consumido:** `RecurringPaymentConfigurationData`
  (`gloria_finance_api/src/Financial/domain/RecurringPayments.ts`).

---

## 1. Alcance

| Dentro | Fuera |
| --- | --- |
| Listado de recorrências con filtros y estados | Ejecutar pago, PIX/Boleto en la ejecución |
| Formulario crear / editar | Línea digitável, cámara, comprobantes |
| Activar / desactivar (ciclo de vida) | Competencias mensuales y PAID/PENDING |
| FIXO vs VARIÁVEL y PIX reutilizable opcional | PROCESSING / BLOCKED / FAILED, webhook |

### Escopo geográfico: exclusivo para igrejas do Brasil

O módulo é **exclusivo de igrejas brasileiras**: ele existe para compromissos pagos com PIX/boleto
e execução bancária via Asaas, que são realidades do Brasil (chave PIX, CPF/CNPJ, EVP). O bloqueio
é declarativo e tem duas camadas, no mesmo padrão que o repo já usa para Asaas:

| Camada | Onde | Comportamento |
| --- | --- | --- |
| Menu | `core/layout/erp/menu_items.dart` | O item declara `"countries": ["BR"]`; `menuItems(roles, country)` o esconde em qualquer outro país |
| Rotas | `features/erp/router.dart` | As três rotas têm `redirect` para `/dashboard` quando a sessão não é do Brasil (cobre URL direta) |
| Sessão | `features/auth/auth_session_model.dart` | `isBrazil` centraliza a comparação de país |

Consequência de produto: fora do Brasil o tesoureiro não vê o item em Finanças e, se tentar entrar
pela URL, volta para o dashboard. Nenhuma tela "não disponível" foi criada — o mesmo critério de
`/banks/asaas/connect`.

A pantalla se comporta como **módulo de administración/configuración**, no como historial
financiero: no hay columna de competencia, valor pagado, saldo ni estado de pago. La única
cifra de dinero es el **total fijo activo por mes**, que responde "cuánto está comprometido
todos los meses".

---

## 2. Estructura implementada

```text
lib/features/erp/recurring_payments/
  models/
    recurring_payment_model.dart            # enums + modelo + payload (dueño único del contrato)
    recurring_payment_filter_model.dart     # filtro puro y testeable
  service/
    recurring_payment_service.dart          # GET / POST / PUT (AppHttp + bearerToken)
  state/
    recurring_payment_list_state.dart       # lista, filtros y valores derivados
    recurring_payment_form_state.dart       # campos, reglas y payload del formulario
    recurring_payment_options_state.dart    # conceptos de gasto + centros de costo
  store/
    recurring_payment_list_store.dart       # carga, filtros, activar/desactivar
    recurring_payment_form_store.dart       # hidratación, mutación, submit
    recurring_payment_options_store.dart    # carga SOLO conceptos OUTGO activos
  utils/
    recurring_payment_lookup.dart           # resolución de ids → nombres y opciones válidas
  pages/
    recurring_payment_list/
      recurring_payment_list_screen.dart            # entrada de navegación (delgada)
      widgets/
        recurring_payment_list_view.dart            # composición del módulo (testeable)
        recurring_payment_list_header.dart          # título + acción principal
        recurring_payment_summary.dart              # resumen de configuración
        recurring_payment_filters.dart              # barra de filtros (desktop/tablet)
        recurring_payment_filter_fields.dart        # campos de filtro compartidos
        recurring_payment_filters_sheet.dart        # bottom sheet de filtros (mobile)
        recurring_payment_list_body.dart            # decide estado + layout
        recurring_payment_table.dart                # tabla completa (desktop ≥ 1024)
        recurring_payment_cards.dart                # tarjetas (1 columna mobile, 2 tablet)
        recurring_payment_card.dart                 # tarjeta de recurrencia
        recurring_payment_name_cell.dart            # nombre + segunda línea de contexto
        recurring_payment_row_actions.dart          # Editar / Ativar-Desativar / ⋮
        recurring_payment_actions_menu.dart         # acciones secundarias (copiar PIX)
        recurring_payment_status_action.dart        # comportamiento del toggle de estado
        recurring_payment_type_tag.dart             # etiqueta Fixo / Variável
        recurring_payment_pill.dart                 # etiqueta acotada (texto oscuro legible)
        recurring_payment_value.dart                # valor o "Valor variável"
        recurring_payment_empty_state.dart          # estado vazio
        recurring_payment_no_results_state.dart     # búsqueda sin resultados
    recurring_payment_form/
      recurring_payment_form_screen.dart            # entrada de navegación (delgada)
      widgets/
        recurring_payment_form_view.dart            # composición del formulario (testeable)
        recurring_payment_form_body.dart            # Form + validación + guardado
        recurring_payment_basic_section.dart        # sección 1
        recurring_payment_config_section.dart       # sección 2
        recurring_payment_pix_section.dart          # sección 3 (opcional)
        recurring_payment_type_selector.dart        # radio-cards Fixo / Variável
        recurring_payment_switch_row.dart           # fila de switch (estado y PIX)
        recurring_payment_form_not_found.dart       # id de edición inexistente
        recurring_payment_form_actions.dart         # Cancelar / Salvar
        recurring_payment_form_validators.dart      # mensajes de validación

test/features/erp/recurring_payments/
  recurring_payments_visual_test.dart               # smoke test + generador de capturas
  recurring_payment_model_test.dart                 # parsing estricto + payload
  recurring_payment_store_test.dart                 # iglesia, estado conocido y deep link
  recurring_payment_options_store_test.dart         # regla "só gastos" + recarga por iglesia
  recurring_payment_pix_input_test.dart             # máscaras por tipo de chave
test/core/layout/erp/
  menu_items_test.dart                              # regra "só Brasil" no menu
docs/pagamentos-recorrentes/
  *.png                                             # capturas del entregable
```

Archivos existentes tocados (cambio mínimo y explicado):

| Archivo | Cambio | Motivo |
| --- | --- | --- |
| `lib/core/widgets/section_card.dart` | **nuevo** (movido desde `accounts_payable/.../widgets/section_card.dart`) | Era una primitive reutilizada por 2 features; se promueve a `core` en lugar de duplicarla una tercera vez. Se eliminó el archivo original y se actualizaron sus 2 importadores. |
| `lib/core/widgets/index.dart` | export de `section_card.dart` | Ídem. |
| `lib/features/erp/router.dart` | 3 rutas nuevas, cada una con `redirect` a `/dashboard` fuera de Brasil | `/recurring-payments`, `/recurring-payments/add`, `/recurring-payments/edit/:recurringPaymentId`. |
| `lib/core/layout/erp/menu_items.dart` | 1 ítem en **Finanças** con `"countries": ["BR"]` + filtro por país en `menuItems(roles, country)` | Acceso al módulo, solo para iglesias de Brasil. |
| `lib/core/layout/erp/erp_shell.dart` | pasa `session.country` a `menuItems` y reutiliza los ítems ya filtrados | El sidebar/drawer respetan el filtro de país. |
| `lib/features/auth/auth_session_model.dart` | getter `isBrazil` (y `canConnectAsaas` pasa a reutilizarlo) | Un solo lugar decide qué es "iglesia de Brasil". |
| `lib/core/utils/app_localizations_ext.dart` | 1 caso en `menuLabel` | El menú resuelve labels por key. |
| `lib/app/store_manager.dart` + `lib/main_erp.dart` | registro de `RecurringPaymentListStore` | El store es compartido entre listado y formulario (y permite resolver el deep link de edición). |
| `lib/l10n/app_pt.arb`, `app_es.arb`, `app_en.arb` | 95 keys `recurringPayments_*` + `erp_menu_finance_recurring_payments` + `support_assistant_context_recurring_payment_question` | Regla del repo: todo copy visible vive en ARB. |

---

## 3. Componentes

### Reutilizados tal cual (no se inventó ningún estilo)

| Componente | Archivo | Uso en esta feature |
| --- | --- | --- |
| `CustomTable` + `FactoryDataTable` | `core/paginate/custom_table.dart` | Tabla desktop y tabla compacta tablet |
| `Input` | `core/widgets/form_controls.dart` | Nombre, valor (máscara de moneda), chave PIX |
| `Dropdown` | `core/widgets/form_controls.dart` | Concepto, centro de costo, día, tipo de chave, filtros |
| `ButtonActionTable` | `core/widgets/button_acton_table.dart` | Acción principal, acciones por fila, filtros, cancelar |
| `CustomButton` | `core/widgets/custom_button.dart` | Guardar (verde, texto negro, como banco/centro de costo) y CTA del estado vazio (púrpura) |
| `tagStatus` | `core/widgets/tag_status.dart` | Estado (Ativo/Inativo) y "PIX configurado" |
| `Loading` | `core/widgets/loading.dart` | Carga inicial e hidratación por deep link |
| `SectionCard` | `core/widgets/section_card.dart` | Las 3 secciones del formulario |
| `SwitchListTile.adaptive` / `Switch` | Material (patrón del repo) | Estado de la recorrência y PIX opcional |
| `OpenGloriaAssistanceContextButton` | `features/erp/support_assistant/...` | Ayuda contextual del formulario |
| `CurrencyFormatter` | `core/utils/currency_formatter.dart` | Formato BRL y máscara de entrada |
| `Toast` | `core/toast.dart` | Confirmaciones y errores |

### Nuevos (con identidad propia)

| Componente | Responsabilidad única |
| --- | --- |
| `RecurringPaymentListHeader` | Título + acción principal |
| `RecurringPaymentSummary` | Contadores y total fijo activo |
| `RecurringPaymentFilterFields` | Los 3 campos de filtro, reutilizados por barra y sheet |
| `RecurringPaymentFilters` / `...FiltersSheet` | Composición de filtros por tamaño de pantalla |
| `RecurringPaymentListBody` | Selección de estado y de layout |
| `RecurringPaymentListView` / `RecurringPaymentFormView` | Composición sin dependencia de sesión (permite el test de render) |
| `RecurringPaymentTable` / `...Cards` / `...Card` | Presentación por breakpoint |
| `RecurringPaymentNameCell` | Nombre + segunda línea de contexto en una sola columna |
| `RecurringPaymentPill` | Etiqueta acotada de ancho (para `Row` y tarjetas) |
| `RecurringPaymentRowActions` / `...ActionsMenu` / `...StatusAction` | Acciones por ítem |
| `RecurringPaymentTypeTag` / `RecurringPaymentValue` | Lectura de tipo y valor |
| `RecurringPaymentSwitchRow` | Fila de switch con título y descripción |
| `RecurringPaymentOptionsStore` | Carga, para este módulo, solo conceptos `OUTGO` activos y centros de costo activos |
| `pixKeyInputFormatters` / `pixKeyKeyboardType` | Máscara y teclado de la chave PIX segundo o tipo escolhido |
| `RecurringPaymentEmptyState` / `...NoResultsState` | Dos estados distintos, con salidas distintas |
| `RecurringPaymentTypeSelector` | Decisión Fixo/Variável (radio-cards) |
| Secciones, acciones y validadores del formulario | Una responsabilidad por archivo |

---

## 4. Jerarquía visual

### Listado (desktop)

1. **Título** "Pagamentos recorrentes" (24, `fontTitle`) + acción principal `+ Novo pagamento recorrente` (outline púrpura, patrón del ERP).
2. **Resumen**: 4 chips (Recorrências · Ativas · Inativas · Fixo ativo/mês). Punto de color + valor + label; nunca compite con la tabla.
3. **Filtros**: búsqueda por nombre (con icono) + Status + Tipo de valor, y a la derecha "Limpar filtros" (mostaza) / "Aplicar filtros" (azul).
4. **Tabla**: encabezado en mayúsculas sobre fondo `greyLight`, filas con nombre como texto primario y el resto como metadata. Acciones visibles por fila (Editar azul, Ativar/Desativar verde/rojo, ⋮).
5. La fila inactiva se atenúa para leerse como "configurada pero no vigente".

### Formulario

1. **Encabezado**: flecha de volver + título 18 (`fontTitle`) + ayuda contextual.
2. Tres `SectionCard` numeradas con jerarquía decreciente:
   - 1 · Informações básicas (nombre, concepto, centro de custo).
   - 2 · Configuração da recorrência (tipo, valor, día, estado).
   - 3 · PIX reutilizável, con badge **OPCIONAL** y borde azul solo cuando está activo.
3. **Acciones** al final: en desktop hint de campos obligatorios + Cancelar + **Salvar en verde con
   texto negro** (300 px), que es el color de guardar en los formularios del ERP
   (`cost_center_form`, `bank_form`, `form_create_user`, login); en mobile Cancelar/Salvar a ancho
   completo. El púrpura queda para los CTA de entrar a un flujo (por ejemplo el botón del estado
   vazio), no para confirmar.

---

## 5. Reglas responsive

| Largura | Navegación | Listado | Formulario |
| --- | --- | --- | --- |
| ≥ 1024 (desktop) | Sidebar fija | Tabla de 9 columnas, acciones con texto | 2 columnas, acciones a la derecha |
| 768 – 1023 (tablet) | Drawer | Rejilla de **2 columnas de tarjetas** | 2 columnas compactas |
| < 768 (mobile) | Drawer | Tarjetas con acciones a ancho completo, sin scroll horizontal | 1 columna, radio-cards apilados, acciones fijas al pie |

Notas de decisión:

- El proyecto ya define `isMobile(context)` como `< 768` (`core/utils/general.dart`); el
  breakpoint de desktop se fija en 1024 dentro de `RecurringPaymentListBody`.
- **Mobile nunca es una tabla comprimida.** `CustomTable` resuelve mobile con scroll
  horizontal (`SingleChildScrollView`); para configuración eso es inaceptable, así que cada
  recorrência se convierte en tarjeta.
- En tablet la tabla no cabe con criterio: `CustomTable` reserva ~56 px por columna
  (`DataTable.columnSpacing`), así que 6 columnas ya no entran en 834 px sin recortar datos. Se
  resuelve con **rejilla de dos tarjetas por fila**, que mantiene nombre, concepto, centro de
  costo, tipo, valor, vencimiento, estado y PIX visibles.
- En desktop 9 columnas tampoco caben en 1440 px: el concepto y el centro de costo viajan como
  segunda línea de la celda del nombre (`Aluguel · Templo`), y el encabezado lo declara
  (`Nome / Conceito / Centro de custo`).
- Navegación: el sidebar ya se oculta con `isMobile` y el `Drawer` se crea con ancho < 800.
  Con el breakpoint de contenido en 1024 conviene alinear el drawer a 1024 para que la franja
  tablet tenga ancho útil. **Recomendación de una línea** en `erp_shell.dart`, no aplicada en
  este entregable para no cambiar navegación global sin pedido explícito.

---

## 6. Estados

| Estado | Cuándo | Qué se ve | Salida |
| --- | --- | --- | --- |
| Cargando | Primera carga sin datos | `Loading` centrado | — |
| Vazio | 0 recorrências | Sin resumen, sin filtros; icono, título, copy y CTA | **Criar primeiro pagamento recorrente** |
| Con datos | ≥ 1 recorrência | Resumen + filtros + tabla/tarjetas | Editar / Ativar-Desativar / copiar PIX |
| Busca sin resultados | Hay datos, los filtros no matchean | Resumen y filtros siguen visibles; contador "Exibindo 0 de N" | **Limpar filtros** (nunca el CTA de creación) |
| Hidratando (deep link) | Se abrió `/edit/:id` sin objeto en memoria | `Loading` durante el fetch | — |

La distinción vazio vs sin-resultados es deliberada: en vazio no hay nada que administrar y la
acción es crear; en sin-resultados los datos existen y la acción es limpiar filtros.

---

## 7. Formulario: reglas de interacción

### Tipo de valor (la decisión central)

- Se elige con **radio-cards** (nuevo `RecurringPaymentTypeSelector`), no con dropdown: la
  decisión cambia el resto del formulario y debe estar siempre visible.
- `Valor fixo` → aparece el campo "Valor mensal" (con máscara de moneda) y es obligatorio.
- `Valor variável` → el campo desaparece (no se deshabilita con valor 0) y en su lugar se
  explica que el monto se informa cada mes. Al cambiar a variável, el store limpia el valor:
  el dominio prohíbe `amount` en `VARIABLE` (`RECURRING_PAYMENT_VARIABLE_AMOUNT_FORBIDDEN`).
- En el listado, `VARIABLE` se muestra como *Valor variável* en itálico; nunca "R$ 0,00".

### Conceito financeiro: somente gastos

El dropdown de conceptos ofrece **únicamente conceptos de gasto (`OUTGO`) activos**. No es una
preferencia de UI: es el contrato del backend, que valida el concepto con
`type: ConceptType.OUTGO` + `active: true` al crear o actualizar la recurrencia
(`CreateOrUpdateRecurringPayment.assertImputation`) y está documentado en
`gloria_finance_api/docs/recurring-payments.md` §3 ("Debe ser un concepto de tipo `OUTGO` activo
de la iglesia"). Quedan fuera, por lo tanto:

| Tipo | Por qué no aparece |
| --- | --- |
| `INCOME` | Es una entrada, no un gasto |
| `PURCHASE` | Tiene su propio módulo (Compras); el backend lo rechazaría con `RECURRING_PAYMENT_FINANCIAL_CONCEPT_INVALID` |
| `REVERSAL` | Es un estorno |
| `OUTGO` inactivo | El backend exige `active: true` |

La regla vive en una sola función (`expenseFinancialConcepts`) y se aplica dos veces:

1. En la **query** del endpoint (`type=OUTGO`), para no traer entradas.
2. En el **cliente**, porque es el contrato del dominio y no debe depender de lo que devuelva la red.

Y se carga con un store propio del módulo (`RecurringPaymentOptionsStore`) en lugar del store
global de conceptos. Motivo concreto: `FinancialConceptStore` guarda el resultado del **último
filtro** aplicado en la pantalla de Configurações → Conceptos financeiros; si el tesorero filtró
"Entrada" allí, el formulario de pagos recurrentes se habría quedado con el dropdown vacío (y la
tabla mostrando `—` en la columna de concepto). El mismo store resuelve los nombres de concepto y
centro de costo en el listado, así que la lista y el formulario siempre leen la misma fuente.

Si un registro viejo apunta a un concepto que ya no es `OUTGO`, el dropdown no lo precarga: el
tesorero debe elegir un concepto de gasto antes de guardar. Es el comportamiento correcto, porque
el backend rechazaría el payload anterior.

### PIX reutilizável: o tipo vem antes da chave

O tipo da chave **define o formato**, então ele é o primeiro campo do panel e a chave vem depois,
já com máscara:

| Tipo | Campo da chave | Máscara | Teclado |
| --- | --- | --- | --- |
| CPF | `###.###.###-##` | numérica | número |
| CNPJ | `##.###.###/####-##` | numérica | número |
| PHONE | `(##) #####-####` | numérica | número |
| EMAIL | — | livre | e-mail |
| EVP | — | livre | texto |

Decisões:

- **E-mail e EVP não têm máscara** de propósito: mascarar um e-mail ou um UUID (EVP) só atrapalha
  a digitação e pode truncar o valor colado.
- **Trocar o tipo limpa a chave já digitada.** Um CPF não pode continuar dentro de um campo de
  CNPJ; o valor anterior perderia o sentido com a nova máscara.
- **Não há validação de formato além de "obrigatório".** O domínio só exige chave não vazia e tipo
  dentro da lista (`RecurringPayments.assertConfiguration`), então a máscara orienta a digitação
  sem inventar uma regra mais rígida que a do contrato — que rejeitaria valores que o backend
  aceita.
- As máscaras vêm de `MaskedInputFormatter` (`flutter_multi_formatter`), o mesmo formatter que o
  repo já usa para CPF de membros e telefone.

### Situação: só aparece na edição

O estado (`ACTIVE`/`INACTIVE`) faz parte do contrato — é o ciclo de vida da recorrência, já que a
API não expõe exclusão (`DELETE`): desativar é a forma de parar um compromisso que deixou de
existir. Mas no **formulário de criação** ele não tem consequência nenhuma: uma recorrência nova
nasce ativa.

Por isso:

| Contexto | O que a tela mostra |
| --- | --- |
| Criação | Nenhum switch. Uma nota explica: **"A recorrência é criada ativa. Para pausá-la depois, use Desativar na listagem."** O payload envia `status: ACTIVE`. |
| Edição | Rótulo **Situação** + switch, com a consequência escrita: ativa "entra em todos os meses como pagamento a fazer"; inativa "pausa a recorrência… deixa de entrar nos próximos meses — use quando o compromisso terminar (ex.: fim do contrato de aluguel)". |
| Listagem | Ações **Ativar** / **Desativar** por linha, para pausar sem abrir o formulário. |

O texto foi reescrito porque a versão anterior ("a Glória considera este compromisso todos os
meses") descrevia a própria definição de recorrência e não dizia quando desativar. Agora a copy
responde à pergunta real do tesoureiro: *quando eu uso isto?*

### Centro de custo

Obligatorio en el modelo (todo gasto se imputa) y por eso vive en **Informações básicas**, con
asterisco y helper "Obrigatório: todo gasto é alocado a um centro de custo". No hay caso válido
sin centro de custo.

### PIX reutilizable (opcional de verdad)

- Es la **tercera** sección y nace **desactivada** detrás de un switch explícito
  ("Salvar destino PIX para uso futuro").
- El badge **OPCIONAL** y el subtítulo dejan claro que no es obligatorio y que no define la
  forma de pago.
- El helper explica el significado real: la chave podrá reutilizarse cuando la iglesia ejecute
  pagos por el banco (Asaas), y **no** significa que la recurrencia se pague por PIX.
- **No existe** ningún selector `PIX | BOLETO` en la configuración permanente.
- En el listado, "Sem PIX configurado" es texto neutro: no es error ni pendiente.

### Día de vencimiento

Select 1–31 con helper "Se o mês não tiver este dia, será considerado o último dia válido."
(es la regla del backend en `dueDateForCompetence`).

### Validación

Validación de UI en el propio `Form` (los mensajes replican las invariantes del dominio) y
validación final en el store (`isComplete`) antes de armar el payload:

| Campo | Regla | Key de copy |
| --- | --- | --- |
| Nome | obligatorio | `recurringPayments_error_name_required` |
| Conceito financeiro | obligatorio, solo conceptos `OUTGO` activos | `recurringPayments_error_concept_required` |
| Centro de custo | obligatorio, solo centros activos | `recurringPayments_error_cost_center_required` |
| Valor | obligatorio solo si `FIXED` | `recurringPayments_error_amount_required` |
| Dia de vencimento | obligatorio | `recurringPayments_error_due_day_required` |
| Chave PIX | obligatoria solo si el switch está activo | `recurringPayments_error_pix_key_required` |

Errores de servidor (por ejemplo `RECURRING_PAYMENT_IN_PROGRESS` al editar mientras hay una
ejecución en curso) se muestran con el `Toast` que ya usa `AppHttp.transformResponse`. El
entregable **no** diseña ninguna pantalla de ejecución.

---

## 8. Contrato de datos

### Lectura (`GET /api/v1/recurring-payments/`)

El endpoint devuelve la configuración **más** `competenceStatus` de la competencia corriente.
Esta pantalla consume únicamente la configuración y **descarta `competenceStatus`** de forma
deliberada: ese dato pertenece al flujo de "pagos del mes", que está fuera de alcance.

| UI | Campo del contrato | Tratamiento |
| --- | --- | --- |
| Nombre | `name` | texto primario |
| Conceito financeiro | `financialConceptId` | se resuelve a nombre con `FinancialConceptStore` |
| Centro de custo | `costCenterId` | se resuelve a nombre con `CostCenterListStore` |
| Tipo | `type` (`FIXED` \| `VARIABLE`) | etiqueta Fixo/Variável |
| Valor | `amount` | definido solo en `FIXED`; en `VARIABLE` se muestra "Valor variável" |
| Vencimento | `dayOfMonth` | "Dia N" |
| Status | `status` (`ACTIVE` \| `INACTIVE`) | etiqueta + acción Ativar/Desativar |
| PIX | `pixDestination.pixKey` / `.pixKeyType` | "PIX configurado" / "Sem PIX configurado" |

### Escritura (`POST /` y `PUT /:id`)

`RecurringPaymentConfigurationPayload.build(...)` es el **dueño único** de la forma del
payload, y lo usan tanto el modelo leído de la API como el formulario:

```json
{
  "name": "Aluguel do templo",
  "financialConceptId": "…",
  "costCenterId": "…",
  "type": "FIXED",
  "amount": 3500,
  "dayOfMonth": 10,
  "status": "ACTIVE",
  "pixDestination": { "pixKey": "12.345.678/0001-90", "pixKeyType": "CNPJ" }
}
```

`amount` se omite cuando el tipo es `VARIABLE` y `pixDestination` se omite cuando no existe.

### Punto de atención (backend)

El endpoint actual está atado a competencia (`?competence=YYYY-MM`) y filtra recurrencias
creadas después de esa competencia. Para una pantalla de configuración lo ideal es un endpoint
sin competencia, por ejemplo `GET /api/v1/recurring-payments/configurations`, que devuelva
`RecurringPaymentConfigurationData[]` ordenado por `dayOfMonth` y `name`. Mientras no exista,
este cliente funciona con el endpoint actual **sin** usar `competenceStatus` ni valores pagados.
Como el endpoint no pagina, la lista se carga completa y se filtra en el cliente; por eso la
tabla no muestra paginación. Si una iglesia acumula muchas recurrencias habrá que paginar
(cliente o servidor) y ese cambio se hace en `RecurringPaymentListState`.

---

## 9. Copy (português do Brasil)

| Key | Texto |
| --- | --- |
| `recurringPayments_list_title` | Pagamentos recorrentes |
| `recurringPayments_new_action` | Novo pagamento recorrente |
| `recurringPayments_filter_search_label` | Buscar por nome |
| `recurringPayments_filter_status_label` | Status |
| `recurringPayments_filter_type_label` | Tipo de valor |
| `recurringPayments_filter_all` | Todos |
| `recurringPayments_filter_open_action` | Filtros |
| `recurringPayments_filter_result_count` | Exibindo {visible} de {total} recorrências |
| `recurringPayments_summary_total` | Recorrências |
| `recurringPayments_summary_active` | Ativas |
| `recurringPayments_summary_inactive` | Inativas |
| `recurringPayments_summary_fixed_month` | Fixo ativo / mês |
| `recurringPayments_type_fixed` | Fixo |
| `recurringPayments_type_variable` | Variável |
| `recurringPayments_amount_variable` | Valor variável |
| `recurringPayments_due_day` | Dia {day} |
| `recurringPayments_pix_configured` | PIX configurado |
| `recurringPayments_pix_not_configured` | Sem PIX configurado |
| `recurringPayments_pix_short_not_configured` | Sem PIX |
| `recurringPayments_empty_title` | Nenhum pagamento recorrente cadastrado |
| `recurringPayments_empty_description` | Você ainda não possui pagamentos recorrentes cadastrados. Cadastre compromissos mensais como aluguel, energia, água e outros gastos recorrentes. |
| `recurringPayments_empty_cta` | Criar primeiro pagamento recorrente |
| `recurringPayments_empty_cta_short` | Criar primeiro pagamento (mobile, para no truncar) |
| `recurringPayments_table_name_concept_cost_center` | Nome / Conceito / Centro de custo |
| `recurringPayments_no_results_title` | Nenhum resultado encontrado |
| `recurringPayments_no_results_description` | Nenhuma recorrência corresponde aos filtros aplicados. |
| `recurringPayments_activate_action` | Ativar |
| `recurringPayments_deactivate_action` | Desativar |
| `recurringPayments_menu_copy_pix_key` | Copiar chave PIX |
| `recurringPayments_edit` (reutiliza `common_edit`) | Editar |
| `recurringPayments_form_title_create` | Novo pagamento recorrente |
| `recurringPayments_form_title_edit` | Editar pagamento recorrente |
| `recurringPayments_section_basic_title` | Informações básicas |
| `recurringPayments_section_config_title` | Configuração da recorrência |
| `recurringPayments_section_pix_title` | PIX reutilizável |
| `recurringPayments_optional_badge` | Opcional |
| `recurringPayments_field_due_day` | Dia de vencimento |
| `recurringPayments_helper_due_day` | Se o mês não tiver este dia, será considerado o último dia válido. |
| `recurringPayments_helper_cost_center` | Obrigatório: todo gasto é alocado a um centro de custo. |
| `recurringPayments_type_fixed_hint` | O valor é o mesmo todos os meses. Ex.: aluguel, internet. |
| `recurringPayments_type_variable_hint` | O valor muda a cada mês. Ex.: água, energia. |
| `recurringPayments_variable_amount_note` | Valor variável: nenhum valor fixo é guardado nesta configuração. O valor será informado em cada mês, no momento de registrar o pagamento. |
| `recurringPayments_pix_toggle_label` | Salvar destino PIX para uso futuro |
| `recurringPayments_pix_panel_title` | Destino reutilizável (opcional) |
| `recurringPayments_helper_pix` | Esta chave poderá ser reutilizada em pagamentos futuros quando a igreja utilizar execução bancária via Asaas. Não significa que esta recorrência é paga por PIX. |
| `recurringPayments_save_action` | Salvar recorrência |
| `recurringPayments_field_status` | Situação |
| `recurringPayments_status_active_description` | Ativa: entra em todos os meses como pagamento a fazer. |
| `recurringPayments_status_inactive_description` | Inativa: pausa a recorrência. Ela continua cadastrada, mas deixa de entrar nos próximos meses — use quando o compromisso terminar (ex.: fim do contrato de aluguel). |
| `recurringPayments_status_create_note` | A recorrência é criada ativa. Para pausá-la depois, use Desativar na listagem. |
| `recurringPayments_update_action` | Salvar alterações |

Las traducciones **es** e **en** se agregaron en el mismo cambio (`app_es.arb`, `app_en.arb`),
porque el repo mantiene los 3 idiomas en paralelo.

---

## 10. Accesibilidad

- El estado nunca se comunica solo por color: cada etiqueta tiene texto
  (Ativo/Inativo, Fixo/Variável, PIX configurado).
- La etiqueta de tipo usa fondo suave con texto oscuro en lugar del `tagStatus` sólido: el
  blanco sobre mostaza (#FAB42E) no alcanza contraste suficiente, y además evita dos bloques
  sólidos compitiendo en la misma fila.
- Objetivos táctiles ≥ 34–44 px en mobile (botones de acción dentro de la tarjeta a ancho
  completo); en tablet las acciones en ícono tienen `Tooltip` con la etiqueta.
- Los campos con error muestran borde rojo **y** mensaje con ícono.
- El foco de los inputs mantiene el borde gris del sistema con `AutovalidateMode.onUserInteraction`.

---

## 11. Decisiones y descartes

1. **Página, no modal.** El formulario tiene 3 secciones y ~7 campos; con URL propia gana deep
   link, refresh y un solo código para desktop y mobile. Es además el patrón del ERP para
   configuración (`/cost-center/add`, `/financial-concepts/add`). Si el producto prefiere modal,
   `ModalPage(width: 900)` ya existe y admite el mismo cuerpo.
2. **Sin paginación.** El endpoint devuelve la colección completa; agregar paginación de cliente
   hoy sería maquinaria sin uso. Queda documentado como punto de crecimiento.
3. **Sin acción "Excluir".** La API no expone DELETE para recurrencias; el ciclo de vida es
   Ativar/Desativar. Inventar borrado habría sido diseñar contra el contrato.
4. **Sin acción "Pagar".** Fuera de alcance de este entregable.
5. **Conceptos filtrados a `OUTGO` activos (solo gastos).** Es el contrato del backend, no una
   decisión de UI: se resuelve en `expenseFinancialConcepts()` y el módulo carga sus propias
   opciones para no heredar los filtros del store global de conceptos. Cambiar el criterio (por
   ejemplo admitir `PURCHASE`) exige cambiar primero el backend, porque `assertImputation` lo
   rechaza.
6. **Filtros con "Aplicar".** Se mantiene el patrón de las otras listas del ERP (draft +
   aplicado) aunque los datos estén en memoria: consistencia de aprendizaje para el tesorero.
   En mobile los filtros viven en un bottom sheet, no en una fila comprimida.
7. **Exclusivo do Brasil.** O item de menu é declarativo (`countries`) e as rotas têm guard: a
   regra vive em um só lugar por camada, em vez de condicionais espalhados nas telas. O
   formulário não precisa checar país de novo, porque o módulo inteiro já é brasileiro.
8. **Estado vazio sin degradado.** Es una superficie blanca con borde de 1 px, igual que las demás
   superficies del ERP; el único acento de color es el ícono en púrpura suave. Un gradiente
   decorativo ahí rompía la consistencia con el resto del módulo.
9. **Sin color-coding de "Fixo/Variável" en el resumen.** El resumen cuenta configuraciones; el
   color se reserva para estado (activo/inactivo).

---

## 12. Capturas del entregable

Generadas desde el propio widget tree con el test de capturas (`docs/pagamentos-recorrentes/`):

| Archivo | Qué muestra |
| --- | --- |
| `desktop-01-listado.png` | Listado desktop 1440 · tabla completa, resumen, filtros y acciones por fila |
| `desktop-02-vazio.png` | Estado vacío desktop con el CTA de creación |
| `desktop-05-sem-resultados.png` | Búsqueda sin resultados (datos existen, filtros no matchean) |
| `desktop-03-form-novo-fixo.png` | Formulario desktop · **creación** con Valor fixo (sin switch de situación) |
| `desktop-04-form-novo-variavel-pix.png` | Formulario desktop · **creación** con Valor variável + PIX activado (sin campo de valor; tipo da chave antes e chave com máscara CNPJ) |
| `desktop-06-form-editar.png` | Formulario desktop · **edición**, con la sección Situação visible |
| `tablet-01-listado.png` | Tablet 834 · rejilla de dos tarjetas por fila |
| `mobile-01-cards.png` | Mobile 390 · tarjetas con acciones a ancho completo |
| `mobile-02-vazio.png` | Estado vacío mobile con CTA corto |
| `mobile-04-sem-resultados.png` | Sin resultados mobile (resumen y filtros siguen visibles) |
| `mobile-03-form.png` | Formulario mobile · una columna, captura extendida |

Los PNG se regeneran con:

```bash
flutter test --dart-define=GENERATE_SCREENSHOTS=true \
  test/features/erp/recurring_payments/recurring_payments_visual_test.dart
```

### Lo que el test encontró y se corrigió

Correr las pantallas (no solo el analyzer) atrapó tres defectos reales que el análisis estático no ve:

1. **`SwitchListTile.adaptive` dentro de la `SectionCard`**: Flutter lanza
   *“ListTile background color or ink splashes may be invisible”* porque el `ListTile` necesita su
   propio `Material` cuando vive dentro de una superficie con color. Se reemplazó por una fila
   `Switch` + textos (`RecurringPaymentSwitchRow`), que además es el patrón del repo.
2. **`tagStatus` dentro de un `Row`**: ese widget usa `width: double.infinity`, así que en la
   tarjeta mobile forzaba *“BoxConstraints forces an infinite width”*. Se creó
   `RecurringPaymentPill` (acotado, con texto oscuro legible) para los contextos que no son celda
   de tabla.
3. **Overflow horizontal de la tabla**: con 9 columnas + acciones, el `DataTable` se desbordaba
   57 px incluso a 1440 px, y en tablet se comprimía hasta partir el contenido. Se agruparon
   columnas (concepto + centro de costo en la celda del nombre) y tablet pasó a tarjetas.

También se ajustó el estado vacío para que ocupe el ancho completo y el CTA mobile para que no se
trunque.

## 13. Correcciones de la revisión de código

Comentarios automáticos de revisión sobre el PR y qué se hizo con cada uno:

| Comentario | Qué pasaba | Cómo quedó |
| --- | --- | --- |
| **Buscador no atado al estado** (P2) | La barra construía el buscador sin `initialValue`, así que `clearFilters()` vaciaba el store pero el campo seguía mostrando la búsqueda vieja; el listado ya estaba sin filtrar y parecía que no | `RecurringPaymentSearchField` lee el término del store. Las capturas de "sem resultados" ahora muestran la búsqueda aplicada, que es la prueba visual del arreglo |
| **Parsing de enums demasiado permisivo** (P2) | `fromApiValue` con `orElse` convertía en silencio un valor desconocido en `FIXED`/`ACTIVE`/`CPF`; al editar y guardar se sobrescribía la configuración real | `tryFromApiValue` devuelve `null`. La pantalla muestra estado neutro ("Tipo/Situación não reconhecido"), no ofrece activar/desactivar y el formulario **obliga a elegir** el tipo. En el payload, `status` se omite cuando es nulo: el backend conserva el actual (`request.status ?? existing.getStatus()`), así que no se inventa ningún valor |
| **Destino de edición inexistente** (P2) | Un id viejo o inexistente dejaba el formulario en modo creación: al guardar hacía `POST` y creaba una recorrência nueva desde una ruta de edición | El id de la URL se conserva (`isEdit` queda en true), `initialize()` marca `isEditTargetMissing`, el formulario muestra "não encontrado" con vuelta al listado y `submit()` no hace `POST` |
| **Cachés sin dueño de iglesia** (P1) | Los stores viven en `StoreManager` y sobreviven al logout: si entraba otra iglesia, la lista y las opciones seguían siendo las anteriores (fuga entre iglesias) | Ambos stores guardan `loadedChurchId` y exponen `needsLoad(churchId)`: recargan cuando cambia la iglesia, no solo cuando están vacíos |

Cada arreglo quedó cubierto por tests: parsing estricto y reglas del payload
(`recurring_payment_model_test.dart`), iglesia + activar/desactivar + deep link de edición
(`recurring_payment_store_test.dart`) y la recarga de opciones por iglesia
(`recurring_payment_options_store_test.dart`).

## 14. Cómo revisar

```bash
# El SDK de Flutter del equipo vive en /Volumes/SSD/SDK/flutter (SSD externo).
# Para validar este entregable se instaló una copia local arm64 de Flutter 3.47.7:
export PATH="$HOME/development/flutter/bin:$PATH"

cd gloria_finance_front
flutter gen-l10n                 # regenera lib/l10n/app_localizations*.dart
flutter analyze                  # 0 errores (mismos infos que ya tiene el repo)
flutter test test/features/erp/recurring_payments/recurring_payments_visual_test.dart
flutter run -d chrome            # o el dispositivo/emulador habitual
```

Resultado de la verificación:

- `flutter analyze lib`: **0 errores**, 34 warnings y 285 infos, todos preexistentes en otros
  archivos; el feature nuevo aporta 10 infos (los mismos enums UPPER_CASE y `Switch.activeColor`
  que ya usa el resto del repo).
- `flutter test`: **44/44** verde.
  - `recurring_payments_visual_test.dart` (11): render en 1440, 834 y 390; estados vazio y sin
    resultados; creación (fixo y variável + PIX) y edición; y la comprobación de que **no** hay
    switch de situación al crear y **sí** al editar, con el texto de pausa al desactivar.
  - `recurring_payment_model_test.dart` (7): parsing estricto de los enums y reglas del payload
    (omite `status` y `pixDestination` cuando no se conocen).
  - `recurring_payment_store_test.dart` (7): invalidación por iglesia, activar/desactivar solo con
    estado conocido, y el deep link de edición que no se convierte en creación.
  - `recurring_payment_pix_input_test.dart` (7): máscaras de CPF, CNPJ e telefone; e-mail e EVP sem
    máscara; teclado por tipo; e trocar o tipo limpa a chave.
  - `recurring_payment_options_store_test.dart` (6): o dropdown recebe **só `OUTGO` ativo** mesmo
    quando o serviço devolve entradas, compras, estornos e inativos; a query pede `OUTGO`; só
    centros de custo ativos; e uma falha de rede não quebra a tela.
  - `menu_items_test.dart` (6): o módulo aparece só para `BR` (`ve`, `us`, `bo`, `pt` ficam de
    fora), comparação sem depender de maiúsculas, os outros itens de Finanças continuam visíveis e
    a seção Configurações segue escondida de `TREASURER`.

Rutas para revisar la experiencia completa:

- `/recurring-payments` — listado (tabla en desktop/tablet, tarjetas en mobile).
- `/recurring-payments/add` — creación; probar `Valor fixo` vs `Valor variável` y el switch PIX.
- `/recurring-payments/edit/<recurringPaymentId>` — edición (también funciona por deep link).

Para ver los estados vacío y sin resultados: desactivar los permisos/datos o escribir una
búsqueda sin coincidencias en la barra de filtros.

---

## 15. Fuera de alcance (recordatorio)

Ejecutar pago · selección PIX/Boleto en la ejecución · línea digitável · cámara · webhook ·
comprobantes · estados PROCESSING/BLOCKED/FAILED · detalle de competencia · modal de pagar ·
registro manual del pago.
