# bidrag-actions/git-commit

This action will commit changed repository files and push to origin

Requires a runner with node and ncc installed. Also the running environment must be able to execute
bash scripts.

The action requires the commit message and the author to use for the commit. Optional inputs are the
pattern to use with git add and a file with content to add to the commit message.

If a file containing some commit message content is present, the content will replace {} from the commit
message provided.

The author information of the commit should be gathered from the GITHUB_EVENT, ie:
${{ github.head_commit.author }}
