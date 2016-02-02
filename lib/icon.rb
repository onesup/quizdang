data_url = ''
svg = Base64.decode64(data_url['data:image/svg+xml;base64,'.length .. -1])
File.open('test.png', 'wb') { |f| f.write(svg) }
