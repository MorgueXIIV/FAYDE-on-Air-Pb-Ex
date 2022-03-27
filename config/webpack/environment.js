const { environment } = require('@rails/webpacker')
const alias =  require('./alias/alias')

environment.config.merge(alias)

const webpack = require('webpack')
const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)

environment.plugins.append(
  'Globals', // arbitrary name
   new webpack.ProvidePlugin({
     $: 'jquery',
     _: 'underscore'
   })
);

module.exports = environment