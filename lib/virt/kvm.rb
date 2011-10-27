module Virt::KVM
  autoload :Host,      'virt/kvm/host.rb'
  autoload :Guest,     'virt/kvm/guest.rb'
  autoload :Interface, 'virt/kvm/interface.rb'
  autoload :Volume,    'virt/kvm/volume.rb'
end
