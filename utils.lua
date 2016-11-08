local utils = {}

function utils.asymptote(dist, divisor, dt)
  return (1 - 1/(dt/divisor + 1))*dist
end

function utils.clamp(lower, upper, val)
    return math.max(lower, math.min(upper, val))
end

function utils.sign(x)
   if x<0 then
     return -1
   elseif x>0 then
     return 1
   else
     return 0
   end
end

return utils
