var gulp = require('gulp'),
    coffee = require('gulp-coffee')
    gutil = require('gulp-util'),
    sourcemaps = require('gulp-sourcemaps')

gulp.task('coffee', function ( ) {
    return gulp.src('./src/**/*.coffee')
        // .pipe(sourcemaps.init())
        .pipe(coffee({bare:true})).on('error', gutil.log)
        // .pipe(sourcemaps.write('./'))
        .pipe(gulp.dest('./'))
})

gulp.task('default', ['coffee'],function() {

})