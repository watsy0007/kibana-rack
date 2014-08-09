require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  SimpleCov.minimum_coverage 95

  add_filter '.bundle'
  add_filter 'spec'
end
