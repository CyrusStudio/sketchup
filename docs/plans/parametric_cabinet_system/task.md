# 工作清單：參數化櫃體系統 (Task Checklist: Parametric Cabinet System)

- [x] **第一階段：專案設置與核心結構** (優先級：高)
  - [x] 建立目錄結構 (`src/`, `resources/`, `test/`) <!-- id: 0 -->
  - [x] 實作 `loader.rb` 以註冊 Extension <!-- id: 1 -->
  - [x] 定義 `standard_cabinet.json` Schema <!-- id: 2 -->

- [x] **第二階段：核心引擎實作** (優先級：高)
  - [x] 實作 `CabinetEngine` 類別以解析 JSON <!-- id: 3 -->
  - [x] 實作 `GeometryBuilder` 繪製 3D 幾何 <!-- id: 4 -->
    - [x] 處理面板建立
    - [x] 處理定位
    - [x] 處理「視覺詐欺」(背板重疊)

- [x] **第三階段：材質與 UV 系統** (優先級：中)
  - [x] 實作 `MaterialHandler` <!-- id: 5 -->
  - [x] 實作垂直紋理 UV 旋轉邏輯

- [x] **第四階段：五金邏輯** (優先級：中)
  - [x] 實作 `derived_params` 支援 <!-- id: 6 -->
  - [x] 實作五金數量公式 (Depth > 600 ? 6 : 4)

- [/] **第五階段：互動配置體驗 (UX & Placement)** (優先級：高)
  - [ ] 實作 `PlacementTool` <!-- id: 9 -->
  - [ ] 實作「幽靈預覽 (Ghost)」功能 <!-- id: 10 -->
  - [ ] 實作「智慧吸附 (Smart Snapping)」(牆面/鄰居) <!-- id: 11 -->

- [ ] **第六階段：報價與數據 (Quotation)** (優先級：低)
  - [ ] 實作屬性寫入 (AttributeDictionary) <!-- id: 12 -->
