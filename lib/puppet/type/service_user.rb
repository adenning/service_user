Puppet::Type.newtype(:service_user) do
  @doc = 'Ensures a service runs as a user'
  ensurable
  
  newparam(:service) do
    desc 'Service Name (short name)'
    isnamevar
  end  
  
  newparam(:username) do
    desc 'Username. For a local user, use ".\name"'
  end
  
  newparam(:password) do
    desc 'Password.' # Unfortunately, we cannot ensure the password with each run.
  end  

end