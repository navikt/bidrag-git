const core = require("@actions/core");
const exec = require("@actions/exec");
const github = require("@actions/github");

async function run() {
  try {
    // Set the src-path
    const src = __dirname + "/src";
    core.debug(`src: ${src}`);

    // Fetch the file path from input
    const filepath = core.getInput("file-path");
    core.debug(`input: ${filepath}`);

    // Execute verify bash script
    await exec.exec(`${src}/verify.sh`);

    // Get the JSON webhook payload for the event that triggered the workflow
    const payload = JSON.stringify(github.context.payload, undefined, 2);
    console.debug(`github event payload: ${payload}`);

    await exec.exec(`export FILEPATH=${filepath}`)

  } catch (error) {
    core.setFailed(error.message);
  }
}

// noinspection JSIgnoredPromiseFromCall
run();
