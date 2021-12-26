const core = require("@actions/core");
const exec = require("@actions/exec");

async function run() {
  try {
    const author = core.getInput('author');

    if (author == null || author === "") {
      setAuthorInformationFromGithubEvent();
    } else {
      setAuthorInformationFromInput(author);
    }

    const commitMessage = core.getInput('commit_message');
    const pattern = core.getInput('pattern');
    const securityToken = core.getInput('security_token');

    // Execute tag bash script
    await exec.exec(
        `bash ${__dirname}/../commit.sh`,
        [commitMessage, pattern, securityToken]
    );
  } catch (error) {
    core.setFailed(error.message);
    core.info(error)
    core.info(error.message)
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

    process.env.AUTHOR_NAME = 'jactor-rises';
    process.env.AUTHOR_EMAIL = 'jactor-rises/actions.commit@github.com';
  }

  core.info(
      `Using '${process.env.AUTHOR_NAME} <${process.env.AUTHOR_EMAIL}>' as author.`
  );
}

function setAuthorInformationFromInput(author) {
  process.env.AUTHOR_NAME = author;
  process.env.AUTHOR_EMAIL = 'no-reply-' + author + '@navikt.github.com';

  core.info("Author: " + author + ", email: " + process.env.AUTHOR_EMAIL)
}

// noinspection JSIgnoredPromiseFromCall
run();
