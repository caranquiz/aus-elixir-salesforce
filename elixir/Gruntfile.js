module.exports = function(grunt) {
  var nforce = require('nforce');
  var _ = require('underscore');
  var path = require('path');
  var helpers = require('./helpers').init(grunt);
  var apexEndpoint = '/skuid/api/v1/pages';
  var pageNameList = require('./PageNames').init(grunt);

  var orgOptions = {
    'clientId':'3MVG9pcaEGrGRoTJhcW176ph6xXV8J3rlp16gYmxcFrlDQZsb.q6yKMqcxmU4kdpARaBPsJZNOIiZwizXYmGr',
    'clientSecret':'F33BF4DAA66DC148FF029EAF2D007713FA013A3E601E0B65DC14F0261AA1D9BD',
    'username':'provisioningcls@38trialforce.com.staging',
    'password':'Welcome@123456vOzJLbqttUYeCynhtq1OYGjBl',
    'nforceOptions': {
      'environment':'sandbox'
   }
};
  
    grunt.initConfig({
        pkg: grunt.file.readJSON("package.json"),
        uglify: {
          options: {
            mangle: true
          },
          build: {
            src: "js/*.js",
            dest: "js/min/script.js"
          }
        },
         'skuid-pull': {
          options: orgOptions,
      'dev':{
        options:{
          'dest': 'xxx2/',
          'module':[],          
        }
      }            
        },
        'skuid-push':{'options': orgOptions,
      'specific':{
        'files':{
          'src': [grunt.option('page') || 'skuidPages/*']
        }
      }
    },

    });
  grunt.registerTask('skuid-pull-uat',
    'Pull Skuid pages from any Salesforce org running Skuid.',
    function() {
      var pageNames = pageNameList.getPageNames();
      var self = this,
        done = this.async();
      //@todo figure out how to use this to prevent bad things
      //from happening
      var options = this.options({
        'page': pageNames,
        'dest': 'skuidPages/',
        'mode': 'single',
        'redirectUri': 'http://localhost:3000/oauth/_callback',
     'clientId':'3MVG9N6eDmZRVJOl_QHMBHqHh9q7ppTc0NkBf033w2pCizLwxn58NTno8s.0cA68gvwjNXuUWa2sYsmId4EwY',
    'clientSecret':'838FC5257B336DAFE6B055D02954C9E7128CE90B44510DFFEB098895EF454AF4',
    'username':'provisioningcls@38trialforce.com.uatelixir',
    'password':'Welcome@12345KrK0dBXQJFuLdCF78fyv8x9wr',
    'nforceOptions': {
      'environment':'sandbox'
   }
      });
      
      helpers.validateRequiredOptions(['username','password','clientId', 'clientSecret'], options);
      if (_.isArray(options.page)){
        options.page = options.page.join(',');
      }

      var org = nforce.createConnection(helpers.getOrgOptions(options));

      org.authenticate(helpers.getOrgCredentials(options))
        .then(function() {
          return org.apexRest({
            uri: apexEndpoint,
            method: 'GET',
            urlParams: {
              page: options.page
            }
          });
        })
        .then(function(response) {
          response = JSON.parse(response);
          if (!response.error) {
            helpers.writeDefinitionFiles(response, path.join(options.dest));
            grunt.log.ok('Success! Skuid pages for module(s) ' + options.module + ' written to ' + options.dest);
            done();
          } else {
            grunt.fail.fatal(response.error);
          }

        })
        .error(function(error) {
          grunt.fail.fatal(error);
        });

    });

    grunt.registerTask('skuid-pull-dev',
    'Pull Skuid pages from any Salesforce org running Skuid.',
    function() {
      var pageNames = pageNameList.getPageNames();
      var self = this,
        done = this.async();
      //@todo figure out how to use this to prevent bad things
      //from happening
      var options = this.options({
        'page': pageNames,
        'dest': 'skuidPages/',
        'mode': 'single',
        'redirectUri': 'http://localhost:3000/oauth/_callback',
        'clientId':'3MVG9N6eDmZRVJOl_QHMBHqHh9q7ppTc0NkBf033w2pCizLwxn58NTno8s.0cA68gvwjNXuUWa2sYsmId4EwY',
    'clientSecret':'D733F04A12331C192811B3131AF87A26E03F9C396977CDA065CE0B9CD6683099',
    'username':'provisioningcls@38trialforce.com.devElixir',
    'password':'Welcome@123456mWPhUcWzRbbuWyDkQ7rPjKJdh',
    'nforceOptions': {
      'environment':'sandbox'
   }
      });
      
      helpers.validateRequiredOptions(['username','password','clientId', 'clientSecret'], options);
      if (_.isArray(options.page)){
        options.page = options.page.join(',');
      }

      var org = nforce.createConnection(helpers.getOrgOptions(options));

      org.authenticate(helpers.getOrgCredentials(options))
        .then(function() {
          return org.apexRest({
            uri: apexEndpoint,
            method: 'GET',
            urlParams: {
              page: options.page
            }
          });
        })
        .then(function(response) {
          response = JSON.parse(response);
          if (!response.error) {
            helpers.writeDefinitionFiles(response, path.join(options.dest));
            grunt.log.ok('Success! Skuid pages for module(s) ' + options.module + ' written to ' + options.dest);
            done();
          } else {
            grunt.fail.fatal(response.error);
          }

        })
        .error(function(error) {
          grunt.fail.fatal(error);
        });

    });

    grunt.loadNpmTasks("grunt-contrib-uglify");
    grunt.registerTask('default', ["skuid-pull-dev"]);
    grunt.registerTask('pull-code', ["skuid-pull"]);
    grunt.registerTask('push-code', ["skuid-push:specific"]);
    grunt.loadNpmTasks('skuid-grunt');
};