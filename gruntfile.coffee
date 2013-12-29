module.exports = (grunt) ->
  grunt.initConfig
    concat:
      compile:
        src: ['regioncalc.coffee', '<%= grunt.option("file") %>.coffee']
        dest: '<%= grunt.option("file") %>.coffeecup'
    coffeecup:
      compile:
        src: '<%= grunt.option("file") %>.coffeecup'
        dest: '<%= grunt.option("file") %>.html'

  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-coffeecup'
  grunt.registerTask 'compile', ['concat', 'coffeecup']