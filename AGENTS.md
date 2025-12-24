# Guía de Desarrollo para Agentes IA

## Reglas Fundamentales

### 1. **SIEMPRE Revisar Código Existente Antes de Crear Nuevo**

Antes de crear cualquier componente nuevo (filtros, tablas, formularios, etc.), **SIEMPRE** debes:

1. **Buscar componentes similares existentes** en el proyecto
2. **Visualizar y estudiar** cómo están implementados
3. **Copiar el patrón y estilo** exactamente
4. **NO inventar** nuevos estilos o estructuras

#### Ejemplo: Creando Filtros

❌ **INCORRECTO**: Crear filtros con Container, boxShadow, y tu propio estilo
```dart
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    boxShadow: [...], // ❌ NO INVENTAR ESTILOS
  ),
  child: Column(...)
)
```

✅ **CORRECTO**: Revisar primero los filtros existentes
```bash
# 1. Buscar filtros existentes
lib/features/erp/contributions/pages/contributions_list/widgets/contribution_filters.dart
lib/features/erp/patrimony/pages/list/widgets/patrimony_assets_filters.dart

# 2. Ver cómo están implementados
# 3. Copiar el patrón exacto
```

```dart
// Patrón correcto encontrado en filtros existentes
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      children: [
        Expanded(child: _searchInput()),
        Expanded(child: _statusDropdown()),
      ],
    ),
  ],
)
```

### 2. Componentes que SIEMPRE Debes Revisar

Cuando crees:
- **Filtros** → Revisar `contribution_filters.dart`, `patrimony_assets_filters.dart`
- **Tablas** → Revisar `contribution_table.dart`, `patrimony_assets_table.dart`
- **Listados** → Revisar `contributions_list_screen.dart`, `patrimony_assets_list_screen.dart`
- **Formularios** → Revisar formularios existentes en la misma sección
- **Modales** → Revisar modales existentes

### 3. Pasos Obligatorios Antes de Implementar

1. **Buscar (find_by_name o grep_search)**: Componentes similares
2. **Ver (view_file)**: Implementación completa de ≥2 ejemplos existentes
3. **Identificar el patrón**: Estructura, estilos, widgets usados
4. **Implementar igual**: Mismo patrón, ajustando solo lógica específica

### 4. Widgets y Estilos Estándar del Proyecto

#### Widgets Comunes
- `Input` - Para inputs de texto
- `Dropdown` - Para selectores
- `ButtonActionTable` - Para botones de acción
- `CustomTable` - Para tablas paginadas

#### NO uses:
- `Container` con `boxShadow` en filtros
- Estilos inline personalizados
- Widgets de Material UI directamente (usa los wrappers del proyecto)

## Proceso de Desarrollo

```
1. Usuario pide nueva feature
   ↓
2. BUSCAR componentes similares
   ↓
3. VER implementación de ≥2 ejemplos
   ↓
4. COPIAR patrón exacto
   ↓
5. AJUSTAR solo la lógica específica
   ↓
6. Implementar
```

## Notas Importantes

- La consistencia visual es CRÍTICA
- No asumas cómo deben verse las cosas
- Siempre hay un ejemplo existente que seguir
- Si no estás seguro, PREGUNTA antes de crear

---

**Fecha de creación**: 2025-12-24
**Última actualización**: 2025-12-24
