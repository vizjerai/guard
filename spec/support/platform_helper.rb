def bsd?
  RbConfig::CONFIG['target_os'] =~ /bsd/i
end

def mac?
  RbConfig::CONFIG['target_os'] =~ /darwin/i
end

def linux?
  RbConfig::CONFIG['target_os'] =~ /linux/i
end

def windows?
  RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
end
