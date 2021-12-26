# actions/commit

This action will commit changed repository files and push to origin

Requires a runner that is able to execute bash scripts.

The action requires the commit message

The author information of the commit will be gathered from the GITHUB_EVENT, or a custom author.
If no security token is provided, GITHUB_TOKEN is used.

If no event is present, the following information will be given to git:
- Author name: jactor-rises
- Author email: jactor-rises/actions.commit@github.com

If an author is provided, the following information will be used:
- Author name: the author provided 
- Author email: no-reply-<author provided>@navikt.github.com
