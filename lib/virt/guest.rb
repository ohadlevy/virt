module Virt
  class Guest
    include Virt::Util
    attr_reader :name, :xml_desc
    attr_accessor :memory, :vcpu, :arch, :volume, :interface, :template_path

    def initialize options = {}
    @connection = Virt.connection
    @name       = options[:name]   || raise("Must provide a name")
    # If our domain exists, we ignore the provided options and defaults
    fetch_guest
    @memory ||= options[:memory] || default_memory_size
    @vcpu   ||= options[:vcpu]   || default_vcpu_count
    @arch   ||= options[:arch]   || default_arch

    @template_path = options[:template_path] || default_template_path
    @volume        = Volume.new options
    @interface     = Interface.new options.merge({:mac => @mac})
    end

    def new?
      @domain.nil?
    end

    def save
      @connection.connection.define_domain_xml xml
      fetch_guest
      !new?
    end

    def start
      raise "Guest not created, can't start" if new?
      @domain.create
    end

    def running?
      false if new?
      @domain.active?
    end

    def stop
      raise "Guest not created, can't stop" if new?
      @domain.destroy
    rescue Libvirt::Error
      # domain is not running
      true
    end

    def destroy opts
      return true if new?
      stop if running?
      #vol = host.volume host.default_storage_pool_name, guest.image_name
      @domain.undefine
    end

    def uuid
      @domain.uuid unless new?
    end

    private

    def fetch_guest
      if @domain = @connection.connection.lookup_domain_by_name(name)
        @xml_desc = @domain.xml_desc
        @memory   = @domain.max_memory
        @vcpu     = document("domain/vcpu")
        @arch     = document("domain/os/type", "arch")
        @mac      = document("domain/devices/interface/mac", "address")
      end
      @domain
    rescue Libvirt::RetrieveError
    end

    def default_memory_size
      1048576
    end

    def default_vcpu_count
      1
    end

    def default_arch
      "x86_64"
    end

    def default_template_path
      "guest.xml.erb"
    end
  end
end
