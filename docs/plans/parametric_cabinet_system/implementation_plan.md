# 參數化櫃體系統實作計畫 (Parametric Cabinet System Implementation Plan)

## 目標描述 (Goal Description)
開發一個 SketchUp 擴充功能，用於基於「數據驅動 (Data-Driven)」架構生成參數化櫃體。核心邏輯依賴通用的 Ruby 引擎來解釋定義櫃體規則、尺寸和零件的 JSON schema，而不是硬編碼幾何邏輯。

## 使用者審查需求 (User Review Required)
> [!IMPORTANT]
> **技術堆疊假設**：我們假設使用標準 SketchUp Ruby API。對於 UI，MVP 階段將從簡單的 Ruby 控制台/選單載入器開始。除非另有說明，否則複雜的 WebDialog/HtmlDialog 介面將保留給未來階段。

## 建議變更 (Proposed Changes)

### 核心系統 (Core System)
#### [NEW] [loader.rb](file:///c:/code/sketchup/ParametricCabinet.rb)
- 擴充功能的進入點。
- 在 SketchUp 中註冊擴充功能。

#### [NEW] [cabinet_engine.rb](file:///c:/code/sketchup/ParametricCabinet/core/cabinet_engine.rb)
- 系統的大腦。
- 解析 JSON 輸入。
- 評估字串公式（例如：`"W - 2*T"`）。

#### [NEW] [geometry_builder.rb](file:///c:/code/sketchup/ParametricCabinet/core/geometry_builder.rb)
- 與 SketchUp API (`Sketchup::Entities`) 互動。
- 建立面並推拉 (push/pull) 出厚度。
- 處理元件建立與命名。
- 實作「視覺詐欺 (Visual Fraud)」背板（重疊而非布林運算）。

#### [NEW] [material_handler.rb](file:///c:/code/sketchup/ParametricCabinet/core/material_handler.rb)
- 管理材質指派。
- 實作 UV 的「約定優於配置 (Convention over Configuration)」（預設橫向，垂直時旋轉 90 度）。

### 資料結構 (Data Structure)
#### [NEW] [standard_cabinet.json](file:///c:/code/sketchup/ParametricCabinet/resources/schemas/standard_cabinet.json)
- 定義標準櫃體的範例 JSON，包含：
  - Meta (名稱等)
  - Params (W, D, H, 板厚)
  - Parts (側板, 頂/底板, 背板, 門片) 及其尺寸公式。

## 驗證計畫 (Verification Plan)

### 自動化測試 (Automated Tests)
- Ruby 單元測試（若有測試框架），驗證公式解析邏輯（如 `100 - 18*2` == `64`）。

### 手動驗證 (Manual Verification)
1. **載入擴充功能**：啟動 SketchUp，確保擴充功能已載入。
2. **生成標準櫃體**：執行指令生成預設櫃體。
   - 驗證尺寸是否符合 W/D/H。
   - 驗證結構：側板包底板 (Construction Logic)。
   - 驗證背板：應重疊側板 (Visual Fraud)，而非切割它們。
3. **調整尺寸**：在 JSON 中更改 W/D/H 參數並重新生成。
4. **紋理**：套用木紋材質。檢查「垂直」零件是否已旋轉 UV。
