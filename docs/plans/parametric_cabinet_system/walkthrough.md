# 參數化櫃體系統 - 使用說明 (Walkthrough)

本專案實作了一個基於 SketchUp Ruby API 的參數化櫃體生成系統。系統核心採用「數據驅動 (Data-Driven)」架構，透過 JSON Schema 定義櫃體規則，而非硬編碼幾何邏輯。

## 📥 安裝步驟

1. **定位插件目錄**：
   - Windows: `C:\Users\[Username]\AppData\Roaming\SketchUp\SketchUp [Version]\SketchUp\Plugins`
   - Mac: `~/Library/Application Support/SketchUp [Version]/SketchUp/Plugins`

2. **複製檔案**：
   將本專案中的以下內容複製到 Plugins 目錄：
   - `ParametricCabinet.rb` (檔案)
   - `ParametricCabinet/` (資料夾)

3. **啟動 SketchUp**：
   開啟 SketchUp，若安裝成功，應會在擴充功能管理員中看到 "Parametric Cabinet System"。

## 🚀 功能測試

### 1. 生成標準櫃體 (Standard Generation)
- **路徑**：`Extensions` > `Parametric Cabinet` > `Generate Standard Cabinet`
- **行為**：
  - 系統將讀取 `resources/schemas/standard_cabinet.json`。
  - 在原點 (0,0,0) 生成一個標準尺寸的櫃子。
  - **驗證點**：
    - 檢查背板是否正確「嵌入」側板（視覺詐欺邏輯）。
    - 檢查 Attribute Inspector，確認 Component 上有 `ParametricCabinet` 屬性字典。

### 2. 互動式配置 (Interactive Placement)
- **路徑**：`Extensions` > `Parametric Cabinet` > `Interactive Place Tool`
- **行為**：
  - 啟動工具後，滑鼠游標會出現一個半透明的藍色「幽靈方塊 (Ghost Box)」。
  - 移動滑鼠，方塊會跟隨游標。
  - **點擊左鍵**：在當前位置生成實體櫃子。
  - **驗證點**：
    - 確認幽靈方塊尺寸正確。
    - 確認點擊後櫃子生成位置與預覽一致。

### 3. 五金邏輯驗證 (Hardware Logic)
- **邏輯**：當深度 `D > 600` 時，五金數量應為 6，否則為 4。
- **測試方法**：
  1. 修改 `standard_cabinet.json`，將 `D` 改為 `650`。
  2. 重新執行生成。
  3. 檢查背板元件的 `HardwareQty` 屬性（需透過測試腳本或 Attribute Inspector Plugin 檢視）。

## 📂 檔案結構導覽

- `ParametricCabinet.rb`: 擴充功能註冊檔。
- `ParametricCabinet/`
  - `main.rb`: 選單與主要邏輯入口。
  - `core/`
    - `cabinet_engine.rb`: **[核心]** JSON 解析與公式運算引擎。
    - `geometry_builder.rb`: **[核心]** SketchUp API 幾何生成器。
    - `placement_tool.rb`: 互動式放置工具。
    - `material_handler.rb`: 材質與 UV 處理。
  - `resources/schemas/`
    - `standard_cabinet.json`: 櫃體 DNA 定義檔。

## 🛠 未來擴充建議

- **UI 開發**：目前參數由 JSON 控制，未來可開發 `HtmlDialog` 讓使用者在視窗中輸入 W/D/H。
- **更多櫃型**：新增 L 型櫃、轉角櫃的 JSON Schema。
- **BOM 表匯出**：讀取模型的 Attribute Dictionary 並匯出 CSV 報價單。
