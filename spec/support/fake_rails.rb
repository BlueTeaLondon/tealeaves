require "pathname"

class FakeRails
  TAPE = Pathname(__dir__).join("..", "..", "tmp", "rails_commands")

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
      Fake rails did not run.
    MSG

    ""
  end
end
