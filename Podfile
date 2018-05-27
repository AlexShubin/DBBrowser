platform :ios, '10.3'

use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod 'RxDataSources'
  pod 'RxSwift'
end

target 'DBBrowser' do
  shared_pods
  pod 'SwiftGen'
  pod 'Apollo'
  pod 'RxCocoa'
  pod 'RxFeedback'
  pod 'RxOptional'
end

target 'DBBrowserTests' do
  shared_pods
  pod 'RxTest'
end
