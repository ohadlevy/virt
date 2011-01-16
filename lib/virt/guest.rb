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
      @domain = @connection.connection.define_domain_xml(xml)
      fetch_info
      !new?
    end

    def start
      raise "Guest not created, can't start" if new?
      @domain.create unless running?
      running?
    end

    def running?
      return false if new?
      @domain.active?
    rescue 
      # some versions of libvirt do not support checking for active state
      @connection.connection.list_domains.each do |did|
        return true if @connection.connection.lookup_domain_by_id(did).name == name
      end
      false
    end

    def stop
      raise "Guest not created, can't stop" if new?
      @domain.destroy
      !running?
    rescue Libvirt::Error
      # domain is not running
      true
    end

    def destroy
      return true if new?
      stop if running?
      @domain = @domain.undefine
      new?
    end

    def uuid
      @domain.uuid unless new?
    end

    private

    def fetch_guest
      @domain = @connection.connection.lookup_domain_by_name(name)
      fetch_info
    rescue Libvirt::RetrieveError
    end

    def fetch_info
      return if @domain.nil?
      @xml_desc = @domain.xml_desc
      @memory   = @domain.max_memory
      @vcpu     = document("domain/vcpu")
      @arch     = document("domain/os/type", "arch")
      @mac      = document("domain/devices/interface/mac", "address")
      @interface.mac = @mac if @interface
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
