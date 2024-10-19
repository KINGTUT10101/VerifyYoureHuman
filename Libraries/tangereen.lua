---@module 'love'

---@class Tangereen
---@field texture love.Texture The texture used to render this 9-patch
---@field quads  love.Quad[] The quads used to render each slice of the 9-patch
---@field data SliceData All the data required to render the 9-patch
local tangereen = {
    EPSILON = 0.01,
  }
  tangereen.__index = tangereen
  
  ---@class SliceData
  ---@field slicex number[] Array with the size of each vertical slice.
  ---@field slicey number[] Array with the size of each horizontal slice.
  ---@field offsetx number? The horizontal offset where the patch lies in the Texture (default: 0).
  ---@field offsety number? The vertical offset where the patch lies in the Texture  (default: 0).
  ---@field scalex number[] Array with the proportional scale of each vertical slice (-1 for static).
  ---@field scaley number[] Array with the proportional scale of each horizontal slice (-1 for static).
  ---@field width { min: number, total: number} The total width of the patch, and the minimum width taken by the slices that can't be resized (min width).
  ---@field height {min: number, total: number} The total height of the patch, and the minimum height taken by the slices that can't be resized (min height).
  ---@field pad {top: number?, bottom: number?, left: number?, right: number?}? The padding on each side of the Fill Area.
  
  ---@alias SizingType
  ---|'fill' The coordinates and size define the size of the fill area (internal).
  ---|'box' The coordinates and size define the size of the box itself (external).
  
  ---@alias ImageDataLike love.ImageData|love.FileData|string
  ---@alias TextureLike ImageDataLike|love.Texture|love.Image|love.Canvas
  
  ---@alias Renderer fun(self: Tangereen, index: integer, texture: love.Texture, x: number, y: number, sx: number, sy: number, ...:unknown): number, number
  
  local ERRORS = {
    MismatchQuadsScale = "Data Mismatch! The number of quads doesn't match the scale data (quads: %s, scales: %s).",
    MinimumSize = "This patch has a minimum %s of %i (requested width was %i).",
    BadArgument = "Bad argument #%i to %s (%s expected, got %s)."
  }
  
  --- This is an utility function, used to determine if the data matches the expected type (including LÖVE types).
  ---@package
  ---@param data any
  ---@param type string
  ---@return boolean
  local function isTypeOf(data, typeEnum)
    local t = type(data)
  
    if (t == typeEnum) then return true end
    if (t == "userdata" or t == "cdata" or t == "table") and data.typeOf then
      return data:typeOf(typeEnum)
    end
  
    return false
  end
  
  --- This is an utility function, used to get a value of the expected type from the input.
  ---@package
  ---@generic T
  ---@param type `T` The expected type of the returned value
  ---@param generator fun(input: unknown, ...: unknown): T The function to call with the given input to get a value
  ---@param input unknown Input argument
  ---@param ... unknown Any other argument needed by the generator
  ---@return T result
  local function get(typeEnum, generator, input, ...)
    if isTypeOf(input, typeEnum) then
      return input
    end
  
    local ok, err = pcall(generator, input, ...)
    if ok then
      return err
    else
      error(err, 4)
    end
  end
  
  --- This is an utility function, used to get an ImageData value.
  ---@package
  ---@param	input ImageDataLike
  ---@return love.ImageData
  local function getImageData(input)
    return get("ImageData", love.image.newImageData, input) --[[@as love.ImageData]]
  end
  
  --- This is an utility function, used to get a Texture value.
  ---@package
  ---@param input TextureLike
  ---@return love.Texture
  local function getTexture(input)
    return get("Texture", love.graphics.newImage, input) --[[@as love.Texture]]
  end
  
  --- This function reads a pixel tries to find black or non-black pixels
  --- and when a switch occurs adds the insert value to the line list.
  ---@package
  ---comment
  ---@param x integer X coordinate for the scanned pixel
  ---@param y integer Y coordinate for the scanned pixel
  ---@param imageData love.ImageData The ImageData being scanned
  ---@param scan number[] The scan results
  ---@param insert number The value to insert when an edge is found
  local function scanPixel(x, y, imageData, scan, insert)
    local r, g, b, a = imageData:getPixel(x, y)
    local E = tangereen.EPSILON
  
    if #scan % 2 == 0 then
      -- Searching for Black
      if r <= E and g <= E and b <= E and a >= (1 - E) then
        table.insert(scan, insert)
      end
    else
      -- Searching for Not-Black
      if r > E or g > E or b > E or a < (1 - E) then
        table.insert(scan, insert)
      end
    end
  end
  
  --- Line scans can't have an odd number of points
  --- This function makes sure that it's always even.
  ---@package
  ---@param scan number[] The scan results
  ---@param insert number The value to insert into the line
  ---@return number[] result The terminated scan results
  local function closeScan(scan, insert)
    if #scan % 2 == 1 then
      table.insert(scan, insert)
    end
  
    return scan
  end
  
  --- This function scans an image horizontally
  --- Searching for black lines at the top and bottom of the image
  ---@package
  ---@param imageData love.ImageData The ImageData to scan
  ---@return number[] top The scan results for the top line
  ---@return number[] bottom The scan results for the bottom line
  local function horizontalScan(imageData)
    local top, bottom = {}, {}
    local width, height = imageData:getDimensions()
    local finish = width - 2
  
    for x = 1, finish do
      local insert = x - 1 -- Just an alias to be more clear
  
      scanPixel(x, 0, imageData, top, insert)
      scanPixel(x, height - 1, imageData, bottom, insert)
    end
  
    return closeScan(top, finish),
        closeScan(bottom, finish)
  end
  
  --- This function scans an image vertically
  --- Searching for black lines at the left and right side of the image
  ---@package
  ---@param imageData love.ImageData The ImageData to scan
  ---@return number[] left The scan results for the left line
  ---@return number[] right The scan results for the right line
  local function verticalScan(imageData)
    local left, right = {}, {}
    local width, height = imageData:getDimensions()
    local finish = height - 2
  
    for y = 1, finish do
      local insert = y - 1 -- Just an alias to be more clear
  
      scanPixel(0, y, imageData, left, insert)
      scanPixel(width - 1, y, imageData, right, insert)
    end
  
    return closeScan(left, finish),
        closeScan(right, finish)
  end
  
  -- This function trims the black lines from the image data, 1px at each side
  ---@package
  ---@param untrimmed love.ImageData The un-trimmed 9-patch image
  ---@return love.ImageData trimmed love.ImageData The trimmed image, without the lines that define the 9-patch
  local function trimImageData(untrimmed)
    local w = untrimmed:getWidth() - 2
    local h = untrimmed:getHeight() - 2
  
    local trim = love.image.newImageData(w, h)
    trim:paste(untrimmed, 0, 0, 1, 1, w, h)
  
    return trim
  end
  
  --- Pushes a slice into the appropriate tables
  ---@package
  ---@param length number The size of this slice
  ---@param scaling boolean Whether this slice should be scaled
  ---@param slice number[] Push the size of the slice
  ---@param scale number[] Push the size of the slice if it should be scaled, -1 otherwise
  ---@return number size If scaled, returns it's length (dynamic) otherwise returns 0 (static)
  local function pushData(length, scaling, slice, scale)
    table.insert(slice, length)
    if scaling then
      table.insert(scale, length)
      return length
    else
      table.insert(scale, -1)
      return 0
    end
  end
  
  -- This function takes the scan along an axis and the length of that axis
  -- and generates the slice data for that axis (slice, scale and size).
  ---@package
  ---@param scan number[] The scan we are gonna use to get the slice data from
  ---@param length number The total size of the axis
  ---@return number[] slice The data for each slice size
  ---@return number[] scale The amount each slice should be scaled by
  ---@return {min: number, total: number} size The total size of the original patch and minimum size on this axis
  local function getSliceData(scan, length)
    local size = { total = length }
    local slice = {}
    local scale = {}
  
    -- Iterate through the scan and push all the lines found
    local current, dynamic, scaling = 0, 0, false
    for _, value in ipairs(scan) do
      if value ~= current then
        dynamic = dynamic + pushData(value - current, scaling, slice, scale)
        current = value
      end
      scaling = not scaling
    end
  
    -- It should always reach the end of the image
    if current ~= length then
      dynamic = dynamic + pushData(length - current, scaling, slice, scale)
    end
  
    size.min = length - dynamic -- Save the static size
  
    -- Recalculate scaling, by dividing all the pushed lengths by the dynamic size
    for k, v in ipairs(scale) do
      if v > 0 then scale[k] = v / dynamic end
    end
  
    return slice, scale, size
  end
  
  -- This function gets the padding data from a scan
  ---@package
  ---@param scan number[] The scan we are gonna use to get the slice data from
  ---@param length number The total size of the axis
  ---@return number start The padding at the start of the axis
  ---@return number end The padding at the end of the axis
  local function getPaddingData(scan, length)
    local first = scan[1] or 0
    local last = scan[#scan] or length
  
    return first, length - last
  end
  
  ---comment
  ---@param imageData ImageDataLike
  ---@param sliceData SliceData?
  ---@return Tangereen
  function tangereen.load(imageData, sliceData)
    if sliceData == nil then
      imageData, sliceData = tangereen.processImageData(imageData)
    end
  
    local texture = getTexture(imageData)
    local quads = tangereen.generateQuads(sliceData, texture:getDimensions())
  
    return setmetatable({
      data    = sliceData, -- This remains serializable
      quads   = quads, -- This are LÖVE Quads used for rendering
      texture = texture, -- This is the main texture
    }, tangereen)
  end
  
  ---comment
  ---@param imageData ImageDataLike
  ---@return love.ImageData
  ---@return SliceData
  function tangereen.processImageData(imageData)
    -- Make sure it got an ImageData
    imageData = getImageData(imageData)
  
    -- Scan it horizontally and vertically
    local top, bottom = horizontalScan(imageData)
    local left, right = verticalScan(imageData)
  
    -- Trim the lines from the ImageData
    local image = trimImageData(imageData)
    local w, h = image:getDimensions()
  
    -- Get the slice data from the scans
    local slicex, scalex, width  = getSliceData(top, w)
    local slicey, scaley, height = getSliceData(left, h)
  
    -- Get the padding data from the scans
    local pad = {}
    pad.left, pad.right = getPaddingData(bottom, w)
    pad.top, pad.bottom = getPaddingData(right, h)
  
    return image, {
      slicex = slicex,
      slicey = slicey,
      scalex = scalex,
      scaley = scaley,
  
      width = width,
      height = height,
      offsetx = 0,
      offsety = 0,
  
      pad = pad,
    } --[[@as SliceData]]
  end
  
  ---comment
  ---@param data SliceData
  ---@param imagew integer
  ---@param imageh integer
  ---@return love.Quad[]
  function tangereen.generateQuads(data, imagew, imageh)
    local quads = {}
  
    local y = data.offsety or 0
    for _, h in ipairs(data.slicey) do
      local x = data.offsetx or 0
      for _, w in ipairs(data.slicex) do
        table.insert(quads, love.graphics.newQuad(x, y, w, h, imagew, imageh))
        x = x + w
      end
      y = y + h
    end
  
    return quads
  end
  
  ---comment
  ---@param renderer Renderer A function to be called to render a given slice. It gets the required data as arguments.
  ---@param x number The x coordinate to use when rendering
  ---@param y number The y coordinate to use when rendering
  ---@param w number The width to use when rendering
  ---@param h number The height to use when rendering
  ---@param sizing SizingType The sizing type to use when specifying coordinates and sizes (default: "box")
  ---@param ... unknown Any other argument needed by `renderer`
  ---@return number totalWidth The final width of the renderer 9-patch image
  ---@return number totalHeight The final height of the renderer 9-patch image
  function tangereen:baseDraw(renderer, x, y, w, h, sizing, ...)
    if type(renderer) ~= "function" then
      error(ERRORS.BadArgument:format(1, "baseDraw", "function", type(renderer)), 2)
    end
  
    if w < 0 then x, w = x + w, -w end --Negative width
    if h < 0 then y, h = y + h, -h end --Negative height
  
    if sizing ~= "box" and sizing ~= "fill" then
    --   error(ERRORS.BadArgument:format(2, "baseDraw", "fill|box", tostring(sizing)), 2)
        sizing = "box"
    end

    if sizing == "fill" and self.data.pad then
      -- The requested box is the safe area, draw the patch around it (using the padding data)
      x = x - (self.data.pad.left or 0)
      y = y - (self.data.pad.top or 0)
      w = w + (self.data.pad.left or 0) + (self.data.pad.right or 0)
      h = h + (self.data.pad.top or 0) + (self.data.pad.bottom or 0)
    end
  
    -- Size can't be less than the static size of the patch
    if w < self.data.width.min then
      error(ERRORS.MinimumSize:format("width", self.data.width.min, w), 2)
    end
    if h < self.data.height.min then
      error(ERRORS.MinimumSize:format("height", self.data.width.min, h), 2)
    end
  
    -- Calculate how much we need to scale the dynamic part of the patch
    -- Here we trust that self.data.width/height matches the dimensions of the slices
    local totalSX = (w - self.data.width.min) / (self.data.width.total - self.data.width.min)
    local totalSY = (h - self.data.height.min) / (self.data.height.total - self.data.height.min)
  
    local index, currentQuadY, currentQuadX = 0, 0, 0
    for _, sy in ipairs(self.data.scaley) do
      -- Negative sy means static size (scale 1)
      -- Otherwise sy is a percentage of totalSY
      local scaley = sy > 0 and sy * totalSY or 1
      local drawWidth, drawHeight, ok
  
      currentQuadX = 0 -- Reset the X coordinate
      for _, sx in ipairs(self.data.scalex) do
        -- Negative sx means static size (scale 1)
        -- Otherwise sx is a percentage of totalSX
        local scalex = sx > 0 and sx * totalSX or 1
  
        -- Get the index for this slice
        index = index + 1
        -- Render the slice
        ok, drawWidth, drawHeight = pcall(renderer, self, index, self.texture, x + currentQuadX, y + currentQuadY, scalex,
          scaley, ...)
  
        if not ok then
          error(drawHeight, 2)
        end
  
        -- Move the X by the width of the rendered slice
        currentQuadX = currentQuadX + drawWidth
      end
      -- Move the Y by the height of the rendered slice
      currentQuadY = currentQuadY + drawHeight
    end
  
    return currentQuadX, currentQuadY
  end
  
  ---@package
  ---@type Renderer
--   local function defaultRenderer(self, index, texture, x, y, sx, sy)
--     love.graphics.draw(texture, self.quads[index], x, y, 0, sx, sy)
  
--     --local i, j = index % self.data.slicex, math.ceil(index / self.data.slicex)
--     --return self.data.slicex[i] * sx, self.data.slicey[j] * sy
  
--     ---@diagnostic disable-next-line: undefined-field
--     local _x, _y, w, h = self.quads[index]:getViewport()
--     return w * sx, h * sy
--   end

local function defaultRenderer(self, index, texture, x, y, sx, sy)
  local quad = self.quads[index]
  local _x, _y, w, h = quad:getViewport()

  -- Big rectangle starting from top-left corner and going down
  for i=1, math.floor(sx), 1 do
    for j=1, math.floor(sy), 1 do
      love.graphics.draw(texture, quad, x + w * (i-1), y + h * (j-1))
    end
  end

  local imgW, imgH = texture:getDimensions()
  local newWidth = w * (sx % 1)
  local newHeight = h * (sy % 1)

  -- Right side left over space
  if (newWidth > 0) then
    quad:setViewport(_x, _y, newWidth, h, imgW, imgH)
    for j=1, math.floor(sy), 1 do
      love.graphics.draw(texture, quad, x + w * math.floor(sx), y + h * (j-1))
    end
  end

  -- Bottom side left over space
  if (newHeight > 0) then
    quad:setViewport(_x, _y, w, newHeight, imgW, imgH)
    for i=1, math.floor(sx), 1 do
      love.graphics.draw(texture, quad, x + w * (i-1), y + h * math.floor(sy))
    end
  end

  -- Bottom right left over corner
  if (newWidth > 0 and newHeight > 0) then
    quad:setViewport(_x, _y, newWidth, newHeight, imgW, imgH)
    love.graphics.draw(texture, quad, x + w * math.floor(sx), y + h * math.floor(sy))
  end

  quad:setViewport(_x, _y, w, h, imgW, imgH)  
  return w * sx, h * sy
end
  
  ---comment
  ---@param x number The x coordinate to use when rendering
  ---@param y number The y coordinate to use when rendering
  ---@param w number The width to use when rendering
  ---@param h number The height to use when rendering
  ---@param sizing SizingType The sizing type to use when specifying coordinates and sizes (default: "box")
  ---@return number totalWidth The final width of the renderer 9-patch image
  ---@return number totalHeight The final height of the renderer 9-patch image
  function tangereen:draw(x, y, w, h, sizing)
    -- If the number of quads doesn't match the slice data then there is an error
    local quads = #self.quads
    local scales = #self.data.scalex * #self.data.scaley
    if quads ~= scales then
      error(ERRORS.MismatchQuadsScale:format(quads, scales), 2)
    end
  
    local paddingHorizontal, paddingVertical = 0, 0
    if sizing ~= "box" and sizing ~= "fill" then
    --   error(ERRORS.BadArgument:format(1, "draw", "fill|box", tostring(sizing)), 2)
        sizing = "box"
    end
    if sizing == "fill" and self.data.pad then
      paddingHorizontal = (self.data.pad.left or 0) + (self.data.pad.right or 0)
      paddingVertical   = (self.data.pad.top or 0) + (self.data.pad.bottom or 0)
    end
  
    -- Size can't be less than the static size of the patch
    if (w + paddingHorizontal) < self.data.width.min then
      error(ERRORS.MinimumSize:format("width", self.data.width.min, w + paddingHorizontal), 2)
    end
    if (h + paddingVertical) < self.data.height.min then
      error(ERRORS.MinimumSize:format("height", self.data.width.min, h + paddingVertical), 2)
    end
  
    return self:baseDraw(defaultRenderer, math.floor (x), math.floor (y), w, h, sizing)
  end
  
  return tangereen