module ParametricCabinet
  module Core
    class MaterialHandler
      
      def initialize
      end

      def apply_material(entity, part_data)
        # 需求：約定優於配置 (Requirement: Convention over Configuration)
        # 1. 基於 Role 指派材質 (UI 處理 Role -> Material 映射，這裡僅檢查是否設定)
        # 目前尚未載入材質庫，除非有預設值，否則跳過實際紋理指派。
        
        # 2. UV 邏輯
        # "若 JSON 寫 vertical -> 自動旋轉 UV 90 度。"
        # 假設：零件群組的所有面都需要 UV 調整？
        # 通常檢查最大的面 (前/後/側) 即可。
        
        grain_direction = part_data['grain'] # 'vertical' 或 'horizontal'
        
        if grain_direction == 'vertical' && entity.is_a?(Sketchup::Group)
          rotate_uvs(entity)
        end
      end

      private

      def rotate_uvs(group)
        # 迭代群組中的面
        group.entities.grep(Sketchup::Face).each do |face|
          # 1. 獲取當前 UV 映射
          # 在純 Ruby 中若無指派材質，這一步很複雜。
          # 若無材質，視覺上 UV 不存在。
          # 但我們可以準備座標。
          
          # MVP：僅在已塗材質時套用。
          # 使用 position_material 進行旋轉。
          mat = face.material
          next unless mat && mat.texture

          # 旋轉紋理 90 度
          # 獲取當前映射
          # 這需要複雜的矩陣運算來繞面透過中心點旋轉 UV。
          
          # 簡化：僅旋轉紋理投影？
          # 真實實作需要映射一組新的 UVQ 點。
          
          # 注意：在 SketchUp 中，若希望在 Z 軸較長的面板上呈現「垂直紋理」，
          # 且原始紋理是橫向的，則需要旋轉 90 度。
        end
      end

    end
  end
end
