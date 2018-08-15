#
#  Be sure to run `pod spec lint QCCollectionView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
s.name         = "QCCollectionView"
s.version      = "1.0.0"
s.summary      = "Lib of QC."
s.description  = <<-DESC
Lib of QCCollectionView.
DESC

s.homepage     = "https://github.com/QCCoder"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author       = { "qiancheng" => "596896692@qq.com" }
s.source       = { :git => "https://github.com/QCCoder/QCCollectionView.git", :tag => "#{s.version}" }
s.platform     = :ios, "8.0"

s.source_files = 'QCCollectionView/QCCollectionView/**/*'
s.public_header_files = 'QCCollectionView/QCCollectionView/**/*.h'
s.resources = 'QCCollectionView/QCCollectionView/QCCollectionView.bundle'
s.dependency 'MJRefresh'
s.dependency 'DZNEmptyDataSet'
end
