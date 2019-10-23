module.exports = function(grunt) {
  var nforce = require('nforce');
  var _ = require('underscore');
  var path = require('path');
  var helpers = require('./helpers').init(grunt);
  var apexEndpoint = '/skuid/api/v1/pages';
  var pageNameList = require('./PageNames').init(grunt);

  var orgOptions = {
    'clientId':'3MVG9iLRabl2Tf4hKxUFhiBKU_kbpZ2NwhzDAWgfp09mdYXh2gPipHzyK2NTV2CqZgyDqHTUEgaI3HyPL74ZV',
    'clientSecret':'0399795E433FF28D61C4607EC0AEECFD3422C766C30C6FC17CFB1F2C2A86EB4E',
    'username':'provisioningcls@38trialforce.com.khaliddev',
    'password':'Welcome@12345hxAl4qbawnxYo9BE8xac3tW35',
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
     'clientId':'3MVG9aWdXtdHRrI0e4qHQ7X8QIBbA6lfLvf3FAHoSdpOG5QbpQzGEFT_uT3fPAyPqlKWL6vTZSEDkAB3LZ4Qn',
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
     'clientId':'3MVG9iLRabl2Tf4hKxUFhiBKU_kbpZ2NwhzDAWgfp09mdYXh2gPipHzyK2NTV2CqZgyDqHTUEgaI3HyPL74ZV',
    'clientSecret':'0399795E433FF28D61C4607EC0AEECFD3422C766C30C6FC17CFB1F2C2A86EB4E',
    'username':'provisioningcls@38trialforce.com.khaliddev',
    'password':'Welcome@12345hxAl4qbawnxYo9BE8xac3tW35',
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
    grunt.registerTask('default', ["skuid-pull-uat"]);
    grunt.registerTask('pull-code', ["skuid-pull"]);
    grunt.registerTask('push-code', ["skuid-push:specific"]);
    grunt.loadNpmTasks('skuid-grunt');
};