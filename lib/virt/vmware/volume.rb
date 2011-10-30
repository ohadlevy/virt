module Virt::VMWare
  class Volume < Virt::Volume

    def default_type
      "raw"
    end

    def default_template_path
      "vmware/volume.xml.erb"
    end

    def path
      "[#{pool.name}] #{self}"
    end

    def name= name
      super name
      @name += ".vmdk" unless name.match(/.*\.vmdk$/)
    end

    def to_s
      "#{title}/#{name}"
    end

    private

    def title
      name.chomp(".vmdk")
    end

  end
end
