require "pathname"

class FakeNpm
  TAPE = Pathname(__dir__).join("..", "..", "tmp", "npm_commands")

  def record!
    File.write(TAPE, ARGV.join(" "))
  end

  def ran?
    !arguments.empty?
  end

  def arguments
    @arguments ||= File.read(TAPE)
  rescue Errno::ENOENT
    warn <<~MSG
      Could not find #{TAPE.basename} file!
      Fake npm did not run.
    MSG

    ""
  end
end
