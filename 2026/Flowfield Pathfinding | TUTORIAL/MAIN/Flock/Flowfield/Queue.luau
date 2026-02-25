local Queue = {}
Queue.__index = Queue

function Queue.new(data:{any})
	local self = setmetatable({}, Queue)
	
	self._data = data or {}
	self._size = #self._data
	
	return self
end

function Queue:enqueue(data:any)
	table.insert(self._data, data)
	self._size+=1
end

function Queue:dequeue()
	local cache = table.remove(self._data, 1)
	self._size-=1
	
	return cache
end

function Queue:getSize()
	return self._size
end

return Queue
