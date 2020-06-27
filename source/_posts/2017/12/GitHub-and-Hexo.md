---
title: 使用Hexo搭配Github部署個人部落格
date: 2017-12-19
updated: 2020-06-27
tags: ["Hexo", "GitHub"]
categories: ["Hexo"]
---
前置說明：

> * macOS
> * yarn安裝
> * Git環境設定

## Hexo安裝

<!--more-->
透過yarn安裝hexo

```shell=
yarn global add hexo-cli
```

在初始化要建置的名稱，這邊我用"blog"

```shell=
hexo init blog
```

再到資料夾下進行安裝所需元件

```shell=
cd blog
yarn install
```

接著在port 8080啟用hexo

```shell
hexo s -p 8080
```

直接在瀏覽器打開服務 `http://localhost:8080/`

基本是安裝好了

## 設定

```shell=
hexo new [type] article-title
```

> Hexo 有三種預設 type: draft(草稿)、post(公開文章) 和page(頁面)，下指令時沒填 type 預設是 post。

### 分類

```shell
hexo new page categories
```

設定title與type為categories

```shell
---
title: 分類
date: 2017-12-10 12:39:04
type: "categories"
---
```

### 標籤

```shell=
hexo new page tags
```

設定title與type為tags

```shell
---
title: 標籤
date: 2017-12-09 22:06:51
type: "tags"
---
```

### 關於

```shell
hexo new page "about"
```

啟用剛剛所使用的設定

```[] blog/_config.yml
menu:
  home: / || home
  about: /about/ || user
  tags: /tags/ || tags
  categories: /categories/ || th
  archives: /archives/ || archive
```

### 建立文章搭配分類與標籤

```shell=
hexo new post new_post
```

設定文章主題與標籤跟分類

```shell
---
title: Github建立Hexo blog
date: 2017-12-19 20:12:43
tags:
    - Hexo
    - Git
categories: Hexo
---
```

### 樣式

到[Themes](https://hexo.io/themes/)挑選個人喜愛的樣式

選擇next樣式

```shell
git clone https://github.com/iissnan/hexo-theme-next.git ./themes/next
```

設定樣式

```yaml= blog/_config.yml
theme: next
```

## 發布到Github

### 先安裝套件

```shell=
yarn add hexo-deployer-git
```

### GitHub建立repo

建立一個名稱為 {使用者名稱}.github.io
設定git路徑

```[] blog/_config.yml
# Deployment
deploy:
  type: git
  repo: https://github.com/github-username/github-username.github.io.git
  branch: master
```

進行編譯與發布

```shell
hexo clean  # 清除暫存
hexo g      # 產生靜態檔案
hexo d      # 發布到github
```

### 文章索引

若有申請 `ALGOLIA` 的文章索引, 記得 export key 之後

```shell
# Search-Only-API-key 替換成自己的 key
export HEXO_ALGOLIA_INDEXING_KEY=Search-Only-API-key
```

接著再透過以下方式將文章做索引

```shell
hexo algolia # 索引文章
```

## Reference

[1] https://hexo.io/zh-tw/docs/commands.html
[2] https://oawan.me/2016/easy-hexo-easy-blog/
[3] https://tw.saowen.com/a/de69eb1f736ae4c2fbe831878dbe8d301fef8038cb6c8808e615d7e966cc9ade