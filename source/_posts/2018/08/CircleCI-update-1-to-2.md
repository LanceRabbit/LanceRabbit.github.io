---
title: CircleCI update from 1.0 to 2.0
date: 2018-08-02 19:51:14
tags: ["CircleCI"]
categories: ["CircleCI"]
---
# CircleCI 1.0 to 2.0

> 緣起

由於CircleCI 1.0 將在2018/8/31 終止支援Linux&MacOS([Detail](https://circleci.com/blog/sunsetting-1-0/))
若要繼續使用CI機制，這時候就需要將 CircleCI 1.0 升級成 2.0

## How to update CircleCI from 1.0 to 2.0 
<!--more-->
若單純更改`config.yml`過程之繁瑣就不多說，好在官方有提供1.0轉換成2.0的機制`config-translation`

這邊就直接使用config-translation直接作轉換，若要手動更新也是可以，詳細請參考官網文件

> config-translation

有三種方式可以進行操作
1. GET: /project/:vcs-type/:username/:project/config-translation
2. https://circleci.com/api/v1.1/project/github/bar/foo/config-translation
3. 透過cmd指令curl

```shell= 
curl https://circleci.com/api/v1.1/project/github/bar/foo/config-translation?circle-token=$CIRCLE_TOKEN&branch=develop
```

這邊選擇第二種，是因已有權限可以進行該專案的操作。

只要在browser(瀏覽器)上的URL網址列直接下
`https://circleci.com/api/v1.1/project/github/bar/foo/config-translation`

bar/foo 請更換成自己team/account下的專案

就會取得 config-translation 的文字檔案(瀏覽器會自動下載)

```yaml= config-translation
version: 2
jobs:
  build:
    （中略）
    # In CircleCI 1.0 we used a pre-configured image with a large number of languages and other packages.
    # In CircleCI 2.0 you can now specify your own image, or use one of our pre-configured images.
    # The following configuration line tells CircleCI to use the specified docker image as the runtime environment for you job.
    # We have selected a pre-built image that mirrors the build environment we use on
    # the 1.0 platform, but we recommend you choose an image more tailored to the needs
    # of each job. For more information on choosing an image (or alternatively using a
    # VM instead of a container) see https://circleci.com/docs/2.0/executor-types/
    # To see the list of pre-built images that CircleCI provides for most common languages see
    # https://circleci.com/docs/2.0/circleci-images/
    docker:
    - image: circleci/build-image:ubuntu-14.04-XXL-upstart-1189-5614f37
      command: /sbin/init
```

> project/.circleci/config.yml

將下載下來的檔案更名為`config.yml` 並新增folder`.circleci`在放置在專案的路徑下 

接著上傳檔案進行測試，若有問題記得看一下config.yml的設定

## 問題區
>時區設定

這邊就遇到時區設定問題 造成測試出現時間差一天的情況
重新調整`config.yml` 的設定時區，就通過測試了

修正前
`echo ''Asia/Taipei'' | sudo tee -a /etc/timezone;`
修正後
`echo ''Asia/Taipei'' | sudo tee /etc/timezone;`

ref：
1. [config-translation](https://circleci.com/docs/2.0/config-translation/#using-config-translation)
2. [CircleCI migrating-from-1-2](https://circleci.com/docs/2.0/migrating-from-1-2/)