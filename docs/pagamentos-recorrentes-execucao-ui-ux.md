# Pagamentos Recorrentes — Ejecución mensual (UI/UX, segundo entregable)

Diseño e implementación de la **ejecución mensual** de los pagamentos recorrentes de Glória
Finance (ERP para igrejas): qué compromisos del mes están pendientes, procesando o pagados, y cómo
se ejecuta cada uno **con** y **sin** banca Asaas conectada.

El primer entregable (listado administrativo, creación, edición, activación/desactivación,
`FIXED`/`VARIABLE` y `pixDestination`) **no se rediseña**: esta pantalla convive con él como la
pestaña *Mês* del mismo módulo.

- Alcance exclusivo: ejecución mensual. Fuera: rediseñar la configuración, ejecución desde otras
  pantallas y cualquier funcionalidad no listada al final de este documento.
- Solo iglesias de Brasil (el módulo ya está restringido por país).
- Copy visible en **português do Brasil**; claves en `l10n` (`pt`/`es`/`en`).

## 1. Principio de diseño

> **Não pergunte novamente o que o usuário já configurou.**

Todo dato que vive en la configuración se **muestra** (solo lectura); el usuario solo informa lo que
es propio de **esa** ejecución. Caso ideal:

```text
Aluguel FIXED + PIX configurado
PAGAR → revisar R$ 3.500 + destino PIX → CONFIRMAR
```

Nunca: `PAGAR → digitar valor → digitar chave → escolher tipo → confirmar`.

## 2. Navegación

`/recurring-payments` abre el módulo con dos pestañas:

| Pestaña | Ruta | Contenido |
| --- | --- | --- |
| **Mês** (por defecto) | `/recurring-payments` | Ejecución mensual |
| **Configuração** | `/recurring-payments/configuration` | Listado administrativo del entregable 1 |

El formulario de la recurrencia vuelve a *Configuração* (es su contexto). Los flujos de ejecución se
abren como **modal lateral/central** en desktop y **bottom sheet** en mobile.

## 3. Pantalla mensual

Selector de competencia `‹ OUTUBRO 2026 ›`, resumen del mes y la lista de compromisos.

- **Resumen**: `Pendentes: N · Pagos: N`, total **solo de los valores fijos** pendientes y, aparte,
  la cantidad de pendientes con valor variable (un variable no tiene importe antes de pagarse: sumar
  cero mentiría).
- **Desktop (≥ 1024)**: tabla de 4 columnas (nombre + concepto · centro de costo, vencimiento, valor
  y estado) con las acciones en la última columna.
- **Tablet (768–1023)**: rejilla de **dos** columnas de tarjetas (no se comprime la tabla).
- **Mobile (< 768)**: una columna de tarjetas, sin tabla ni scroll horizontal.

Tarjeta de mobile (según el brief):

```text
Aluguel do templo                     Pendente
10 OUT · Templo
R$ 3.500,00
[ REGISTRAR PAGAMENTO ]  (o [ PAGAR ] con Asaas)
```

El **vencimiento** se calcula con la misma regla que el backend (`min(dia, último dia do mês)`), así
que un día 31 muestra 28 en febrero; la competencia se resuelve en el calendario de São Paulo
(UTC-3), no en el del dispositivo.

## 4. Estados de la competencia

Los calcula el backend (`ListRecurringPayments.competenceStatus`); la UI solo los interpreta y los
colorea para distinguirlos de un vistazo:

| Estado | Copy | Color | Acciones |
| --- | --- | --- | --- |
| `PENDING` | Pendente | purple | Ejecutar |
| `UPCOMING` | A vencer | blue | Ejecutar |
| `PROCESSING` | Processando | blue | **No** inicia otra operación; atualizar status |
| `BLOCKED` | Bloqueado | mustard | **No** retry ni nuevo pago; solo atualizar status |
| `FAILED` | Falhou | red | **Tentar novamente** (ejecución nueva) |
| `PAID` | Pago | green | Ver detalle (+ cancelar si es registro manual) |
| `INACTIVE` | Inativo | grey | Ver detalle |

Reglas que la UI respeta y no recalcula:

- **PAID tiene prioridad histórica**: si la competencia quedó pagada y después la recurrencia se
  desactivó, sigue mostrándose **Pago** (y la tarjeta lo explica).
- Mientras exista **una** operación viva (`PROCESSING`) en el mes, ninguna otra fila ofrece pago:
  el backend lo rechazaría y la pantalla no ofrece lo que será negado.
- Un estado desconocido se muestra como **"Estado não reconhecido"** y nunca habilita un pago.

## 5. Matriz de ejecución (la parte central del entregable)

**La diferencia determinante no es `FIXED`/`VARIABLE` sino la capacidad bancaria**: el tipo decide
*qué datos* se piden; la banca decide *si Glória ejecuta o solo registra*.

| Caso | Configuración | Flujo | Qué NO se vuelve a pedir |
| --- | --- | --- | --- |
| A | Sin Asaas | **REGISTRAR PAGAMENTO**: data, conta, comprovante (obligatorio) y valor solo si es variable | Valor (en `FIXED`), y **nunca** PIX/boleto: Glória no ejecutó nada |
| 1 | `FIXED` + `pixDestination` | **PAGAR** → confirmación PIX directa | valor, chave, tipo de chave, método |
| 2 | `FIXED` sin `pixDestination` | **PAGAR** → elegir PIX o boleto | valor (ya está definido) |
| 3 | `VARIABLE` + `pixDestination` | **PAGAR** → valor + método; PIX hereda el destino | chave y tipo de chave |
| 4 | `VARIABLE` sin `pixDestination` | **PAGAR** → valor + método; si es PIX, chave y tipo | — |

En los cuatro casos con Asaas la **cuenta** es la conectada (`Conta Asaas conectada`): se muestra, no
se pregunta.

### A. Iglesia sin Asaas — registro manual

`REGISTRAR PAGAMENTO` informa que el gasto se pagó **fuera** de Glória, así que:

- **no** se pregunta PIX, boleto, chave ni método externo (a nadie le sirve ese dato);
- se pide **data do pagamento**, **conta utilizada** y **comprovante obligatorio**;
- el **valor** se pide solo en `VARIABLE`; en `FIXED` se muestra como lectura con la nota
  *"Definido na configuração da recorrência"*;
- al enviar se muestra *"Processando registro…"* (el backend procesa el registro de forma asíncrona,
  sin arquitectura adicional inventada).

### B. Iglesia con Asaas — PIX

La confirmación **no es un formulario**: revisa lo que ya se sabe (nombre, competencia, valor,
destino PIX con la nota *"Configurado no pagamento recorrente"*, cuenta) y avisa
*"Após confirmar, o pagamento será enviado para processamento bancário."*

Después de confirmar **no se dice "Pago"**: se muestra *"Pagamento enviado"* / *Processando* hasta
que exista confirmación bancaria.

### C. Iglesia con Asaas — boleto

Entrada con dos caminos, ambos visibles:

```text
Como deseja informar o boleto?
  [câmera]  LER COM A CÂMERA   "Aponte a câmera para o código de barras"
  [teclado] DIGITAR LINHA      "Informe a linha digitável do boleto"
```

- **Cámara** (mobile primero): preview con guía, *"Posicione o código de barras dentro da área
  indicada."*, y la alternativa *"Digitar linha manualmente"* **siempre** visible. Estados de
  permiso: *"Permitir acesso à câmera"* → *"Não foi possível acessar a câmera."* con
  `DIGITAR LINHA MANUALMENTE`.
- **Linha digitável**: campo ancho, fuente legible y teclado numérico; acepta 44 (código de barras) o
  47 dígitos (linha digitada) y rechaza los 48 de arrecadação/convênio.
- **Valor**: en el flujo de boleto **el usuario no escribe el valor**, porque el boleto ya define
  cuánto se paga. El valor lo lee el banco de la propia línea (`church-banking`) y lo devuelve en la
  misma llamada.
- **Resultado**:
  - si los valores coinciden → *BOLETO VALIDADO* / *"Os valores conferem."* + **Valor do boleto** y
    el pago queda en procesamiento;
  - si no coinciden → **VALORES DIFERENTES** con *Valor esperado*, el *Valor do boleto* cuando el
    banco lo informa, y el mensaje *"O valor do boleto é diferente do valor esperado para este
    pagamento. Nada foi debitado."* con `[VOLTAR] [REVISAR BOLETO]`. **No existe "pagar mesmo
    assim"**: church-banking rechaza la diferencia **antes** de debitar.

## 6. PROCESSING / BLOCKED / FAILED / PAID

| Estado | Contenido | Acciones |
| --- | --- | --- |
| PROCESSING | valor, método, referencia, última actualización + *"O pagamento foi enviado ao banco e estamos aguardando a confirmação."* | **ATUALIZAR STATUS**; ninguna operación nueva |
| BLOCKED | los mismos datos + *"O banco ainda está processando ou aguardando resolução."* | **ATUALIZAR STATUS**. Sin *"Tentar novamente"* y sin nueva referencia |
| FAILED | motivo comprensible; si fue diferencia de importe, los dos valores | **TENTAR NOVAMENTE** (ejecución nueva; el intento anterior terminó) |
| PAID | valor, fecha, origen, cuenta y comprovante | **Cancelar registro** solo si es manual; en `RECONCILED` se explica que *"Um débito bancário confirmado não pode ser cancelado."* |

Cancelar un registro manual avisa: *"Este registro será anulado e o pagamento voltará a aparecer como
pendente nesta competência. A recorrência continua ativa."* — el asiento pasa a `VOID` y la
competencia vuelve a `PENDING`; la recurrencia **no** se desactiva (se reutiliza
`PATCH /finance/financial-record/cancel/:id`, que ya existía).

## 7. Contrato de datos

Sin recalcular nada en el cliente:

| Necesidad de la pantalla | Origen |
| --- | --- |
| Compromisos de la competencia | `GET /api/v1/recurring-payments?competence=YYYY-MM` |
| Estado de la competencia | `competenceStatus` (los 7 estados del backend) |
| Detalle de la ejecución en curso | `currentPayment` (valor, método, referencia, `providerStatus`, `failureCode`, `updatedAt`) |
| Cómo se pagó | `settlement` (valor, fecha, `CLEARED`/`RECONCILED`, cuenta, comprovante) |
| Ejecución bancaria | `POST /:id/pay` con `{competence, amount?, payment: PIX|BILL, availabilityAccountId?}` |
| Registro manual | `POST /:id/register-payment` (multipart, `file` obligatorio) |
| Cancelar registro manual | `PATCH /finance/financial-record/cancel/:financialRecordId` |
| Banca conectada | `AuthSessionModel.asaasConnect` |

### Cambio aditivo requerido en el API (PR propio)

`GET ?competence=` devolvía **solo** `competenceStatus`: `toConfiguration()` excluye `currentPayment`
y de los asientos solo se usaban los ids. Sin eso, PROCESSING/BLOCKED/FAILED no podían explicar
valor/método/referencia y PAID no podía mostrar fecha, cuenta ni comprovante.

- PR del API ([#147](https://github.com/gloriafinance/gloria_finance_api/pull/147), apilado sobre
  `chore/recurring-payments`): expone `currentPayment` de la competencia pedida y un resumen
  `settlement`; un `BILL` **no pide importe** (lo adopta de `valueInCents`, que el banco lee de la
  línea); y un mismatch se persiste como `FAILED` con ambos importes en lugar de lanzar un error que
  dejaba la reserva en `PROCESSING` para siempre.
- Dependencia de arriba: [church-banking #105](https://github.com/gloriafinance/church-banking/pull/105)
  lee el importe de la línea y lo devuelve; su "fuera de alcance" asigna al API validar la
  coincidencia.

**Único dato aún no disponible**: el rechazo `BILL_PAYMENT_AMOUNT_MISMATCH` (422) no incluye el
importe leído, así que cuando el banco rechaza por diferencia la pantalla muestra el *valor esperado*
y el motivo. La UI ya soporta el campo (`providerValueInCents`): el día que el rechazo lo traiga, el
mismatch muestra también *Valor do boleto* sin cambios de UI.

## 8. Archivos

```text
lib/features/erp/recurring_payments/
  models/
    recurring_payment_competence_status.dart   # 7 estados + reglas (canExecute/canRetry/BLOCKED)
    recurring_payment_competence_model.dart    # fila del mes: config + estado + ejecución + asiento
    recurring_payment_execution_model.dart     # currentPayment (método, intento, proveedor)
    recurring_payment_settlement_model.dart    # asiento: CLEARED (manual) vs RECONCILED (banco)
    recurring_payment_pay_result.dart          # resultado del banco (incluye el mismatch)
    recurring_payment_execution_payload.dart   # dueño único del payload de ejecución
    recurring_payment_month.dart               # competencia, etiquetas pt-BR y vencimiento
  service/recurring_payment_execution_service.dart
  state/
    recurring_payment_monthly_state.dart       # mes + resumen
    recurring_payment_execution_state.dart     # matriz de casos y qué falta pedir
  store/
    recurring_payment_monthly_store.dart       # lista del mes + pagar/registrar/cancelar
    recurring_payment_execution_store.dart     # flujo de una competencia
  pages/
    recurring_payments_screen.dart             # pestañas Mês / Configuração
    monthly/recurring_payment_monthly_view.dart
    monthly/widgets/recurring_payment_month_selector.dart
    monthly/widgets/recurring_payment_monthly_summary.dart
    monthly/widgets/recurring_payment_monthly_table.dart
    monthly/widgets/recurring_payment_monthly_cards.dart
    monthly/widgets/recurring_payment_monthly_card.dart
    monthly/widgets/recurring_payment_monthly_actions.dart
    monthly/widgets/recurring_payment_status_chip.dart
    monthly/widgets/recurring_payment_monthly_empty_state.dart
    monthly/widgets/recurring_payment_execution_detail_sheet.dart
    execution/recurring_payment_execution_sheet.dart
    execution/widgets/recurring_payment_amount_method_step.dart
    execution/widgets/recurring_payment_pix_key_step.dart
    execution/widgets/recurring_payment_confirmation_step.dart
    execution/widgets/recurring_payment_boleto_entry_step.dart
    execution/widgets/recurring_payment_boleto_line_step.dart
    execution/widgets/recurring_payment_boleto_camera_step.dart
    execution/widgets/recurring_payment_manual_registration_step.dart
    execution/widgets/recurring_payment_execution_result_step.dart
    execution/widgets/recurring_payment_execution_field.dart
  utils/recurring_payment_boleto.dart           # 44/47 dígitos, agrupación y final de la línea
```

Reutilizado del entregable 1: `RecurringPaymentModel` (configuración), `RecurringPaymentService`,
`RecurringPaymentOptionsStore` (conceptos de gasto y centros de costo), las tarjetas/etiquetas de
valor y estado, `SectionCard`, `CustomButton`, `ButtonActionTable`, `UploadFile`,
`CurrencyFormatter` y `AvailabilityAccountsListStore`.

Cambios de cableado: `lib/app/store_manager.dart`, `lib/main_erp.dart`, `lib/features/erp/router.dart`
(ruta de configuración) y las navegaciones del formulario.

Dependencia nueva: **`mobile_scanner` ^7.4.2** (lectura de código de barras). Se verificó el build
web del CI (`flutter build web -t lib/main_erp.dart --release` → OK), porque el ERP también se
despliega como web.

## 9. Copy (português do Brasil)

| Clave | pt-BR |
| --- | --- |
| `..._tab_month` / `..._tab_configuration` | Mês / Configuração |
| `..._status_pending` … `..._status_inactive` | Pendente / A vencer / Processando / Bloqueado / Falhou / Pago / Inativo |
| `..._pay_action` / `..._register_action` | PAGAR / REGISTRAR PAGAMENTO |
| `..._method_title` | Como deseja pagar? |
| `..._amount_label` / `..._amount_bill_note` | Valor a pagar / O valor será o do boleto. |
| `..._pix_confirm_title` / `..._pix_confirm_action` | Confirmar pagamento PIX / CONFIRMAR PIX |
| `..._pix_destination_note` | Configurado no pagamento recorrente |
| `..._pix_send_note` | Após confirmar, o pagamento será enviado para processamento bancário. |
| `..._boleto_entry_title` | Como deseja informar o boleto? |
| `..._boleto_camera_action` / `..._boleto_type_action` | LER COM A CÂMERA / DIGITAR LINHA |
| `..._boleto_scan_instruction` | Posicione o código de barras dentro da área indicada. |
| `..._boleto_scan_manual_action` | Digitar linha manualmente |
| `..._boleto_camera_denied` / `..._amount_required` | Não foi possível acessar a câmera. / Informe o valor a pagar. |
| `..._boleto_validated_title` / `..._boleto_values_match` | BOLETO VALIDADO / Os valores conferem. |
| `..._boleto_mismatch_title` / `..._mismatch_message` | VALORES DIFERENTES / O valor do boleto é diferente do valor esperado para este pagamento. Nada foi debitado. |
| `..._sent_title` / `..._sent_description` | Pagamento enviado / O pagamento foi enviado ao banco e estamos aguardando a confirmação. |
| `..._blocked_title` / `..._blocked_description` | Pagamento bloqueado / O banco ainda está processando ou aguardando resolução. |
| `..._failed_title` / `..._failed_retry` | Pagamento não concluído / TENTAR NOVAMENTE |
| `..._manual_submit` / `..._manual_submitting` | REGISTRAR PAGAMENTO / Processando registro… |
| `..._manual_voucher_required` | O comprovante é obrigatório. |
| `..._cancel_record_action` / `..._cancel_message` | CANCELAR REGISTRO / Este registro será anulado e o pagamento voltará a aparecer como pendente nesta competência. |

132 claves `recurringPaymentsExecution_*` en `pt`, `es` y `en`.

## 10. Capturas del entregable

Generadas por comando (39 pantallas):

```bash
flutter test --dart-define=GENERATE_SCREENSHOTS=true \
  test/features/erp/recurring_payments/recurring_payments_execution_visual_test.dart
```

| Archivo | Pantalla |
| --- | --- |
| `desktop-01-mes-asaas.png` | Vista mensual con Asaas (tabla, `PAGAR`) |
| `desktop-02-mes-sem-asaas.png` | Vista mensual sin Asaas (`REGISTRAR PAGAMENTO`) |
| `desktop-03-registro-manual-fixo.png` / `desktop-04-...-variavel.png` | Registro manual `FIXED` / `VARIABLE` |
| `desktop-05-pix-confirmacao-direta.png` | Caso 1: `FIXED` + destino → confirmación directa |
| `desktop-06-fixo-sem-destino-metodo.png` | Caso 2: elección PIX/boleto |
| `desktop-07-variavel-com-destino.png` / `desktop-08-variavel-sem-destino.png` | Casos 3 y 4 |
| `desktop-09-pix-sem-chave.png` | PIX sin destino guardado (chave + tipo) |
| `desktop-10-boleto-entrada.png` / `desktop-11-boleto-digitar-linha.png` / `desktop-19-boleto-camera.png` | Entrada del boleto, línea digitável y cámara |
| `desktop-12-boleto-validado.png` / `desktop-13-boleto-mismatch.png` | Boleto validado / valores diferentes |
| `desktop-14-processing.png` … `desktop-16-failed.png` | PROCESSING, BLOCKED, FAILED |
| `desktop-17-pago-manual.png` / `desktop-18-pago-asaas.png` | PAID `CLEARED` (con cancelar) / `RECONCILED` (sin cancelar) |
| `desktop-20-boleto-confirmacao.png` | Confirmación final del boleto |
| `tablet-01-mes.png` … `tablet-04-bloqueado.png` | Listado mensual, PIX, boleto y bloqueado en tablet |
| `mobile-01-mes.png` … `mobile-15-pago.png` | Las 15 pantallas pedidas para mobile |

## 11. Verificación

- `flutter test test/features/erp/recurring_payments test/core/layout/erp/menu_items_test.dart` →
  **104/104** (40 capturas/smoke de ejecución, 20 de modelos de ejecución, 11 del listado, 7 de
  máscaras, 7 del parsing estricto, 7 de stores, 6 de opciones y 6 del menú).
- `flutter analyze lib test` → **0 errores** (los warnings/infos son los preexistentes del repo).
- `flutter build web -t lib/main_erp.dart --release` → OK con `mobile_scanner`.
- El test de capturas encontró y dejó corregidos **tres defectos reales**: el paso de valor/método
  bloqueaba el avance cuando la chave PIX se pedía en el paso siguiente; el encabezado del mes
  desbordaba en tablet; y la copy del resumen decía "1 pagos".

## 12. Decisiones y desvíos respecto del brief

1. **El boleto no pide importe** (tu indicación): el boleto define cuánto se paga, así que en
   `VARIABLE` + boleto no hay campo de valor; el valor llega del banco. Consecuencia: la pantalla
   previa "BOLETO VALIDADO" con **dos** importes se muestra como **resultado** de la validación
   síncrona del banco, no antes de enviar (no existe endpoint de consulta previa: la única ruta que
   recibe la línea es `pay`).
2. **VARIABLE elige método y valor en el mismo paso**: pedir el valor antes obligaría a descartarlo si
   después se elige boleto.
3. **El switch de situación no aparece aquí**: la competencia **no** se desactiva; lo que cambia es la
   configuración, que se edita en la otra pestaña.
4. **Sin "pagar mesmo assim"**: church-banking rechaza el importe distinto antes del débito, así que
   ofrecerlo sería una acción que el backend niega.
5. **Mientras hay una operación viva, las demás filas no ofrecen pago** (solo consulta): regla del
   backend, no preferencia de UI.
6. **No se inventó una entidad mensual editable**: la competencia es una lectura del mes más el
   estado de la ejecución; el histórico sigue siendo el `FinancialRecord`.

## 13. Fuera de alcance (recordatorio)

Rediseñar creación/edición, ejecución desde el listado administrativo, conciliación bancaria,
comprobantes de otros módulos, pagos parciales, reprogramación del vencimiento, edición de la
competencia, y cualquier estado de ejecución distinto de PROCESSING/BLOCKED/FAILED/PAID.
