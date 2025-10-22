# Guía de arquitectura y prácticas de `church_finance_front`

## 1. Visión general del proyecto
- Aplicación Flutter organizada por *features* (`auth/`, `finance/`, `providers/`, `settings/`, etc.) y soportada por un módulo `core/` con utilidades compartidas.
- Navegación declarativa gestionada con `go_router` desde `lib/core/router.dart`, ensamblando rutas de cada feature mediante funciones `...Router()` dedicadas.
- `main.dart` inicializa un `MultiProvider` que inyecta *stores* compartidos (p. ej. `AuthSessionStore`, `FinancialConceptStore`) siguiendo el patrón *Service Locator* ligero vía `StoreManager` singleton.

## 2. Buenas prácticas implementadas
- **Inyección de dependencias vía Provider:** uso consistente de `ChangeNotifierProvider`/`MultiProvider` para exponer estado reactivo a la UI (`lib/main.dart`).
- **Gestión de errores HTTP centralizada:** clase base `AppHttp` concentra configuración de `Dio`, encabezados y transformación de errores con `Toast.showMessage`, reduciendo duplicación en los servicios (`lib/core/app_http.dart`).
- **Serialización tipada:** modelos usan `factory` constructors y `toJson()` para mapear datos (`lib/providers/models/supplier_model.dart`, `lib/finance/models/installment_model.dart`).
- **Extensiones semánticas:** `enum` + `extension` aportan nombres amigables y valores de API (`AccountsPayableStatusExtension`, `SupplierTypeExtension`).
- **Componentización de UI:** widgets reutilizables en `lib/core/widgets/` y `lib/finance/widgets/` (por ejemplo `ContentViewer`) encapsulan lógica visual y uso de librerías como `url_launcher`.
- **Utilidades compartidas:** helpers como `convertDateFormatToDDMMYYYY` centralizan transformaciones de fecha (`lib/helpers/date_formatter.dart`).
- **Paginación genérica:** `PaginateResponse<T>` implementa un contenedor generics reutilizable para listar datos paginados (`lib/core/paginate/paginate_response.dart`).

## 3. Patrones de diseño y gestión de estado
- **Patrón Service + Store:** cada feature expone servicios HTTP (infraestructura) que heredan de `AppHttp` y *stores* `ChangeNotifier` para orquestar la UI (`PaymentCommitmentStore`).
- **Singleton controlado:** `StoreManager` concentra instancias largas con un constructor privado y acceso estático.
- **Builder pattern en rutas:** funciones que devuelven `List<RouteBase>` permiten componer rutas modularmente (`providerRouter`, `authRouters`, `financialRouter`).

## 4. Convenciones de nombres y organización
- Directorios en *snake_case* y archivos `.dart` en minúsculas, alineados con las guías oficiales de Flutter.
- Clases y enums en `PascalCase`; métodos, variables y propiedades en `camelCase`.
- Sufijos semánticos: `...Service` para capa de datos, `...Store` para administradores de estado, `...Model` para entidades.
- Widgets se nombran en `PascalCase` y se ubican junto a su feature (`finance/widgets/`, `providers/pages/...`).

## 5. Desacoplamiento infraestructura vs. dominio
- **Infraestructura:**
  - `core/app_http.dart` gestiona clientes HTTP y URLs (incluye distinción `kReleaseMode` para endpoints prod/dev).
  - Servicios de features (`accounts_payable_service.dart`, `supplier_service.dart`) solo se encargan de llamadas REST y manejo de tokens.
- **Dominio/UI:**
  - Modelos (`AccountsPayableModel`, `InstallmentModel`, `SupplierModel`) encapsulan reglas de negocio ligeras (formatos, conteos).
  - Stores (`PaymentCommitmentStore`) mantienen estado de UI y orquestan servicios sin conocer detalles de red.
  - Widgets presentan datos formateados sin depender de `Dio` u otros detalles de infraestructura.

## 6. División de responsabilidades
- `auth/`: pantallas y stores relacionados con autenticación y sesión (`AuthSessionStore`).
- `core/`: utilidades compartidas (tema, layout, navegación, HTTP, paginación, widgets comunes).
- `finance/`: módulos financieros (cuentas por pagar/cobrar, contribuciones, compromisos de pago, reportes) cada uno con modelos, servicios y widgets especializados.
- `providers/`: gestión de proveedores; incluye router propio, modelos (`SupplierModel`) y servicios (`SupplierService`).
- `settings/`: administración de catálogos auxiliares (bancos, centros de costo, conceptos financieros) con sus respectivos stores.
- `helpers/`: funciones puros para formato/selección de fechas.

## 7. Recomendaciones para futuras contribuciones
- Mantener la separación `service` (infraestructura) / `store` (estado) / `widget` (UI) dentro de cada feature.
- Reutilizar `AppHttp` para nuevos servicios HTTP y registrar cualquier mensaje de error mediante `transformResponse` para feedback consistente al usuario.
- Declarar nuevas rutas dentro de la función `...Router()` correspondiente y agregarlas al ensamblador en `core/router.dart`.
- Preferir extensiones sobre enums para mapear valores de API y etiquetas amigables.
- Centralizar helpers o constantes compartidas en `core/` o `helpers/` para evitar duplicación.

