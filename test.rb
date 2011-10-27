$LOAD_PATH.unshift *Dir["#{File.dirname(__FILE__)}/lib"]
require 'rubygems'
require 'lib/virt'
require 'pry'

esxhost="yourserver.com"
user="root"
pass="secretpass"

uri = "esx://#{esxhost}?no_verify=1&auto_answer=1"
conn = Virt.connect(uri, :username => user, :password => pass)
host = conn.host
puts "Hypervisor version: #{host.version}"
g = Virt::VMWare::Guest.new({:name => "test-host-#{Time.now.to_i}", :pool => "default"})
g.save
g.start
binding.pry
