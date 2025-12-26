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
        # 1. Merge basic params
        base_params = merged_params(user_params)
        
        # 2. Resolve derived parameters (e.g. HardwareCount = D > 600 ? 6 : 4)
        full_params = resolve_derived_params(base_params)

        parts_def = @schema['parts']
        
        calculated_parts = []

        parts_def.each do |part_def|
          part_data = part_def.clone
          
          # Calculate dimensions and position
          ['width', 'depth', 'height', 'pos_x', 'pos_y', 'pos_z'].each do |key|
            formula = part_def[key].to_s
            val = evaluate_formula(formula, full_params)
            part_data[key] = val
          end

          # Also evaluate custom attributes if they exist
          if part_def['attributes']
            part_data['attributes'] = {}
            part_def['attributes'].each do |k, v|
              part_data['attributes'][k] = evaluate_formula(v.to_s, full_params)
            end
          end

          calculated_parts << part_data
        end

        calculated_parts
      end

      # Expose full params resolution for external use
      def resolve_full_params(user_params = {})
        base = merged_params(user_params)
        resolve_derived_params(base)
      end

      private

      def resolve_derived_params(base_params)
        derived_defs = @schema['derived_params'] || {}
        final_params = base_params.clone

        # Iterate simple hash. 
        # Note: If derived params depend on OTHER derived params, we need topological sort or multi-pass.
        # For MVP, we assume derived params only depend on base_params.
        derived_defs.each do |key, formula|
          val = evaluate_formula(formula, base_params)
          final_params[key] = val
        end
        final_params
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
