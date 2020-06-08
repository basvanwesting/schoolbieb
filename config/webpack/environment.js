const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

environment.plugins.append(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    'window.jQuery': 'jquery'
    // Popper: ['popper.js', 'default']
  })
)

// const { BundleAnalyzerPlugin } = require('webpack-bundle-analyzer')
// environment.plugins.append(
//   'BundleAnalyzer',
//   new BundleAnalyzerPlugin({
//     analyzerHost: '0.0.0.0'
//   })
// )

environment.splitChunks()

environment.loaders.append('expose', {
  test: require.resolve('jquery'),
  use: [
    { loader: 'expose-loader', options: '$' },
    { loader: 'expose-loader', options: 'jQuery' },
    { loader: 'expose-loader', options: 'window.jQuery' }
  ]
})

module.exports = environment
