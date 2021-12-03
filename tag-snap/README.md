# bidrag-actions/git-tag-snap

This action will tag a git repository on current HEAD commit with the next available snapshot version

Requires a runner with node and ncc installed. Also the running environment must be able to execute
bash scripts.

The author information of the commit will be gathered from the GITHUB_EVENT. If no event is present, the
following information will be used:
- Author name: Tag snapshot Action
- Author email: navikt.bidrag-actions.git-tag-snap@github.com
