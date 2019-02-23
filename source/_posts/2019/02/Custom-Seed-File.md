---
title: Custom Seed File
date: 2019-02-23 15:13:17
tags: ["rails", "ruby", ]
categories: ["rails"]
---
# 如何製作 Custom seeds file

若需要經常透過`rake db:seed`去更新資料時，可以改用客製化的`db:seed:*`去執行，且在執行時帶入參數，就可以順利完成資料新增。

就可以利用此次的方式來進行。
<!--more-->
## 客製化 seeds 步驟

首先要先在 `lib/tasks/` 下新增 `custom_seed.rake` 這個檔案，詳細新增內容如下

```ruby
# lib/tasks/custom_seed.rake
namespace :db do
  namespace :seed do
    namespace :one_categories do
      Dir[File.join(Rails.root, 'db', 'seeds', 'one_categories', '*.rb')].each do |filename|
        task_name = File.basename(filename, '.rb').intern
        task task_name => :environment do
          load(filename) if File.exist?(filename)
        end
      end
    end
  end
end

```

## 建立檔案路徑檔案

要透過`rake db:seed:one_categories:add_sub_category`的方式，來新增一筆資料到關聯資料表`one_sub_categories`內

其主要資料表與關聯資料表的關係如下:
```ruby
class OneCategory
  has_many :one_sub_categories
end

class OneSubCategory
  belongs_to :one_category
end

```

接著在`db/seeds/one_categories`下建立`add_sub_category.rb`，

程式碼內容如下:

```ruby
# db/seeds/one_categories/add_sub_category.rb

ActiveRecord::Base.transaction do
  cate_name = ENV["cate_name"]
  # try(:match, /^\d+$/) 判斷是否為數值
  major_id = ENV["major_id"].to_i if ENV["major_id"].try(:match, /^\d+$/)
  p cate_name
  p major_id
  if cate_name.nil? || major_id.nil?
    p "cate_name, major_id are empty, You must be set these info for this cmd." 
  else
    OneCategory.find_by_id(major_id.to_i).try(:one_sub_categories).try(:find_or_create_by!, name: cate_name, enable: 0)
    p "Add #{cate_name} into one_sub_category success."
  end
end

```

簡單說明程式流程，主要透過 `ENV["cate_name"]` 與 `ENV["major_id"]` 取得從 cmd 所傳入的參數，

接著透過`OneCategory`尋找`major_id`是否存在在主要資料內，再透過`try(:one_sub_categories)`去找尋關聯資料，

並透過`try(:find_or_create_by!, name: cate_name, enable: 0)`建立資料

## 執行方式

透過 shell cmd 執行以下程式，執行新增的 `db:seed:*` 方法，並傳入所需要的參數

```shell
RAILS_ENV=production bundle exec rake db:seed:one_categories:add_sub_category cate_name="次要資料" major_id="57"`
```

