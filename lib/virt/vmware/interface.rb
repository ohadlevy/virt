module Virt::VMWare
  class Interface < Virt::Interface

    protected

    def default_template_path
      "vmware/guest.xml.erb"
    end

    def default_device
      @connection.host.interfaces.first
    rescue
      "VM Network"
    end

    def default_type
      "bridge"
    end

    def default_model
      "e1000"
    end

  end
end
