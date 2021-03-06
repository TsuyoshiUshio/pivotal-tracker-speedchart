require 'yard'
require 'yard/rake/yardoc_task'


YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.options = ['--no-private']
  t.options << '--debug' << '--verbose' if $trace
end