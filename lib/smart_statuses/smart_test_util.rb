class SmartTestUtil
	class << self
		def stats
			@disks = DiskUtils.stats
			response = []
			@disks.each_with_index do |disk, index|
				status = fetch_status(disk[:device])
				next if status.blank?
				color = get_color(status)
				response << { model: disk[:model], device: disk[:device],
					health_check: status, color: color }
			end
			return response
		end

		def fetch_status(device)
			return nil if device.blank?
			status = `sudo /var/hda/apps/0gjocmmq4k/elevated/smart-details #{device[5..-1]}`
			read_streamed_smart_status(status)
		end

		def sample_stats
			@disks = SampleData.load('disks')
			response = []
			@disks.each_with_index do |disk, index|
				status = read_smart_status(get_sample_file_path(index))
				color = get_color(status)
				response << { model: disk[:model], device: disk[:device],
					health_check: status, color: color }
			end
			return response
		end

		def get_sample_file_path(index)
			if index.blank?
				Rails.root+Dir["plugins/*smart_statuses/db/sample-data/smartctl-output-sample"+(1+rand(3)).to_s+".txt"][0]
			else
				Rails.root+Dir["plugins/*smart_statuses/db/sample-data/smartctl-output-sample"+(1+index%3).to_s+".txt"][0]
			end
		end

		def get_color(status)
			if status =~ /PASSED/
				"green"
			elsif status =~ /FAILED/
				"red"
			else
				"blue"
			end
		end

		def read_smart_status(filepath)			
			return "Some Error Occurred !!" unless File.exists?(filepath)
			file = File.new(filepath)
			line_num = file.find_index { |line| line =~ /START OF READ SMART DATA SECTION/ }

			if line_num.blank?
				return "Device Lacks SMART Compatibility."
			else
				return IO.readlines(filepath)[line_num + 1][50..-1]
			end
		end

		def read_streamed_smart_status(status)
			return "Some Error Occurred !!" if status.blank?
			strings = status.split("\n")
			line_num = strings.index { |line| line =~ /START OF READ SMART DATA SECTION/ }

			if line_num.blank?
				return "Device Lacks SMART Compatibility."
			else
				return strings[line_num + 1][50..-1]
			end
		end
	end
end