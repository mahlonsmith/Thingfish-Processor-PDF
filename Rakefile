#!/usr/bin/env rake
# vim: set nosta noet ts=4 sw=4:

require 'rake/clean'
require 'pathname'

BASEDIR = Pathname( __FILE__ ).dirname.relative_path_from( Pathname.pwd )
LIBDIR  = BASEDIR + 'lib' + 'thingfish'
CLOBBER.include( 'coverage' )

$LOAD_PATH.unshift( LIBDIR.to_s )

if Rake.application.options.trace
    $trace = true
    $stderr.puts '$trace is enabled'
end

task :default => [ :spec, :docs, :package ]


########################################################################
### P A C K A G I N G
########################################################################

require 'rubygems'
require 'rubygems/package_task'
spec = Gem::Specification.new do |s|
	s.homepage     = 'http://projects.martini.nu/ruby-modules'
	s.authors      = [ 'Mahlon E. Smith', 'Michael Granger' ]
	s.email        = [ 'mahlon@martini.nu', 'ged@faeriemud.org' ]
	s.platform     = Gem::Platform::RUBY
	s.summary      = "Extract PDF metadata for the Thingfish digital asset manager."
	s.name         = 'thingfish-processor-pdf'
	s.version      = '0.1.0'
	s.license      = 'BSD-3-Clause'
	s.has_rdoc     = true
	s.require_path = 'lib'
	s.bindir       = 'bin'
	s.files        = File.read( __FILE__ ).split( /^__END__/, 2 ).last.split
	#s.executables  = %w[]
	s.description  = <<-EOF
		A basic pdf processor plugin for the Thingfish digital asset manager.
		It extracts PDF metadata from uploaded files.
	EOF
	s.required_rubygems_version = '>= 2.0.3'
	s.required_ruby_version = '>= 2.0.0'

	s.add_dependency 'thingfish', '~> 0.5'
	s.add_dependency 'pdf-reader', '~> 1.4'

	s.add_development_dependency 'rspec',     '~> 3.7'
	s.add_development_dependency 'simplecov', '~> 0.16'
end

Gem::PackageTask.new( spec ) do |pkg|
	pkg.need_zip = true
	pkg.need_tar = true
end


########################################################################
### D O C U M E N T A T I O N
########################################################################

begin
	require 'rdoc/task'

	desc 'Generate rdoc documentation'
	RDoc::Task.new do |rdoc|
		rdoc.name       = :docs
		rdoc.rdoc_dir   = 'docs'
		rdoc.main       = "README.rdoc"
		rdoc.options    = [ '-f', 'fivefish' ]
		rdoc.rdoc_files = [ 'lib', *FileList['*.rdoc'] ]
	end

	RDoc::Task.new do |rdoc|
		rdoc.name       = :doc_coverage
		rdoc.options    = [ '-C1' ]
	end

rescue LoadError
	$stderr.puts "Omitting 'docs' tasks, rdoc doesn't seem to be installed."
end


########################################################################
### T E S T I N G
########################################################################

begin
	require 'rspec/core/rake_task'
	task :test => :spec

	desc "Run specs"
	RSpec::Core::RakeTask.new do |t|
		t.pattern = "spec/**/*_spec.rb"
	end

	desc "Build a coverage report"
	task :coverage do
		ENV[ 'COVERAGE' ] = "yep"
		Rake::Task[ :spec ].invoke
	end

rescue LoadError
	$stderr.puts "Omitting testing tasks, rspec doesn't seem to be installed."
end


########################################################################
### M A N I F E S T
########################################################################
__END__
lib/thingfish/processor/pdf.rb
