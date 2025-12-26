require 'sketchup.rb'

module ParametricCabinet
  # 載入核心模組 (Load core modules)
  require_relative 'core/cabinet_engine'
  require_relative 'core/geometry_builder'
  require_relative 'core/material_handler'

  unless file_loaded?(__FILE__)
    menu = UI.menu('Plugins')
    sub_menu = menu.add_submenu('Parametric Cabinet')
    
    # 新增選單項目：生成標準櫃體
    sub_menu.add_item('Generate Standard Cabinet') do
      generate_standard_cabinet
    end
    
    sub_menu.add_item('Interactive Place Tool') do
      activate_place_tool
    end

    file_loaded(__FILE__)
  end

  def self.activate_place_tool
    require_relative 'core/placement_tool'
    model = Sketchup.active_model
    
    # Load defaults
    schema_path = File.join(File.dirname(__FILE__), 'resources', 'schemas', 'standard_cabinet.json')
    engine = Core::CabinetEngine.new(schema_path)
    # Default params
    params = { 'W' => 600, 'D' => 580, 'H' => 2000 }
    
    tool = Core::PlacementTool.new(engine, params)
    model.select_tool(tool)
  end

  def self.generate_standard_cabinet
    model = Sketchup.active_model
    model.start_operation('Generate Cabinet', true)
    
    begin
      # 1. 載入架構 (Load Schema)
      schema_path = File.join(File.dirname(__FILE__), 'resources', 'schemas', 'standard_cabinet.json')
      
      # 2. 初始化引擎 (Initialize Engine)
      engine = Core::CabinetEngine.new(schema_path)
      
      # 3. 計算零件 (Calculate Parts)
      # 這裡可以透過 UI 獲取參數，MVP 階段使用預設值或覆蓋值
      # 假設使用者輸入 W=800, D=600, H=2000
      user_params = { 'W' => 800, 'D' => 600, 'H' => 1800 } 
      parts_data = engine.calculate_parts(user_params)
      
      # 4. 建立幾何 (Build Geometry)
      full_params = engine.merged_params(user_params) # 獲取完整參數以供其他邏輯使用
      builder = Core::GeometryBuilder.new
      builder.build(parts_data, full_params)
      
    rescue => e
      UI.messagebox("Error: #{e.message}\n#{e.backtrace.first}")
    ensure
      model.commit_operation
    end
  end
end
