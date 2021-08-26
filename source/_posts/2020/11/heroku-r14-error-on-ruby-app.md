---
title: Heroku R14 Error with Ruby on Rails app
date: 2020-11-09 23:48:50
tags: ["heroku", "ruby", "R14", "memory bloat"]
---

## 緣由

這次開發維護的專案是使用 Heroku 作為運行服務的平台, 近期遇到了 <a href="https://devcenter.heroku.com/articles/error-codes#r14-memory-quota-exceeded" rel="nofollow noopener noreferrer" target="_blank">R14 - Memory quota exceeded</a> 這個問題.

<!--more-->

## 以為是 Memory Leak

一開始以為是這個是 Memory Leak 的情況, 是因為機器的 Memory Usage 的呈現狀況(如下圖1)看起來像是 Memory Leak 造成的.

![production.png](https://github.com/LanceRabbit/LanceRabbit.github.io/blob/source/source/images/202011/prodcution.png?raw=true)
(圖1 - Memory Usage - Production)

一開始先在 Local 確認程式運行狀況, 確認程式的執行有無一次撈取大量資料的動作.

接著在<a href="https://devcenter.heroku.com/" rel="nofollow noopener noreferrer" target="_blank">R14 - Memory Quota Exceeded in Ruby (MRI)</a> 查看相關的問題以及排除. 接著又看到關鍵詞<a href="https://devcenter.heroku.com/articles/ruby-memory-use#memory-leaks" rel="nofollow noopener noreferrer" target="_blank">Memory leaks</a>就整個陷落在要如何找到方法解決 Ruby 的 Memory Leak 泥沼內.

## 最後則確認是 Memory Bloat

這件事一直持續花時間看了一到兩週的時間, 直到搜尋到 Memory Bloat.

造成 Memory bloat 的原因, 是因為記憶體碎片化(Memory Fragmentation).

這邊就簡單說明 Memory Bloat 的造成的原因之一.

一開始記憶體空間都未使用, 應用程式會先請求(allocate) 一些記憶體空間.

但是釋放時間點不同時, 導致記憶體空間被切割成零散的狀況, 導致應用程式需要 allocate 較大的記憶空間時, 出現問題

這個狀況就導致了記憶體空間的浪費.

不同於 Memory leak, Memory bloat 會造成 Memory 使用量瞬間增大, 而 Memory leak 則緩慢增長.

這個部分可以回到圖1, 可以看到機器重啟後, 記憶體被大量 allocate 掉一大部分.

後來朝著這個方向去找相關資訊, 就找到了 Heroku 提供的 <a href="https://devcenter.heroku.com/articles/tuning-glibc-memory-behavior#when-to-tune-malloc_arena_max" rel="nofollow noopener noreferrer" target="_blank">malloc_arena_max</a>
這個解決方式.

## 設定參數 MALLOC_ARENA_MAX 流程

先確認機器是否有設定 `MALLOC_ARENA_MAX`

```shell
$ heroku run bash -a app_name
~$ env | grep MALLOC_ARENA_MAX
```

若沒有設定的話, 就用以下方式設定. 設定之後機器會自動重啟

```shell
heroku config:set MALLOC_ARENA_MAX=2 -a app_name
```

確認是否有設定到

```shell
$ heroku run bash -a app_name
~$ env | grep MALLOC_ARENA_MAX
MALLOC_ARENA_MAX=2
```

以下是先經過 Staging 機器的設定後的測試狀況, 很明顯設定 `MALLOC_ARENA_MAX` 後, 記憶體的用量並沒有大量瞬間被使用的狀況發生.

![staging.png](https://github.com/LanceRabbit/LanceRabbit.github.io/blob/source/source/images/202011/staging-L.png?raw=true)
(圖2 - Memory Usage - Staging)

## 進階做法

調整 jemalloc, 這部分可以參考<a href="https://www.speedshop.co/2017/12/04/malloc-doubles-ruby-memory.html" rel="nofollow noopener noreferrer" target="_blank">malloc-doubles-ruby-memory</a>這個解決方式.
