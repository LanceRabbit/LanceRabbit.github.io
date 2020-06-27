---
title: TGONetworks 導師計畫 - 紀錄與心得
date: 2020-06-26 19:04:22
tags: ["tgonetworks", "taien", "ant"]
---
這個計畫活動, 是在去年 TGONext 所發佈的, 主要是希望透過這個活動可以讓想了解創業/技術/管理相關知識的人,

可以藉有導師的帶領一起討論. 我參與的是的由 Taien Wang 導師帶領的技術架構組(第三組), 主要是探討技術架構相關的議題.

除了的技術架構議題的討論之外, 導師也列出技術架構相關的書籍以及偏向個人內化的心法書籍, 讓大家自行去閱讀.

<!--more-->

所謂的個人心法, 指得是個人的溝通技巧或是管理相關的能力.

這邊列出導師推薦的幾本書籍:

- QBQ問題背後的問題
- 我編程，我快樂
- 軟體架構師的12項修煉
- 大型網站技術架構
- Web容量規劃的藝術
- 佈道之道
- 從技術走向管理-李元芳履職記

## 自我盤點

導師在第二次的聚會時, 讓大家盤點自己的 *職涯/管理/技術*. 藉由這個過程, 檢視自己職涯的目標之外, 也能盤點出自己對於管理的

軟實力以及技術的硬實力的掌握度. 每一位成員在分享的過程中, 導師也會一一的點出哪邊不足或是可以延伸思考的部分.

### 職涯

簡單來說就是對於目前以及職涯的願景. 例如自己目前是前端工程師, 那設定的職涯目標就會是前端資深工程師的技術職

或是需要帶領團隊的主管職.

透過職涯願景所勾勒出的路線圖, 讓自己思考是要朝哪一種目標前進. 舉例來說, 技術職強調的就是技術的深耕以及研究,

而主管職則是側重在團隊的協調以及溝通.

或許有些主管職仍會強調技術, 但比重就相較於技術職沒有來得那麼多. 雖說只是願景, 但仍需要每隔一段時間來做回顧,

來確認自己是否朝著目標在前進.


### 管理

管理, 由於範圍涵蓋很廣. 這邊我用*軟實力 (Soft Skills)* 來做說明, 將範圍限縮在個人身上. 若要深入管理相關的知識,

建議可以參考其他管理學大師的書籍. 舉例來說, 溝通或是跨部門協調等等, 這些軟實力技能,

其實都屬於管理的部分. 而我個人覺得管理這部份, 是需要時時刻刻的持續練習以及學習的.

這邊列出幾項, 管理的相關技能

- 向上/向下/跨部門溝通
- 時程管理
- 任務管理
- 文件管理
- 簡報技巧


### 技術

這邊就依照個人目前的狀況來列出所學以及未來要接觸的技術, 自己對於目前的技術掌握度為何, 以及自己所使用的

程式語言的其他特性是否熟悉. 而如何知道對於程式語言的掌握度, 這邊用 [Ant Yi-Feng Tzeng](https://blog.gcos.me/about/) 大大提供的方式簡單說明.

對於某語言的熟悉度的掌握, 除了懂得該語言的特性之外, 也能列出其語言的缺點超過三項.

除此之外, 能閱讀該程式語言的原始碼, 其實也是提升對程式語言特性的掌握.

而這邊簡單列出以下幾項(以後端為例)的技術:

- Java/C#/Node
- RESTFul API/ gRPC/ GraphQL
- SQL/NoSQL
- Cache, Redis/Memcached
- Load Blance, 延伸探討如何用 Nginx 做 Load blancer
- Design Pattern
- Test (TDD/BDD)
- CI/CD
- Deployment
- Monitor
- Logger

### 個人盤點狀況

下圖則為當時, 我所盤點的技術/管理/職涯目標, 可以看得出來仍要持續努力學習.

![skill.png](https://github.com/LanceRabbit/LanceRabbit.github.io/blob/source/source/images/skill.png?raw=true)

### 自我修煉

經過自我盤點後, 要如何去慢慢提升相關得職能, 除了透過閱讀書籍之外,  Taien 導師提到可以藉由以下方式來做提升.

- 多看
  - 瀏覽開源專案 (Wordpress, OpenCart, phpBB, Sylius),
- 組織管理
  - 參與技術社群, 透過協同合作的方式來學習管理
- 自我挑戰
  - 技術分享(演講), 挑戰 hackathon 的活動

這邊列出 Taien 導師曾發表過的相關技術 slide.

- [Scrum深入淺出](https://www.slideshare.net/taientw/scrum-46413376)
- [成長駭客 Growth Hacker](https://www.slideshare.net/taientw/growth-hacker-63192113)
- [[ModernWeb2019] Taien - 高併發的道與術](https://www.slideshare.net/taientw/modernweb2019-taien-167720096)
- [百人團隊敏捷轉型暨持續性整合與交付實踐](https://www.slideshare.net/taientw/ss-81331444)
- [MOPCON2019-從零建立商業技術團隊](https://www.slideshare.net/taientw/mopcon2019)


## 架構的規劃

系統架構的設計, 除了要根據使用的情境以及要達成的目標來進行規劃以及設計之外.

依照[分層架構模式](https://docs.microsoft.com/en-us/previous-versions/msp-n-p/ee658109(v=pandp.10))的方式來進行評估要如何切分結構.

![分層架構模式](https://docs.microsoft.com/en-us/previous-versions/msp-n-p/images/ee658109.a4691b48-1b2c-4102-984d-4fd1233f369d%28en-us%2cpandp.10%29.png "ref: Microsoft")


由上面的分層架構圖所示, 從最靠近 User 端的分別為 *Presentation Layer*, 這個部分就是屬於與使用者互動的   UI 介面, 例如 App 或是 Web 網站.

而 *Business Layer*, 主要是處理商業邏輯的部分. 以購物車系統為例, 從用戶開始商品選購, 到購物車結帳時的優惠卷選擇,

以及是付款方式得選擇, 最後到結帳完成後的物流配送系統. 整個核心業務流程模組, 就是這一個部分在處理.

*Data Layer* 則是負責處理資料存儲的部分,

軟體分層架構, 每一層只能與上一層和下一層做溝通, 而不能跨層來做溝通. 也就是說 *Presentation Layer* 不應該跨層

與 *Data Layer* 做資料讀取, 而必須透過 *Business Layer* 這一層來存取資料後再提供資料給 *Presentation Layer*.

更多的分層架構可以參考[軟體分層架構模式 \| John Wu's Blog](https://blog.johnwu.cc/article/software-layered-architecture-pattern.html) 有更詳盡的說明.

除了上述提到的架構模式之外, 還要考慮以下幾點

- 擴展性和災難恢復
- 安全性
- 部署, 監測, 警示, 事件管理
- 容量計畫, 成本優化

上述的前三點能透過字面上來知道之外, 第四點的容量計畫與成本優化, 是比較少比較提及的.

簡單舉例, 系統上線運營一段時間後, 可以透過監測系統來觀察資料的增長狀況, 假設資料持續穩定增加, 這邊就會要考量

到資料庫系統的硬碟擴充. 要在何時進行設備擴充, 就會根據監測的狀況來評估時間點, 來做提早準備.

每一項硬體的使用都是成本, 透過監測來檢視每一項設備的使用, 來調優成本使用狀況.

### 系統可靠性

而整體系統的可靠性 (Availabilty), 這部分就是會根據架構設計的目標來做制定, 最常見的就是使用服務等級協議

(Service Level Agreements, SLA) 來提供用戶知道系統整體穩定度.

如何制定 SLA, 這部分就需要考慮到服務等級指標 (Service Level Indicators, SLI) 與 服務等級目標(Service Level Objectives, SLO).

這三者之間關係為 `SLI > SLO > SLA`. 這邊用範例說明之間關係.

範例:
- SLI: Http 請求能夠正常回應(return 200)
- SLO: 95% Http return 200 且 回應時間小於等於 200ms
- SLA: 95%能正常回應, 且回應時間小於等於 300ms

說明:

先為一個系統設定 SLI 的目標為 http 能夠正常回應請求. 而 SLO 則會依據 SLI 來做設定, 例如目標設定

為 95％ 的 http 請求能正常回應, 並且回應時間小於等於 200 毫秒. 而 SLA 則是能夠設定略高或等於 SLO

所設定的目標. 例如 95% 的請求能夠正常回應, 並且回應時間小於等於 300ms.

## 用戶目標

系統的用戶增長框架, 主要是透過這些框架來識別所設計的商業或是產品能夠吸引到正確目標用戶來使用, 進而達成公司的營收.

藉由這樣的框架, 除了能夠讓商業模式或產品的生命週期能持續穩定成長下去之外, 也能夠持續透過這樣的框架來迭代整個系統產品.

這邊列出幾種常見的增長框架.

- AARRR
- RARRA
- Lean Startup
- Customer Development
- Business Model Canvas
- Value Proposition
- Scrum - Most Important is Value

下圖為我依照 `Business Model Canvas` 框架的方式, 來設計出我所身處的影音廣告產業的一個商業模式.

![business.png](https://github.com/LanceRabbit/LanceRabbit.github.io/blob/source/source/images/business.png?raw=true)


## 心得

每一次的討論, 除了 Taien 導師根據大家討論的狀況深入討論之外, 也會分享他過往的經驗來說明每一個技術使用的原因.

除了技術探討使用之外, 也有討論到系統外包其他團隊的作法. 會採用外包專案的原因是, 團隊仍需要運維現有現有系統,

並無人力能在短時間快速開發出實驗性質的方案, 所以要透過外包專案方式, 能在短時間內開發出實驗性方案.

若此方案成效有達到預期(流量或是收益)的話, 才有機會(有那個價值)將專案透過重構的方式導回現有系統.

是快速迭代測試的另外一種方式, 不難看出這邊主要考慮的是開發成本, 而非是現有系統的狀況.

每次聚會所獲得的資訊非常多, 目前也仍在慢慢吸收以及在實務上應用. 透過此次的導師計畫才知道除了要學得知識還有

很多之外, 有機會也要跟多其他人交流分享. 這樣的方式能讓知識能持續傳遞之外, 也會獲得更多不同領域的資訊以及想法.
