function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = { // Properties set in `config` (karate-config.js) become globally accessible variables in Karate
	  apiUrl: 'https://conduit-api.bondaracademy.com/api/'
  }

  if (env == 'dev') { // Properties set in `config` (karate-config.js) become globally accessible variables in Karate
    config.passwordFromConfig = 'KarateDEV123'
  }
  if (env == 'qa') { // Properties set in `config` (karate-config.js) become globally accessible variables in Karate
    config.passwordFromConfig = 'KarateQA456'
  }

  //var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authToken
  //karate.configure('headers', {Authorization: 'Token ' + accessToken})

  return config;
}