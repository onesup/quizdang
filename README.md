# 퀴즈당(quizdang) [![Build Status](https://travis-ci.org/kimsuelim/quizdang.svg?branch=master)](https://travis-ci.org/kimsuelim/quizdang)

<img src="https://www.quizdang.com/assets/icon-b3d61be85a1232ad3149d49c55cbf76719984f9ac93ff126b553001f50885cc2.png" width="100" align="right">

안녕하세요!

이곳은 [quizdang.com](https://www.quizdang.com) 서비스를 오픈소스로 공개한 repo입니다. 
rails를 배우시려는 초보부터, rails로 개발한 서비스를 알고자 하시는 분, 개발에 참여하고 싶으신 분들까지 모두 환영합니다.
github 이슈에서 만나요.

---

## Quickstart

This README would normally document whatever steps are necessary to get the application up and running.

### Ruby version

* MRI 2.2.4
* Rails >= 4.2

### System dependencies

brew 또는 apt-get으로 개발에 필요한 패키지 설치

* mysql ~>5.7.10
* redis ~>3.3.0
* memcached ~>1.4.24
* node.js ~>4.2.6
* elasticsearch ~>2.2.0
* imagemagick
* optipng
* jpegoptim

### 설정
git repository를 Fork 또는 Clone

    $ git clone https://github.com/kimsuelim/quizdang.git

Gem 설치

    $ cd quizdang

    $ bundle

### Database 생성
Create a database for quizdang's data.

    $ rake db:create

### Database initialization

migrate your database:

    $ rake db:migrate

And don't forget to seed(Populate with test data)

    $ rake db:seed

### up and running(Test your installation)
여기까지 완료되었다면 개발 서버를 실행할 수 있으며

    $ bundle exec rails s 

그리고 브라우저에서 localhost:3000에 연결할 수 있어야 합니다.

### How to run the test suite
테스트를 실행하려면 `rake test`를 이용해 주세요.

    $ rake test

### Services and Cron Jobs
#### Services
production에서 실행하기 위해 필요한 서비스입니다.

* nginx(reverse proxy servers)
* unicorn(app servers)
* sidekiq(job queues)
* memcached(cache servers)
* elasticsearch(search engines)

#### Crons
사이트를 업데이트하기 위해 주기적으로 실행되는 job은 [whenever](https://github.com/javan/whenever)
을 이용합니다. deploy시 capistrano로 crontab을 업데이트합니다.

### Deployment instructions
capistrano를 이용하여 production에 deploy

    $ cap production deploy

## Development

### frontend(공통)
필수 개발 tool

* [bower](http://bower.io)
* [gulp](https://github.com/gulpjs/gulp)
* [babel](https://github.com/babel/babel)
* [autoprefixer](https://github.com/postcss/autoprefixer)
* [Sass](http://sass-lang.com)

bower 설치

    $ npm install -g bower

bower package 설치

    $ cd frontend
    $ bower install

개발 tool 설치

    $ npm install

### frontend(web app)
mobile/tablet/desktop web app 개발 시

build

    $ gulp build

### frontend(hybrid app)
* [cordova](https://cordova.apache.org)

cordova hybrid app 개발 시

    $ npm install -g cordova@5.4.0
    $ cordova platform add ios
    $ cordova platform add android
    $ cordova build
    $ cordova emulate ios

## Contributing
ruby 스타일 가이드 [ruby-style-guide](https://github.com/bbatsov/ruby-style-guide)
rails 스타일 가이드 [rails-style-guide](https://github.com/bbatsov/rails-style-guide)

* [rubocop](https://github.com/bbatsov/rubocop)

javascript 스타일 가이드 [javascript-style-guide](https://github.com/airbnb/javascript)

* [jshint](https://github.com/jshint/jshint)
* [jscs](https://github.com/jscs-dev/node-jscs)

Bug reports and pull requests are welcome on GitHub at https://github.com/kimsuelim/quizdang. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Author

Surim Kim (김수림)

## License

The app is available as open source under the terms of the [CPAL License](http://opensource.org/licenses/CPAL-1.0).
