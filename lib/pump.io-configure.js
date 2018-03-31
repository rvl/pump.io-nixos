var fs = require('fs');

var opts = JSON.parse(fs.readFileSync("/dev/stdin").toString());
var config = opts.config;

var readSecret = function(filename) {
  return fs.readFileSync(filename).toString().trim();
};

if (config.secretFile) {
  config.secret = readSecret(config.secretFile);
}
if (config.dbPasswordFile) {
  config.params.dbpass = readSecret(config.dbPasswordFile);
}
if (config.smtpPasswordFile) {
  config.smtppass = readSecret(config.smtpPasswordFile);
}
if (config.spamClientSecretFile) {
  config.spamclientsecret = readSecret(config.spamClientSecretFile);
}

function clean(obj) {
  for (var propName in obj) {
    if (obj[propName] === null || obj[propName] === undefined) {
      delete obj[propName];
    }
  }
}

clean(config);
clean(config.params);

fs.writeFileSync(opts.outputFile, JSON.stringify(config));
