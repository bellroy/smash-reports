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

namespace :users do
  desc "Create a new user"
  task :create => :environment do
    u = User.new
    u.email = prompt_for "Email"
    u.password = prompt_for "Password"
    if u.save
      success "User ID #{u.id} created for #{u.email}"
    else
      error "Failed to create user. Validation errors follow:"
      u.errors.full_messages.each { |m| puts "  #{m}"}
    end
  end
end
