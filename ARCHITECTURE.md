# Frontend Architecture

## Objetivo

Mantener el frontend de `gloria_finance_front` evolutivo, predecible y fácil de cambiar sin inflar pantallas, widgets o servicios con responsabilidades mezcladas.

Este documento define la estructura y los principios obligatorios para nuevas implementaciones y refactors.

## Patrón real del proyecto

El frontend de `gloria_finance_front` usa como convención dominante:

- `Service` para acceso remoto e infraestructura HTTP
- `Store` para estado y orquestación con `ChangeNotifier`
- `Pages` para entrada de navegación y composición
- `Widgets` para secciones visuales reutilizables
- `Models` para contratos y estructuras del feature
- `Utils` y `State` solo cuando agregan valor real

Esto no es opcional ni teórico: es el lenguaje arquitectónico ya usado de forma mayoritaria en el proyecto.

### Convención obligatoria

- El patrón oficial del repo es `Store + ChangeNotifier`.
- `Controller` no es la convención estándar del proyecto.
- No introducir carpetas `controllers/` en features nuevos salvo decisión explícita y documentada del equipo.
- Si un feature necesita un orquestador de estado, debe vivir en `store/` y llamarse `SomethingStore`.
- No basta con cambiar el nombre a `Store`: debe comportarse igual que los stores existentes del repo.
- El problema no es de lenguaje solamente; es de comportamiento arquitectónico.

### Ejemplos reales del proyecto

- [auth_session_store.dart](/Volumes/SSD/Develop/gloria_finance/gloria_finance_front/lib/features/auth/pages/login/store/auth_session_store.dart)
- [member_today_devotional_store.dart](/Volumes/SSD/Develop/gloria_finance/gloria_finance_front/lib/features/member_experience/home/store/member_today_devotional_store.dart)
- [schedule_list_store.dart](/Volumes/SSD/Develop/gloria_finance/gloria_finance_front/lib/features/erp/schedule/store/schedule_list_store.dart)
- [member_commitment_store.dart](/Volumes/SSD/Develop/gloria_finance/gloria_finance_front/lib/features/member_experience/commitments/store/member_commitment_store.dart)

## Principios no negociables

### 1. Contratos estrictos
- Backend y frontend deben hablar mediante contratos explícitos.
- No se permiten normalizaciones silenciosas, alias temporales ni tolerancia oculta de formatos.
- Si el contrato está mal, se corrige en la fuente de verdad y se actualizan todos los consumidores en el mismo cambio.

### 2. Fix at source
- No parchear síntomas en la UI si el problema real está en el mapper, modelo, servicio o contrato.
- No duplicar lógica correctiva en múltiples widgets.

### 3. SOLID aplicado al frontend
- `S`: cada archivo, widget, store, mapper o servicio debe tener una sola responsabilidad clara.
- `O`: extender por composición antes que modificar un widget gigante lleno de condicionales.
- `L`: los componentes reutilizables no deben romper expectativas de uso entre pantallas.
- `I`: no crear interfaces o helpers con métodos que una pantalla no necesita.
- `D`: la UI depende de stores/services/mappers del feature; no incrustar acceso HTTP o parsing en widgets.

### 4. Pantallas delgadas
- Una screen debe orquestar navegación, estado y composición de secciones.
- Una screen no debe contener decenas de widgets privados, lógica de parsing, copy social, estados de loading, formularios y bottom sheets todo en el mismo archivo.

### 5. Widgets pequeños y composables
- Si una sección tiene identidad visual propia, debe vivir en su propio widget.
- Si una sección tiene subestructura estable, debe extraerse antes de crecer.
- Evitar archivos gigantes de widgets “helper” sin límite. Agrupar solo piezas con cohesión real.

### 6. Estado fuera de la UI declarativa
- La carga, escritura y sincronización con backend deben vivir en `store/` del feature.
- Widgets y screens no deben contener lógica de negocio ni secuencias largas de mutación de estado.
- Si un estado necesita ser reutilizado o probado de forma aislada, no debe vivir incrustado en un `StatefulWidget` complejo.

### 7. Diseño consistente
- Reutilizar primitives del proyecto y patrones visuales existentes antes de inventar una variante nueva.
- Mantener jerarquía clara: contenido principal, metadata secundaria, acciones terciarias.
- No llenar la UI de cards con el mismo peso visual si eso rompe el flujo de lectura.

## Estructura recomendada por feature

```text
lib/features/<feature>/
  models/
  service/
  store/
  pages/
  widgets/
    <subfeature>/
  utils/
  mappers/            # si el feature lo necesita
  state/              # solo si el feature realmente separa DTOs/UI state
```

## Responsabilidad por carpeta

### `models/`
- Modelos serializables y tipos de lectura/escritura.
- Sin widgets.
- Sin acceso HTTP.
- Sin lógica de presentación compleja.

### `service/`
- Comunicación con APIs, adaptadores remotos y composición de requests/responses.
- Deben devolver modelos del feature, no mapas crudos cuando pueda evitarse.

### `store/`
- Orquestan carga, mutación, flags de loading/error y coordinación del feature.
- Deben ser la única fuente de verdad del estado de la pantalla.
- No deben contener layout.
- Deben seguir la convención `SomethingStore extends ChangeNotifier`.
- No deben convertirse en “god objects”; si un store empieza a agrupar demasiadas responsabilidades, debe dividirse.
- Deben comportarse igual que los stores ya existentes del proyecto:
  - exponer estado observable simple
  - mutar estado de forma explícita
  - llamar `notifyListeners()` cuando corresponde
  - no inventar ciclos de vida o contratos distintos a los ya usados en el repo
  - no actuar como presenter, controller MVC o view model aislado del patrón existente

### `pages/`
- Entrada de navegación del feature.
- Componen secciones y conectan callbacks.
- Deben mantenerse relativamente pequeñas.

### `widgets/`
- Piezas visuales enfocadas por sección o intención.
- Un widget debe poder entenderse sin tener que leer toda la pantalla.

### `utils/`
- Helpers puros y específicos del feature.
- No poner side effects aquí.

### `state/`
- Estructuras de estado de UI cuando el feature necesita separar estado derivado del store principal.
- No usar `state/` por costumbre; usarlo solo si realmente reduce complejidad.

## Reglas de tamaño y complejidad

### Screens
- Si una pantalla supera aproximadamente `200-300` líneas, revisar extracción inmediata.
- Si una pantalla mezcla `loading + error + content + share + comments + reactions + helpers privados`, ya está demasiado grande.

### Widgets
- Si un widget privado empieza a tener múltiples variantes, callbacks y subestados, convertirlo en archivo propio.
- Si una sección ocupa más de `80-120` líneas y tiene identidad propia, extraerla.

### Funciones
- Evitar funciones extensas con múltiples responsabilidades.
- Una función debe hacer una sola cosa: cargar, mapear, compartir, validar o construir una sección; no varias a la vez.
- Si una función requiere muchos comentarios para entenderse, probablemente necesita división.

## Reglas de implementación

### 1. Separar composición y comportamiento
- Composición visual: `widgets/`
- Orquestación de estado: `store/`
- Infraestructura remota: `service/`

### 2. Evitar lógica de negocio en widgets
No hacer esto:
- parsear responses en la pantalla
- decidir contratos de backend en widgets
- construir deep links o payloads complejos en componentes visuales
- manejar múltiples estados remotos dentro de un botón o card si eso pertenece al store

### 3. Evitar widgets privados masivos
No mantener un archivo con una screen y veinte clases privadas si esas piezas tienen valor por sí mismas.

### 4. Evitar helpers ambiguos
No crear archivos tipo `helpers.dart` o `widgets.dart` con mezcla de responsabilidades no relacionadas.

### 5. Preferir nombres orientados al dominio
- `MemberDevotionalCommunitySection`
- `MemberDevotionalDetailStore`
- `MemberDevotionalShareSheet`

Evitar nombres genéricos como:
- `CommonCard2`
- `UtilsWidget`
- `HelperSection`

## Flujo recomendado para nuevas pantallas

1. Definir contrato de datos.
2. Crear o ajustar modelos.
3. Implementar service.
4. Implementar store.
5. Componer la page con secciones pequeñas.
6. Extraer bottom sheets, cards o listas si tienen identidad propia.
7. Validar con `flutter analyze`.

## Ejemplo: Momento Devocional

El detalle del devocional debe estructurarse así:

```text
member_experience/devotional/
  store/
    member_devotional_detail_store.dart
  pages/
    member_devotional_detail_screen.dart
  widgets/detail/
    member_devotional_bottom_sheets.dart
    member_devotional_community_section.dart
    member_devotional_content_section.dart
    member_devotional_detail_sections.dart
    member_devotional_reactions_section.dart
```

### Responsabilidades esperadas
- `screen`: navegación, scaffolding y composición general.
- `store`: load, toggleReaction, submitComment, flags y errores.
- `detail_sections`: top bar, hero, primitives editoriales, share prompt.
- `content_section`: lectura y pasajes bíblicos.
- `reactions_section`: UI de reacciones exclusivamente.
- `community_section`: presencia, preview y CTAs comunitarios.
- `bottom_sheets`: share sheet y comments sheet.

## Buenas prácticas obligatorias del repo

### 1. Seguir el patrón existente antes de inventar uno nuevo
- Si el módulo ya usa `store/`, no introducir `controller/`.
- Si el módulo ya usa `ChangeNotifier`, no mezclar otro patrón localmente sin razón fuerte.
- La consistencia del repo pesa más que preferencias personales de naming.
- El nuevo store debe verse, leerse y comportarse como un store del proyecto, no solo llamarse igual.

### 2. El store no reemplaza la modularidad
- Tener un `Store` no justifica un archivo gigante.
- El store orquesta estado; no debe contener construcción de widgets, copy final ni lógica de presentación compleja.

### 3. Un feature sano se puede leer por capas
Orden esperado de lectura:
1. `models`
2. `service`
3. `store`
4. `pages`
5. `widgets`

### 4. Los widgets no son vertederos de lógica
- Los widgets reciben estado ya preparado.
- Si hay mapeos, derivaciones o reglas condicionales repetidas, muévelas al store, `state/` o `utils/`.

### 5. Los nombres deben reflejar el patrón del repo
Correcto:
- `MemberTodayDevotionalStore`
- `ScheduleListStore`
- `AuthSessionStore`

Incorrecto dentro de este repo:
- `MemberDevotionalController`
- `ScheduleController`
- `PageManager`

Incorrecto también:
- un `Store` que en realidad se comporte como otra abstracción ajena al proyecto
- un `Store` con interfaz, ciclo de vida o responsabilidades diferentes al patrón ya establecido

### 6. Refactor antes de inflar
Si para agregar una feature necesitas:
- sumar otra docena de métodos a una screen
- agregar más estado local disperso
- o meter más clases privadas en el mismo archivo

detente y extrae primero.

## Decisión arquitectónica explícita

Mientras el proyecto no adopte formalmente otro patrón de estado:

- `Store + ChangeNotifier` es el estándar oficial
- `controller/` no debe usarse como convención nueva
- un `Store` debe seguir el mismo comportamiento arquitectónico de los demás stores del repo
- la documentación, ejemplos y features nuevas deben seguir ese estándar

## Reglas para cambios de contrato
- Si cambia un endpoint o payload, actualizar `models`, `service` y consumidores en el mismo PR.
- No aceptar “por ahora soportamos ambas formas” salvo orden explícita del usuario.
- Si un valor nuevo requiere migración conceptual, documentarlo en el cambio.

## Reglas para l10n
- Todo copy visible debe vivir en `app_*.arb`.
- No dejar strings finales incrustados en widgets salvo labels puramente técnicas temporales.
- Después de cambiar copy, regenerar `l10n` y correr análisis.

## Reglas de validación
Antes de cerrar un cambio frontend:
- `dart format` sobre archivos `.dart` tocados
- `flutter gen-l10n` si hubo cambios de localización
- `flutter analyze` sobre el feature afectado

## Señales de alerta
Si aparece cualquiera de estos síntomas, detenerse y refactorizar antes de seguir:
- una screen supera claramente el tamaño razonable
- un archivo mezcla UI, HTTP, mapping y estado
- múltiples widgets privados dependen de variables internas de una sola screen
- se agregan parches locales para tolerar contratos inconsistentes
- una nueva feature solo puede implementarse tocando un archivo enorme existente

## Criterio de calidad
Un cambio está bien diseñado cuando:
- otro desarrollador puede ubicar rápidamente dónde vive cada responsabilidad
- una sección visual puede cambiarse sin reescribir toda la pantalla
- el contrato remoto no está escondido dentro de la UI
- el feature puede crecer sin volver a un archivo monolítico
