class SmartTestUtil
	class << self
		def stats
			@disks = DiskUtils.stats
			response = []
			@disks.each_with_index do |disk, index|
				status = read_smart_status(create_file_and_get_path(disk[:device]))
				color = (status=="PASSED")? "green": "red";
				response << { model: disk[:model], device: disk[:device], 
					health_check: status, color: color }
			end
			return response
		end

		def create_file_and_get_path(device)
			# create the status file and return file path
			# need to implement for production
			get_sample_file_path(rand(2))
		end

		def sample_stats
			@disks = SampleData.load('disks')
			response = []
			@disks.each_with_index do |disk, index|
				status = read_smart_status(get_sample_file_path(index))
				color = (status=="PASSED")? "green": "red";
				response << { model: disk[:model], device: disk[:device], 
					health_check: status, color: color }
			end
			return response
		end

		def get_sample_file_path(index)
			if index.blank? or index%2 == 0
				Rails.root+Dir["plugins/*smart_statuses/db/sample-data/smartctl-output-sample1.txt"][0]
			else
				Rails.root+Dir["plugins/*smart_statuses/db/sample-data/smartctl-output-sample2.txt"][0]
			end
		end

		def read_smart_status(filepath)			
			return nil unless File.exists?(filepath)
			IO.readlines(filepath)[3][50..-1]
		end
	end
end
