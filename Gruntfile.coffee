module.exports = (grunt) ->
  'use strict'

  # Project configuration.
  grunt.initConfig
    # Metadata.
    pkg: grunt.file.readJSON 'package.json'

    # Parse CSS and add vendor-prefixed CSS properties using the Can I Use database.
    autoprefixer:
      options:
        browsers: ['ios >= 5', 'android >= 2.3']
      dist:
        src: 'public/files/css/maple.css'

    # Start a static web server.
    # Reload assets live in the browser
    connect:
      app:
        options:
          port: 8080
          base: 'build/'
          open: 'http://localhost:8080/'
      doc:
        options:
          port: 8081
          base: 'doc/'
          open: 'http://localhost:8081/'

    # Sort CSS properties in specific order.
    csscomb:
      dist:
        options:
          config: '.csscombrc'
        files:
          'public/files/css/maple.css': ['public/files/css/maple.css']

    # Lint CSS files.
    csslint:
      dist:
        options:
          csslintrc: '.csslintrc'
        src: ['public/files/css/maple.css']

    # Minify CSS files with CSSO.
    csso:
      dist:
        options:
          banner: """
          /*
           * Maple.css
           * Copyright 2013 Koji Ishimoto
           * Licensed under the MIT License
           */

          """
        files:
          'public/files/css/maple.min.css': ['public/files/css/maple.css']

    # Optimize PNG, JPEG, GIF images with grunt task.
    image:
      options:
        optimizationLevel: 3
      dist:
        files: [
          expand: true
          cwd: "public/files/img/sprite/"
          src: ["**/*.{png,jpg,gif}"]
          dest: "public/files/img/sprite/"
        ]

    # KSS styleguide generator for grunt.
    kss:
      options:
        css: 'public/files/css/maple.css'
        template: 'doc/template'
      dist:
        files:
          # dest : src
          'doc/': ['src/stylesheets/']

    # Grunt task to compile Sass SCSS to CSS
    sass:
      dist:
        files:
          'public/files/css/maple.css': 'src/stylesheets/maple.scss'

    # Grunt task for creating spritesheets and their coordinates
    sprite:
      dist:
        src: 'public/files/img/sprite/tabs/*.png'
        destImg: 'public/files/img/sprite/tabs.png'
        imgPath: '/files/img/sprite/tabs.png'
        destCSS: 'public/files/css/sass/lib/_sprite.scss'
        algorithm: 'binary-tree'
        padding: 2
        cssTemplate: 'public/files/img/sprite/spritesmith.mustache'
        # cssOpts: { functions: false }

    # Run tasks whenever watched files change.
    watch:
      options:
        livereload: true
      css:
        files: ['src/stylesheets/**/*.scss', 'build/**/*.html']
        tasks: ['stylesheet']
      sprite:
        files: ['public/files/img/sprite/*/*.png']
        tasks: ['sprite']

    # SVG to webfont converter for Grunt.
    webfont:
      dist:
        src: 'src/svg/*.svg'
        dest: 'public/files/font/'
        destCss: 'src/stylesheets/lib/'
        options:
          font: 'myfont'
          types: ['woff', 'ttf']
          stylesheet: 'scss'
          htmlDemo: false
          syntax: 'bootstrap'
          relativeFontPath: '/files/font/'

  # Load the plugins.
  grunt.loadNpmTasks 'grunt-kss'
  grunt.loadNpmTasks 'grunt-sass'
  grunt.loadNpmTasks 'grunt-csso'
  grunt.loadNpmTasks 'grunt-image'
  grunt.loadNpmTasks 'grunt-csscomb'
  grunt.loadNpmTasks 'grunt-webfont'
  grunt.loadNpmTasks 'grunt-spritesmith'
  grunt.loadNpmTasks 'grunt-autoprefixer'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-csslint'


  # Tasks.
  grunt.registerTask 'default', ['develop']
  grunt.registerTask 'stylesheet', ['sass', 'autoprefixer', 'csscomb', 'csslint']
  grunt.registerTask 'develop', ['connect:app', 'watch']
  grunt.registerTask 'typeset', ['webfont', 'stylesheet']
  grunt.registerTask 'publish', ['stylesheet', 'kss','connect:doc', 'watch']
  grunt.registerTask 'build', ['stylesheet', 'csso', 'image']