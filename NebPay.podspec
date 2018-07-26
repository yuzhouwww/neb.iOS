Pod::Spec.new do |spec|
  spec.name         = 'NebPay'
  spec.version      = '0.1.0'
  spec.license      = { :type => 'BSD', :file => 'LICENSE' }
  spec.homepage     = 'https://developers.nebulas.io'
  spec.authors      = { 'Zhou Yu' => 'ryan.yu@nebulas.io' }
  spec.summary      = 'NebPay is an official iOS SDK of NAS nano App, provides several APIs to pay with NAS/NRC20, authenticate, even deploy a smart contract.'
  spec.source       = { :git => 'https://github.com/yuzhouwww/neb.iOS.git', :tag => spec.version.to_s }
 #spec.source_files = 'iosSDK/iosSDK/*.{h,m}'
  spec.source_files = '*.framework'
  spec.platform     = :ios, '8.0'
  spec.static_framework = true
  spec.documentation_url = 'https://developers.nebulas.io/dapp/nebpay-installation'
end