var gulp = require('gulp');
var sass = require('gulp-sass');
var pure = require('gulp-purescript');
var del = require('del');

gulp.task('build:sass', function() {
  return gulp
    .src('style/style.sass')
    .pipe(sass())
    .pipe(gulp.dest('dist/'));
});

var sources = [
  "src/**/*.purs",
  "bower_components/purescript-*/src/**/*.purs",
];

gulp.task('build:pure:compile', function() {
  return pure.compile({src: sources});
});

gulp.task('build:pure:bundle', ['build:pure:compile'], function() {
  return pure.bundle({src: 'output/**/*.js', output: 'dist/index.js', main: 'Main'});
});

gulp.task('build:pure', ['build:pure:bundle']);

gulp.task('build:copy', function() {
  return gulp.src('resources/**/*').pipe(gulp.dest('dist/'));
});
gulp.task('build:clean', () => {
    del.sync('dist/');
});

gulp.task('build', ['build:clean', 'build:copy', 'build:sass']);

gulp.task('default', ['build']);
