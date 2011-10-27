module Virt::KVM
  class Guest < Virt::Guest

    def initialize options = {}
      super(options)
      @volume        = Volume.new options
      @interface   ||= Interface.new options
    end

    protected

    def default_template_path
      "kvm/guest.xml.erb"
    end

  end
end
