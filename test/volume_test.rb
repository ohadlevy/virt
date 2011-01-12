require 'test/test_helper'

class Virt::VolumeTest < Test::Unit::TestCase

  def setup
    hostname = "h01.sat.lab"
    uri = "qemu+ssh://root@#{hostname}/system"
    Virt.connect(uri)
    @vol = Virt::Volume.new
  end

  def test_volume
  end

end
