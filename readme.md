
This project is **abandoned and incomplete**. Pomada started as a simple web app for the pomodoro technique.

The goal of this experiment was to create a single client-side codebase that could be used to generate a Web App, a Chrome Packaged App and a Mac App (using [Cordova Mac](//github.com/apache/incubator-cordova-mac), [node-webkit](//github.com/rogerwang/node-webkit) or [App.js](http://appjs.org)), while still making use of common good practices available today in traditional web frameworks (such as layouts and templates, asset combination and minification, cache busting, etc.). 

It contains a demo server written in the Ruby language that uses the [Sinatra](http://sinatrarb.com) microframework, and a client that executes in the browser written in [CoffeeScript](http://coffeescript.org) and structured with [Backbone.js](http://backbonejs.org). The [Middleman](http://middlemanapp.com) framework was used to optimize the client code.

The client is fully decoupled from the server. They communicate through a simple REST API. The server supports CORS requests to enable cross-domain communication.

![screenshot](//raw.github.com/dmfrancisco/pomada/master/client/resources/screenshot.jpg "Screenshot")

---

Commands to install dependencies and run the demo server:

    cd server
    bundle
    ruby app.rb -p 9292

Commands to build the client from source:

    cd client
    bundle
    middleman build

For convenience, middleman offers a development server:

    middleman server
