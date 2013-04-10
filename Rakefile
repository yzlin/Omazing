class String
  def self.colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end

  def red
    self.class.colorize(self, 31)
  end

  def green
    self.class.colorize(self, 32)
  end
end

desc 'Run the tests'
task :test do
  verbose = ENV['VERBOSE']
  ret = test_scheme('Omazing', 'Omazing', verbose)

  puts "\n\n\n" if verbose
  puts "Mac: #{ret == 0 ? 'PASSED'.green : 'FAILED'.red}"

  exit ret
end

def test_scheme(workspace, scheme, verbose=false)
  ret = -1
  output = `xcodebuild -workspace #{workspace}.xcworkspace -scheme #{scheme} clean test 2>&1`
  for line in output.lines
    if line == "** TEST SUCCEEDED **\n"
      puts line.green
      ret = 0
    elsif line == "** TEST FAILED **\n"
      puts line.red
      ret = 1
    else
      puts line if verbose
    end
  end

  return ret
end
