require 'console_interaction'

class OrganizationManager
  include ConsoleInteraction

  def select_org
    name = prompt_for "Organization short name"
    o = Organization.where(:name => name).first
    if o
      success "Found organization ID #{o.id}"
      o
    else
      error "Couldn't find an organization with that name"
    end
  end

  def create_org
    o = Organization.new
    o.name = prompt_for "Short name (lowercase letters and dashes only)"
    o.long_name = prompt_for "Long name (free-form text)"
    if o.save
      success "Organization ID #{o.id} created for #{o.name}"
    else
      error "Failed to create organization. Validation errors follow:"
      o.errors.full_messages.each { |m| puts "  #{m}"}
    end
  end

  def delete_org
    return unless o = select_org
    if confirm? "Are you sure you want to delete it?"
      o.destroy
      success "Organization ID #{o.id} deleted"
    else
      error "Cancelled!"
    end
  end

  def list_orgs
    Organization.all.each do |o|
      puts " *".blue + " #{o.id}".yellow + " #{o.name}".cyan
    end
  end
end
