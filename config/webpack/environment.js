const alias =  require('./alias/alias')
const webpack = require('webpack')
const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
environment.config.merge(alias)


environment.plugins.append(
  'Globals', // arbitrary name
   new webpack.ProvidePlugin({
     $: 'jquery',
     _: 'underscore'
   })
);

module.exports = environment