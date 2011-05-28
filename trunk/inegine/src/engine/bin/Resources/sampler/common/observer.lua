Observer = {}

-- Register
function Observer.register( self, observer, method )
  local t = {}
  t.o = observer
  t.m = method
  table.insert( self, t )
end

-- Deregister
function Observer.deregister( self, observer, method )
  local i
  local n = #self
  for i = n, 1, -1 do
    if (not observer or self[i].o == observer) and
       (not method   or self[i].m == method)
    then
      table.remove( self, i )
    end
  end
end

-- Notify
function Observer.notify( self, ... )
  local i
  local n = #self
  for i = 1, n do
    self[i].m( self[i].o, ... )
  end
end

-- signal metatable
Observer.mt = {
  __call = function( self, ... )
    self:notify(...)
  end
}

function Observer.signal()
  local t = {}
  t.register = Observer.register
  t.deregister = Observer.deregister
  t.notify = Observer.notify
  setmetatable( t, Observer.mt )
  return t
end