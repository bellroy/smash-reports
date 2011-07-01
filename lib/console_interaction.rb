module ConsoleInteraction
  CHECKMARK = "\u2713"
  X = "\u2717"

  def prompt_for(string)
    puts "#{string}?"
    $stdin.gets.chomp
  end

  def success(msg)
    puts "#{CHECKMARK} #{msg}".green
  end

  def error(msg)
    puts "#{X} #{msg}".red
  end

  def confirm?(msg)
    puts "#{msg} (y/n)"
    yn = $stdin.gets.chomp
    yn == "y"
  end
end

