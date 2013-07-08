module.exports =  (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-bower-task'

  grunt.initConfig {
    bower: 
      install:
        options:
          cleanTargetDir: false
          targetDir: "static"
          layout: 'byType'
          install: true
          verbose: false

  }