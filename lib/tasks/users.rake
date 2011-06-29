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

  desc "Delete a user"
  task :delete => :environment do
    email = prompt_for "User's email address"
    u = User.where(:email => email).first
    if u
      puts "Found a user that might be the one you're looking for:"
      puts "  ID: #{u.id}"
      puts "  Email: #{u.email}"
      if confirm? "Are you sure you want to delete them?"
        u.destroy
        success "User ID #{u.id} deleted"
      else
        error "Cancelled!"
      end
    else
      error "Couldn't find a user with that email address."
    end
  end

  desc "List users"
  task :list => :environment do
    User.all.each do |u|
      puts " *".blue + " #{u.id}".yellow + " #{u.email}".cyan
    end
  end
end
