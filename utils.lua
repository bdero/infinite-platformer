utils = {}

function utils.asymptote(dist, divisor, dt)
  return (1 - 1/(dt/divisor + 1))*dist
end

return utils
