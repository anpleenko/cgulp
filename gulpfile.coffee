gulp = require('gulp')
jade = require('gulp-jade')
sass = require('gulp-sass')
browserSync = require('browser-sync').create()

# js compile
coffee = require('gulp-coffee')
rjs = require('gulp-requirejs')
uglify = require('gulp-uglify')
clean = require('gulp-clean')

gulp.task 'server', ['scss', 'jade'], ->
  browserSync.init
    server: './build'
    open: false

  gulp.watch 'jade/**/*.jade', ['jade']
  gulp.watch 'scss/**/*.scss', ['scss']
  gulp.watch 'coffee/**/*.coffee', ['build']

gulp.task 'scss', ->
  gulp.src 'scss/**/*.scss'
    .pipe sass
      outputStyle: 'nested'
    .on 'error', sass.logError
    .pipe gulp.dest 'build/css'
    .pipe browserSync.stream()

gulp.task 'jade', ->
  gulp.src 'jade/**/*.jade'
    .pipe do jade
    .pipe gulp.dest 'build'
    .pipe browserSync.stream()

gulp.task 'build', ['coffee'], ->
  rjs
    baseUrl: 'js'
    name: '../bower_components/almond/almond'
    include: ['main']
    insertRequire: ['main']
    out: 'all.js'
    wrap: on
  .pipe do uglify
  .pipe gulp.dest 'build/js'
  .pipe browserSync.stream()

  gulp.src 'js/', read: no
    .pipe do clean

gulp.task 'coffee', ->
  gulp.src 'coffee/**/*.coffee'
    .pipe do coffee
    .pipe gulp.dest 'js'

gulp.task 'default', ['server', 'scss', 'jade', 'build']
