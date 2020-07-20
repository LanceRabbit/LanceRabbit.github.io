---
title: 如何在 Rails 中 使用 Arel sql
date: 2020-07-19 23:27:08
tags: ["arel_table", "rails", "arel"]
---

本篇文章主要是在說明如何在 Rails 中 使用 `Arel` 來做資料查詢, 以及解釋為何要使用 Arel 來操作的原因

使用的開發環境設置如下:

- Rails: `6.0.3`
- Ruby: `2.7.1`

<!--more-->

## Arel sql

<a href="https://github.com/rails/arel" rel="nofollow noopener noreferrer" target="_blank">Arel</a> (A Relational Algebra) 是 Ruby 的一種 SQL 抽象語法樹（Abstract Syntax Tree-like, AST）管理器, 允許開發者可以在 Rails 中寫複雜的 SQL 查詢語法.


## 為何使用 Arel sql

為了節省不必要的資料撈取, 我們可能會在 Rails 中使用 `pluck` 的方式, 來選取需要的欄位資料.

```ruby
Task.all.pluck([:id, :title])
```

但在執行時, 會在 console 中看到了以下的警示訊息. 雖然資料正常的撈取回來, 並且不影響程式執行.

```shell
DEPRECATION WARNING: Dangerous query method (method whose arguments are used as raw SQL) called with non-attribute
argument(s):  [:id, :title]. Non-attribute arguments will be disallowed in Rails 6.1.
This method should not be called with user-provided values, such as request parameters or model attributes.
Known-safe values can be passed by wrapping them in Arel.sql(). (called from irb_binding at (irb):35)
```

為何會出現這個訊息呢? 原來是 <a href="https://github.com/rails/rails/pull/27947/files" rel="nofollow noopener noreferrer" target="_blank">Rails</a> 已經在版本 5.2 時, 就將部分的 `raw sql` 的查詢方式列為有潛在風險.

會在開發者使用時提醒開發者, 這樣的方式是存在著潛在的 `SQL Injection` 的風險, 並且建議使用 `Arel sql` 的方式來進行資料檢索.

另外, 提示訊息中也有補充說明到, 在 Rails 6.1 版本時, 這樣的操作方式可能就會無法執行.

> 什麼樣的 ActiveRecord 的操作方法會造成的 `SQL Injection`,  詳情可以參閱 <a href="https://rails-sqli.org/" rel="nofollow noopener noreferrer" target="_blank">Rails SQL Injection Examples</a>

## 使用 Arel sql 檢索資料

在 Rails 中, 可以使用兩種方式來做資料查詢.

第一種是直接透過 `Arel.sql` 的方式來指定所需要的欄位

```ruby
Task.all.pluck(Arel.sql('id, title'))

```

第二種是使用 `arel_table` 的方式來查詢資料.

```ruby
table = Task.arel_table
Task.all.pluck(table[:id], table[:title])
```

若要在 Model 中來使用的話, 可以參考以下的方式, 在 scope 中直接使用 `arel_table` 來操作查詢.

```ruby
class Task < ApplicationRecord
  scope :get_id_title, -> { pluck(arel_table[:id], arel_table[:title]) }
end
```

### Arel 其他操作方式

舉例, 如果要找尋任務開始日期為 `2020-07-14` 之後的搜尋條件, 可能會使用以下的操作方式.

```ruby
Task.where("start_date >= ?", Date.parse('2020-07-14'))

# or

Task.where(start_date: Date.parse('2020-07-14')..Float::INFINITY)
```

而 Arel 提供許多方式, 可以方便地來進行資料檢索.

這邊就可以改用 `arel_table` 來進行欄位條件設定.

```ruby
table = Task.arel_table
Task.where(table[:start_date].gteq(Date.parse('2020-07-14')))
```

Arel 提供多少方式可以來進行檢索, 這邊可以參考 <a href="https://qiita.com/akicho8/items/c3bfd39213d6e9843e4f" rel="nofollow noopener noreferrer" target="_blank">arel_table 的檢索條件</a>.

### 使用 Arel 轉換 SQL 複雜的搜尋

這邊用一個簡單的情境來做說明如何使用 `arel_table` 來做複雜搜尋

情境: 使用者有很多任務, 且任務可以標記很多標籤, 而 Model 關聯設定如下.

```ruby
class User < ApplicationRecord
  has_many :tasks
end

class Task < ApplicationRecord
  belongs_to :user
  has_many :taggings
  has_many :tags, through: :taggings
end

class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :task
end

class Tag < ApplicationRecord
  has_many :taggings
  has_many :tasks, through: :taggings
end

```

假設管理者想知道所有使用者的任務, 從任務開始日 `2020-07-14` 的所有任務中, 總共使用了多次標籤.

這邊就會考慮先用 ras sql 來確認資料結構.

```sql
SELECT
  USERS.*,
  TOTAL_TAGGINGS.TAGGINGS_COUNT
FROM
  "USERS"
INNER JOIN (
  SELECT
	  "TASKS"."USER_ID",
	  COUNT("TAGGINGS"."TAG_ID") AS TAGGINGS_COUNT
  FROM "TASKS"
  INNER JOIN "TAGGINGS"
  ON "TASKS"."ID" = "TAGGINGS"."TASK_ID"
  AND "TASKS"."START_DATE" >= '2020-06-25'
  GROUP BY "TASKS"."USER_ID"
) TOTAL_TAGGINGS
ON "USERS"."ID" = TOTAL_TAGGINGS."USER_ID"
ORDER BY TOTAL_TAGGINGS.TAGGINGS_COUNT DESC
```

接著再開始使用 `arel_table` 轉換上述的 `raw sql` 語法.

轉換的流程這邊會以由內而外的方式, 將整段 SQL 語法作轉換處理.

因此, 先看到內部的 JOIN 語法, Task 與 Tagging 除了 JOIN 之外, 還有設定日期條件以及 GROUP BY 的方式.

```ruby
INNER JOIN (
  SELECT
	  "TASKS"."USER_ID",
	  COUNT("TAGGINGS"."TAG_ID") AS TAGGINGS_COUNT
  FROM "TASKS"
  INNER JOIN "TAGGINGS"
  ON "TASKS"."ID" = "TAGGINGS"."TASK_ID"
  AND "TASKS"."START_DATE" >= '2020-06-25'
  GROUP BY "TASKS"."USER_ID"
) TOTAL_TAGGINGS
```

因此, 這邊只需要用到 Task 與 Tagging 的 Model, 透過相對應的語法來做轉換.

而 `.project` 代表的是撈取得欄位, `.as` 則代表命名一個名稱, 後續就改使用這個名稱做應用

```ruby
  def total_taggings
    @total_taggings ||= begin
      tasks = Task.arel_table
      taggings = Tagging.arel_table
      tasks.join(taggings).on(tasks[:id].eq(taggings[:task_id])
                              .and(tasks[:start_date].gteq(Date.parse(start_date))))
            .project(tasks[:user_id], taggings[:tag_id].count.as('taggings_count'))
            .group(tasks[:user_id])
            .as('total_taggings')
    end
  end

```

接著再透過上面已經處理好的對應結構與 User 來做 JOIN.

`.join_sources` 轉換為對應的 join 語句, 因後續會與 User 做 `joins` (ActiveRecod 的方法), 這邊需要透過這個方法做轉換.

主要是因為未使用 `join_sources` 之前的內容結構都是為 Arel Table 的結構, 因此要與 ActiveRecord 使用時,

```ruby
  def join_clause
    @join_clause ||= begin
      users = User.arel_table
      users.join(total_taggings).on(users[:id].eq(total_taggings[:user_id])).join_sources
    end
  end

```

接著將所有轉換的語法搭配 User 串接使用. 整個完整的轉換內容如下.

```ruby
# frozen_string_literal: true
class UserTaggings < Struct.new(:start_date)
  def fetch
    User.joins(join_clause)
      .select('users.*, total_taggings.taggings_count')
      .order('total_taggings.taggings_count DESC')
  end

  private

  def join_clause
    @join_clause ||= begin
      users = User.arel_table
      users.join(total_taggings).on(users[:id].eq(total_taggings[:user_id])).join_sources
    end
  end

  def total_taggings
    @total_taggings ||= begin
      tasks = Task.arel_table
      taggings = Tagging.arel_table
      tasks.join(taggings).on(tasks[:id].eq(taggings[:task_id])
                              .and(tasks[:start_date].gteq(Date.parse(start_date))))
            .project(tasks[:user_id], taggings[:tag_id].count.as('taggings_count'))
            .group(tasks[:user_id])
            .as('total_taggings')
    end
  end
end

```

要怎麼使用 `UserTaggings`呢? 這邊可以先在 `Rails console` 中, 使用下列方式來做資料查詢.

```ruby
UserTaggings.new('2020-07-14').fetch
```

確認沒問題之後, 後續再應用在程式碼之中吧!

## 總結

運用 `arel_table` 將複雜的 SQL 拆解成程式碼, 主要目的是為了降低與 `raw sql` 的耦合, 且可以配合單元測試進行驗證.

未來在因需求調整時, 也可以方便擴充使用. 而不在只是字串(String) 到處串來串去.

當然也是有缺點, 就是查詢語法相當複雜的時候, 要使用 Arel 的話會非常費時. 且可能程式碼的複雜度會大大提升.

以下列出使用 Arel sql 的優缺點比較, 提供給大家做參考.

優點

- 使用 Ruby 語法, 而不是 String
- 可重複使用 Arel 的表達式
- 容易撰寫測試程式進行驗證

缺點

- 比較難閱讀
- 冗余的程式碼
- 出錯時不容易 debugging

## 參考資料

1. <a href="https://www.gapintelligence.com/blog/how-to-build-complex-queries-using-arel/" rel="nofollow noopener noreferrer" target="_blank">How to build complex queries using Arel - gap intelligence</a>

2. <a href="http://danshultz.github.io/talks/mastering_activerecord_arel/#/" rel="nofollow noopener noreferrer" target="_blank">Mastering ActiveRecord and Arel</a>

3. <a href="https://rails-sqli.org/" rel="nofollow noopener noreferrer" target="_blank">Rails SQL Injection Examples</a>

4. <a href="https://qiita.com/akicho8/items/c3bfd39213d6e9843e4f" rel="nofollow noopener noreferrer" target="_blank">arel_table 的檢索條件</a>
