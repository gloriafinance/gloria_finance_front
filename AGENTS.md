# 🧭 Guía de Arquitectura y Prácticas de `church_finance_front`

> Este documento aplica a todo el repositorio. Resume la arquitectura vigente y define **reglas operativas y técnicas**
> para cualquier agente o colaborador que modifique el proyecto.

---

## ⚡ TL;DR para agentes

- Respeta la estructura `service` (infraestructura) / `store` (estado) / `widget` (UI) en cada *feature*.
- Todo cambio en `lib/` debe ir acompañado de pruebas en `test/` si agrega lógica o corrige bugs.
- Reutiliza utilidades existentes en `core/` (HTTP, rutas, widgets, helpers) antes de crear duplicados.
- Mantén la **coherencia total con el backend** [
  `church_finance_api`](https://github.com/abejarano/church_finance_api):  
  al mapear campos o modelos, **valida siempre las claves y estructuras** contra el backend.
- Las cadenas visibles para el usuario deben pasar por los helpers de localización y formato existentes.
- En la respuesta final, incluye resumen por archivo modificado, comandos ejecutados y pruebas realizadas.

---

## 1. Visión general del proyecto

- Aplicación **Flutter modularizada por features** (`auth/`, `finance/`, `providers/`, `settings/`, etc.).
- Módulo `core/` provee utilidades globales (tema, HTTP, router, layout, paginación, widgets).
- Navegación declarativa mediante `go_router` (`lib/core/router.dart`), ensamblada dinámicamente con funciones
  `...Router()`.
- `main.dart` inicializa un `MultiProvider` con *stores* compartidos (p. ej. `AuthSessionStore`,
  `FinancialConceptStore`) usando el patrón **Service Locator** a través de `StoreManager`.

---

## 2. Mapa de carpetas

| Ruta             | Propósito                                                                               |
|------------------|-----------------------------------------------------------------------------------------|
| `lib/core/`      | Router, layout, tema, cliente HTTP (`AppHttp`), widgets globales y paginación           |
| `lib/finance/`   | Módulos financieros (cuentas por pagar/cobrar, contribuciones, compromisos)             |
| `lib/providers/` | Catálogo de proveedores, con router propio y `SupplierService`                          |
| `lib/settings/`  | Configuración de catálogos auxiliares (bancos, centros de costo, conceptos financieros) |
| `lib/helpers/`   | Funciones puras: formato de fechas, rangos, transformaciones                            |
| `test/`          | Pruebas unitarias y de widgets para lógica de negocio y UI                              |

---

## 3. Buenas prácticas implementadas

- **Inyección de dependencias:** `ChangeNotifierProvider` / `MultiProvider` exponen estado reactivo en toda la app.
- **Gestión de errores centralizada:** `AppHttp` maneja encabezados, autenticación, errores y `Toast.showMessage`.
- **Serialización tipada:** todos los modelos usan `factory fromJson()` y `toJson()`.
- **Extensiones semánticas:** las `enum` poseen extensiones para traducción y etiquetas legibles (
  `AccountsPayableStatusExtension`).
- **Componentización:** widgets modulares en `core/widgets/` o en `feature/widgets/` encapsulan lógica visual
  reutilizable.
- **Paginación genérica:** `PaginateResponse<T>` implementa contenedor de datos reutilizable para listados grandes.
- **Formateo y helpers:** funciones en `helpers/` garantizan consistencia de formatos (fechas, máscaras, strings).

---

## 4. Patrones de diseño y gestión de estado

- **Patrón Service–Store:** separación clara entre acceso a datos (`Service`) y orquestación/UI (`Store`).
- **Singleton controlado:** `StoreManager` centraliza instancias persistentes de stores.
- **Builder Pattern en rutas:** funciones `...Router()` devuelven `List<RouteBase>` para modularidad en la navegación.
- **Flujo de datos reactivo:** stores notifican cambios a la UI vía `notifyListeners()`.

---

## 5. Convenciones de código

- Directorios en `snake_case` y archivos `.dart` en minúsculas.
- Clases, enums y widgets en `PascalCase`; variables, métodos y propiedades en `camelCase`.
- Sufijos semánticos:
    - `...Service` → capa de infraestructura
    - `...Store` → gestor de estado
    - `...Model` → entidad o DTO
- Widgets de UI van en el módulo correspondiente; usa `core/widgets/` solo para componentes globales.

---

## 6. Desacoplamiento infraestructura / dominio

### Infraestructura (`service`)

- `core/app_http.dart` define el cliente HTTP (`Dio`) con manejo de entornos (`kReleaseMode`).
- Los `...Service` de cada módulo (ej. `accounts_payable_service.dart`) implementan REST calls y gestión de tokens.

### Dominio y UI (`store`, `model`, `widget`)

- Modelos (`AccountsPayableModel`, `SupplierModel`) encapsulan validaciones y formateos.
- Stores (`PaymentCommitmentStore`) mantienen estado y coordinan llamadas de servicio.
- Widgets muestran datos formateados sin conocer la capa HTTP.

> 🔗 **Importante:** Todos los modelos y servicios deben mantener correspondencia exacta con los endpoints y DTOs
> definidos en [`church_finance_api`](https://github.com/abejarano/church_finance_api).  
> Antes de modificar o agregar campos, **valida en el backend los
contratos (`src/AccountsReceivable`, `src/AccountsPayable`, etc.)** para evitar inconsistencias de mapeo.

---

## 7. División de responsabilidades

| Módulo       | Función principal                                            |
|--------------|--------------------------------------------------------------|
| `auth/`      | Autenticación y sesión (`AuthSessionStore`)                  |
| `core/`      | Tema, layout, navegación, widgets globales, paginación, HTTP |
| `finance/`   | Gestión de cuentas, contribuciones, compromisos, reportes    |
| `providers/` | CRUD de proveedores y servicios REST asociados               |
| `settings/`  | Catálogos auxiliares: bancos, centros de costo, conceptos    |
| `helpers/`   | Funciones puras, sin dependencias de UI                      |

---

## 8. Recomendaciones para contribuciones futuras

- Mantén la separación `service` / `store` / `widget` en cada módulo.
- **Explora el backend** (`church_finance_api`) antes de crear o modificar modelos para asegurar correspondencia.
- Usa `AppHttp` y sus métodos (`get`, `post`, `transformResponse`) para consistencia en el manejo de errores.
- Nuevas rutas deben definirse en el `...Router()` del módulo y agregarse al ensamblador de `core/router.dart`.
- Prefiere **extensiones sobre enums** para valores API ↔ etiquetas amigables.
- Centraliza helpers compartidos en `core/` o `helpers/` antes de crear nuevas utilidades.

---

## 9. Reglas adicionales para agentes

- 🚫 No añadas `try/catch` alrededor de imports.
- ⚖️ Mantén `ChangeNotifier` livianos; la lógica de negocio va en servicios o helpers.
- 🖼️ Si cambias estilos o UI visibles, incluye **captura de pantalla** del resultado.
- 🧪 Ejecuta `flutter test` para validar nueva lógica o correcciones críticas.
    - Si no es posible, explica el motivo en la respuesta.
- 🧾 Incluye en la salida final:
    1. Archivos modificados
    2. Comandos ejecutados
    3. Resultados de tests
    4. Notas sobre compatibilidad con el backend

---

## ✅ Ejemplo de flujo correcto

1. Revisar modelo en `church_finance_api` → confirmar estructura JSON esperada.
2. Actualizar `...Model` y `...Service` para mapear los campos correctamente.
3. Verificar que el store usa los nombres de propiedades alineados con backend.
4. Probar en entorno local (`flutter run`) y ejecutar `flutter test`.
5. Adjuntar resumen + evidencias visuales si aplica.
