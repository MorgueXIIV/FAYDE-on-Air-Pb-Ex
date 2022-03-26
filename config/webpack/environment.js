const { environment } = require('@rails/webpacker')
const alias =  require('./alias/alias')

environment.config.merge(alias)
module.exports = environment
