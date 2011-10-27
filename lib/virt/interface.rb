module Virt
  class Interface
    attr_accessor  :mac, :model, :type, :device, :network

    def initialize options = {}
      @connection = Virt.connection
      @device     = options[:device] || default_device
      @type       = options[:type]   || default_type
      @model      = options[:model]  || default_model
      @mac        = options[:mac]
      @network    = options[:network]
    end

    def new?
      mac.nil?
    end

    protected

    # Abstracted methods
    def default_device; end

    def default_type; end

    def default_model; end

  end
end
