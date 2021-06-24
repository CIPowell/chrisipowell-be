const { version } = require("../package.json");

module.exports.handler = async () => ({
  statusCode: "200",
  body: `{ "status":"OK", "version": "${version}" }`,
  headers: {},
});
