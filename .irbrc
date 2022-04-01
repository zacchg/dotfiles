#!/usr/bin/env ruby

# cache
cache_dir = ENV["XDG_CACHE_HOME"] || File.join(ENV["HOME"], ".cache")
IRB.conf[:HISTORY_FILE] = File.join(cache_dir, "ruby/irb_history")
FileUtils.mkdir_p File.dirname(IRB.conf[:HISTORY_FILE])

# prompt
IRB.conf[:PROMPT][:CUSTOM] = {
  PROMPT_I: "💎 >> ",
  PROMPT_N: "💎 >> ",
  PROMPT_S: "💎 >%l ",
  PROMPT_C: "💎 >* ",
  RETURN: "%s\n"
}
IRB.conf[:PROMPT_MODE] = :CUSTOM
