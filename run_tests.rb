# run_tests.rb
Dir["./test/*_test.rb"].each { |file|
  require file
}
