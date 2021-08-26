---
title: heroku-reduce-slug-size
date: 2021-08-26 10:05:07
tags: heroku rails
---

## 緣由

在執行 deploy project to Heroku 時出現了`slug size is too large`的訊息。

```shell
Compiled slug size: 505.5M is too large (max is 500M).
```

經確認後，是因為新增使用 `wkhtmltopdf` 來匯出 pdf 檔案，導致整個專案 size 變大。

<!--more-->
## 處理流程

### 確認檔案大小

登入 heroku 機器的 bash 執行指令 `du -sh * | sort -hr`

```shell
du -sh * | sort -hr
463M	vendor
225M	node_modules
103M	public
91M	tmp
31M	app
1.4M	spec
548K	db
436K	styleguide
432K	config
252K	package-lock.json
240K	myVim.log
108K	lib
60K	test
36K	bin
20K	Gemfile.lock
4.0K	README.md
4.0K	Rakefile
4.0K	Procfile
4.0K	package.json
4.0K	log
4.0K	Guardfile
4.0K	Gemfile
4.0K	environment_url.txt
4.0K	CONTRIBUTING.md
4.0K	config.ru
4.0K	Capfile
4.0K	app.json
0	@1
```

發現`vendor`空間使用達 `463M`,  以及`node_module` 也佔用了 `225M`

接著確認 `vendor` 是哪一個資料夾佔用了空間

```shell
# vendor/
du -sh * | sort -hr
433M	bundle
30M	ruby-2.6.5
5.2M	yarn-v1.22.4
468K	assets
32K	heroku
20K	smooth_scroll
```

從 `bundle` 一路往下找發現是 `wkhtmltopdf-binary-0.12.6.3` 佔用了絕大的空間, 因為安裝時會一並安裝其他版本的 lib.

而專案的 Heroku 環境是使用 ` wkhtmltopdf_ubuntu_18.04_amd64.gz`, 基本上其他的版本都可以移除不用。

```shell
~/vendor/bundle/ruby/2.6.0/gems/wkhtmltopdf-binary-0.12.6.3/bin $ du -sh * | sort -hr
18M    wkhtmltopdf_ubuntu_18.04_i386.gz
18M    wkhtmltopdf_debian_10_i386.gz
17M    wkhtmltopdf_macos_cocoa.gz
17M    wkhtmltopdf_debian_9_i386.gz
17M    wkhtmltopdf_debian_10_amd64.gz
17M    wkhtmltopdf_archlinux_amd64.gz
16M    wkhtmltopdf_ubuntu_20.04_amd64.gz
16M    wkhtmltopdf_ubuntu_18.04_amd64.gz
16M    wkhtmltopdf_ubuntu_16.04_i386.gz
16M    wkhtmltopdf_debian_9_amd64.gz
16M    wkhtmltopdf_centos_8_amd64.gz
15M    wkhtmltopdf_ubuntu_16.04_amd64.gz
15M    wkhtmltopdf_centos_7_i386.gz
14M    wkhtmltopdf_centos_7_amd64.gz
14M    wkhtmltopdf_centos_6_i386.gz
14M    wkhtmltopdf_centos_6_amd64.gz
4.0K    wkhtmltopdf
0    wkhtmltopdf-binary.rb
```

### 調整方式

釐清原因後，依照[Ways for reducing Heroku slug size](https://blog.saeloun.com/2020/05/04/how-to-reduce-heroku-slug-size.html)的方式, 使用`.slugignore`排除不必要檔案的。

#### .slugignore

新增 `.slugignore`, 將不需要部署的檔案列做排除。

```yml
/spec
/test
/public/*.mp4
/tmp
```

#### 其他動態檔案

由於 `node_modules`, 以及 `wkhtmltopdf-binary` 是部署時，才會安裝的檔案, 因此需要透過另外的方式來做處理。

可以知道 deploy Heroku 會執行 `assets:clean`, 因此可以將要執行排除檔案的功能設定在 `assets:clean`.

可以看到 `remove_wkhtmltopdf_binary` 的流程中, 是將需要的檔案搬移到暫存區，接著將該路徑下的檔案直接清除, 接著再將暫存區的檔案搬移回來。

```ruby
# frozen_string_literal: true

namespace :assets do
  desc "Remove install files"
  task rm_unuse_files: :environment do
    remove_node_modules
    remove_wkhtmltopdf_binary
  end
end

def remove_node_modules
  Rails.logger.info "Removing node_modules folder"
  FileUtils.remove_dir("node_modules", true)
end

def remove_wkhtmltopdf_binary
  # /app/vendor/bundle/ruby/2.6.0/gems/wkhtmltopdf-binary-0.12.6.3
  Rails.logger.info "Removing unuse wkhtmltopdf_binary gz file"
  path = `bundle show wkhtmltopdf-binary`
  regex = %r{vendor\/.*}
  original_file_path = Rails.root.join(path.slice(regex, 0), 'bin/wkhtmltopdf_ubuntu_18.04_amd64.gz')
  mv_file_path = Rails.root.join(path.slice(regex, 0), 'wkhtmltopdf_ubuntu_18.04_amd64.gz')

  # move specified file to tmp path
  FileUtils.mv(original_file_path, mv_file_path)

  list = Dir.glob(Rails.root.join(path.slice(regex, 0), 'bin/*.gz'))
  Rails.logger.info "File size: #{list.size}"
  FileUtils.rm_rf(list)
  # move specified file back to original path
  FileUtils.mv(mv_file_path, original_file_path)
end

skip_clean = %w[no false n f].include?(ENV["WEBPACKER_PRECOMPILE"])

unless skip_clean
  if Rake::Task.task_defined?("assets:clean")
    Rake::Task["assets:clean"].enhance do
      Rake::Task["assets:rm_unuse_files"].invoke
    end
  else
    Rake::Task.define_task("assets:clean" => "assets:rm_unuse_files")
  end
end

```

至少可以清除不必要的檔案，改善部署時所佔的空間容量達到將近 50%, 進而提升部署速度。

## 參考

[Ways for reducing Heroku slug size](https://blog.saeloun.com/2020/05/04/how-to-reduce-heroku-slug-size.html)
