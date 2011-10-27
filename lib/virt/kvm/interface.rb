module Virt::KVM
  class Interface < Virt::Interface

    protected

    def default_template_path
      "kvm/guest.xml.erb"
    end

    def default_device
      @connection.host.interfaces.first
    rescue
      "br0"
    end

    def default_type
      "bridge"
    end

    def default_model
      "virtio"
    end

  end
end
