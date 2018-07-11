platform :ios, '11.0'

use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod 'RxDataSources'
  pod 'RxSwift'
end

target 'DBBrowser' do
  shared_pods
  pod 'SwiftLint'
  pod 'SwiftGen'
  pod 'RxCocoa'
  pod 'RxFeedback'
  pod 'RxOptional'
  pod 'SWXMLHash', '~> 4.0.0'
end

target 'DBBrowserTests' do
  shared_pods
  pod 'RxTest'
end
