gulp          = require('gulp')

# browser refresh
browserSync   = require('browser-sync').create()

# css compile
sass          = require('gulp-sass')
postcss       = require('gulp-postcss')
perfectionist = require('perfectionist')
autoprefixer  = require('autoprefixer')
mqpacker      = require('css-mqpacker')
csso          = require('gulp-csso')

# html compile
jade          = require('gulp-jade')
HTMLprettify  = require('gulp-html-prettify')

# js compile
coffee        = require('gulp-coffee')
rjs           = require('gulp-requirejs')
uglify        = require('gulp-uglify')
clean         = require('gulp-clean')

# -----------------------------------
#   project variables
# -----------------------------------

SASS_CONFIG =
  outputStyle: 'nested'

HTML_PRETTIFY_CONFIG =
  indent_char: '  '
  indent_size: 2

PROCESSORS = [
  mqpacker,
  autoprefixer,
  perfectionist
]

# -----------------------------------
#   gulp tasks
# -----------------------------------

gulp.task 'server', ['scss', 'jade'], ->
  browserSync.init
    server: './app'
    open: false

  # gulp watch tack
  gulp.watch 'jade/**/*.jade', ['jade']
  gulp.watch 'scss/**/*.scss', ['scss']
  gulp.watch 'coffee/**/*.coffee', ['build']

gulp.task 'scss', ->
  gulp.src 'scss/**/!(_)*.scss'
    .pipe sass SASS_CONFIG
    .on 'error', sass.logError
    .pipe do csso
    .pipe postcss PROCESSORS
    .pipe gulp.dest 'app/css'
    .pipe browserSync.stream()

gulp.task 'jade', ->
  gulp.src './jade/**/!(_)*.jade'
    .pipe do jade
    .on 'error', console.log
    .pipe HTMLprettify HTML_PRETTIFY_CONFIG
    .pipe gulp.dest 'app'
    .on 'end', browserSync.reload

gulp.task 'build', ['coffee'], ->
  rjs
    baseUrl: 'js'
    name: '../bower_components/almond/almond'
    include: ['main']
    insertRequire: ['main']
    out: 'all.js'
    wrap: on
  .pipe do uglify
  .pipe gulp.dest 'app/js'
  .pipe browserSync.stream()

  gulp.src 'js/', read: no
    .pipe do clean

gulp.task 'coffee', ->
  gulp.src 'coffee/**/*.coffee'
    .pipe do coffee
    .pipe gulp.dest 'js'

gulp.task 'default', ['server', 'scss', 'jade', 'build']
