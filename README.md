# bidrag-git
Github Actions for git spesialisert for team bidrag

### Continuous integration
![](https://github.com/navikt/bidrag-git/workflows/build%20actions/badge.svg)

### Hovedregel for design:
Alt blir utført av bash-scripter slik at det enkelt kan testes på reell kodebase uten å måtte bygge med github. Javascript brukes dog til å hente
informasjon om den som forårsaker en workflow til å bli utført.

### Release log

Action | Versjon | Endringstype | Beskrivelse
---|---|---|---
tag-snap | v1.0.0 | Opprettet | "Bump" av "snapshot" versjon utelukkende ved bruk av git tags
tag | v1.0.0 | Endret (fra bidrag-git@v5) | Release versjon lages på bakgrunn av "tagged snapshot" versjon

Versjon | Endringstype | Beskrivelse
----|---|---
v5.0.6 | Endret | `tag`: bump actions/core 1.2.7, call tag.sh from parent folder, fix tag message 
v5.0.6 | Endret | `commit`: bump actions/core 1.2.7
v5.0.5 | Endret | `commit`: use exit codes and swallow errors from git push 
v5.0.4 | Endret | `commit`: bug hunt with changes (no functional change) 
v5.0.3 | Endret | `commit`: gitt `diff-files --quiet` (instead of `git diff --quiet`) 
v5.0.2 | Endret | `commit`: remove simple quotes from url 
v5.0.1 | Endret | `commit`: the script will find the github project based on the `.git` folder 
v5.0.0 | Endret | `commit`: removed git folder. Using the name of the github repository for folder to use 
v4.0.x | Endret | `commit`: add security token and change directory to git folder before running
v3.0.7 | Endret | `commit`: run without input when author is blank
v3.0.6 | Endret | `commit`: author and token can be provided as input
v3.0.5 | Endret | `commit`: no git status after push
v3.0.4 | Endret | `tag`: message is surrounded with quotes in javascript
v3.0.3 | Endret | repo foldere endret navn, git-commit -> commit og git-tag -> tag
v3.0.2 | Endret | `git-commit`: javascript setter anførselstegn rundt commit melding
v3.0.1 | Endret | `git-commit`: javascript setter anførselstegn rundt commit melding
v3 | Endret | name of action input variables
v2.0.1 | Endret | `git-commit`: push without sed communication with file system
v2 | Endret | `git-commit`: push without sed communication with file system
v1 | Endret | `git-tag`: ommit " when doing logging with the echo command 
v1 | Created | Moved from `bidrag-actions` 
