# 🧭 Guía de Arquitectura y Prácticas de `church_finance_front`

> Este documento aplica a todo el repositorio. Resume la arquitectura vigente y define **reglas operativas y técnicas**
> para cualquier agente o colaborador que modifique el proyecto.

---

## ⚡ TL;DR para agentes

- Existen **dos apps** dentro del mismo código:
    - **ERP (backoffice)** → `main_erp.dart` + `app/erp_router.dart` + `features/erp/**`.
    - **Member Experience (app de membros)** → `main_member.dart` + `app/member_router.dart` +
      `features/member_experience/**`.
- Respeta el patrón por feature: **`service` (infraestructura) / `store` (estado) / `pages` + `widgets` (UI)**.
- Antes de crear un widget nuevo:
    - Revisa primero `core/widgets/**` y `core/layout/**`.
    - **Reusa componentes existentes** (`CustomButton`, `FormControls`, `UploadFile`, `BackgroundContainer`, etc.).
- Cualquier cambio en lógica (servicios, stores, helpers) debe venir acompañado de pruebas en `test/`.
- Mantén la **coherencia total con el backend** [`church_finance_api`](https://github.com/abejarano/church_finance_api):
    - Modelos y servicios deben mapear 1:1 los DTOs del backend.
- En tu respuesta final (como agente), indica:
    - Archivos modificados
    - Comandos ejecutados
    - Resultados de tests
    - Notas de compatibilidad con backend

---

## 1. Visión general del proyecto

La app está organizada por **capas horizontales** y **features verticales**:

- `app/` contiene:
    - Configuración de routers (`erp_router.dart`, `member_router.dart`).
    - `my_app.dart` (config común de `MaterialApp.router`).
    - `store_manager.dart` (singletons de stores compartidos).
- `core/` provee la **infraestructura transversal**:
    - Tema, tipografía y colores.
    - Layout base (shells, sidebar, header).
    - Cliente HTTP (`AppHttp`).
    - Widgets reutilizables.
    - Utilidades de formateo.
- `features/` agrupa módulos de negocio:
    - `auth/` (login, recuperación, aceptación de políticas).
    - `erp/` (gestión financiera y administrativa).
    - `member_experience/` (flujo para membros: contribuciones, compromisos, perfil, etc.).

Cada feature sigue la estructura:

- `service/` → acceso a API (infraestructura).
- `state/` + `store/` → gestión de estado con `ChangeNotifier`.
- `pages/` → pantallas principales.
- `widgets/` → componentes visuales específicos del módulo.

---

## 2. Mapa de carpetas y responsabilidades

### 2.1 Nivel raíz de `lib/`

| Ruta               | Propósito                                                          |
|--------------------|--------------------------------------------------------------------|
| `app/`             | App shells y routers para ERP y Member, `MyApp`, `StoreManager`.   |
| `core/`            | Infraestructura transversal: tema, layout, HTTP, widgets, helpers. |
| `features/`        | Todas las features de negocio (auth, erp, member_experience).      |
| `main_erp.dart`    | Punto de entrada de la app ERP (backoffice).                       |
| `main_member.dart` | Punto de entrada de la app Member Experience.                      |

---

### 2.2 `app/`

- **`app/erp_router.dart`**
    - Define el router del **ERP** usando `GoRouter`.
    - Usa `ShellRoute` con `ErpShell` para envolver todas las pantallas internas.
    - Importa routers de features ERP (por ejemplo `features/erp/router.dart`).

- **`app/member_router.dart`**
    - Router específico de la app de **membros**.
    - Debe importar `auth_router.dart` y las rutas de `features/member_experience/router.dart`.

- **`app/my_app.dart`**
    - Define `MyApp` (config común de `MaterialApp.router`: localización, theme, etc.).
    - Se usa tanto en `main_erp.dart` como en `main_member.dart` con distintos `routerConfig`.

- **`app/store_manager.dart`**
    - Service Locator para stores compartidos (ERP o globales).
    - No dupliques stores: si algo debe ser global, vive aquí; si es específico de una pantalla, créalo en el
      `ChangeNotifierProvider` de esa pantalla.

---

### 2.3 `core/`

| Subruta                  | Descripción                                                                                                                    |
|--------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| `core/app_http.dart`     | Cliente HTTP (Dio) con manejo de base URL, headers, auth y errores.                                                            |
| `core/layout/erp/**`     | Layout del ERP: `ErpShell`, `HeaderLayout`, `menu_items.dart` (estructura del sidebar y navegación).                           |
| `core/layout/widgets/**` | Widgets de layout genéricos: `SidebarLayoutDashboard`, `NavigatorMember`, etc.                                                 |
| `core/theme/**`          | `app_color.dart`, `app_fonts.dart`, `transition_custom.dart`. Todo el tema visual *debe* salir de aquí.                        |
| `core/widgets/**`        | Componentes UI reutilizables globales: `CustomButton`, `FormControls`, `UploadFile`, `BackgroundContainer`, `CardAmount`, etc. |
| `core/utils/**`          | Helpers puros: formateo de moneda, fechas, strings, etc.                                                                       |
| `core/paginate/**`       | Infraestructura de paginación (`PaginateResponse`, `CustomTable`).                                                             |
| `core/toast.dart`        | Notificaciones visuales globales.                                                                                              |

> **Regla:** si un widget/función será usado en más de una feature, llévalo a `core/widgets/` o `core/utils/` en lugar
> de duplicarlo en cada módulo.

---

### 2.4 `features/auth`

- Maneja todo el flujo de autenticación:
    - `auth_router.dart` → rutas públicas (`/`, `/recovery-password`, `/policy-acceptance`).
    - `pages/login/**` → pantalla de login + estado/validación.
    - `pages/recovery_password/**` → wizard para recuperación de contraseña.
    - `pages/policies/**` → aceptación de políticas.
- `auth_persistence.dart` / `auth_service.dart` → integración con backend para login, refresh, etc.
- `auth_session_store.dart` → estado global de sesión (roles, `churchId`, flags de políticas, etc.).

---

### 2.5 `features/erp/**`

Concentra la experiencia de **tesorería/administración** (ERP).

Ejemplos de módulos:

- `features/erp/home/` → dashboard ERP.
- `features/erp/accounts_payable/**` → contas a pagar.
- `features/erp/accounts_receivable/**` → contas a receber, compromissos.
- `features/erp/reports/**` → DRE, demonstrativos, relatórios.
- `features/erp/settings/**` → bancos, centros de custo, conceitos financeiros, membros, RBAC.
- `features/erp/patrimony/**`, `providers/**`, `purchase/**`, etc.

Cada módulo sigue el patrón:

```text
models/            -> DTOs y entidades
service/           -> llamadas HTTP a endpoints específicos
state/             -> clases de estado (cuando se separan de store)
store/             -> ChangeNotifier con la lógica y orquestación
pages/             -> pantallas
widgets/           -> componentes específicos del módulo
router.dart (opt.) -> rutas locales del módulo
```

### 2.6 `features/member_experience/**`

Contiene la **app de membros** (fase en construcción).

Responsabilidades típicas:

- `contributions/**` → pantallas para registrar dízimos/ofertas (incluyendo PIX / boleto / upload de comprovante).
- `commitments/**` → compromissos del membro (parcelas, histórico de pagos).

- `dashboard/**` → home/resumo financiero del membro.
- `profile/**` → perfil, alterar senha, notificações.
- `statements/**` → extractos/relatórios personales.
- `router.dart` → rutas internas del flujo de membro.

> Importante:
>
>
> La app de membros debe **reutilizar el máximo posible** de:
>
> - `core/theme/**`
> - `core/widgets/**`
>
> Solo crear widgets específicos cuando no exista un equivalente en `core/`.
>

---

## 3. Patrones de diseño y gestión de estado

### 3.1 Patrón Service–Store–Widget

**Service (`...Service`)**

- No conoce UI.
- Habla con `AppHttp`, construye URLs, headers, body.
- Devuelve modelos tipados (`Model.fromJson`).

**Store (`...Store`)**

- Extiende `ChangeNotifier`.
- Orquesta llamadas del service, transforma datos para la UI.
- Expone estados (`isLoading`, `errorMessage`, `items`, etc.).
- No hace llamadas HTTP directas fuera de los services.

**Widget / Page**

- Consume el store (vía `ChangeNotifierProvider` / `Consumer` / `Provider.of`).
- Presenta la información usando **widgets de `core/widgets/` siempre que sea posible**.
- No contiene lógica de negocio compleja.

---

### 3.2 Navegación

Usamos `go_router`:

- `app/erp_router.dart` → ensambla rutas ERP (`ShellRoute` + rutas de `features/erp/router.dart`).
- `app/member_router.dart` → ensambla rutas de `auth` + `features/member_experience/router.dart`.

Las rutas por módulo se construyen con funciones tipo `erpListRouter()`, `settingsRouter()`, etc.

**No añadas rutas sueltas** fuera de estas funciones.

---

## 4. Reuso de widgets y estilos

Antes de crear un nuevo widget, **verifica siempre**:

### 4.1 `core/widgets/**`

- Botones → `CustomButton`, `ButtonActionTable`.
- Estructuras de formulário → `FormControls` (inputs, selects, datepickers).
- Uploads → `UploadFile`.
- Layouts simples → `BackgroundContainer`, `CardAmount`, `TagStatus`, etc.
- Loading → `Loading`.

### 4.2 `core/layout/**`

- **ERP:**
    - `ErpShell` ya encapsula **header**, **sidebar** y **contenedor de contenido**.
    - No repitas header/sidebar en cada `Screen`.

      Las páginas ERP deben ser **contenido interno** que vive dentro del shell.

- **Member:** (cuando exista shell propio) deberá seguir el mismo patrón.

### 4.3 `core/theme/**`

- Usa colores desde `AppColors`.
- Usa fuentes desde `AppFonts`.
- Usa transiciones desde `transition_custom.dart`.

> Regla explícita:
>
>
> 🚫 No crees nuevos botones/inputs con estilos propios en features si el estilo puede representarse con los widgets ya
> existentes en `core/widgets/`.
>
> ✅ Solo crea un nuevo widget global cuando:
>
> - No exista nada similar en `core/`.
> - Sea genérico y reutilizable.
> - Tiene sentido moverlo luego a `core/widgets/`.

---

## 5. Convenciones de código

- Directorios y archivos `.dart` en `snake_case`.
- Clases, enums y widgets → `PascalCase`.
- Variables, métodos, propiedades → `camelCase`.

---

## 6. Arquitectura de internacionalización (i18n)

La app usa el flujo oficial de Flutter `gen-l10n` con `AppLocalizations` + una extensión sobre `BuildContext`.

### 6.1 Infraestructura principal

- Archivos ARB:
    - `lib/l10n/app_pt.arb` → texto base en PT-BR.
    - `lib/l10n/app_es.arb` → traducciones ES.
    - `lib/l10n/app_en.arb` → traducciones EN.
- Código generado:
    - `lib/l10n/app_localizations.dart` (no tocar a mano).
    - `lib/l10n/app_localizations_*.dart` (pt/es/en).
- Extensión para acceso cómodo desde widgets:
    - `lib/core/utils/app_localizations_ext.dart`
    - Uso: `context.l10n.<clave>`.

### 6.2 Selección de idioma en runtime

- `LocaleStore` (`lib/app/locale_store.dart`):
    - Mantiene el `Locale` actual.
    - Persiste la selección en `SharedPreferences`.
    - Define `supportedLocales` (pt_BR, es, en).
- `StoreManager` (`lib/app/store_manager.dart`):
    - Expone una instancia compartida de `LocaleStore`.
- `MyApp` (`lib/app/my_app.dart`):
    - Usa `context.watch<LocaleStore>()` para:
        - `supportedLocales: localeStore.supportedLocales`
        - `locale: localeStore.locale`
        - `localizationsDelegates: [AppLocalizations.delegate, ...]`
- `LanguageSelector` (`lib/core/widgets/language_selector.dart`):
    - Muestra el idioma actual (`PT-BR`, `ES`, `EN`).
    - Al cambiar, llama `localeStore.setLocale(locale)`.
    - Se inyecta en el header ERP (`HeaderLayout`) y puede reutilizarse en otras pantallas.

### 6.3 Reglas para texto y claves

- Ningún texto visible para usuario debe estar hardcodeado en los widgets.
    - ✔️ Bien: `Text(context.l10n.common_apply_filters)`
    - ❌ Mal: `Text('Aplicar filtros')`
- Reutilizar claves comunes (`common_*`) cuando aplique:
    - `common_filters`, `common_filters_upper`, `common_status`,
      `common_start_date`, `common_end_date`, `common_apply_filters`,
      `common_clear_filters`, `common_loading`, `common_view`, `common_edit`,
      `common_actions`, etc.
- Para textos específicos de un módulo, prefijar con el dominio:
    - ERP cuentas a pagar: `accountsPayable_*`
    - ERP cuentas a recibir: `accountsReceivable_*`
    - Extractos bancarios: `bankStatements_*`
    - Registros financieros: `finance_records_*`
    - Patrimonio: `patrimony_*`
    - Tendencias: `trends_*`
    - Reportes: `reports_*`
- Textos parametrizados deben declararse con `placeholders` en ARB, por ejemplo:

  ```json
  "reports_income_cashflow_summary": "Entradas totais: {income} | Saídas totais: {expenses} | Saldo consolidado: {total}",
  "@reports_income_cashflow_summary": {
    "placeholders": {
      "income": {"type": "String"},
      "expenses": {"type": "String"},
      "total": {"type": "String"}
    }
  }
  ```

  Y usarse así:

  ```dart
  context.l10n.reports_income_cashflow_summary(income, expenses, total);
  ```

### 6.4 Patrones recomendados por módulo

- **Filters / listados:**
    - Siempre usar `common_filters[_upper]`, `common_status`,
      `common_apply_filters`, `common_clear_filters`, `common_search_hint`.
    - Mensajes vacíos: claves específicas por módulo (`*_table_empty`,
      `*_empty`, etc.).
- **Tablas (`CustomTable`):**
    - Cabecera de acciones usa `common_actions` automáticamente.
    - Botones de acción:
        - Ver → `common_view`
        - Editar → `common_edit`
- **Formularios de ERP (Payable/Receivable, registros financieros, patrimonio, etc.):**
    - Labels y errores de validación van en `*_form_field_*` y `*_form_error_*`.
    - Toasts → `*_toast_*`.
    - Secciones → `*_section_*`.

### 6.5 Flujo de trabajo para nuevas traducciones

1. Identificar el texto hardcodeado en el widget.
2. Definir una clave semántica siguiendo el prefijo del módulo.
3. Añadir la clave en `app_pt.arb` (PT-BR) y sus traducciones en `app_es.arb` y `app_en.arb`.
4. Ejecutar `flutter gen-l10n` para regenerar `AppLocalizations`.
5. Reemplazar el texto plano por `context.l10n.<clave>` en el widget.
6. Si se trata de lógica nueva en `lib/` (stores, services, validadores), agregar pruebas en `test/` que cubran al
   menos:
    - El flujo de selección de idioma cuando aplique.
    - El uso correcto de las cadenas (por ejemplo, tests de `LanguageSelector` y `LocaleStore`).

> Nota: cualquier contribución que agregue o cambie texto en `lib/` debe seguir este flujo para mantener la app 100%
> traducible en PT/ES/EN.

**Sufijos:**

- `...Service` → infraestructura (HTTP / API).
- `...Store` → estado.
- `...Model` → entidad/DTO.
- `...Screen` → página principal UI.

Usa:

```dart
factory
Model.fromJson
(
Map<String, dynamic> json);
Map<String
,
dynamic
>
toJson
(
);
```

en todos los modelos.

---

## 6. Sincronización con el backend

- Toda entidad de negocio tiene su espejo en [`church_finance_api`](https://github.com/abejarano/church_finance_api).

Antes de:

- agregar un campo,
- renombrar una propiedad,
- cambiar filtros o estructuras,

**revisa el backend** (módulos `AccountsReceivable`, `AccountsPayable`, `Contributions`, etc.) y ajusta
modelos/servicios de forma consistente.

Los enums con valores de API deben tener:

- extensión para label amigable (ej.: `toLabel()`),
- y, si aplica, para color/tag.

---

## 7. Reglas para nuevas features

### 7.1 ¿ERP o Member Experience?

- Si la función la usa **tesorería/administración** → va en `features/erp/**`.
- Si la función es para un **membro final (app de membro)** → va en `features/member_experience/**`.

### 7.2 Dónde colocar qué

- Lógica de negocio / orquestación → `store/`.
- Acceso a datos → `service/`.
- Componentes visuales compartidos → `core/widgets/`.
- Helpers puros → `core/utils/` o `helpers/` según el caso.

### 7.3 Rutas

- **ERP:** añade rutas en `features/erp/router.dart` y asegúrate de que `erp_router.dart` las use.
- **Member:** añade rutas en `features/member_experience/router.dart` y conéctalas en `member_router.dart`.

---

## 8. Pruebas y reporte de cambios

Cualquier ajuste de:

- lógica de negocio,
- integración con API,
- serialización/deserialización,

debe tener pruebas en `test/` (unitarias o de widget según corresponda).

Antes de finalizar:

- Ejecuta al menos `flutter test`.
- Si afecta navegación o UI crítica, verifica `flutter run` en modo debug para ambos targets cuando aplique (
  `main_erp.dart` y/o `main_member.dart`).

En la respuesta final (como agente), incluye siempre:

1. Lista de archivos modificados.
2. Comandos ejecutados (`flutter test`, `flutter analyze`, etc.).
3. Resultado de los tests.
4. Notas de compatibilidad con backend o cambios de contrato.

---

## ✅ Ejemplo de flujo correcto (resumido)

1. Identificar si la feature es de **ERP** o de **Member Experience**.
2. Revisar el contrato correspondiente en `church_finance_api`.
3. Crear/ajustar modelos y services en el módulo correcto (`features/erp/**` o `features/member_experience/**`).
4. Reusar widgets de `core/widgets/` para la UI; solo crear nuevos si realmente hacen falta.
5. Conectar rutas en el `router.dart` del módulo y en `erp_router.dart` / `member_router.dart`.
6. Ejecutar pruebas (`flutter test`) y revisar visualmente la pantalla.
7. Documentar cambios en la respuesta final.
