module ParametricCabinet
  module Core
    class PlacementTool
      
      def initialize(cabinet_engine, default_params)
        @engine = cabinet_engine
        @params = default_params
        @model = Sketchup.active_model
        @cursor_point = Geom::Point3d.new(0, 0, 0)
        
        # 預覽元件定義 (避免每次繪製重算)
        @ghost_definition = nil
        @ghost_group = nil
      end

      def activate
        puts "Placement Tool Activated"
        create_ghost_geometry
      end

      def deactivate
        # 清除幽靈預覽
        if @ghost_group && @ghost_group.valid?
          @ghost_group.erase! 
        end
        puts "Placement Tool Deactivated"
      end

      def onMouseMove(flags, x, y, view)
        # 1. 射線檢測 (Raycast) 找地板或牆面
        input_point = view.inputpoint(x, y)
        @cursor_point = input_point.position

        # 2. 智慧吸附 (Smart Snapping)
        # 檢查 Face Normal，自動旋轉
        face = input_point.face
        if face
          normal = face.normal
          # 簡單邏輯：若法線朝 X，則旋轉櫃子
          # 這裡需要更複雜的矩陣運算來對齊牆面
          # MVP: 僅吸附位置
        end

        # 3. 更新幽靈位置
        update_ghost_position(@cursor_point, normal)
        
        view.invalidate # 重繪
      end

      def onLButtonDown(flags, x, y, view)
        # 確認放置
        place_cabinet
        
        # 放置後重設預覽或結束工具?
        # 通常是連續放置
      end

      private

      def create_ghost_geometry
        # 建立一個暫時的 Group 作為幽靈
        # 使用 Wireframe 或半透明材質
        
        # 這裡為了效能，可以只畫 bounding box
        # 或者呼叫 GeometryBuilder 生成一次幾何，然後變成ComponentDef
        
        # MVP: 簡化為線框盒
        @ghost_group = @model.active_entities.add_group
        w = @params['W'].to_f.mm
        d = @params['D'].to_f.mm
        h = @params['H'].to_f.mm
        
        # 繪製線框
        pts = [
          [0,0,0], [w,0,0], [w,d,0], [0,d,0], [0,0,0],
          [0,0,h], [w,0,h], [w,d,h], [0,d,h], [0,0,h]
        ]
        # ...連接頂點...
        # 簡單起見，直接畫一個半透明方塊代表量體
        face = @ghost_group.entities.add_face([0,0,0], [w,0,0], [w,d,0], [0,d,0])
        face.pushpull(h)
        @ghost_group.material = "blue"
        @ghost_group.material.alpha = 0.3
      end

      def update_ghost_position(point, normal)
        return unless @ghost_group && @ghost_group.valid?
        
        # 移動到游標位置
        tr = Geom::Transformation.translation(point)
        
        # 若有法線，旋轉
        # tr_rot = ...
        
        @ghost_group.transformation = tr
      end

      def place_cabinet
        # 呼叫 GeometryBuilder 在當前位置生成真實櫃子
        # 這裡重複利用 Main 的邏輯，或者重構 Main 呼叫這裡
        
        # 為了示範，我們直接呼叫 Builder
        builder = GeometryBuilder.new
        parts = @engine.calculate_parts(@params)
        
        # 鎖入 Undo
        @model.start_operation('Place Cabinet', true)
        group = builder.build(parts, @engine.resolve_full_params(@params))
        
        # 移動到最後確認的位置
        group.transform!(Geom::Transformation.translation(@cursor_point))
        
        @model.commit_operation
      end

    end
  end
end
