#!/usr/bin/ruby
require 'open-uri'
require 'nokogiri'

def get_ows_data(host, romid, reqnode)
	url = open("http://#{host}/details.xml")
	doc = Nokogiri::XML(url)
	## List all romids if one is not provided
	unless romid
		nodes = doc.xpath("//xmlns:ROMId") rescue false or raise "Cannot find any ROMIds"
		ret = nodes.map do |e|
			e.text
		end
		return ret
	end

	## Look for requested romid
	ows_node = doc.xpath("//xmlns:ROMId[text()='#{romid}']").first.parent rescue false or raise "ROMId not found"
	## Return all values if specific node is not provided
	unless reqnode
		ret = ows_node.elements.map do |e|
			"#{e.name} = #{e.text}"
		end
	## Return requested node value
	else
		ret = ows_node.search(reqnode).text
	end
	return ret

end


if $0 == __FILE__
	host, romid, reqnode = ARGV[0..2]
	begin
		answer = get_ows_data host, romid, reqnode
	rescue => e
		puts "Error: #{e}"
		exit 1
	end
	puts answer
end
