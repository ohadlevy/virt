require 'test/test_helper'

class Virt::InterfaceTest < Test::Unit::TestCase

  def setup
    hostname = "h01.sat.lab"
    uri = "qemu+ssh://root@#{hostname}/system"
    Virt.connect(uri)
    @interface = Virt::Interface.new()
  end

  def test_should_be_new
    assert @interface.new?
  end

end
