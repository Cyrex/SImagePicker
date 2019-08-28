#
# Be sure to run `pod lib lint SImagePicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SImagePicker'
  s.version          = '1.0.0'
  s.summary          = 'A simple library to pick pictures.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

#  s.description      = <<-DESC
#  A simple library to pick pictures.
#                       DESC

  s.homepage         = 'https://github.com/Cyrex/SImagePicker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Cyrex' => 'szwathub@gmail.com' }
  s.source           = { :git => 'https://github.com/Cyrex/SImagePicker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
#  s.default_subspec = 'Core'

# s.subspec 'Core' do |ss|
#ss.dependency 'SImagePicker/Untils'
#  end

  s.subspec 'Untils' do |ss|
    ss.public_header_files = 'SImagePicker/Untils/*.h'
    ss.ios.source_files  = 'SImagePicker/Untils/*.{h,m}'
  end
end
