module ActiveClassHelper
  # Return active or nil based on the given route spec
  #   %li{ class: active_class('users') # true if controller is users, false otherwise
  #   %li{ class: active_class('pages#about') # true if controller is pages and action is about
  def active_class(*route_specs)
    options = route_specs.extract_options!
    return nil if Array.wrap(options[:except]).any?{|exception| current_route_spec?(exception) }
    return 'is-active' if route_specs.any?{|rs| current_route_spec?(rs, options) }
    nil
  end

  # Check if the current route matches the route given as argument.
  # The syntax is meant to be a bit similar to specifying routes in
  # `config/routes.rb`.
  #   current_route_spec?('products') #=> true if controller name is products, false otherwise
  #   current_route_spec?('products#show') #=> true if controller_name is products AND action_name is show
  #   current_route_spec?('#show') #=> true if action_name is show, false otherwise
  #NOTE: this helper is tested through the active_class helper
  def current_route_spec?(route_spec, options = {})
    return route_spec.match([controller_path, action_name].join('#')) if route_spec.is_a?(Regexp)
    controller, action = route_spec.split('#')
    return action == params[:id] if controller_path == 'high_voltage/pages'
    actual_controller_parts = controller_path.split('/')
    if controller #and controller_path == controller
      tested_controller_parts = controller.split('/')
      return if tested_controller_parts.size > actual_controller_parts.size
      if actual_controller_parts[0...tested_controller_parts.size] == tested_controller_parts
        # controller spec matches
        return true unless action
        action_name == action
      end
    else
      action_name == action
    end
  end

end
