# bidrag-actions/git-commit

This action will commit changed repository files and push to origin

Requires a runner that is able to execute bash scripts.

The action requires the commit messageN

The author information of the commit will be gathered from the GITHUB_EVENT or an cusom auhor with a
security token can be provided.

If no event is present, the following information will be used:
- Author name: Tag & Commit Action
- Author email: bidrag-git.commit@navikt.github.com

If an author is provided, the following information will be used:
- Author name: the author provided 
- Author email: no-reply-<author provided>@navikt.github.com
