# tests/test_engine.rb
# 模擬 SketchUp 環境，因為 Engine 本身依賴 Ruby 標準庫與一些 SketchUp 假設 (但 Engine 主要計算邏輯是純 Ruby)
# 但注意：我們實作的 geometry_builder 依賴 SketchUp API，這裡只測 Logic，不測 Geometry。

require_relative '../ParametricCabinet/core/cabinet_engine'

# 1. 測試初始化
schema_path = File.join(File.dirname(__FILE__), '../ParametricCabinet/resources/schemas/standard_cabinet.json')
puts "Loading schema from: #{schema_path}"

engine = ParametricCabinet::Core::CabinetEngine.new(schema_path)

# 2. 測試預設情況 (D = 580, expects HardwareCount = 4)
puts "\n--- Test Case 1: Default (D=580) ---"
default_parts = engine.calculate_parts({})
back_panel = default_parts.find { |p| p['name'] == 'Back_Panel' }
qty = back_panel['attributes']['HardwareQty']
puts "D=580 => HardwareQty: #{qty}"

if qty == 4
  puts "[PASS] Hardware count is 4 for depth <= 600"
else
  puts "[FAIL] Expected 4, got #{qty}"
end

# 3. 測試深度 > 600 (expects HardwareCount = 6)
puts "\n--- Test Case 2: Deep Cabinet (D=650) ---"
deep_parts = engine.calculate_parts({'D' => 650})
back_panel_deep = deep_parts.find { |p| p['name'] == 'Back_Panel' }
qty_deep = back_panel_deep['attributes']['HardwareQty']
puts "D=650 => HardwareQty: #{qty_deep}"

if qty_deep == 6
  puts "[PASS] Hardware count is 6 for depth > 600"
else
  puts "[FAIL] Expected 6, got #{qty_deep}"
end

# 4. 測試基本公式 W=1000, T=18 => Top_Panel Width should be 1000 - 36 = 964
puts "\n--- Test Case 3: Basic Formula ---"
parts = engine.calculate_parts({'W' => 1000, 'T' => 18})
top = parts.find { |p| p['name'] == 'Top_Panel' }
width = top['width']
puts "W=1000, T=18 => Top Width: #{width}"

if width == 964
  puts "[PASS] Top Width is correctly calculated"
else
  puts "[FAIL] Expected 964, got #{width}"
end
