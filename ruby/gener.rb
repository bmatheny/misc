#!/usr/bin/env ruby

%w(digest ipaddr ostruct pp set zlib).each {|f| require f}

def has_v6_address pct
  return (Random.rand(1..100) < pct)
end

def random_address ub, stype
  IPAddr.new(Random.rand(1..ub), stype).to_string
end
def random_ipv4_address
  random_address (2**32), Socket::AF_INET
end
def random_ipv6_address
  random_address (2**128), Socket::AF_INET6
end

$seen_addresses = Set.new
def unique_address generator
  address = generator.call
  while $seen_addresses.include?(address) do
    address = generator.call
  end
  $seen_addresses.add(address)
  address
end

def get_addresses count
  result = OpenStruct.new
  v6_count = 0
  result.addresses = (1..count).map do |idx|
    ipv4 = unique_address method(:random_ipv4_address)
    ipv6 = ""
    if has_v6_address(60) then
      ipv6 = unique_address method(:random_ipv6_address)
      v6_count += 1
    end
    str = "#{ipv4}#{ipv6}"
    OpenStruct.new({:address => str, :hash => Zlib.crc32(str)})
  end
  result.counts = OpenStruct.new({:total => count, :v6 => v6_count})
  result
end

data = get_addresses 100000

address_count = data.counts.total
v6_count = data.counts.v6
v4_count = address_count - v6_count
v6_pct = 100 * (v6_count.to_f / address_count.to_f)

puts "Addresses(total = #{address_count}, v4only = #{v4_count}, v6 = #{v6_count}, v6pct = #{v6_pct.round(2)})"

(1..100).each do |pct|
  found = data.addresses.select {|addr| (addr.hash % 100) <= pct}.size
  npct = 100 * (found.to_f / address_count.to_f)
  puts("Found #{npct.round(2)}% (#{found}/#{address_count}) of hosts with pct <= #{pct}");
end
