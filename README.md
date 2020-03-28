# bidrag-git
Github Actions for git spesialisert for team bidrag

### Continuous integration
![](https://github.com/navikt/bidrag-git/workflows/build%20actions/badge.svg)

### Hovedregel for design:
Alt blir utført av bash-scripter slik at det enkelt kan testes på reell kodebase uten å måtte bygge med github. Javascript brukes dog til å hente
informasjon om den som forårsaker en workflow til å bli utført.

Man må også oppgi miljøvariabler for autentisering, eks: `GITHUB_TOKEN`.

Andre sider ved design av disse "actions", er at de er laget for å kjøre sammen. Dvs. at enkelte actions lager output som kan brukes av andre "actions". 

### Changelog

Versjon | Endringstype | Beskrivelse
--------|--------------|------------
v3.0.3  | Endret       | repo foldere endret navn, git-commit -> commit og git-tag -> tag
v3.0.2  | Endret       | `git-commit`: javascript setter anførselstegn rundt commit melding
v3.0.1  | Endret       | `git-commit`: javascript setter anførselstegn rundt commit melding
v3      | Endret       | nname of action input variables
v2.0.1  | Endret       | `git-commit`: push without sed communication with file system
v2      | Endret       | `git-commit`: push without sed communication with file system
v1      | Endret       | `git-tag`: ommit " when doing logging with the echo command 
