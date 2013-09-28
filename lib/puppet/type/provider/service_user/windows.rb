Puppet::Type.type(:service_user).provide(:windows) do
  defaultfor :operatingsystem => :windows
  confine    :operatingsystem => :windows
 
  def create
    retval = get_service.Change(nil, nil, nil, nil, nil, nil, resource[:username], resource[:password], nil, nil, nil)
    # http://msdn.microsoft.com/en-us/library/aa384901(v=vs.85).aspx
    if retval != 0
      raise "Unable to ensure user. service.Change returned #{retval} See " + 
            "http://msdn.microsoft.com/en-us/library/aa384901(v=vs.85).aspx"
    end
  end
   
  def exists?
    get_service.StartName == resource[:username]
  end
  
  def destroy
    retval = get_service.Change(nil, nil, nil, nil, nil, nil, 'LocalSystem', '', nil, nil, nil)
    if retval != 0
      raise "Unable to ensure user. service.Change returned #{retval} See " + 
            "http://msdn.microsoft.com/en-us/library/aa384901(v=vs.85).aspx"
    end    
  end
  
  def get_service
    require 'win32ole'
    retval = nil
    wmi = WIN32OLE.connect("winmgmts://")
    query = wmi.ExecQuery("Select * from Win32_Service where Name = '#{resource[:service]}'")
    if query.count < 1
      raise "Unable to ensure service user. Service #{resource[:service]} not found."
    end
    query.each do |service|
      retval = service
      break
    end
    retval
  end  
end