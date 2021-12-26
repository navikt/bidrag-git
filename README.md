# actions
Github Actions utbedret av jactor-rises

### Continuous integration

### Hovedregel for design:
Alt blir utført av bash-scripter slik at det enkelt kan testes på reell kodebase uten å måtte bygge med github. Javascript brukes dog til å hente
informasjon om den som forårsaker en workflow til å bli utført.

### Release log

Action | Versjon | Endringstype | Beskrivelse
---|---|---|---
build-node-action | v1.0.0 | Opprettet | Bygger github action ved hjelp av node og ncc
commit | v1.0.0 | Opprettet | Commit endring av files i et github repo og push til "origin"
tag | v1.0.0 | Opprettet | "Tag" release versjon lages på bakgrunn av "tagged snapshot" versjon
tag-snapshot | v1.0.0 | Opprettet | "Bump" av "snapshot" versjon ved bruk av git tag
