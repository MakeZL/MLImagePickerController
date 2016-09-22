
Pod::Spec.new do |s|

  s.name         = "MLImagePickerController"
  s.version      = "0.3"
  s.summary      = "MLImagePickerController Swift written using PhotoKit easy to use multi album Library Based on."

  s.description  = <<-DESC
                    The PhotoKit package, so that the use of more simple, provides more pictures, more video preview, fast and easy to use features
                    DESC

  s.homepage     = "https://github.com/MakeZL/MLImagePickerController"

  s.license      = { :type => "MIT", :file => "LICENSE" }
 
  s.author             = { "Leo" => "120886865@qq.com" }
  s.social_media_url   = "http://weibo.com/MakeZL"

  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/MakeZL/MLImagePickerController.git", :tag => s.version }

  s.source_files  = "MLImagePickerController/**/*.swift"
  s.resource = "MLImagePickerController/Classes/MLImagePickerController.bundle"

  s.requires_arc = true
  s.framework = "Photos"

end
