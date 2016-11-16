# -*- ruby -*-
#encoding: utf-8

require 'pdf-reader'

require 'strelka'
require 'thingfish' unless defined?( Thingfish )
require 'thingfish/processor' unless defined?( Thingfish::Processor )


# Attach PDF metadata to the Adobe Portable Document Format.
class Thingfish::Processor::PDF < Thingfish::Processor
	extend Loggability

	# Package version
	VERSION = '0.1.0'

	# Version control revision
	REVISION = %q$Revision$


	# Loggability API -- log to the :thingfish logger
	log_to :thingfish

	# The list of handled types
	handled_types 'application/pdf'


	### Synchronous processor API -- extract metadata from uploaded PDFs
	###
	def on_request( request )
		reader   = ::PDF::Reader.new( request.body )
		metadata = self.extract_pdf_metadata( reader )

		request.add_metadata( metadata )
	end


	#########
	protected
	#########

	### Normalize metadata from the PDFReader object and return it as a hash.
	###
	def extract_pdf_metadata( reader )
		self.log.debug "Extracting PDF metadata..."

		pdf_metadata = {
			'pdf:version'   => reader.pdf_version,
			'pdf:pagecount' => reader.page_count,
		}.reject {|_,v| v.nil? }

		reader.info.each_pair do |key, val|
			pdf_metadata[ "pdf:#{key}" ] = val unless val.is_a?( ::PDF::Reader::Reference )
		end

		self.log.debug "  raw PDF metadata: %p" % [ pdf_metadata ]
		return pdf_metadata
	end

end # class Thingfish::Processor::PDF

