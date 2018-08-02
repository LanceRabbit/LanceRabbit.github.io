---
title: Git使用手札
date: 2018-03-17 13:49:06
tags: ["Git", "GitHub"]
categories: ["Git"]
---
# Git 手扎
> 主要紀錄常用指令
## Git 指令
<!--more-->
### git init
初始化一個init的資訊在指定的folder下
* git init

確認遠端設定
* git remote -v

查看遠端分支 
*  git remote --all

新增檔案在本機暫存區(從工作區存到暫存區)
* git add .
* git commit -m "message"

確認工作區的狀態
* git status

* git commit -m "message"

* git remote add origin path

path="https://github.com/LanceRabbit/my-page"

將已確認的檔案上傳到遠端版控
* git push -u origin master


> -u 是 --set-upstream 的縮寫，意即是「設定上游」。也就是說，這個參數會讓本地的 master 和 origin 從此有一個上下游的關係，以後只要輸入 git push，就會自動把本地的 master 推送到遠端的 origin。


### git log
```shell=
git log

git log --oneline
git log --oneline --graph --all

git log --graph --pretty=oneline --abbrev-commit


git log --all --grep='hotfix'

# 重寫log紀錄 (上一次commit紀錄，尚未push)
git commit --amend
```

> --oneline 是把 commit 資訊整理成一行的副指令。至於 HEAD 是目前分支最新的 commit，由於目前位在 master，所以 HEAD 指向 master。

### 若檔案有關聯其他project，其關聯project有更新時，要進行同步更新
git submodule update

### git branch 

```shell
#列出所有版本
[~/git-demo] $ git branch -a
* master
  remotes/origin/master
# 切換分支
git checkout feature/a
# 推送分支到遠端
git push origin feature/a  
#重新命名分支
git branch -m feature/a feature/abc  

#刪除分支
#要刪除 feature/a，需要先 切換到其他分支
git branch -d feature/a

#合併分支流程 切回master
git checkout master
#執行合併
git merge feature/a
```
> * -m 是 --move 的縮寫，後面依序加上原本的分支名稱，和新的名稱。
> * 若有需要刪除 feature/b 分支的情況，可以使用 -d 這個副指令，這是 --delete 的縮寫
> * 若遠端上有新內容，就不能使用 -d 來刪除，需要使用 -D

### git pull/fetch
* 能使用 git pull 來將遠端分支下載至本地
* 認識 git pull 和 git fetch 與 git merge 的關係
* 能夠使用 git fetch 來抓取遠端分支的資訊

上傳檔案到遠端
git push origin feature/a

git push origin master


### 暫存檔案
> 功能開發到一半，被緊急"插件"時，需要將開發中的檔案先暫存起來，等後續處理完插件再繼續開發

```shell=
#暫存已開發的檔案
git stash

#切回原開發的branch後 講暫存檔案倒出來繼續開發
git stash pop
```



### git rebase
另外一種方式，使用rebase去介接branch的commit到主幹(development)上
這邊就不同於merge會再長出一個節點，所以使用上要特別注意...別蓋到別人的commit

```shell=
# 先從分支切回主幹上
$ git checkout development
# 確保目前已更新到最新的commit
$ git pull 
# 切回分支上
$ git checkout branch_name
# 與development進行rebase
$ git rebase development
# 成功rebase訊息
First, rewinding head to replay your work on top of it...
Applying: adjust the contact list of row size
Applying: modify edit contact typesetting
Applying: using map method for init contacts_detail
# push到remote, -f :
$ git push --set-upstream origin branch_name -f

### 若要重新操作, 補救
# 回到 rebase 前的 HEAD
$ git reset --hard ORIG_HEAD 

# 或是用reflog找rebase之前的commit id
$ git reflog
$ git reset --hard xxxxx[commit id] 
```


### git diff

| 指令                | Result |
| ------------------- | -------- |
| git diff：          | 沒有顯示任何結果，因為 Staging Area 與 Working Area 的內容更動一樣    |
| git diff --cached： | 顯示目前在 Staging Area 與 Git Repository 的內容更動差異   |
| git diff HEAD：     | 結果同上，顯示目前在 Working Area 與 Git Repository 的內容更動差異 |


### git reset

| 模式 | 指令 | 內容更動會保留在不同階段的差異 |
| -------- | -------- | -------- |
| mixed    | git reset commitcode     | 當前內容在還原後會保留在 Working Area     |
| soft     | git reset --soft commitcode     | 當前內容在還原後會保留在 Staging Area 和 Working Area     |
| hard     | git reset --hard commitcode     | 當前內容不會保留而是被捨棄，還原回指定節點的內容     |


檔案還原： git reset --hard HEAD

#### 修正commit案例
發現有一個commit 改錯了且已push到遠端(github)

為了修正這一段commit 退版到沒問題的版號

退版： git reset --hard HEAD^

接著同步遠端也相同版號：git push <分支名稱> --force

確認遠端同步狀況. 


> 指定版號後，後續的commit皆會被刪除 :fire:
> --force 因節點有修改，要重新調整節點位置


#### 還原單檔

git checkout HEAD \-\- src/123.txt
> \-\- 代表後面參數皆為檔案名

### git patch

```shell=
# 搭配 git diff 產生patch檔案
[$] <git:(development)> git diff > xxx.patch
# 匯入patch檔案
[$] <git:(development)> git apply xxx.patch
```


## git PR
```shell=
#先fork專案到自己的github上，再進行clone
git clone 
# 建立分支
git checkout -b feature/web-client
# 推送分支到原project的遠端
git push --set-upstream origin  feature/web-client
```


# Git Flow
> Ｇit flow為開發流程的一種控管模式，避免各自commit造成版控的災難發生
## git release

```shell=
# local更新到最新
# 切到master進行 release
[$] <git:(master)> git flow release start v9.43.001
# 會自動切換到版本，release 為 develop最新版，因此不需額外進行動作
# 直接執行finish
[$] <git:(release/v9.43.001)> git flow release finish 'v9.43.001'

# 發佈到遠端
[$] <git:(master)> git push
# tag新版本
[$] <git:(master)> git push --tags
Counting objects: 1, done.
Writing objects: 100% (1/1), 194 bytes | 97.00 KiB/s, done.
Total 1 (delta 0), reused 0 (delta 0)
To https://github.com/project/project.git
 * [new tag]             v9.43.001 -> v9.43.001
```

## git hotfix

```shell=
# master/development 皆更新到最新
# 切到master進行 hotfix
# 確認最新版本號
[$] <git:(master)> git tag -l
# 最先版本號增加一碼
[$] <git:(master)> git flow hotfix start v9.43.005
# 確定修正檔案後, finish
[$] <git:(hotfix/v9.43.005)> git flow hotfix finish v9.43.005

# 發佈到遠端
[$] <git:(master)> git push
[$] <git:(development)> git push
# tag新版本
[$] <git:(development)> git push --tags
```