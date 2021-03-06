# Application template recipe for the rails_apps_composer. Check for a newer version here:
# https://github.com/RailsApps/rails_apps_composer/blob/master/recipes/navigation.rb

after_bundler do

  say_wizard "Navigation recipe running 'after bundler'"
  
    if recipes.include? 'devise'
      # Create navigation links for Devise
      if recipes.include? 'haml'
        # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
        # We have to use single-quote-style-heredoc to avoid interpolation.
        create_file "app/views/shared/_navigation.html.haml" do <<-'HAML'
- if user_signed_in?
  %li
    = link_to('Logout', destroy_user_session_path, :method=>'delete')
- else
  %li
    = link_to('Login', new_user_session_path)
- if user_signed_in?
  %li
    = link_to('Edit account', edit_user_registration_path)
- else
  %li
    = link_to('Sign up', new_user_registration_path)
HAML
        end
      else
        create_file "app/views/shared/_navigation.html.erb" do <<-ERB
<% if user_signed_in? %>
  <li>
  <%= link_to('Logout', destroy_user_session_path, :method=>'delete') %>        
  </li>
<% else %>
  <li>
  <%= link_to('Login', new_user_session_path)  %>  
  </li>
<% end %>
<% if user_signed_in? %>
  <li>
  <%= link_to('Edit account', edit_user_registration_path) %>
  </li>
<% else %>
  <li>
  <%= link_to('Sign up', new_user_registration_path)  %>
  </li>
<% end %>
ERB
        end
      end

    else
      # Create navigation links
      if recipes.include? 'haml'
        # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
        # We have to use single-quote-style-heredoc to avoid interpolation.
        create_file "app/views/shared/_navigation.html.haml" do <<-'HAML'
- if user_signed_in?
  %li
    Logged in as #{current_user.name}
  %li
    = link_to('Logout', signout_path)
- else
  %li
    = link_to('Login', signin_path)
HAML
        end
      else
        create_file "app/views/shared/_navigation.html.erb" do <<-ERB
<% if user_signed_in? %>
  <li>
  Logged in as <%= current_user.name %>
  </li>
  <li>
  <%= link_to('Logout', signout_path) %>        
  </li>
<% else %>
  <li>
  <%= link_to('Login', signin_path)  %>  
  </li>
<% end %>
ERB
        end
      end
    end

    # Add navigation links to the default application layout
    if recipes.include? 'html5'
      if recipes.include? 'haml'
        # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
        inject_into_file 'app/views/layouts/application.html.haml', :after => "%header\n" do <<-HAML
        %nav
          %ul.hmenu
            = render 'shared/navigation'
HAML
        end
      else
        inject_into_file 'app/views/layouts/application.html.erb', :after => "<header>\n" do <<-ERB
        <nav>
          <ul class="hmenu">
            <%= render 'shared/navigation' %>
          </ul>
        </nav>
ERB
        end
      end
    else
      if recipes.include? 'haml'
        # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
        inject_into_file 'app/views/layouts/application.html.haml', :after => "%body\n" do <<-HAML
    %ul.hmenu
      = render 'shared/navigation'
HAML
        end
      else
        inject_into_file 'app/views/layouts/application.html.erb', :after => "<body>\n" do
  <<-ERB
  <ul class="hmenu">
    <%= render 'shared/navigation' %>
  </ul>
ERB
        end
      end
    end

    # Throw it all away and create new navigation if we're enabling subdomains
    if recipes.include? 'subdomains'
      remove_file 'app/views/shared/_navigation.html.haml'
      # There is Haml code in this script. Changing the indentation is perilous between HAMLs.
      # We have to use single-quote-style-heredoc to avoid interpolation.
      create_file 'app/views/shared/_navigation.html.haml' do <<-'HAML'
%li
  = link_to 'Main', root_url(:host => request.domain)
- if request.subdomain.present? && request.subdomain != "www"
  - if user_signed_in?
    %li
      = link_to('Edit account', edit_user_registration_url)
    %li
      = link_to('Logout', destroy_user_session_url, :method=>'delete')
  - else
    %li
      = link_to('Login', new_user_session_url)
- else
  %li
    = link_to('Sign up', new_user_registration_url(:host => request.domain))
  - if user_signed_in?
    %li
      = link_to('Logout', destroy_user_session_url, :method=>'delete')
HAML
      end
    end

end

__END__

name: Navigation
description: "Add navigation links."
author: RailsApps

category: other
tags: [utilities, configuration]
