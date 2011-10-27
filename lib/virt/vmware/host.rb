module Virt::VMWare
  class Host < Virt::Host

    # Available libvirt interfaces, excluding lo
    def interfaces
      connection.list_interfaces.delete_if{|i| i == "lo"}.sort
    rescue => e
      raise "This function is not supported by the hypervisor: #{e}"
    end

    def interface iface
      connection.lookup_interface_by_name(iface)
    end

    # libvirt internal networks
    def networks
      connection.list_networks.map do |network|
        connection.lookup_network_by_name(network).bridge_name
      end
    end

    def create_guest opts
      Virt::VMWare::Guest.new opts
    end

  end

end
