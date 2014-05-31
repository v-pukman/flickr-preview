require 'faye'
faye = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
run faye