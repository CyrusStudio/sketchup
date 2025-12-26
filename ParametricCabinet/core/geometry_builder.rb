module ParametricCabinet
  module Core
    class GeometryBuilder
      
      def initialize
        @model = Sketchup.active_model
        @definitions = @model.definitions
        require_relative 'material_handler'
        @mat_handler = MaterialHandler.new
      end

      # parts_data: 來自 Engine 的 Hash 陣列
      # global_params: 所有參數 Hash (保留上下文用)
      def build(parts_data, global_params)
        # 為整個櫃子建立容器群組
        cabinet_group = @model.active_entities.add_group
        cabinet_group.name = global_params['Name'] || "Parametric Cabinet"
        
        # 新增屬性以供「再編輯機制」使用 (Requirement: 1.2.9 re-edit mechanism)
        dict = cabinet_group.attribute_dictionary("ParametricCabinet", true)
        global_params.each { |k, v| dict[k] = v }

        parts_data.each do |part|
          create_part(cabinet_group, part)
        end
      end

      private

      def create_part(parent_group, part_data)
        w = part_data['width'].mm
        d = part_data['depth'].mm
        h = part_data['height'].mm
        
        # 位置
        x = part_data['pos_x'].mm
        y = part_data['pos_y'].mm
        z = part_data['pos_z'].mm

        # 建立幾何群組
        part_group = parent_group.entities.add_group
        part_group.name = part_data['name']
        
        # 標記/圖層? (可選)
        
        # 建立方塊 (Create Box)
        # 繪製底面
        # 我們在元件內部的 0,0,0 繪製，然後移動實體 (Instance)? 
        # 或者直接在地點繪製? 對於簡單群組，直接原地繪製較容易。
        
        # 定義底面的 4 個點
        pts = [
          [0, 0, 0],
          [w, 0, 0],
          [w, d, 0],
          [0, d, 0]
        ]
        
        face = part_group.entities.add_face(pts)
        face.pushpull(h) # 推拉至高度

        # 移動到正確位置
        tr = Geom::Transformation.translation(Geom::Vector3d.new(x, y, z))
        part_group.transform!(tr)

        # 套用屬性
        part_group.set_attribute("ParametricPart", "role", part_data['role'])
        
        # 套用材質 / UV 邏輯 (約定優於配置)
        @mat_handler.apply_material(part_group, part_data)
      end

    end
  end
end
