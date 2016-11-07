utils = {}

function utils.asymptote(dist, divisor, dt)
  return (1 - 1/(dt/divisor + 1))*dist
end

function utils.clamp(lower, upper, val)
    return math.max(lower, math.min(upper, val))
end

return utils
