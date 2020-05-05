const core = require("@actions/core");
const exec = require("@actions/exec");

async function run() {
  try {
    const pattern = core.getInput('pattern');
    const commitMessage = core.getInput('commit_message');
    const author = core.getInput('author');

    if (author == null || author === "") {
      setAuthorInformationFromGithubEvent();
    } else {
      setAuthorInformationFromInput(author);
    }

    // Execute tag bash script
    await exec.exec(
        `bash ${__dirname}/../commit.sh ${pattern} "${commitMessage}"`
    );

  } catch (error) {
    core.setFailed(error.message);
  }
}

function setAuthorInformationFromGithubEvent() {
  const eventPath = process.env.GITHUB_EVENT_PATH;

  if (eventPath) {
    const {author} = require(eventPath).head_commit;

    process.env.AUTHOR_NAME = author.name;
    process.env.AUTHOR_EMAIL = author.email;

  } else {
    core.warning('No event path available, unable to fetch author info.');

    process.env.AUTHOR_NAME = 'Commit Action';
    process.env.AUTHOR_EMAIL = 'bidrag-git.commit@navikt.github.com';
  }

  core.info(
      `Using '${process.env.AUTHOR_NAME} <${process.env.AUTHOR_EMAIL}>' as author.`
  );
}

function setAuthorInformationFromInput(author) {
  process.env.AUTHOR_NAME = author;
  process.env.AUTHOR_EMAIL = 'no-reply-' + author + '@navikt.github.com';
  process.env.GITHUB_TOKEN = core.getInput('security_token');

  core.info("Author: " + author + ", email: " + process.env.AUTHOR_EMAIL)
}

// noinspection JSIgnoredPromiseFromCall
run();
