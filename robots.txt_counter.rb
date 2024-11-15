##
# This was made by Brendan Coles <bcoles@gmail.com> and modified by Michael Provenzano (@MikeyPPPPPPPP)
#
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# https://morningstarsecurity.com/research/whatweb
##
Plugin.define do
	name "robots_counter"
	authors [
	  "Michael Provenzano (@MikeyPPPPPPPP)",# 2024-11-14
	  "Brendan Coles <bcoles@gmail.com>", # 2010-10-22
	  # v0.2 # Added aggressive `/robots.txt` retrieval. 
	  # v0.3 # 2011-03-23 # Removed aggressive section. 
	]
	version "0.1"
	description "From the root URL (no trailing slash), this plugin identifies robots.txt files and counts the entries. The idea is to get an idea of the website size; this is just to estimate the size and wont acuretly help you with the size"
	
	
	
	# Passive #
	aggressive do
		m=[]
		r = []
		
		counter = 0
		# Extract directories if current file is robots.txt
	
		#goto robots file
		target = URI.join(@base_uri.to_s,"/robots.txt").to_s
	
		#get the data
		status,url,ip,body,headers = open_target(target)
	
		#puts status
		#puts bodys
		if status == 200
	
			# Disallow
			if body =~ /^Disallow:[\s]*(.+)$/i
				m << { :string=>body.scan(/^Disallow:[\s]*(.+)/i) }
			end
	
			# Allow
			if body =~ /^Allow:[\s]*(.+)$/i
				m << { :string=>body.scan(/^Allow:[\s]*(.+)/i) }
			end
			
			m.each do |key, array|
			  key.each_value { |paths| counter += paths.size }
			end
			r << { :string => " Length #{counter}" }
		end
	
		# Return passive matches
		r
	end
end
