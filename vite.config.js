// vite.config.js
import NodePolyfillPlugin from 'node-polyfill-webpack-plugin';

export default {
  plugins: [
    NodePolyfillPlugin()
  ],
  define: {
    global: 'globalThis'
  },
  optimizeDeps: {
    include: ['crypto-browserify']
  }
};
