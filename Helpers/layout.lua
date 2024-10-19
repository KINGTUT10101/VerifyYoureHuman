local layout = {}

function layout.scaleToSize (origW, origH, newW, newH)
    return newW / origW, newH / origH
end

return layout