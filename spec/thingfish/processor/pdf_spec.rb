#!/usr/bin/env ruby

require_relative '../../spec_helper'

require 'rspec'

require 'thingfish'
require 'thingfish/processor'

require 'strelka'
require 'strelka/httprequest/metadata'


describe Thingfish::Processor, "PDF" do

	before( :all ) do
		Strelka::HTTPRequest.class_eval { include Strelka::HTTPRequest::Metadata }
	end


	let( :processor ) { described_class.create(:pdf) }

	let( :factory ) do
		Mongrel2::RequestFactory.new(
			:route => '/',
			:headers => {:accept => '*/*'})
	end


	it "extracts metadata from uploaded PDFs" do
		req = factory.post( '/tf', fixture_data('hi.pdf'), 'Content-type' => 'application/pdf' )

		processor.process_request( req )

		expect( req.metadata ).to include( 'pdf:pagecount', 'pdf:producer' )
	end
end

# vim: set nosta noet ts=4 sw=4 ft=rspec:
