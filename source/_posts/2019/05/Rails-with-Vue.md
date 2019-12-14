---
title: Deploy Rails 5 with Vue via Capsitrano
date: 2019-05-08 08:22:11
tags: ["capsitrano", "rails", "vue", "webpacker"]
categories: ["rails"]
---
# Capsitrano + Rails 5 + Webpacker + Vue on CentOS

這邊使用 Rails 5 與 webpacker 整合 Vue, 在發佈到 sandbox / staging 所遇到的問題.

若是 sandbox / staging 未設定 HTTPS 憑證時, 會遇到類似此問題.

## 專案設定

| 專案設定    | Version |
| ---------- | --------|
| Ruby       | 2.5.5   |
| Rails      | 5.2.3   |
| webpacker  | 4.0.2   |
| vue        | 2.6.10  |

<!--more-->

## 上線(sandbox/staging))問題
上版到測試區(sandbox/staging)遇到的問題, Capsitrano 上版流程包含前端 Vue build code 都順利完成, 

但是連線到測試網站畫面是空白的, Nginx log 也找不到出錯.

花了很一天的時候, 才發現是`content_security_policy.rb` 的設定中, 有設定一些安全性機制.

而這個部分是參照 Webpacker 的說明所設定 [rails/webpacker](https://github.com/rails/webpacker#vue)


原先設定如下:

```ruby
# config/initializers/content_security_policy.rb

# If you're using Rails 5.2+ you'll need to enable unsafe-eval rule for your development environment.
# https://github.com/rails/webpacker#vue
Rails.application.config.content_security_policy do |policy|
  if Rails.env.development?
    policy.script_src :self, :https, :unsafe_eval
  else
    policy.script_src :self, :https
  end
end
```

改成以下方式, 暫時先將 `else` 區塊的程式碼移除. 畫面就能正常運作了！！

這邊研判是, 官網預設上線的流程都會有 HTTPS 的憑證. 

而 sandbox / staging 環境若未設定 HTTPS 的憑證就會出現這個問題

```ruby
# # config/initializers/content_security_policy.rb
Rails.application.config.content_security_policy do |policy|
  if Rails.env.development?
    policy.script_src :self, :https, :unsafe_eval
  end
end
```

## 參考來源:
1. [GitHub - rails/webpacker: Use Webpack to manage app-like JavaScript modules in Rails](https://github.com/rails/webpacker#vue))
2. [rails+vue+webpackerでproductionが真っ白になった件 - Qiita](https://qiita.com/knzw_ats/items/628d4faab25fba5dfe87)
3. [javascript is not load in Production · Issue #1520 · rails/webpacker · GitHub](https://github.com/rails/webpacker/issues/1520)