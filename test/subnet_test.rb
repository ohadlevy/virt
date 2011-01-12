require 'test/test_helper'

class Virt::SubnetTest < Test::Unit::TestCase

  def setup
    guest = Virt::Guest.new({:name => "test"})
    @subnet = Virt::Subnet.new({:guest => guest, :vlan => 100})
  end

  def test_subnet_should_have_a_guest
    assert_kind_of Virt::Guest, @subnet.guest
  end

  def test_subnet_should_have_a_vlan
    assert_equal @subnet.vlan, 100
  end


end
