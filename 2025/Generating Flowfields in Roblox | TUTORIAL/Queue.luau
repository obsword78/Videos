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
	self._size-=1
	return table.remove(self._data, 1)
end

function Queue:getSize()
	return self._size
end

return Queue
