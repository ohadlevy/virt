module Virt
  class Interface
    attr_accessor  :mac, :model, :type, :device

    def initialize options = {}
      @connection = Virt.connection
      @device     = options[:device] || default_device
      @type       = options[:type]   || default_type
      @model      = options[:model]  || default_model
      @mac        = options[:mac]
    end

    def new?
      mac.nil?
    end

    private

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
