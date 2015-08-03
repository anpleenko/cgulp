gulp = require('gulp')

# browser refresh
browserSync = require('browser-sync').create()

# css compile
sass = require('gulp-sass')
autoprefixer = require('gulp-autoprefixer')
csso = require('gulp-csso')
csscomb = require('gulp-csscomb')
cssbeautify = require('gulp-cssbeautify')
cmq = require('gulp-combine-media-queries')

# html compile
jade = require('gulp-jade')
HTMLprettify = require('gulp-html-prettify')

# js compile
coffee = require('gulp-coffee')
rjs = require('gulp-requirejs')
uglify = require('gulp-uglify')
clean = require('gulp-clean')

# -----------------------------------
#   project variables
# -----------------------------------

AUTOPREFIXER_CONFIG =
  browsers: ['ie >= 8', 'last 3 versions', '> 2%']
  cascade: no

CSS_BEAUTIFY_CONFIG =
  autosemicolon: on

SASS_CONFIG =
  outputStyle: 'nested'

HTML_PRETTIFY_CONFIG =
  indent_char: '  '
  indent_size: 2

REQUIRE_JS_CONFIG =
  baseUrl: 'js'
  name: '../bower_components/almond/almond'
  include: ['main']
  insertRequire: ['main']
  out: 'all.js'
  wrap: on

# -----------------------------------
#   gulp tasks
# -----------------------------------

gulp.task 'server', ['scss', 'jade'], ->
  browserSync.init
    server: './build'
    open: false

  # gulp watch tack
  gulp.watch 'jade/**/*.jade', ['jade']
  gulp.watch 'scss/**/*.scss', ['scss']
  gulp.watch 'coffee/**/*.coffee', ['build']

gulp.task 'scss', ->
  gulp.src 'scss/**/!(_)*.scss'
    .pipe sass SASS_CONFIG
    .on 'error', sass.logError
    .pipe autoprefixer AUTOPREFIXER_CONFIG
    .pipe do cmq
    .pipe do csso
    .pipe cssbeautify CSS_BEAUTIFY_CONFIG
    .pipe do csscomb
    .pipe gulp.dest 'build/css'
    .pipe browserSync.stream()

gulp.task 'jade', ->
  gulp.src './jade/**/!(_)*.jade'
    .pipe do jade
    .on 'error', console.log
    .pipe HTMLprettify HTML_PRETTIFY_CONFIG
    .pipe gulp.dest 'build'
    .on 'end', browserSync.reload

gulp.task 'build', ['coffee'], ->
  rjs REQUIRE_JS_CONFIG
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
