# Gestión de estado — EcoTrack Meta

**Equipo:** Equipo EcoTrack
**Fecha:** Actual

## Tipos de estado en nuestro código

| Dato | Tipo (efímero, compartido, derivado, persistido) | Dónde vive |
|---|---|---|
| Pestaña activa | Efímero | `_PantallasEcoTrackState` en `lib/presentacion/vistas.dart` |
| Texto del campo de litros | Efímero | `_FormularioRegistroState` en `lib/presentacion/vistas.dart` |
| consumos y meta | Compartido | `ConsumosViewModel` en `lib/presentacion/consumos_view_model.dart` |
| total y metaSuperada | Derivado | Getters en `ConsumosViewModel` en `lib/presentacion/consumos_view_model.dart` |
| Lo que regresa todos() | Persistido | `MemoriaConsumoRepository` en `lib/datos/memoria_consumo_repository.dart` |

## Criterios

| Criterio | A · ChangeNotifier puro | B · provider |
|---|---|---|
| Dato compartido | `ConsumosViewModel` pasado explícitamente por constructor | `ConsumosViewModel` colgado en el árbol de widgets |
| Capas | Respetadas estrictamente (`dominio`, `datos`, `presentacion`) | Respetadas estrictamente (`dominio`, `datos`, `presentacion`) |
| Encaje con el diagrama | Cumple con las flechas legales | Cumple con las flechas legales |
| Constructores que reciben vm | Todos los adaptadores (`RegistroCN`, etc.) | Ninguno (uso de `context.watch` y `context.read`) |
| Quién libera el ViewModel | El `State` de `AppChangeNotifier` mediante `_vm.dispose()` | El `ChangeNotifierProvider` automáticamente |
| Costo de adoptarla ahora | Bajo, gestión manual de dependencias | Bajo, inyección declarativa en el árbol |
| Sustitución de la fuente de datos | Mediante `main_change_notifier.dart` | Mediante `main.dart` |

## Elección

Elegimos: Variante B (provider)
Se mantiene esta pieza del diagrama: `ConsumosViewModel`, la capa de dominio (`dominio/`) y las vistas tontas (`vistas.dart`).
Esta pieza es la que podría sustituirse después: `MemoriaConsumoRepository` por un repositorio de red o persistencia local.
