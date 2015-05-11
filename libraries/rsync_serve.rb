class Chef
  class Resource
    class RsyncServe < LWRPBase
      self.resource_name = :rsync_serve
      actions :add, :remove
      default_action :add

      # man rsyncd.conf for more info on each attribute
      attribute :name, :kind_of => String, :name_attribute => true
      attribute :config_path, :kind_of => String, :default => '/etc/rsyncd.conf'
      attribute :path, :kind_of => String, :required => true
      attribute :comment, :kind_of => String
      attribute :read_only, :kind_of => [TrueClass, FalseClass]
      attribute :write_only, :kind_of => [TrueClass, FalseClass]
      attribute :list, :kind_of => [TrueClass, FalseClass]
      attribute :uid, :kind_of => String
      attribute :gid, :kind_of => String
      attribute :auth_users, :kind_of => String
      attribute :secrets_file, :kind_of => String
      attribute :hosts_allow, :kind_of => String
      attribute :hosts_deny, :kind_of => String
      attribute :max_connections, :kind_of => Fixnum, :default => 0
      attribute :munge_symlinks, :kind_of => [TrueClass, FalseClass], :default => true
      attribute :use_chroot, :kind_of => [TrueClass, FalseClass]
      attribute :numeric_ids, :kind_of => [TrueClass, FalseClass], :default => true
      attribute :fake_super, :kind_of => [TrueClass, FalseClass]
      attribute :exclude_from, :kind_of => String
      attribute :exclude, :kind_of => String
      attribute :include_from, :kind_of => String
      attribute :include, :kind_of => String
      attribute :strict_modes, :kind_of => [TrueClass, FalseClass]
      attribute :log_file, :kind_of => String
      attribute :log_format, :kind_of => String
      attribute :transfer_logging, :kind_of =>  [TrueClass, FalseClass]
      # by default rsync sets no client timeout (lets client choose, but this is a trivial DOS) so we make a 10 minute one
      attribute :timeout, :kind_of => Fixnum, :default => 600
      attribute :dont_compress, :kind_of  =>  String
      attribute :lock_file, :kind_of => String
      attribute :refuse_options, :kind_of => String
      attribute :restart_service, :kind_of => [TrueClass,FalseClass], :default => true
    end
  end
  class Provider
    class RsyncServe < LWRPBase
      action :add do
        write_conf
      end

      action :remove do
        write_conf
      end

      protected
      def write_conf
        g_m = global_modules
        r_m = rsync_modules
    
        t = template(new_resource.config_path) do
          source   'rsyncd.conf.erb'
          cookbook 'rsync'
          owner    'root'
          group    'root'
          mode     '0640'
          variables(
            :globals => g_m,
            :modules => r_m
          )
          notifies :restart, "service[#{node['rsyncd']['service']}]", :delayed if new_resource.restart_service
        end
    
        new_resource.updated_by_last_action(t.updated?)
    
        service node['rsyncd']['service'] do
          action :nothing
        end
      end
      # The list of attributes for this resource.
      #
      # @todo find a better way to do this
      #
      # @return [Array<String>]
      def resource_attributes
        %w(
          auth_users
          comment
          dont_compress
          exclude
          exclude_from
          fake_super
          gid
          hosts_allow
          hosts_deny
          include
          include_from
          list
          lock_file
          log_file
          log_format
          max_connections
          munge_symlinks
          numeric_ids
          path
          read_only
          refuse_options
          secrets_file
          strict_modes
          timeout
          transfer_logging
          uid
          use_chroot
          write_only
        )
      end
    
      # The list of rsync server resources in the resource collection
      #
      # @return [Array<Chef::Resource>]
      def rsync_resources
        run_context.resource_collection.select do |resource|
          resource.is_a?(Chef::Resource::RsyncServe)
        end
      end
    
      # Expand "snake_case_things" to "snake case things".
      #
      # @param [String] string
      #
      # @return [String]
      def snake_to_space(string)
        string.to_s.gsub(/_/, ' ')
      end
    
      # The list of rsync modules defined in the resource collection.
      #
      # @return [Hash]
      def rsync_modules
        rsync_resources.reduce({}) do |hash, resource|
          if resource.config_path == new_resource.config_path && resource.action == :add
            hash[resource.name] ||= {}
            resource_attributes.each do |key|
              value = resource.send(key)
              next if value.nil?
              hash[resource.name][snake_to_space(key)] = value
            end
          end
    
          hash
        end
      end
    
      # The global rsync configuration
      #
      # @return [Hash]
      def global_modules
        node['rsyncd']['globals'].reduce({}) do |hash, (key, value)|
          hash[snake_to_space(key)] = value unless value.nil?
          hash
        end
      end
    end
  end
end
