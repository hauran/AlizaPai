module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-simple-watch');

  grunt.initConfig({
    less:{
      dev:{
        files: {
          "public/css/alizapai.css": "less/alizapai.less"
        } 
      }
    },
    coffee: {
      compile: {
        files: {
          'public/js/alizapai.js': 'coffee/**/*.coffee'
        }
      }
    },
    watch: {
      less: {
        files: 'less/**/*.less',
        tasks: 'less:dev'
      },
      coffee: {
        files: 'coffee/**/*.coffee',
        tasks: 'coffee'
      }
    }
  });
  // Default task.
  grunt.registerTask('default', 'less:dev coffee watch');
  grunt.registerTask('prod', 'less:dev coffee');
};