# 工作清單：參數化櫃體系統 (Task Checklist: Parametric Cabinet System)

- [/] **第一階段：專案設置與核心結構** (優先級：高)
  - [x] 建立目錄結構 (`src/`, `resources/`, `test/`) <!-- id: 0 -->
  - [x] 實作 `loader.rb` 以註冊 Extension <!-- id: 1 -->
  - [x] 定義 `standard_cabinet.json` Schema <!-- id: 2 -->

- [/] **第二階段：核心引擎實作** (優先級：高)
  - [x] 實作 `CabinetEngine` 類別以解析 JSON 並評估公式 <!-- id: 3 -->
  - [x] 實作 `GeometryBuilder` 從零件列表繪製 3D 幾何 <!-- id: 4 -->
    - [x] 處理面板建立（寬度、高度、厚度）
    - [x] 處理定位
    - [x] 處理「視覺詐欺」(背板重疊)

- [/] **第三階段：材質與 UV 系統** (優先級：中)
  - [x] 實作 `MaterialHandler` <!-- id: 5 -->
  - [x] 實作邏輯：若 `grain: vertical`，則旋轉 UV

- [ ] **第四階段：五金邏輯** (優先級：中)
  - [ ] 實作深度檢查以計算五金數量 (Depth > 600 ? 6 : 4) <!-- id: 6 -->

- [ ] **第五階段：MVP 驗證** (優先級：高)
  - [ ] 邏輯測試：使用範例輸入執行 `CabinetEngine` <!-- id: 7 -->
  - [ ] 整合測試：在 SketchUp 中載入並生成櫃體 <!-- id: 8 -->
