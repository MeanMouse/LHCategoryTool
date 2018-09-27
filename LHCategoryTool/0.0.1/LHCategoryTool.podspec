
Pod::Spec.new do |s|


  s.name         = "LHCategoryTool"
  s.version      = "0.0.1"
  s.summary      = "LHCategoryTool is foundation category methods"

  s.description  = <<-DESC
                   you can select some category methods of foundation that you want,this methods can help own improve develop quickly
                   DESC

  s.homepage     = "http://gitee.com/meanmouse/LHCategoryTool"
  s.license      = "MIT"

  s.author             = { "MeanMouse" => "1871382624@qq.com" }
 
  s.platform     = :ios, "8.0"

  s.source       = { :git => "http://gitee.com/meanmouse/LHCategoryTool.git", :tag => "0.0.1" }

  s.source_files  = "LHCategoryTool/**/*.{h,m}", "LHCategoryTool/**/*.{h,m}"
 
  s.frameworks = "Foundation"
  
  s.requires_arc = true

end
