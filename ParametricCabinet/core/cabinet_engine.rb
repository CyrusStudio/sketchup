require 'json'

module ParametricCabinet
  module Core
    class CabinetEngine
      attr_reader :schema, :default_params

      def initialize(schema_path)
        file_content = File.read(schema_path)
        @schema = JSON.parse(file_content)
        @default_params = @schema['default_params'] || {}
      end

      # 合併使用者參數與預設值，並盡可能轉換為浮點數
      # (Merges user params with defaults and converts to Float where possible)
      def merged_params(user_params = {})
        # 從預設值開始
        combined = @default_params.clone
        
        # 合併使用者參數
        user_params.each do |k, v|
          combined[k] = v
        end

        # 確保數值類型正確
        combined.transform_values! do |v|
          # 如果字串看起來像數字則轉換，否則保留
          begin
            Float(v)
          rescue
            v
          end
        end
        combined
      end

      def calculate_parts(user_params = {})
        params = merged_params(user_params)
        parts_def = @schema['parts']
        
        calculated_parts = []

        parts_def.each do |part_def|
          part_data = part_def.clone
          
          # 計算尺寸與位置
          ['width', 'depth', 'height', 'pos_x', 'pos_y', 'pos_z'].each do |key|
            formula = part_def[key].to_s
            val = evaluate_formula(formula, params)
            part_data[key] = val
          end

          calculated_parts << part_data
        end

        calculated_parts
      end

      private

      def evaluate_formula(formula, params)
        # 1. 將變數替換為數值
        # 依長度降序排序鍵，避免部分替換（例如有 "ToeH" 與 "T" 時，避免 "ToeH" 被替換成 "ValueoeH"）
        sorted_keys = params.keys.sort_by { |k| -k.length }
        
        expression = formula.clone
        sorted_keys.each do |key|
          val = params[key]
          # Regex 匹配完整單字以避免部分替換
          expression.gsub!(/\b#{key}\b/, val.to_s)
        end

        # 2. 評估 (Evaluate)
        begin
          # MVP 階段直接使用 eval。"Ruby 作為通用引擎"。
          result = eval(expression)
          return result.to_f
        rescue => e
          puts "Formula Error: #{formula} -> #{expression} : #{e.message}"
          return 0.0
        end
      end

    end
  end
end
