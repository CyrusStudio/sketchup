require 'sketchup.rb'
require 'extensions.rb'

module ParametricCabinet
  unless file_loaded?(__FILE__)
    # 註冊擴充功能
    ex = SketchupExtension.new('Parametric Cabinet System', 'ParametricCabinet/main')
    ex.description = 'Generates parametric cabinets based on JSON schemas. (基於 JSON 架構生成參數化櫃體)'
    ex.version = '0.1.0'
    ex.copyright = 'Antigravity 2025'
    ex.creator = 'Antigravity'
    Sketchup.register_extension(ex, true)
    file_loaded(__FILE__)
  end
end
