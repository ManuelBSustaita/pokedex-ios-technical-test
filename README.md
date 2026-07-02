# Pokedex — Prueba Técnica iOS

Aplicación iOS que consume la [PokéAPI](https://pokeapi.co) para mostrar un listado
de Pokémon y su detalle, construida con SwiftUI y arquitectura MVVM.

## Requisitos
- Xcode 15+
- iOS 16+ (usa NavigationStack y async/await)
- Sin dependencias externas — solo Foundation y SwiftUI

## Cómo correr el proyecto
1. Abre `Pokedex.xcodeproj` en Xcode.
2. Selecciona un simulador (iPhone 15, por ejemplo).
3. Cmd+R para correr.
4. Cmd+U para correr los tests.

## Arquitectura

MVVM con inyección de dependencias por constructor:

- **Models**: structs `Codable` que mapean las respuestas de la PokéAPI
  (`PokemonListItem`, `PokemonDetail` y sus sub-modelos).
- **Networking**: `PokemonServiceProtocol` define el contrato; `PokemonAPIService`
  lo implementa con `URLSession` + `async/await`. El protocolo permite mockear 
  el service en tests sin pegarle a la red real.
- **ViewModels**: `ObservableObject` por pantalla (`PokemonListViewModel`,
  `PokemonDetailViewModel`), reciben el service inyectado en su `init`, nunca
  lo crean ellos mismos. Exponen su estado como un único enum (`ListState`)
  en vez de banderas booleanas sueltas, para evitar estados inválidos
  (ej. loading + error al mismo tiempo).
- **Views**: SwiftUI puro, sin lógica de negocio — solo reaccionan al estado
  que expone el ViewModel.

### Por qué este patrón de inyección de dependencias
Los ViewModels dependen de `PokemonServiceProtocol` (abstracción), no de
`PokemonAPIService` (implementación concreta). Esto permite sustituir la
implementación real por `PokemonServiceMock` en tests, sin tocar el código
de producción. El único lugar donde se instancia la implementación real es
`PokedexApp.swift` (composition root).

## Persistencia de datos

Se implementó una cache local en disco (`PokemonCache`, usando `FileManager`
+ JSON) para el listado (por página) y el detalle (por id de Pokémon), con
estrategia **network-first con fallback a cache**: la app siempre intenta
traer datos frescos de la red primero, y solo recurre a la cache si la
petición falla.

**Justificación**: los datos de la PokéAPI son estáticos (los stats, tipos
y sprites de un Pokémon no cambian con el tiempo), por lo que no existe
riesgo real de inconsistencia entre lo cacheado y el servidor — no se
necesita lógica de invalidación ni resolución de conflictos.

**Offline parcial**: con este approach, el usuario puede seguir viendo
contenido ya visitado (Pokémon ya cargados) sin conexión, pero no puede
cargar páginas o Pokémon que nunca visitó — de ahí el carácter "parcial"
del soporte offline.

## Estados de UI
Cada pantalla maneja explícitamente 4 estados (vía enum, no banderas sueltas):
- **Loading**: spinner mientras se obtiene la primera página / el detalle.
- **Loaded**: contenido normal.
- **Empty**: mensaje cuando no hay resultados.
- **Error**: mensaje + botón de reintentar, sin exponer el error técnico crudo.

## Paginación
El listado carga de a 20 Pokémon por página (según lo pedido), y dispara la
siguiente página automáticamente cuando el usuario se acerca al final del
scroll (`.task` en cada fila + verificación de índice), sin librerías
externas.

## UI — carcasa Pokédex
Los componentes visuales que imitan la carcasa de una Pokédex viven en
`Views/PokedexShell/` (`PokedexFrameView`, `OctagonButton`, `DPadView`,
`IndicatorLightsView`), separados de `Views/Components/`, que contiene
componentes ligados a datos de dominio (`PokemonRowView`). Esta separación
distingue "chrome" decorativo reutilizable de vistas que sí dependen de los
modelos de Pokémon.

## Testing
Se testearon los ViewModels (la lógica con más valor de negocio) usando
`PokemonServiceMock`, que implementa `PokemonServiceProtocol`:
- Carga exitosa → estado `.loaded`
- Error de red → estado `.error`
- Resultados vacíos → estado `.empty`
- No se re-hacen peticiones si ya hay datos cargados

No se testeó `PokemonAPIService` contra `URLSession` real ni con
`URLProtocol` mockeado por límite de tiempo — se priorizó testear la lógica
de negocio (ViewModels) sobre la capa de red, que es en gran parte código
estándar de `URLSession`.

## Decisiones y trade-offs
- **SwiftData vs cache manual en disco**: se optó por cache manual con
  `FileManager` por simplicidad, dado que solo se necesita almacenamiento
  clave-valor simple (por página / por id), sin relaciones entre entidades.
- **AppDependencies / contenedor de DI**: no se implementó un contenedor
  formal dado el tamaño del proyecto (1 service). Con más pantallas o
  services, se recomendaría introducir un `AppDependencies` que centralice
  la construcción de dependencias.

## Posibles mejoras con más tiempo
- Búsqueda/filtro de Pokémon por nombre o tipo.
- Tests de integración de `PokemonAPIService` con `URLProtocol` mockeado.
- Animaciones de transición entre listado y detalle.
- Soporte de Dynamic Type / accesibilidad más exhaustivo.
- Adaptar `PokedexFrameView` a tamaños de pantalla variados (actualmente usa
  tamaños fijos en algunos componentes).
