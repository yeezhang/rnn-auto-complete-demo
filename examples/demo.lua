local app = require('../waffle')
app.set('debug', true)

app.get('/', function(req, res)
   res.header('Content-Type', 'text/html')
   res.send[[
<html>
<head></head>
<body>Hello</body>
</html>
   ]]
end)

app.post('/', function(req, res)
   res.send('Posting...')
end)

app.put('/', function(req, res)
   res.send('Putting...')
end)

app.delete('/', function(req, res)
   res.send('Deleting...')
end)

app.get('/test', function(req, res)
   res.send('Hello World!')
end)

app.get('/html', function(req, res)
   res.sendFile('./examples/index.html')
end)

app.get('/error', function(req, res)
   local b = a + 5 -- 500 Error
end)

app.get('/redir', function(req, res)
   res.redirect('http://www.google.com')
end)

app.get('/lua', function(req, res)
   res.sendFile('./examples/demo.lua')
end)

app.get('/user/(%d+)', function(req, res)
   local userId = tonumber(req.params[1])
   local users = {
      [1] = 'Lua',
      [2] = 'JavaScript',
      [3] = 'Python'
   }
   res.send(string.format('Hello, %s', users[userId] or 'undefined'))
end)

app.get('/user/(%a+)', function(req, res)
   local name = req.params[1]
   res.send(string.format('Hello, %s', name))
end)

app.post('/onlypost', function(req, res)
   res.send('Only posting from here')
end)

app.get('/render/(%a+)', function(req, res)
   res.render('./examples/template.html', {
      name = req.params[1],
      time = os.time()
   })
end)

app.get('/cookie', function(req, res)
   local c = req.cookies.counter or -1
   res.cookie('counter', tonumber(c) + 1)
   res.send('#' .. c)
end)

app.get('/cookie/clear', function(req, res)
   res.cookie.clear(req.cookies)
   res.send('Deleting cookies ...')
end)

app.error(404, function(description, req, res)
   local url = string.format('%s%s', req.headers.host, req.url.path)
   res.status(404).send('No page found at ' .. url)
end)

app.error(500, function(description, req, res)
   if app.debug then
      res.status(500).send(description)
   else
      res.status(500).send('500 Error')
   end
end)

app.listen({host='0.0.0.0'})
