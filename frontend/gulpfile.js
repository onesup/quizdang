var gulp = require('gulp');
var concat = require('gulp-concat');
var sourcemaps = require('gulp-sourcemaps');
var babel = require('gulp-babel');
var sass = require('gulp-sass');
var autoprefixer = require('gulp-autoprefixer');

var paths = {
  js: 'src/js/**/*.js',
  venderJS: [
    // 'bower_components/framework7/dist/js/framework7.js',
    'bower_components/toast-for-framework7/toast.js',

    'bower_components/jquery/dist/jquery.js',
    'bower_components/jquery-rails/vendor/assets/javascripts/jquery_ujs.js',
    // 'bower_components/cocoon/app/assets/javascripts/cocoon.js',
    'bower_components/offline/offline.js',
    'bower_components/fingerprintjs2/fingerprint2.js',
    'bower_components/jquery.cookie/jquery.cookie.js',
  ],
  css: 'src/css/**/*.scss',
  venderCSS: [
    // 'bower_components/normalize.css/normalize.css',
    // 'bower_components/framework7/dist/css/framework7.ios.css',
    // 'bower_components/framework7/dist/css/framework7.ios.colors.css',
    'bower_components/toast-for-framework7/toast.css',
    'bower_components/offline/themes/offline-language-english.css',
    'bower_components/offline/themes/offline-theme-chrome.css',
  ],
  images: 'src/img/**/*',
  venderImages: 'bower_components/framework7/dist/img/*',
  copy: 'src/index.html',
  app: 'dist/**/*',
};

// Production build
gulp.task('build', ['js', 'vendorjs', 'css', 'vendorcss', 'image', 'venderimage', 'copy', 'app']);
gulp.task('clean', function() {
  // return del(['dist']);
});

gulp.task('js', function() {
  return gulp.src(paths.js)
  .pipe(sourcemaps.init())
  .pipe(babel())
  .pipe(concat('app.js'))
  .pipe(sourcemaps.write('.'))
  .pipe(gulp.dest('dist/js'));
});

gulp.task('vendorjs', function() {
  gulp.src(paths.venderJS)
  .pipe(concat('vendor.js'))
  .pipe(gulp.dest('dist/js'));
});

gulp.task('css', function() {
  gulp.src(paths.css)
  .pipe(sass().on('error', sass.logError))
  .pipe(concat('app.css'))
  .pipe(autoprefixer({
    browsers: ['last 2 versions'],
    cascade: false
  }))
  .pipe(gulp.dest('dist/css'));
});

gulp.task('vendorcss', function() {
  gulp.src(paths.venderCSS)
  .pipe(concat('vendor.css'))
  .pipe(gulp.dest('dist/css'));
});

// Copy all static images
gulp.task('image', ['clean'], function() {
  return gulp.src(paths.images)
  // Pass in options to the task
  // .pipe(imagemin({optimizationLevel: 5}))
  .pipe(gulp.dest('dist/img'));
});

gulp.task('venderimage', ['clean'], function() {
  return gulp.src(paths.venderImages)
  // Pass in options to the task
  // .pipe(imagemin({optimizationLevel: 5}))
  .pipe(gulp.dest('dist/img'));
});

gulp.task('copy', function() {
  return gulp.src(paths.copy)
  .pipe(gulp.dest('dist'));
});

gulp.task('app', function() {
  gulp.src(paths.app).pipe(gulp.dest('www'));
  // gulp.src('src/js/index.js').pipe(gulp.dest('www/js'));
});

gulp.task('css:watch', function() {
  gulp.watch(paths.css, ['css']);
});

gulp.task('js:watch', function() {
  gulp.watch(paths.js, ['js']);
});

gulp.task('watch', function() {
  gulp.watch(paths.js, ['js']);
  gulp.watch(paths.vendorJS, ['vendorjs']);
  gulp.watch(paths.css, ['css']);
  gulp.watch(paths.vendorCSS, ['vendorcss']);
  gulp.watch(paths.image, ['image']);
  gulp.watch(paths.image, ['venderimage']);
  gulp.watch(paths.copy, ['copy']);
  gulp.watch(paths.copy, ['app']);
});
