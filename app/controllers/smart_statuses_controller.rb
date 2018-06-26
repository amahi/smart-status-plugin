require "smart_statuses/smart_test_util.rb"

class SmartStatusesController < ApplicationController
	before_action :admin_required

	def index
		@page_title = t('smart_status')
		unless use_sample_data?
			@tests = SmartTestUtil.stats
		else
			# NOTE: this is to get sample fake data in development
			@tests = SmartTestUtil.sample_stats
		end
	end
end