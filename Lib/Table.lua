local Table = {}

-- CHECK IF IN TABLE --
function Table.hasValue (tab, val)
   for index, value in ipairs (tab) do
       if value == val then
           return true
       end
   end
   return false
end

return Table