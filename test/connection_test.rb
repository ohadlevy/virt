require 'test/test_helper'

class Virt::ConnectionTest < Test::Unit::TestCase

  def setup
    hostname = "h01.sat.lab"
    uri = "qemu+ssh://root@#{hostname}/system"
    @conn = Virt.connect uri
  end

  def test_should_be_able_to_connect
    assert !@conn.closed?
  end

  def test_should_be_able_to_disconnect
    @conn.disconnect
    assert @conn.closed?
  end

  def test_should_return_a_version
    assert @conn.version
  end

end
