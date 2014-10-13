#!/usr/bin/env ruby

require 'ipaddr'
require 'pp'

ipv6 = IPAddr.new(rand(2**128),Socket::AF_INET6)

pp ipv6.to_s
