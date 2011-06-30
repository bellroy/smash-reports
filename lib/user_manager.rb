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

class UserManager
  include ConsoleInteraction

  def select_user
    email = prompt_for "User's email address"
    u = User.where(:email => email).first
    if u
      success "Found user ID #{u.id}"
      u
    else
      error "Couldn't find a user with that email address"
    end
  end

  def select_organizations_for(user)
    orgs = Organization.order("id ASC").all
    ids = user.organization_ids.dup
    loop do
      orgs.each do |org|
        s = "#{org.id}. #{org.long_name} (#{org.name})"
        if ids.include? org.id
          puts "#{CHECKMARK} #{s}".green
        else
          puts "  #{s}"
        end
      end
      v = prompt_for "Organization ID, or 'q' to finish picking organizations"
      break if v == 'q'
      id = v.to_i
      unless orgs.map(&:id).include? id
        error "Couldn't find an organization with that id."
        next
      end
      if ids.include? id
        ids.delete id
      else
        ids << id
      end
    end
    user.organization_ids = ids
  end

  def create_user
    u = User.new
    u.email = prompt_for "Email"
    u.password = prompt_for "Password"
    select_organizations_for u
    if u.save
      success "User ID #{u.id} created for #{u.email}"
    else
      error "Failed to create user. Validation errors follow:"
      u.errors.full_messages.each { |m| puts "  #{m}"}
    end
  end

  def delete_user
    return unless u = select_user
    if confirm? "Are you sure you want to delete them?"
      u.destroy
      success "User ID #{u.id} deleted"
    else
      error "Cancelled!"
    end
  end

  def list_users
    User.all.each do |u|
      puts " *".blue + " #{u.id}".yellow + " #{u.email}".cyan
    end
  end

  def select_orgs
    return unless u = select_user
    select_organizations_for u
    if u.save
      success "User ID #{u.id} now belongs to orgs #{u.organization_ids.inspect}"
    else
      error "Couldn't save the user; validation errors follow"
      u.errors.full_messages.each { |m| puts "  #{m}"}
    end
  end
end
